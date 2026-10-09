
ACTION StationSequence_S3:
	// Point station reference to this station
	pStation ACCESS ADR(stations[3]);

	// Station parameters
//	pStation.Station := ADR(S3);
//	pStation.NextStation := ADR(S5);
	pStation.Parameters.ShuttleCapacity := 1;
	pStation.Parameters.Zone.BottomLeft.X := 0.720;
	pStation.Parameters.Zone.BottomLeft.Y := 1.440;
	pStation.Parameters.Zone.TopRight.X := 0.960;
	pStation.Parameters.Zone.TopRight.Y := 1.920;
				
	CASE pStation.State OF
		0:
			pStation.StateInfo := 'Activating station';
			// -----------------------------------------------------------------
			IF pStation.Active THEN
				pStation.Loop := 0;
				pStation.TargetState := 100;
				pStation.JumpToTargetState := TRUE;
			END_IF;

		100:
			pStation.StateInfo := 'Movement settings';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			
			pStation.Operation.Shuttle := pStation.MacroShuttle;
			pStation.Operation.MoveArc.EndVelocity := 1.5;
			pStation.Operation.MoveArc.Angular.Angle := brmPI;
			pStation.NextState := TRUE;
		101:
			pStation.StateInfo := 'Move to position 1';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveInPlane.Position.X := 0.840;
			pStation.Operation.MoveInPlane.Position.Y := 1.680;
			
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		102:
			pStation.StateInfo := 'Move figure 8';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveArc.Direction := mcACP6D_ARC_COUNTER_CLOCKWISE;
			pStation.Operation.MoveArc.Angular.Center.X := 0;
			pStation.Operation.MoveArc.Angular.Center.Y := 0.060;
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;	
			END_IF;
		103:
			pStation.StateInfo := 'Move figure 8';
			// -----------------------------------------------------------------
			pStation.Operation.MoveArc.Direction := mcACP6D_ARC_COUNTER_CLOCKWISE;
			pStation.Operation.MoveArc.Angular.Center.X := 0;
			pStation.Operation.MoveArc.Angular.Center.Y := -0.060;
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;	
			END_IF;
		104:
			pStation.StateInfo := 'Move figure 8';
			// -----------------------------------------------------------------
			pStation.Operation.MoveArc.Direction := mcACP6D_ARC_CLOCKWISE;
			pStation.Operation.MoveArc.Angular.Center.X := 0;
			pStation.Operation.MoveArc.Angular.Center.Y := -0.060;
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;	
			END_IF;
		105:
			pStation.StateInfo := 'Move figure 8';
			// -----------------------------------------------------------------
			pStation.Operation.MoveArc.Direction := mcACP6D_ARC_CLOCKWISE;
			pStation.Operation.MoveArc.Angular.Center.X := 0;
			pStation.Operation.MoveArc.Angular.Center.Y := 0.060;
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		106:
			pStation.StateInfo := 'Check if sequence is complete';
			// -----------------------------------------------------------------
			IF pStation.Loop < 5 THEN
				pStation.Loop := pStation.Loop + 1;
				pStation.TargetState := 100;
				pStation.JumpToTargetState := TRUE;
			ELSE
				pStation.NextState := TRUE;
			END_IF;
		107:
			pStation.StateInfo := 'Move to last position';
			// -----------------------------------------------------------------
			pStation.Operation.MoveArc.Direction := mcACP6D_ARC_COUNTER_CLOCKWISE;
			pStation.Operation.MoveArc.Angular.Center.X := 0;
			pStation.Operation.MoveArc.Angular.Center.Y := 0.060;
			pStation.Operation.MoveArc.EndVelocity := 0;
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.TargetState := 199;
				pStation.JumpToTargetState := TRUE;
			END_IF;	
		199:
			pStation.StateInfo := 'Save macro';
			// -----------------------------------------------------------------
			pStation.Commands.MacroSave := TRUE;

			IF pStation.CommandDone THEN
				pStation.TargetState := 200;
				pStation.JumpToTargetState := TRUE;
			END_IF;

		200:
			pStation.StateInfo := 'Waiting for shuttle to arrive at station';
			// -----------------------------------------------------------------
			pStation.Loop := 0;
			
			IF pStation.NumOccupyingShuttles > 0 THEN
				pStation.NextState := TRUE;
			END_IF;
		201:
			pStation.StateInfo := 'Add last arrived shuttle to the station';
			// -----------------------------------------------------------------
			pStation.Commands.AddShuttle := TRUE;

			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;
		202:
			pStation.StateInfo := 'Run macro';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.Shuttles.List[0];
			pStation.Commands.MacroRun := TRUE;

			IF pStation.CommandDone THEN
				pStation.TargetState := 1000;
				pStation.JumpToTargetState := TRUE;
			END_IF;			
	
		1000:
			pStation.StateInfo := 'Release shuttle to traffic network';
			// -----------------------------------------------------------------
			pStation.Commands.ReleaseAllShuttles := TRUE;

			IF pStation.CommandDone THEN
				pStation.TargetState := 200;
				pStation.JumpToTargetState := TRUE;
			END_IF;
	END_CASE;
	
	// Add macro info for these steps
	IF pStation.State > 100 AND pStation.State < 200 THEN
		pStation.StateInfo := CONCAT('Writing macro - ', pStation.StateInfo);  
	END_IF;
	
END_ACTION
