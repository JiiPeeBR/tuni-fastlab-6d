
ACTION execute_station_S2:
	// Point station reference to this station
	station ACCESS ADR(stations[2]);
			
	// Station control logic and mapping
	station.Control.Enable := TRUE;
	station.Control.Station := ADR(S2);
	station.Control.To := ADR(B1);
			
	CASE station.State OF
		0:	
			station.Var.StateInfo := 'Activating station';
			// -----------------------------------------------------------------
			IF station.Control.Active AND station.Control.State = mpTRAFFIC_ST_ON_OPEN THEN
				station.State := station.State + 1;	
			END_IF;
			
		1:	
			station.Var.StateInfo := 'Waiting for shuttle to arrive at station';
			// -----------------------------------------------------------------
			IF station.Control.Info.Occupied THEN
				station.Operation.MoveInPlane.Shuttle := ADR(station.Control.SelectedShuttle.Shuttle6D);
				station.Operation.Spin.Shuttle := ADR(station.Control.SelectedShuttle.Shuttle6D);
	  			station.State := 10;	
			END_IF;
			
		10:
			station.Var.StateInfo := 'Move to position 1';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Velocity := 2;
			station.Operation.MoveInPlane.Parameters.Acceleration := 20;
			station.Operation.MoveInPlane.Parameters.EndVelocity := 0;
			
			station.Operation.MoveInPlane.Parameters.Path := mcACP6D_PATH_DIRECT;
			station.Operation.MoveInPlane.Parameters.Position.X := 0.840;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.120;
			
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		
		11:
			station.Var.StateInfo := 'Spin 1';
			// -----------------------------------------------------------------
			station.Operation.Spin.Parameters.Acceleration := 35.0;
			station.Operation.Spin.Parameters.Velocity := 22.0;
			station.Operation.Spin.Parameters.Angle := 0;
			station.Operation.Spin.Parameters.Duration := 2.0;
			
			station.Commands.Spin := TRUE;
			
			IF station.Operation.Spin.Acknowledge THEN
				station.State := station.State + 1;	
			END_IF;
		
		12:
			station.Var.StateInfo := 'Move position 2';
			// -----------------------------------------------------------------			
			station.Operation.MoveInPlane.Parameters.Path := mcACP6D_PATH_DIRECT;
			station.Operation.MoveInPlane.Parameters.Position.X := 0.840;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.360;
			
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
			
		13:
			station.Var.StateInfo := 'Spin 2';
			// -----------------------------------------------------------------
			station.Operation.Spin.Parameters.Velocity := -22.0;
			
			station.Commands.Spin := TRUE;
			
			IF station.Operation.Spin.Done THEN
				station.State := 100;	
			END_IF;
		
			
		100:
			station.Var.StateInfo := 'Check if sequence complete';
			// -----------------------------------------------------------------
			station.Var.LoopNum := station.Var.LoopNum + 1;
			
			IF station.Var.LoopNum > 0 THEN
				// Station sequence complete
				station.State :=  200;
			ELSE
				// New loop of moves
				station.State :=  10;
			END_IF;
			
		200:
			station.Var.StateInfo := 'Wait shuttle to complete its moves';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_DIRECT;
			station.Operation.MoveInPlane.Parameters.Position.X := 0.840;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.360;
			station.Operation.MoveInPlane.Parameters.EndVelocity := 0;
			
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := 1000;	
			END_IF;
					
		1000:
			station.Var.StateInfo := 'Release shuttle to traffic network';
			// -----------------------------------------------------------------
			station.Commands.Release := TRUE;
			
			IF station.Control.ReleaseDone THEN
				station.State := 0;
			END_IF;
	END_CASE;
	
	// Reset station commands when state changes
	IF station.State <> station.Var.PreviousState THEN
		station.Var.PreviousState := station.State;
		brsmemset(ADR(station.Commands), 0, SIZEOF(station.Commands));
	END_IF;
	
END_ACTION
