
ACTION StationSequence_S5:
	// Point station reference to this station
	pStation ACCESS ADR(stations[5]);

	// Station parameters
//	pStation.Station := ADR(S5);
//	pStation.NextStation := ADR(S6);
	pStation.Parameters.ShuttleCapacity := 2;
	pStation.Parameters.Zone.BottomLeft.X := 0.720;
	pStation.Parameters.Zone.BottomLeft.Y := 2.880;
	pStation.Parameters.Zone.TopRight.X := 0.960;
	pStation.Parameters.Zone.TopRight.Y := 3.360;
		
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
			pStation.Operation.MoveInPlane.Position.X := 0.900;
			pStation.Operation.MoveInPlane.Position.Y := 2.940;
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
			pStation.Operation.MoveInPlane.Position.X := 0.780;
			pStation.Operation.MoveInPlane.Position.Y := 2.940;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;
		206:
			pStation.StateInfo := 'Couple grouped shuttles together';
			// -----------------------------------------------------------------
			pStation.Commands.Group.Couple_CommonCenterPoint := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.TargetState := 300;
				pStation.JumpToTargetState := TRUE;
			END_IF;
			
		300:
			pStation.StateInfo := 'Move group init';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			pStation.Loop := 0;
			pStation.Operation.Shuttle := pStation.Shuttles.List[0];
			pStation.NextState := TRUE;
		301:
			pStation.StateInfo := 'Move group';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode :=  mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := 0.0;
			pStation.Operation.MoveInPlane.Position.Y := 0.360;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		302:
			pStation.StateInfo := 'Move group';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode :=  mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := 0.0;
			pStation.Operation.MoveInPlane.Position.Y := -0.360;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		303:
			pStation.StateInfo := 'Move group';
			// -----------------------------------------------------------------
			IF pStation.Loop < 4 THEN
				pStation.TargetState := 301;
				pStation.JumpToTargetState := TRUE;
				pStation.Loop := pStation.Loop + 1;
			ELSE
				pStation.TargetState := 400;
				pStation.JumpToTargetState := TRUE;
			END_IF;
			
		400:
			pStation.StateInfo := 'Decouple group';
			// -----------------------------------------------------------------
			pStation.Commands.Group.Decouple := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;
		401:
			pStation.StateInfo := 'Move shuttle 1';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.Shuttles.List[0];
			pStation.Operation.MoveInPlane.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Position.Y := 0.360;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		402:
			pStation.StateInfo := 'Move shuttle 1';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Position.X := -0.060;
			pStation.Operation.MoveInPlane.Position.Y := 0.000;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		403:
			pStation.StateInfo := 'Move shuttle 1 to mid';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Position.Y := -0.120;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		404:
			pStation.StateInfo := 'Move shuttle 2';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.Shuttles.List[1];
			pStation.Operation.MoveInPlane.Position.X := 0.060;
			pStation.Operation.MoveInPlane.Position.Y := 0.000;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		405:
			pStation.StateInfo := 'Move shuttle 2 to mid';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Position.Y := 0.120;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		406:
			pStation.StateInfo := 'Sync shuttles';
			// -----------------------------------------------------------------
			pStation.Commands.WaitUntilAllDone := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;
		407:
			pStation.StateInfo := 'Group shuttles';
			// -----------------------------------------------------------------
			pStation.Commands.Group.Couple_CommonCenterPoint := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.TargetState := 420;
				pStation.JumpToTargetState := TRUE;
			END_IF;	
		420:
			pStation.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			
			pStation.Loop := 0;
			brsmemset(ADR(pStation.Operation.MoveShortAxis.Position), 0, SIZEOF(pStation.Operation.MoveShortAxis.Position));
			pStation.Operation.MoveShortAxis.Rotation.Type := mcACP6D_SHORT_AX_ROT_CENTER;
			pStation.Operation.MoveShortAxis.Rotation.Center.X := 0.840;
			pStation.Operation.MoveShortAxis.Rotation.Center.Y := 3.120;
			pStation.Operation.MoveShortAxis.Velocity.Rz := 0.3;
			pStation.Operation.Shuttle := pStation.Shuttles.List[0];
			pStation.NextState := TRUE;
		421:
			pStation.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveShortAxis.Position.Rz := 0.15;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;	
		422:
			pStation.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveShortAxis.Position.Rz := -0.30;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;	
		423:
			pStation.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveShortAxis.Position.Rz := 0.15;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;	
		424:
			pStation.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			IF pStation.Loop < 2 THEN
				pStation.TargetState := 421;
				pStation.JumpToTargetState := TRUE;
				pStation.Loop := pStation.Loop + 1;
			ELSE
				pStation.Loop := 0;
				pStation.TargetState := 500;
				pStation.JumpToTargetState := TRUE;
			END_IF;
		500:
			pStation.StateInfo := 'Group move initialize';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			pStation.Loop := 0;
			pStation.NextState := TRUE;
		501:
			pStation.StateInfo := 'Group move';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.Shuttles.List[0];
			pStation.Operation.MoveInPlane.Mode :=  mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := 0.060;
			pStation.Operation.MoveInPlane.Position.Y := 0.000;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;	
		502:
			pStation.StateInfo := 'Group move';
			// -----------------------------------------------------------------
			pStation.Operation.MoveArc.Direction := mcACP6D_ARC_COUNTER_CLOCKWISE;
			pStation.Operation.MoveArc.Angular.Angle :=  10 * brmTWOPI;
			pStation.Operation.MoveArc.Angular.Center.X := -0.060;
			pStation.Operation.MoveArc.Angular.Center.Y := 0.000;
			pStation.Operation.MoveArc.EndVelocity := 1.5;
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;	
		503:
			pStation.StateInfo := 'Group move';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode :=  mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Position.Y := 0.120;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;	
		504:
			pStation.StateInfo := 'Group move';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode :=  mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := -0.120;
			pStation.Operation.MoveInPlane.Position.Y := 0.000;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;	
		505:
			pStation.StateInfo := 'Group move';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode :=  mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Position.Y := -0.240;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;	
		506:
			pStation.StateInfo := 'Group move';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode :=  mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := 0.120;
			pStation.Operation.MoveInPlane.Position.Y := 0.000;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;	
		507:
			pStation.StateInfo := 'Group move';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode :=  mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Position.Y := 0.240;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.TargetState := 508;
				pStation.JumpToTargetState := TRUE;
			END_IF;	
		508:
			pStation.StateInfo := 'decouple shuttles';
			// -----------------------------------------------------------------
			pStation.Commands.Group.Decouple := TRUE;
			
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
	
END_ACTION
