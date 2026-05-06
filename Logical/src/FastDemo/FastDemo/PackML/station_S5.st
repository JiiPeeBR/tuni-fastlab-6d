
ACTION execute_station_S5:
	// Point station reference to this station
	station ACCESS ADR(stations[5]);

	// Station parameters
	station.Station := ADR(S5);
	station.NextStation := ADR(S6);
	station.Parameters.ShuttleCapacity := 2;
	station.Parameters.Zone.BottomLeft.X := 0.720;
	station.Parameters.Zone.BottomLeft.Y := 2.880;
	station.Parameters.Zone.TopRight.X := 0.960;
	station.Parameters.Zone.TopRight.Y := 3.360;
		
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
			station.Operation.MoveInPlane.Position.X := 0.900;
			station.Operation.MoveInPlane.Position.Y := 2.940;
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
			station.Operation.MoveInPlane.Position.X := 0.780;
			station.Operation.MoveInPlane.Position.Y := 2.940;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;
		206:
			station.StateInfo := 'Couple grouped shuttles together';
			// -----------------------------------------------------------------
			station.Commands.Group.Couple_CommonCenterPoint := TRUE;
			
			IF station.CommandDone THEN
				station.JumpToState := 300;
			END_IF;
			
		300:
			station.StateInfo := 'Move group init';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			station.Loop := 0;
			station.Operation.Shuttle := station.Shuttles.List[0];
			station.NextState := TRUE;
		301:
			station.StateInfo := 'Move group';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode :=  mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := 0.0;
			station.Operation.MoveInPlane.Position.Y := 0.360;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		302:
			station.StateInfo := 'Move group';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode :=  mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := 0.0;
			station.Operation.MoveInPlane.Position.Y := -0.360;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		303:
			station.StateInfo := 'Move group';
			// -----------------------------------------------------------------
			IF station.Loop < 4 THEN
				station.JumpToState := 301;
				station.Loop := station.Loop + 1;
			ELSE
				station.JumpToState := 400;
			END_IF;
			
		400:
			station.StateInfo := 'Decouple group';
			// -----------------------------------------------------------------
			station.Commands.Group.Decouple := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;
		401:
			station.StateInfo := 'Move shuttle 1';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.Shuttles.List[0];
			station.Operation.MoveInPlane.Position.X := 0.000;
			station.Operation.MoveInPlane.Position.Y := 0.360;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		402:
			station.StateInfo := 'Move shuttle 1';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Position.X := -0.060;
			station.Operation.MoveInPlane.Position.Y := 0.000;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		403:
			station.StateInfo := 'Move shuttle 1 to mid';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Position.X := 0.000;
			station.Operation.MoveInPlane.Position.Y := -0.120;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		404:
			station.StateInfo := 'Move shuttle 2';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.Shuttles.List[1];
			station.Operation.MoveInPlane.Position.X := 0.060;
			station.Operation.MoveInPlane.Position.Y := 0.000;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		405:
			station.StateInfo := 'Move shuttle 2 to mid';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Position.X := 0.000;
			station.Operation.MoveInPlane.Position.Y := 0.120;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		406:
			station.StateInfo := 'Sync shuttles';
			// -----------------------------------------------------------------
			station.Commands.WaitUntilAllDone := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;
		407:
			station.StateInfo := 'Group shuttles';
			// -----------------------------------------------------------------
			station.Commands.Group.Couple_CommonCenterPoint := TRUE;
			
			IF station.CommandDone THEN
				station.JumpToState := 420;
			END_IF;	
		420:
			station.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			
			station.Loop := 0;
			brsmemset(ADR(station.Operation.MoveShortAxis.Position), 0, SIZEOF(station.Operation.MoveShortAxis.Position));
			station.Operation.MoveShortAxis.Rotation.Type := mcACP6D_SHORT_AX_ROT_CENTER;
			station.Operation.MoveShortAxis.Rotation.Center.X := 0.840;
			station.Operation.MoveShortAxis.Rotation.Center.Y := 3.120;
			station.Operation.MoveShortAxis.Velocity.Rz := 0.3;
			station.Operation.Shuttle := station.Shuttles.List[0];
			station.NextState := TRUE;
		421:
			station.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveShortAxis.Position.Rz := 0.15;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;	
		422:
			station.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveShortAxis.Position.Rz := -0.30;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;	
		423:
			station.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveShortAxis.Position.Rz := 0.15;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;	
		424:
			station.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			IF station.Loop < 2 THEN
				station.JumpToState := 421;
				station.Loop := station.Loop + 1;
			ELSE
				station.Loop := 0;
				station.JumpToState := 500;
			END_IF;
		500:
			station.StateInfo := 'Group move initialize';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			station.Loop := 0;
			station.NextState := TRUE;
		501:
			station.StateInfo := 'Group move';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.Shuttles.List[0];
			station.Operation.MoveInPlane.Mode :=  mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := 0.060;
			station.Operation.MoveInPlane.Position.Y := 0.000;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;	
		502:
			station.StateInfo := 'Group move';
			// -----------------------------------------------------------------
			station.Operation.MoveArc.Direction := mcACP6D_ARC_COUNTER_CLOCKWISE;
			station.Operation.MoveArc.Angular.Angle :=  10 * brmTWOPI;
			station.Operation.MoveArc.Angular.Center.X := -0.060;
			station.Operation.MoveArc.Angular.Center.Y := 0.000;
			station.Operation.MoveArc.EndVelocity := 1.5;
			station.Commands.MoveArc := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;	
		503:
			station.StateInfo := 'Group move';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode :=  mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := 0.000;
			station.Operation.MoveInPlane.Position.Y := 0.120;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;	
		504:
			station.StateInfo := 'Group move';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode :=  mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := -0.120;
			station.Operation.MoveInPlane.Position.Y := 0.000;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;	
		505:
			station.StateInfo := 'Group move';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode :=  mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := 0.000;
			station.Operation.MoveInPlane.Position.Y := -0.240;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;	
		506:
			station.StateInfo := 'Group move';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode :=  mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := 0.120;
			station.Operation.MoveInPlane.Position.Y := 0.000;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;	
		507:
			station.StateInfo := 'Group move';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode :=  mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := 0.000;
			station.Operation.MoveInPlane.Position.Y := 0.240;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandDone THEN
				station.JumpToState := 508;
			END_IF;	
		508:
			station.StateInfo := 'decouple shuttles';
			// -----------------------------------------------------------------
			station.Commands.Group.Decouple := TRUE;
			
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
	
END_ACTION
