
ACTION execute_station_S4:
	// Point station reference to this station
	station ACCESS ADR(stations[4]);

	// Station parameters
	station.Station := ADR(S4);
	station.NextStation := ADR(S5);
	station.Parameters.ShuttleCapacity := 2;
	station.Parameters.Zone.BottomLeft.X := 0;
	station.Parameters.Zone.BottomLeft.Y := 1.440;
	station.Parameters.Zone.TopRight.X := 0.240;
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
			station.JumpToState := 200;
	
		200:
			station.StateInfo := 'Waiting for first shuttle to arrive at station';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
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
			station.StateInfo := 'Move first shuttle to start position';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.Shuttles.List[0];
			station.Operation.MoveInPlane.Position.X := 0.120;
			station.Operation.MoveInPlane.Position.Y := 1.740;
			station.Operation.MoveInPlane.Path :=  mcACP6D_PATH_X_THEN_Y;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;
		203:	
			station.StateInfo := 'Waiting for second shuttle to arrive at station';
			// -----------------------------------------------------------------
			IF station.NumOccupyingShuttles > 1 THEN		
				station.NextState := TRUE;
			END_IF;
		204:
			station.StateInfo := 'Add last arrived shuttle to the station';
			// -----------------------------------------------------------------
			station.Commands.AddShuttle := TRUE;

			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;		
		205:
			station.StateInfo := 'Move second shuttle to start position';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.Shuttles.List[1];
			station.Operation.MoveInPlane.Position.X := 0.120;
			station.Operation.MoveInPlane.Position.Y := 1.620;
			station.Operation.MoveInPlane.Path :=  mcACP6D_PATH_X_THEN_Y;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandDone THEN
				station.JumpToState := 210;
			END_IF;
			
		210:
			station.StateInfo := 'Init synchronized move';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			
			station.Operation.MoveArc.Angular.Angle := 10 * brmTWOPI;
			station.NextState := TRUE;
		211:
			station.StateInfo := 'Shuttle 1 waits for 0';
			// -----------------------------------------------------------------			
			station.Operation.Shuttle := station.Shuttles.List[1];
			station.Operation.WaitCommandLabel.TriggerShuttleID := station.Shuttles.List[0].ShuttleID;
			station.Operation.WaitCommandLabel.TriggerCmdLb := 213;
			station.Commands.WaitCommandLabel := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		212:
			station.StateInfo := 'Arc';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.Shuttles.List[1];
			station.Operation.MoveArc.Direction := mcACP6D_ARC_CLOCKWISE;
			station.Operation.MoveArc.Angular.Center.X := 0;
			station.Operation.MoveArc.Angular.Center.Y := -0.060;
			station.Commands.MoveArc := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;	
		213:
			station.StateInfo := 'Arc';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.Shuttles.List[0];
			station.Operation.MoveArc.Direction := mcACP6D_ARC_CLOCKWISE;
			station.Operation.MoveArc.Angular.Center.X := 0;
			station.Operation.MoveArc.Angular.Center.Y := 0.060;
			station.Commands.MoveArc := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		214:
			station.StateInfo := 'Move to 2nd start pos';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			station.Operation.Shuttle := station.Shuttles.List[0];
			station.Operation.MoveInPlane.Position.X := 0.180;
			station.Operation.MoveInPlane.Position.Y := 1.860;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		215:
			station.StateInfo := 'Move to 2nd start pos';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.Shuttles.List[1];
			station.Operation.MoveInPlane.Position.X := 0.060;
			station.Operation.MoveInPlane.Position.Y := 1.500;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;	
		216:
			station.StateInfo := 'Sync shuttles';
			// -----------------------------------------------------------------
			station.Commands.WaitUntilAllDone := TRUE;
		
			IF station.CommandDone THEN
				station.JumpToState := 220;
			END_IF;
			
		220:
			station.StateInfo := 'Move pattern for slave shuttle';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			station.NextState := TRUE;
		221:
			station.StateInfo := '';
			// -----------------------------------------------------------------			
			station.Operation.Shuttle := station.Shuttles.List[1];
			station.Operation.WaitCommandLabel.TriggerShuttleID := station.Shuttles.List[0].ShuttleID;
			station.Operation.WaitCommandLabel.TriggerCmdLb := 241;
			station.Commands.WaitCommandLabel := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		222:
			station.StateInfo := 'Shuttle 1 moves';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := 0.120;
			station.Operation.MoveInPlane.Position.Y := 0.0;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		223:
			station.StateInfo := 'Shuttle 1 moves';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := 0.000;
			station.Operation.MoveInPlane.Position.Y := 0.120;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		224:
			station.StateInfo := 'Shuttle 1 moves';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := -0.120;
			station.Operation.MoveInPlane.Position.Y := 0.0;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		225:
			station.StateInfo := 'Shuttle 1 moves';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := 0.000;
			station.Operation.MoveInPlane.Position.Y := 0.120;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		226:
			station.StateInfo := 'Shuttle 1 moves';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := 0.120;
			station.Operation.MoveInPlane.Position.Y := 0.0;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		227:
			station.StateInfo := 'Shuttle 1 moves';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := 0.000;
			station.Operation.MoveInPlane.Position.Y := 0.120;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		228:
			station.StateInfo := 'Shuttle 1 moves';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := -0.120;
			station.Operation.MoveInPlane.Position.Y := 0.0;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.JumpToState := 240;
			END_IF;
		
		240:
			station.StateInfo := 'Move pattern for master shuttle';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			station.Operation.Shuttle := station.Shuttles.List[0];
			station.NextState := TRUE;
		241:
			station.StateInfo := 'Shuttle 0 moves';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := -0.120;
			station.Operation.MoveInPlane.Position.Y := 0.0;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		242:
			station.StateInfo := 'Shuttle 0 moves';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := 0.000;
			station.Operation.MoveInPlane.Position.Y := -0.120;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		243:
			station.StateInfo := 'Shuttle 0 moves';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := 0.120;
			station.Operation.MoveInPlane.Position.Y := 0.0;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		244:
			station.StateInfo := 'Shuttle 0 moves';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := 0.000;
			station.Operation.MoveInPlane.Position.Y := -0.120;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		245:
			station.StateInfo := 'Shuttle 0 moves';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := -0.120;
			station.Operation.MoveInPlane.Position.Y := 0.0;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		246:
			station.StateInfo := 'Shuttle 0 moves';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := 0.000;
			station.Operation.MoveInPlane.Position.Y := -0.120;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		247:
			station.StateInfo := 'Shuttle 0 moves';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := 0.120;
			station.Operation.MoveInPlane.Position.Y := 0.0;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.JumpToState := 1000;
			END_IF;
							
		1000:
			station.StateInfo := 'Sync shuttles';
			// -----------------------------------------------------------------	 	 
			station.Commands.WaitUntilAllDone := TRUE;
		
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;
		1001:
			station.StateInfo := 'Decouple group';
			// -----------------------------------------------------------------
			station.Commands.Group.Decouple := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;	
		1002:
			station.StateInfo := 'Move shuttles to exit positions';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			
			station.Operation.Shuttle := station.Shuttles.List[0];
			station.Operation.MoveInPlane.Path := mcACP6D_PATH_X_THEN_Y;
			station.Operation.MoveInPlane.Position.X := 0.180;
			station.Operation.MoveInPlane.Position.Y := 1.860;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;
		1003:
			station.StateInfo := 'Move shuttles to exit positions';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.Shuttles.List[1];
			station.Operation.MoveInPlane.Path := mcACP6D_PATH_X_THEN_Y;
			station.Operation.MoveInPlane.Position.X := 0.060;
			station.Operation.MoveInPlane.Position.Y := 1.860;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;	
		1004:
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
