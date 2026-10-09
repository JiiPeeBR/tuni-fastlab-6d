
ACTION StationSequence_S4:
	// Point station reference to this station
	pStation ACCESS ADR(stations[4]);

	// Station parameters
//	pStation.Station := ADR(S4);
//	pStation.NextStation := ADR(S5);
	pStation.Parameters.ShuttleCapacity := 2;
	pStation.Parameters.Zone.BottomLeft.X := 0;
	pStation.Parameters.Zone.BottomLeft.Y := 1.440;
	pStation.Parameters.Zone.TopRight.X := 0.240;
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
			pStation.TargetState := 200;
			pStation.JumpToTargetState := TRUE;
		200:
			pStation.StateInfo := 'Waiting for first shuttle to arrive at station';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
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
			pStation.StateInfo := 'Move first shuttle to start position';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.Shuttles.List[0];
			pStation.Operation.MoveInPlane.Position.X := 0.120;
			pStation.Operation.MoveInPlane.Position.Y := 1.740;
			pStation.Operation.MoveInPlane.Path :=  mcACP6D_PATH_X_THEN_Y;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;
		203:	
			pStation.StateInfo := 'Waiting for second shuttle to arrive at station';
			// -----------------------------------------------------------------
			IF pStation.NumOccupyingShuttles > 1 THEN		
				pStation.NextState := TRUE;
			END_IF;
		204:
			pStation.StateInfo := 'Add last arrived shuttle to the station';
			// -----------------------------------------------------------------
			pStation.Commands.AddShuttle := TRUE;

			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;		
		205:
			pStation.StateInfo := 'Move second shuttle to start position';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.Shuttles.List[1];
			pStation.Operation.MoveInPlane.Position.X := 0.120;
			pStation.Operation.MoveInPlane.Position.Y := 1.620;
			pStation.Operation.MoveInPlane.Path :=  mcACP6D_PATH_X_THEN_Y;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.TargetState := 210;
				pStation.JumpToTargetState := TRUE;
			END_IF;
			
		210:
			pStation.StateInfo := 'Init synchronized move';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			
			pStation.Operation.MoveArc.Angular.Angle := 10 * brmTWOPI;
			pStation.NextState := TRUE;
		211:
			pStation.StateInfo := 'Shuttle 1 waits for 0';
			// -----------------------------------------------------------------			
			pStation.Operation.Shuttle := pStation.Shuttles.List[1];
			pStation.Operation.WaitCommandLabel.TriggerShuttleID := pStation.Shuttles.List[0].ShuttleID;
			pStation.Operation.WaitCommandLabel.TriggerCmdLb := 213;
			pStation.Commands.WaitCommandLabel := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		212:
			pStation.StateInfo := 'Arc';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.Shuttles.List[1];
			pStation.Operation.MoveArc.Direction := mcACP6D_ARC_CLOCKWISE;
			pStation.Operation.MoveArc.Angular.Center.X := 0;
			pStation.Operation.MoveArc.Angular.Center.Y := -0.060;
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;	
		213:
			pStation.StateInfo := 'Arc';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.Shuttles.List[0];
			pStation.Operation.MoveArc.Direction := mcACP6D_ARC_CLOCKWISE;
			pStation.Operation.MoveArc.Angular.Center.X := 0;
			pStation.Operation.MoveArc.Angular.Center.Y := 0.060;
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		214:
			pStation.StateInfo := 'Move to 2nd start pos';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			pStation.Operation.Shuttle := pStation.Shuttles.List[0];
			pStation.Operation.MoveInPlane.Position.X := 0.180;
			pStation.Operation.MoveInPlane.Position.Y := 1.860;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		215:
			pStation.StateInfo := 'Move to 2nd start pos';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.Shuttles.List[1];
			pStation.Operation.MoveInPlane.Position.X := 0.060;
			pStation.Operation.MoveInPlane.Position.Y := 1.500;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;	
		216:
			pStation.StateInfo := 'Sync shuttles';
			// -----------------------------------------------------------------
			pStation.Commands.WaitUntilAllDone := TRUE;
		
			IF pStation.CommandDone THEN
				pStation.TargetState := 220;
				pStation.JumpToTargetState := TRUE;
			END_IF;
			
		220:
			pStation.StateInfo := 'Move pattern for slave shuttle';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			pStation.NextState := TRUE;
		221:
			pStation.StateInfo := '';
			// -----------------------------------------------------------------			
			pStation.Operation.Shuttle := pStation.Shuttles.List[1];
			pStation.Operation.WaitCommandLabel.TriggerShuttleID := pStation.Shuttles.List[0].ShuttleID;
			pStation.Operation.WaitCommandLabel.TriggerCmdLb := 241;
			pStation.Commands.WaitCommandLabel := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		222:
			pStation.StateInfo := 'Shuttle 1 moves';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := 0.120;
			pStation.Operation.MoveInPlane.Position.Y := 0.0;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		223:
			pStation.StateInfo := 'Shuttle 1 moves';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Position.Y := 0.120;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		224:
			pStation.StateInfo := 'Shuttle 1 moves';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := -0.120;
			pStation.Operation.MoveInPlane.Position.Y := 0.0;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		225:
			pStation.StateInfo := 'Shuttle 1 moves';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Position.Y := 0.120;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		226:
			pStation.StateInfo := 'Shuttle 1 moves';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := 0.120;
			pStation.Operation.MoveInPlane.Position.Y := 0.0;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		227:
			pStation.StateInfo := 'Shuttle 1 moves';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Position.Y := 0.120;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		228:
			pStation.StateInfo := 'Shuttle 1 moves';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := -0.120;
			pStation.Operation.MoveInPlane.Position.Y := 0.0;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.TargetState := 240;
				pStation.JumpToTargetState := TRUE;
			END_IF;
		
		240:
			pStation.StateInfo := 'Move pattern for master shuttle';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			pStation.Operation.Shuttle := pStation.Shuttles.List[0];
			pStation.NextState := TRUE;
		241:
			pStation.StateInfo := 'Shuttle 0 moves';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := -0.120;
			pStation.Operation.MoveInPlane.Position.Y := 0.0;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		242:
			pStation.StateInfo := 'Shuttle 0 moves';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Position.Y := -0.120;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		243:
			pStation.StateInfo := 'Shuttle 0 moves';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := 0.120;
			pStation.Operation.MoveInPlane.Position.Y := 0.0;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		244:
			pStation.StateInfo := 'Shuttle 0 moves';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Position.Y := -0.120;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		245:
			pStation.StateInfo := 'Shuttle 0 moves';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := -0.120;
			pStation.Operation.MoveInPlane.Position.Y := 0.0;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		246:
			pStation.StateInfo := 'Shuttle 0 moves';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Position.Y := -0.120;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		247:
			pStation.StateInfo := 'Shuttle 0 moves';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := 0.120;
			pStation.Operation.MoveInPlane.Position.Y := 0.0;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.TargetState := 1000;
				pStation.JumpToTargetState := TRUE;
			END_IF;
							
		1000:
			pStation.StateInfo := 'Sync shuttles';
			// -----------------------------------------------------------------	 	 
			pStation.Commands.WaitUntilAllDone := TRUE;
		
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;
		1001:
			pStation.StateInfo := 'Decouple group';
			// -----------------------------------------------------------------
			pStation.Commands.Group.Decouple := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;	
		1002:
			pStation.StateInfo := 'Move shuttles to exit positions';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			
			pStation.Operation.Shuttle := pStation.Shuttles.List[0];
			pStation.Operation.MoveInPlane.Path := mcACP6D_PATH_X_THEN_Y;
			pStation.Operation.MoveInPlane.Position.X := 0.180;
			pStation.Operation.MoveInPlane.Position.Y := 1.860;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;
		1003:
			pStation.StateInfo := 'Move shuttles to exit positions';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.Shuttles.List[1];
			pStation.Operation.MoveInPlane.Path := mcACP6D_PATH_X_THEN_Y;
			pStation.Operation.MoveInPlane.Position.X := 0.060;
			pStation.Operation.MoveInPlane.Position.Y := 1.860;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;	
		1004:
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
