
ACTION execute_station_S3:
	// Point station reference to this station
	station ACCESS ADR(stations[3]);

	// Station parameters
	station.Station := ADR(S3);
	station.NextStation := ADR(S5);
	station.Parameters.ShuttleCapacity := 1;
	station.Parameters.Zone.BottomLeft.X := 0.720;
	station.Parameters.Zone.BottomLeft.Y := 1.440;
	station.Parameters.Zone.TopRight.X := 0.960;
	station.Parameters.Zone.TopRight.Y := 1.920;
				
	CASE station.State OF
		0:
			station.StateInfo := 'Activating station';
			// -----------------------------------------------------------------
			IF station.Active THEN
				station.Loop := 0;
				station.JumpToState := 100;
			END_IF;

		100:
			station.StateInfo := 'Movement settings';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			
			station.Operation.Shuttle := station.MacroShuttle;
			station.Operation.MoveArc.EndVelocity := 1.5;
			station.Operation.MoveArc.Angular.Angle := brmPI;
			station.NextState := TRUE;
		101:
			station.StateInfo := 'Move to position 1';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveInPlane.Position.X := 0.840;
			station.Operation.MoveInPlane.Position.Y := 1.680;
			
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		102:
			station.StateInfo := 'Move figure 8';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveArc.Direction := mcACP6D_ARC_COUNTER_CLOCKWISE;
			station.Operation.MoveArc.Angular.Center.X := 0;
			station.Operation.MoveArc.Angular.Center.Y := 0.060;
			station.Commands.MoveArc := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;	
			END_IF;
		103:
			station.StateInfo := 'Move figure 8';
			// -----------------------------------------------------------------
			station.Operation.MoveArc.Direction := mcACP6D_ARC_COUNTER_CLOCKWISE;
			station.Operation.MoveArc.Angular.Center.X := 0;
			station.Operation.MoveArc.Angular.Center.Y := -0.060;
			station.Commands.MoveArc := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;	
			END_IF;
		104:
			station.StateInfo := 'Move figure 8';
			// -----------------------------------------------------------------
			station.Operation.MoveArc.Direction := mcACP6D_ARC_CLOCKWISE;
			station.Operation.MoveArc.Angular.Center.X := 0;
			station.Operation.MoveArc.Angular.Center.Y := -0.060;
			station.Commands.MoveArc := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;	
			END_IF;
		105:
			station.StateInfo := 'Move figure 8';
			// -----------------------------------------------------------------
			station.Operation.MoveArc.Direction := mcACP6D_ARC_CLOCKWISE;
			station.Operation.MoveArc.Angular.Center.X := 0;
			station.Operation.MoveArc.Angular.Center.Y := 0.060;
			station.Commands.MoveArc := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		106:
			station.StateInfo := 'Check if sequence is complete';
			// -----------------------------------------------------------------
			IF station.Loop < 5 THEN
				station.Loop := station.Loop + 1;
				station.JumpToState := 100;
			ELSE
				station.NextState := TRUE;
			END_IF;
		107:
			station.StateInfo := 'Move to last position';
			// -----------------------------------------------------------------
			station.Operation.MoveArc.Direction := mcACP6D_ARC_COUNTER_CLOCKWISE;
			station.Operation.MoveArc.Angular.Center.X := 0;
			station.Operation.MoveArc.Angular.Center.Y := 0.060;
			station.Operation.MoveArc.EndVelocity := 0;
			station.Commands.MoveArc := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.JumpToState := 199;	
			END_IF;	
		199:
			station.StateInfo := 'Save macro';
			// -----------------------------------------------------------------
			station.Commands.MacroSave := TRUE;

			IF station.CommandDone THEN
				station.JumpToState := 200;
			END_IF;

		200:
			station.StateInfo := 'Waiting for shuttle to arrive at station';
			// -----------------------------------------------------------------
			station.Loop := 0;
			
			IF station.NumOccupyingShuttles > 0 THEN
				station.NextState := TRUE;
			END_IF;
		201:
			station.StateInfo := 'Add last arrived shuttle to the station';
			// -----------------------------------------------------------------
			station.Commands.AddShuttle := TRUE;

			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;
		202:
			station.StateInfo := 'Run macro';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.Shuttles.List[0];
			station.Commands.MacroRun := TRUE;

			IF station.CommandDone THEN
				station.JumpToState := 1000;
			END_IF;			
	
		1000:
			station.StateInfo := 'Release shuttle to traffic network';
			// -----------------------------------------------------------------
			station.Commands.ReleaseAllShuttles := TRUE;

			IF station.CommandDone THEN
				station.JumpToState := 200;
			END_IF;
	END_CASE;
	
	// Add macro info for these steps
	IF station.State > 100 AND station.State < 200 THEN
		station.StateInfo := CONCAT('Writing macro - ', station.StateInfo);  
	END_IF;
	
END_ACTION
