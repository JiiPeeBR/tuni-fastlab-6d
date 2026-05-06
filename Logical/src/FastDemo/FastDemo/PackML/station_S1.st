

ACTION execute_station_S1:
	// Point station reference to this station
	station ACCESS ADR(stations[1]);

	// Station parameters
	station.Station := ADR(S1);
	station.NextStation := ADR(S2);
	station.Parameters.ShuttleCapacity := 1;
	station.Parameters.Zone.BottomLeft.X := 0;
	station.Parameters.Zone.BottomLeft.Y := 0;
	station.Parameters.Zone.TopRight.X := 0.240;
	station.Parameters.Zone.TopRight.Y := 0.480;
	
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
			station.NextState := TRUE;
		101:
			station.StateInfo := 'Move to UL';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Position.X := 0.060;
			station.Operation.MoveInPlane.Position.Y := 0.420;
			station.Commands.MoveInPlane := TRUE;

			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		102:
			station.StateInfo := 'Move to LL';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveInPlane.Position.X := 0.060;
			station.Operation.MoveInPlane.Position.Y := 0.060;
			station.Commands.MoveInPlane := TRUE;

			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		103:
			station.StateInfo := 'Move to LR';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveInPlane.Position.X := 0.180;
			station.Operation.MoveInPlane.Position.Y := 0.060;
			station.Commands.MoveInPlane := TRUE;

			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		104:
			station.StateInfo := 'Move to UR';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveInPlane.Position.X := 0.180;
			station.Operation.MoveInPlane.Position.Y := 0.420;
			station.Commands.MoveInPlane := TRUE;

			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		105:
			station.StateInfo := 'Move to UL';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveInPlane.Position.X := 0.060;
			station.Operation.MoveInPlane.Position.Y := 0.420;
			station.Commands.MoveInPlane := TRUE;

			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		106:
			station.StateInfo := 'Move to LR';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveInPlane.Position.X := 0.180;
			station.Operation.MoveInPlane.Position.Y := 0.060;
			station.Commands.MoveInPlane := TRUE;

			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		107:
			station.StateInfo := 'Move to LL';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveInPlane.Position.X := 0.060;
			station.Operation.MoveInPlane.Position.Y := 0.060;
			station.Commands.MoveInPlane := TRUE;

			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		108:
			station.StateInfo := 'Move to UR';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveInPlane.Position.X := 0.180;
			station.Operation.MoveInPlane.Position.Y := 0.420;
			station.Commands.MoveInPlane := TRUE;

			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		109:
			station.StateInfo := 'Move to UL';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveInPlane.Position.X := 0.060;
			station.Operation.MoveInPlane.Position.Y := 0.420;
			station.Commands.MoveInPlane := TRUE;

			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		110:
			station.StateInfo := 'Move to LL';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveInPlane.Position.X := 0.060;
			station.Operation.MoveInPlane.Position.Y := 0.060;
			station.Commands.MoveInPlane := TRUE;

			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		111:
			station.StateInfo := 'Move right';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := 0.120;
			station.Operation.MoveInPlane.Position.Y := 0.000;
			station.Commands.MoveInPlane := TRUE;

			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		112:
			station.StateInfo := 'Move up';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := 0.000;
			station.Operation.MoveInPlane.Position.Y := 0.120;
			station.Commands.MoveInPlane := TRUE;

			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		113:
			station.StateInfo := 'Move left';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := - 0.120;
			station.Operation.MoveInPlane.Position.Y := 0.000;
			station.Commands.MoveInPlane := TRUE;

			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		114:
			station.StateInfo := 'Move up';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := 0.000;
			station.Operation.MoveInPlane.Position.Y := 0.120;
			station.Commands.MoveInPlane := TRUE;

			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		115:
			station.StateInfo := 'Move right';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := 0.120;
			station.Operation.MoveInPlane.Position.Y := 0.000;
			station.Commands.MoveInPlane := TRUE;

			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		116:
			station.StateInfo := 'Move up';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := 0.000;
			station.Operation.MoveInPlane.Position.Y := 0.120;
			station.Commands.MoveInPlane := TRUE;

			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		117:
			station.StateInfo := 'Move left';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := - 0.120;
			station.Operation.MoveInPlane.Position.Y := 0.000;
			station.Commands.MoveInPlane := TRUE;

			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		118:
			station.StateInfo := 'Move down';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := 0.000;
			station.Operation.MoveInPlane.Position.Y := - 0.120;
			station.Commands.MoveInPlane := TRUE;

			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		119:
			station.StateInfo := 'Move right';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := 0.120;
			station.Operation.MoveInPlane.Position.Y := 0.000;
			station.Commands.MoveInPlane := TRUE;

			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		120:
			station.StateInfo := 'Move down';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := 0.000;
			station.Operation.MoveInPlane.Position.Y := - 0.120;
			station.Commands.MoveInPlane := TRUE;

			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		121:
			station.StateInfo := 'Move left';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := - 0.120;
			station.Operation.MoveInPlane.Position.Y := 0.000;
			station.Commands.MoveInPlane := TRUE;

			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		122:
			station.StateInfo := 'Move down';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := 0.000;
			station.Operation.MoveInPlane.Position.Y := - 0.120;
			station.Commands.MoveInPlane := TRUE;

			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		123:
			station.StateInfo := 'Move right';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := 0.120;
			station.Operation.MoveInPlane.Position.Y := 0.000;
			station.Commands.MoveInPlane := TRUE;

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
				station.Loop := station.Loop + 1;
				IF station.Loop < 3 THEN
					station.Commands.MacroRun := FALSE;
				ELSE
					station.JumpToState := 1000;
				END_IF;
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
