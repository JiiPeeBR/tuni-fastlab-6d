// 
FUNCTION fdCalcTimeToTarget

	// v = a * t -> t = v / a
	timeToMaxVelocity := MaxVelocity / Acceleration;
	
	// Displacement: s = v_0 * t + 0.5 * at^2 -> s = 0.5 * at^2
	distanceToMaxVelocity := 0.5 * Acceleration * brmpow(timeToMaxVelocity, 2);
	
	// Displacement: s = v_0 * t + 0.5 * at^2 -> t = sqrt((2s)/a)
	IF distanceToMaxVelocity > Distance THEN
		// Case where we never hit the target velocity
		fdCalcTimeToTarget := SQRT(2 * Distance / Acceleration);
	ELSE
		// Case where we reach target velocity
		distanceToTarget := Distance - distanceToMaxVelocity;
		
		fdCalcTimeToTarget := SQRT(2 * distanceToMaxVelocity / Acceleration) + distanceToTarget / MaxVelocity;
	END_IF;
     	
END_FUNCTION

//
FUNCTION fdCalcTargetVelocity
 	
	// This seems to be rougly minimum velocity 6D system can do
	minimumVelocity := 0.0001;
	
	IF Distance < 0.001 THEN
		fdCalcTargetVelocity := minimumVelocity;
	END_IF;
	
	// Move consists of two parts, 1st is acceleration to end velocity and 2nd is constant velocity part
	// We know following:
	// TimeToTarget = t1 + t2
	// TargetVelocity = Acceleration * t1
	// s2 = TargetVelocity * t2
	// Distance = s1 + s2
	// s1 = 0.5 * Acceleration * t1^2

	// Solve with quadratic equation
	// x = (-b +- SQRT((b^2)-4ac))/2a
	// discriminant = b*b - 4*a*c;
	a := 0.5;
	b := -1 * TimeToTarget * Acceleration;
	c := Acceleration * Distance;
	
	// Solve discriminant for the equation
	discriminant := b * b - 4 * a * c;
		
	IF (discriminant > 0) THEN
		// Two real and distinct roots
		x1 := (-1 * b + SQRT(discriminant)) / (2*a);
		x2 := (-1 * b - SQRT(discriminant)) / (2*a);
		
		IF x1 >= 0 AND x2 >= 0 THEN
			fdCalcTargetVelocity := MIN(x1, x2);
		ELSIF x1 > 0 THEN
			fdCalcTargetVelocity := x1;
		ELSIF x2 > 0 THEN
			fdCalcTargetVelocity := x2;
		ELSE
			// Both are negative -> impossible situation as velocity cant be negative in this case
			fdCalcTargetVelocity := 0;
		END_IF;
		
	ELSIF (discriminant = 0) THEN
		// One real root (repeated)
		fdCalcTargetVelocity := -1 * b / (2*a);
	ELSE 
		// No real solution -> set to zero so it errors out as this is impossible request
		fdCalcTargetVelocity := 0;
	END_IF
	
	//fdCalcTargetVelocity := MAX(MinimumVelocity, fdCalcTargetVelocity);
	
END_FUNCTION

