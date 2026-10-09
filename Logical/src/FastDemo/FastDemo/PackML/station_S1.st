

ACTION StationSequence_S1:
	// Point station reference to this station
	pStation ACCESS ADR(stations[1]);

	// Station parameters
//	pStation.Station := ADR(S1);
//	pStation.NextStation := ADR(S2);
	pStation.Parameters.ShuttleCapacity := 1;
	pStation.Parameters.Zone.BottomLeft.X := 0;
	pStation.Parameters.Zone.BottomLeft.Y := 0;
	pStation.Parameters.Zone.TopRight.X := 0.240;
	pStation.Parameters.Zone.TopRight.Y := 0.480;
	
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
			pStation.NextState := TRUE;
		101:
			pStation.StateInfo := 'Move to UL';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Position.X := 0.060;
			pStation.Operation.MoveInPlane.Position.Y := 0.420;
			pStation.Commands.MoveInPlane := TRUE;

			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		102:
			pStation.StateInfo := 'Move to LL';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveInPlane.Position.X := 0.060;
			pStation.Operation.MoveInPlane.Position.Y := 0.060;
			pStation.Commands.MoveInPlane := TRUE;

			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		103:
			pStation.StateInfo := 'Move to LR';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveInPlane.Position.X := 0.180;
			pStation.Operation.MoveInPlane.Position.Y := 0.060;
			pStation.Commands.MoveInPlane := TRUE;

			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		104:
			pStation.StateInfo := 'Move to UR';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveInPlane.Position.X := 0.180;
			pStation.Operation.MoveInPlane.Position.Y := 0.420;
			pStation.Commands.MoveInPlane := TRUE;

			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		105:
			pStation.StateInfo := 'Move to UL';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveInPlane.Position.X := 0.060;
			pStation.Operation.MoveInPlane.Position.Y := 0.420;
			pStation.Commands.MoveInPlane := TRUE;

			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		106:
			pStation.StateInfo := 'Move to LR';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveInPlane.Position.X := 0.180;
			pStation.Operation.MoveInPlane.Position.Y := 0.060;
			pStation.Commands.MoveInPlane := TRUE;

			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		107:
			pStation.StateInfo := 'Move to LL';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveInPlane.Position.X := 0.060;
			pStation.Operation.MoveInPlane.Position.Y := 0.060;
			pStation.Commands.MoveInPlane := TRUE;

			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		108:
			pStation.StateInfo := 'Move to UR';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveInPlane.Position.X := 0.180;
			pStation.Operation.MoveInPlane.Position.Y := 0.420;
			pStation.Commands.MoveInPlane := TRUE;

			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		109:
			pStation.StateInfo := 'Move to UL';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveInPlane.Position.X := 0.060;
			pStation.Operation.MoveInPlane.Position.Y := 0.420;
			pStation.Commands.MoveInPlane := TRUE;

			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		110:
			pStation.StateInfo := 'Move to LL';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveInPlane.Position.X := 0.060;
			pStation.Operation.MoveInPlane.Position.Y := 0.060;
			pStation.Commands.MoveInPlane := TRUE;

			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		111:
			pStation.StateInfo := 'Move right';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := 0.120;
			pStation.Operation.MoveInPlane.Position.Y := 0.000;
			pStation.Commands.MoveInPlane := TRUE;

			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		112:
			pStation.StateInfo := 'Move up';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Position.Y := 0.120;
			pStation.Commands.MoveInPlane := TRUE;

			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		113:
			pStation.StateInfo := 'Move left';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := - 0.120;
			pStation.Operation.MoveInPlane.Position.Y := 0.000;
			pStation.Commands.MoveInPlane := TRUE;

			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		114:
			pStation.StateInfo := 'Move up';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Position.Y := 0.120;
			pStation.Commands.MoveInPlane := TRUE;

			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		115:
			pStation.StateInfo := 'Move right';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := 0.120;
			pStation.Operation.MoveInPlane.Position.Y := 0.000;
			pStation.Commands.MoveInPlane := TRUE;

			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		116:
			pStation.StateInfo := 'Move up';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Position.Y := 0.120;
			pStation.Commands.MoveInPlane := TRUE;

			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		117:
			pStation.StateInfo := 'Move left';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := - 0.120;
			pStation.Operation.MoveInPlane.Position.Y := 0.000;
			pStation.Commands.MoveInPlane := TRUE;

			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		118:
			pStation.StateInfo := 'Move down';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Position.Y := - 0.120;
			pStation.Commands.MoveInPlane := TRUE;

			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		119:
			pStation.StateInfo := 'Move right';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := 0.120;
			pStation.Operation.MoveInPlane.Position.Y := 0.000;
			pStation.Commands.MoveInPlane := TRUE;

			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		120:
			pStation.StateInfo := 'Move down';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Position.Y := - 0.120;
			pStation.Commands.MoveInPlane := TRUE;

			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		121:
			pStation.StateInfo := 'Move left';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := - 0.120;
			pStation.Operation.MoveInPlane.Position.Y := 0.000;
			pStation.Commands.MoveInPlane := TRUE;

			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		122:
			pStation.StateInfo := 'Move down';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Position.Y := - 0.120;
			pStation.Commands.MoveInPlane := TRUE;

			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		123:
			pStation.StateInfo := 'Move right';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := 0.120;
			pStation.Operation.MoveInPlane.Position.Y := 0.000;
			pStation.Commands.MoveInPlane := TRUE;

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
				pStation.Loop := pStation.Loop + 1;
				IF pStation.Loop < 3 THEN
					pStation.Commands.MacroRun := FALSE;
				ELSE
					pStation.TargetState := 1000;
					pStation.JumpToTargetState := TRUE;
				END_IF;
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
