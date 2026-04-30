
(*  *)
FUNCTION_BLOCK fdTiltAround
	
	IF NOT Execute THEN
		MoveShortAxis.Execute := FALSE;
		step := 0;
		state := 0;  
	END_IF;
	
	CASE state OF
		0:
			IF Execute THEN
				state := 10;
			END_IF;
		10:
			IF step > Steps THEN
				state := 100;
			ELSE
				MoveShortAxis.Parameters.Position.Rx := MaxAngle * SIN((2 * brmPI / Steps) * step);
				MoveShortAxis.Parameters.Position.Ry := MaxAngle * COS((2 * brmPI / Steps) * step);
				MoveShortAxis.Parameters.Position.Rz := 0;
				MoveShortAxis.Parameters.Position.Z := 0.004;
				state := 20;
			END_IF;
		20:
			MoveShortAxis.Execute := TRUE;
			
			IF MoveShortAxis.Acknowledge THEN
				MoveShortAxis.Execute := FALSE;
				step := step + 1;
				state := 10;
			END_IF;	
		100:
//			MoveShortAxis.Parameters.Position.Rx := 0;
//			MoveShortAxis.Parameters.Position.Ry := 0;
//			MoveShortAxis.Parameters.Position.Rz := 0;
//			MoveShortAxis.Parameters.Position.Z := 0.001;
//			MoveShortAxis.Execute := TRUE;
//			
//			IF MoveShortAxis.Done OR MoveShortAxis.Acknowledge THEN
//				MoveShortAxis.Execute := FALSE;
//				step := step + 1;
//				state := 101;
//			END_IF;	
		
			IF NOT Execute THEN
				state := 0;
			END_IF;	
	END_CASE;
	
	MoveShortAxis.Shuttle := ADR(Shuttle);
	MoveShortAxis.Parameters.Mode :=  mcACP6D_MOVE_ABSOLUTE;
	MoveShortAxis.Parameters.Velocity := Velocity;
	MoveShortAxis();
	
	Acknowledge := (state = 100);
	Error := MoveShortAxis.Error;
	
END_FUNCTION_BLOCK