(*  *)
FUNCTION_BLOCK fdMove6DSync
	
	CASE state OF
		0:
			// --------------------------------------------
			ShGetInfo.Execute := FALSE;
			Move6D.Execute := FALSE;
			ErrorID := 0;
			m.PositionUpdatePending := FALSE;
			
			IF Execute THEN
				state := 100;
			ELSIF Home THEN
				state := 200;	
			END_IF;
			
		100:
			// Calculate target velocities for all axis
			// --------------------------------------------
			// Calculate distance each axis needs to travel
			m.DistanceToTarget.InPlane := SQRT(brmpow(Parameters.Position.X - CurrentPosition.X, 2) + brmpow(Parameters.Position.Y - CurrentPosition.Y, 2));
			m.DistanceToTarget.Z := ABS(Parameters.Position.Z - CurrentPosition.Z);
			m.DistanceToTarget.Rx := ABS(Parameters.Position.Rx - CurrentPosition.Rx);
			m.DistanceToTarget.Ry := ABS(Parameters.Position.Ry - CurrentPosition.Ry);
			m.DistanceToTarget.Rz := ABS(Parameters.Position.Rz - CurrentPosition.Rz);
			
			// Calculate which axis takes longest to reach its target from current position
			m.TimeToTarget.InPlane := fdCalcTimeToTarget(m.DistanceToTarget.InPlane, Parameters.Velocity.InPlane, Parameters.Acceleration.InPlane);
			m.TimeToTarget.Z := fdCalcTimeToTarget(m.DistanceToTarget.Z, Parameters.Velocity.Z, Parameters.Acceleration.Z);
			m.TimeToTarget.Rx := fdCalcTimeToTarget(m.DistanceToTarget.Rx, Parameters.Velocity.Rx, Parameters.Acceleration.Rx);
			m.TimeToTarget.Ry := fdCalcTimeToTarget(m.DistanceToTarget.Ry, Parameters.Velocity.Ry, Parameters.Acceleration.Ry);
			m.TimeToTarget.Rz := fdCalcTimeToTarget(m.DistanceToTarget.Rz, Parameters.Velocity.Rz, Parameters.Acceleration.Rz);
			
			// The axis that takes the longest to reach the target 
			m.LongestTimeToTarget := MAX(m.TimeToTarget.InPlane, m.TimeToTarget.Z, m.TimeToTarget.Rx, m.TimeToTarget.Ry, m.TimeToTarget.Rz);

			m.TargetVelocity.InPlane := fdCalcTargetVelocity(m.DistanceToTarget.InPlane, m.LongestTimeToTarget, Parameters.Acceleration.InPlane);
			m.TargetVelocity.Z := fdCalcTargetVelocity(m.DistanceToTarget.Z, m.LongestTimeToTarget, Parameters.Acceleration.Z);
			m.TargetVelocity.Rx := fdCalcTargetVelocity(m.DistanceToTarget.Rx, m.LongestTimeToTarget, Parameters.Acceleration.Rx);
			m.TargetVelocity.Ry := fdCalcTargetVelocity(m.DistanceToTarget.Ry, m.LongestTimeToTarget, Parameters.Acceleration.Ry);
			m.TargetVelocity.Rz := fdCalcTargetVelocity(m.DistanceToTarget.Rz, m.LongestTimeToTarget, Parameters.Acceleration.Rz);
			
			state := 101;
		101:
			// Execute the move
			// -------------------------------------------
			Move6D.Parameters.InPlane.Acceleration := Parameters.Acceleration.InPlane;
			Move6D.Parameters.InPlane.Velocity := m.TargetVelocity.InPlane;
			Move6D.Parameters.InPlane.Position.X := Parameters.Position.X;
			Move6D.Parameters.InPlane.Position.Y := Parameters.Position.Y;
			
			Move6D.Parameters.ShortAxis.Velocity.Z := m.TargetVelocity.Z;
			Move6D.Parameters.ShortAxis.Velocity.Rx := m.TargetVelocity.Rx;
			Move6D.Parameters.ShortAxis.Velocity.Ry := m.TargetVelocity.Ry;
			Move6D.Parameters.ShortAxis.Velocity.Rz := m.TargetVelocity.Rz;
			Move6D.Parameters.ShortAxis.Position.Z := Parameters.Position.Z;
			Move6D.Parameters.ShortAxis.Position.Rx := Parameters.Position.Rx;
			Move6D.Parameters.ShortAxis.Position.Ry := Parameters.Position.Ry;
			Move6D.Parameters.ShortAxis.Position.Rz := Parameters.Position.Rz;
			Move6D.Execute := TRUE;
			
			IF Move6D.Done OR Move6D.Acknowledge THEN
	  			m.PositionUpdatePending := TRUE;
			END_IF;
			
			IF NOT Execute THEN
				IF m.PositionUpdatePending THEN
					m.PositionUpdatePending := FALSE;
	  				CurrentPosition := Parameters.Position;	
				END_IF;
				Move6D.Execute := FALSE;
				state := 0;
			END_IF;
			
		200:
			// Home shuttle by reading its current location
			// --------------------------------------------
			ShGetInfo.Execute := TRUE;
			
			IF NOT Home THEN
				ShGetInfo.Execute := FALSE;
				state := 0;
			ELSIF ShGetInfo.Done THEN
				CurrentPosition := ShGetInfo.ShuttleInfo.Position;
			ELSIF ShGetInfo.Error THEN
				ErrorID := ShGetInfo.ErrorID;
			END_IF;	
	END_CASE;
	
	// Functions
	// --------------------------------------------
	ShGetInfo.Shuttle := ADR(Shuttle);
	ShGetInfo();
	
	Move6D.Shuttle := ADR(Shuttle);
	Move6D();
	
	// --------------------------------------------
	Done := Move6D.Done OR ShGetInfo.Done;
	Acknowledge := Move6D.Acknowledge;
	Error := Move6D.Error OR ShGetInfo.Done;
		
END_FUNCTION_BLOCK
