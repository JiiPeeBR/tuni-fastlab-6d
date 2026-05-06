
ACTION execute_station_S6:
	// Point station reference to this station
	station ACCESS ADR(stations[6]);

	// Station parameters
	station.Station := ADR(S6);
	station.NextStation := ADR(B2);
	station.Parameters.ShuttleCapacity := 4;
	station.Parameters.CreateVirtualShuttle := TRUE;
	station.Parameters.Zone.BottomLeft.X := 0;
	station.Parameters.Zone.BottomLeft.Y := 4.320;
	station.Parameters.Zone.TopRight.X := 0.960;
	station.Parameters.Zone.TopRight.Y := 4.800;
	
	CASE station.State OF
		0:
			// Initialize station
			// -----------------------------------------------------------------
			IF station.Active THEN
				station.Loop := 0;
				station.JumpToState := 100;
			END_IF;
			
		100:
			// ----------------------------------------------------------------------------------------------------------------------------------
			station.StateInfo := 'Movement settings';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			station.Operation.Shuttle := station.MacroShuttle;
			station.NextState := TRUE;		
		101:
			station.StateInfo := 'Z height';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveShortAxis.Position.Z := 0.004;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;	
		102:
			station.StateInfo := 'X rotation';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveShortAxis.Position.Rx := 0.050;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		103:
			station.StateInfo := 'X rotation';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveShortAxis.Position.Rx := -0.050;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		104:
			station.StateInfo := 'X rotation';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveShortAxis.Position.Rx := 0.000;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		105:
			station.StateInfo := 'Y rotation';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveShortAxis.Position.Ry := 0.050;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		106:
			station.StateInfo := 'Y rotation';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveShortAxis.Position.Ry := -0.050;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		107:
			station.StateInfo := 'X rotation';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveShortAxis.Position.Ry := 0.000;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.JumpToState := 120;
			END_IF;
			
		120:
			station.StateInfo := 'Z bounce';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			station.Loop := 0;
			station.Operation.MoveShortAxis.Velocity.Z := 0.04;
			station.NextState := TRUE;
		121:
			station.StateInfo := 'Z bounce';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveShortAxis.Position.Z := 0.0005;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;	
		122:
			station.StateInfo := 'Z bounce';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveShortAxis.Position.Z := 0.004;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		123:
			station.StateInfo := 'Z bounce';
			// -----------------------------------------------------------------
			IF station.Loop < 6 THEN
				station.JumpToState := 121;
				station.Loop := station.Loop + 1;
			ELSE
				station.Loop := 0;
				station.NextState := TRUE;
			END_IF;
		124:
			station.StateInfo := 'Reset position';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			station.Commands.MoveShortAxis := TRUE;
			
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
			// ----------------------------------------------------------------------------------------------------------------------------------
			station.StateInfo := 'Waiting for 1st shuttle to arrive at station';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			station.Loop := 0;
			
			IF station.NumOccupyingShuttles = 1 THEN
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
			station.StateInfo := 'Move 1st shuttle to start position';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.Shuttles.List[0];
			station.Operation.MoveInPlane.Position.X := 0.320;
			station.Operation.MoveInPlane.Position.Y := 4.720;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;	
		203:	
			station.StateInfo := 'Waiting for 2nd shuttle to arrive at station';
			// -----------------------------------------------------------------
			IF station.NumOccupyingShuttles = 2 THEN		
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
			station.StateInfo := 'Move 2nd shuttle to start position';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.Shuttles.List[1];
			station.Operation.MoveInPlane.Position.X := 0.640;
			station.Operation.MoveInPlane.Position.Y := 4.720;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;	
		206:	
			station.StateInfo := 'Waiting for 3rd shuttle to arrive at station';
			// -----------------------------------------------------------------
			IF station.NumOccupyingShuttles = 3 THEN		
				station.NextState := TRUE;
			END_IF;
		207:
			station.StateInfo := 'Add last arrived shuttle to the station';
			// -----------------------------------------------------------------
			station.Commands.AddShuttle := TRUE;

			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;		
		208:
			station.StateInfo := 'Move 3rd shuttle to start position';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.Shuttles.List[2];
			station.Operation.MoveInPlane.Position.X := 0.320;
			station.Operation.MoveInPlane.Position.Y := 4.400;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;	
		209:	
			station.StateInfo := 'Waiting for 4th shuttle to arrive at station';
			// -----------------------------------------------------------------
			IF station.NumOccupyingShuttles = 4 THEN		
				station.NextState := TRUE;
			END_IF;
		210:
			station.StateInfo := 'Add last arrived shuttle to the station';
			// -----------------------------------------------------------------
			station.Commands.AddShuttle := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;		
		211:
			station.StateInfo := 'Move 4th shuttle to start position';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.Shuttles.List[3];
			station.Operation.MoveInPlane.Position.X := 0.640;
			station.Operation.MoveInPlane.Position.Y := 4.400;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;
		212:
			station.StateInfo := 'Couple grouped shuttles together';
			// -----------------------------------------------------------------
			station.Commands.Group.Couple_OwnCenterPoint := TRUE;
			
			IF station.CommandDone THEN
				station.JumpToState := 300;
			END_IF;
			
		300:
			// ----------------------------------------------------------------------------------------------------------------------------------
			station.StateInfo := 'Run macro';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.Shuttles.List[0];
			station.Commands.MacroRun := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;
		301:
			station.StateInfo := 'Decouple grouped shuttles';
			// -----------------------------------------------------------------
			station.Commands.Group.Decouple := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;
		302:
			station.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			
			station.Operation.Shuttle := station.Shuttles.List[0];
			station.Operation.MoveInPlane.Position.X := 0.420;
			station.Operation.MoveInPlane.Position.Y := 4.620;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		303:
			station.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.Shuttles.List[1];
			station.Operation.MoveInPlane.Position.X := 0.540;
			station.Operation.MoveInPlane.Position.Y := 4.620;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;
		304:
			station.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.Shuttles.List[2];
			station.Operation.MoveInPlane.Position.X := 0.420;
			station.Operation.MoveInPlane.Position.Y := 4.500;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;
		305:
			station.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.Shuttles.List[3];
			station.Operation.MoveInPlane.Position.X := 0.540;
			station.Operation.MoveInPlane.Position.Y := 4.500;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;
		306:
			station.StateInfo := 'Couple grouped shuttles';
			// -----------------------------------------------------------------
			station.Commands.Group.Couple_OwnCenterPoint := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;
		307:
			station.StateInfo := 'Move group to start position';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.Shuttles.List[0];
			station.Operation.MoveInPlane.Position.X := 0.300;
			station.Operation.MoveInPlane.Position.Y := 4.620;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandDone THEN
				station.JumpToState := 310;
			END_IF;
			
		310:
			station.StateInfo := 'Move in circles';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			
			station.Operation.MoveArc.EndVelocity := 1.5;
			station.Operation.Shuttle := station.Shuttles.List[0];
			station.Loop := 0;
			station.NextState := TRUE;
		311:
			station.StateInfo := '';
			// -----------------------------------------------------------------
			station.Operation.MoveArc.Direction := mcACP6D_ARC_CLOCKWISE;
			station.Operation.MoveArc.Angular.Angle := brmPI;
			station.Operation.MoveArc.Angular.Center.X := 0.120;
			station.Operation.MoveArc.Angular.Center.Y := 0.000;
			station.Commands.MoveArc := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;	
			END_IF;
		312:
			station.StateInfo := '';
			// -----------------------------------------------------------------
			station.Operation.MoveArc.Direction := mcACP6D_ARC_COUNTER_CLOCKWISE;
			station.Operation.MoveArc.Angular.Angle := brmTWOPI;
			station.Operation.MoveArc.Angular.Center.X := 0.120;
			station.Operation.MoveArc.Angular.Center.Y := 0.000;
			station.Commands.MoveArc := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;		
			END_IF;
		313:
			station.StateInfo := '';
			// -----------------------------------------------------------------
			station.Operation.MoveArc.Direction := mcACP6D_ARC_CLOCKWISE;
			station.Operation.MoveArc.Angular.Angle := brmPI;
			station.Operation.MoveArc.Angular.Center.X := -0.120;
			station.Operation.MoveArc.Angular.Center.Y := 0.000;
			station.Commands.MoveArc := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;	
			END_IF;
		314:
			station.StateInfo := '';
			// -----------------------------------------------------------------
			station.Operation.MoveArc.Direction := mcACP6D_ARC_COUNTER_CLOCKWISE;
			station.Operation.MoveArc.Angular.Angle := brmTWOPI;
			station.Operation.MoveArc.Angular.Center.X := -0.120;
			station.Operation.MoveArc.Angular.Center.Y := 0.000;
			station.Commands.MoveArc := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;	
			END_IF;
		315:
			station.StateInfo := '';
			// -----------------------------------------------------------------
			IF station.Loop < 3 THEN
				station.JumpToState := 311;
				station.Loop := station.Loop + 1;
			ELSE
				station.Loop := 0;
				station.NextState := TRUE;
			END_IF;
		316:
			station.StateInfo := 'End at middle';
			// -----------------------------------------------------------------
			station.Operation.MoveArc.EndVelocity := 0;
			station.Operation.MoveArc.Direction := mcACP6D_ARC_CLOCKWISE;
			station.Operation.MoveArc.Angular.Angle := brmPI;
			station.Operation.MoveArc.Angular.Center.X := 0.120;
			station.Operation.MoveArc.Angular.Center.Y := 0.000;
			station.Commands.MoveArc := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		317:
			station.StateInfo := 'End at middle';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Path :=  mcACP6D_PATH_DIRECT;
			station.Operation.Shuttle := station.Shuttles.List[0];
			station.Operation.MoveInPlane.Position.X := 0.420;
			station.Operation.MoveInPlane.Position.Y := 4.620;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandDone THEN
				station.JumpToState := 350;
			END_IF;
			
		350:
			station.StateInfo := 'Decouple grouped shuttles';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			
			station.Commands.Group.Decouple := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;
		351:
			station.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Path :=  mcACP6D_PATH_Y_THEN_X;
			station.Operation.Shuttle := station.Shuttles.List[0];
			station.Operation.MoveInPlane.Position.X := 0.660;
			station.Operation.MoveInPlane.Position.Y := 4.740;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;
		352:
			station.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Path :=  mcACP6D_PATH_Y_THEN_X;
			station.Operation.Shuttle := station.Shuttles.List[0];
			station.Operation.MoveInPlane.Position.X := 0.660;
			station.Operation.MoveInPlane.Position.Y := 4.620;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;
		353:
			station.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Path :=  mcACP6D_PATH_Y_THEN_X;
			station.Operation.Shuttle := station.Shuttles.List[2];
			station.Operation.MoveInPlane.Position.X := 0.420;
			station.Operation.MoveInPlane.Position.Y := 4.620;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;
		354:
			station.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Path :=  mcACP6D_PATH_X_THEN_Y;
			station.Operation.Shuttle := station.Shuttles.List[3];
			station.Operation.MoveInPlane.Position.X := 0.300;
			station.Operation.MoveInPlane.Position.Y := 4.620;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;
		355:
			station.StateInfo := 'Couple grouped shuttles';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
	
			station.Commands.Group.Couple_CommonCenterPoint := TRUE;
			
			IF station.CommandDone THEN
				station.JumpToState := 370;
			END_IF;	
		370:
			station.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			
			station.Loop := 0;
			brsmemset(ADR(station.Operation.MoveShortAxis.Position), 0, SIZEOF(station.Operation.MoveShortAxis.Position));
			station.Operation.MoveShortAxis.Rotation.Type := mcACP6D_SHORT_AX_ROT_CENTER;
			station.Operation.MoveShortAxis.Rotation.Center.X := 0.480;
			station.Operation.MoveShortAxis.Rotation.Center.Y := 4.620;
			station.Operation.MoveShortAxis.Velocity.Rz := 0.3;
			station.Operation.MoveShortAxis.Position.Z := 0;
			station.Operation.Shuttle := station.Shuttles.List[0];
			station.NextState := TRUE;
		371:
			station.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveShortAxis.Position.Rz := 0.15;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;	
		372:
			station.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveShortAxis.Position.Rz := -0.30;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;	
		373:
			station.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveShortAxis.Position.Rz := 0.15;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;	
		374:
			station.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			IF station.Loop < 1 THEN
				station.JumpToState := 371;
				station.Loop := station.Loop + 1;
			ELSE
				station.Loop := 0;
				station.NextState := TRUE;
			END_IF;
		375:
			station.StateInfo := 'Reset Short axis orientation to defaults';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			station.Operation.Shuttle := station.Shuttles.List[0];
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;	
		376:
			station.StateInfo := 'Decouple grouped shuttles';
			// -----------------------------------------------------------------
			station.Commands.Group.Decouple := TRUE;
			
			IF station.CommandDone THEN
				station.JumpToState := 400;
			END_IF;	
			
		400:
			station.StateInfo := 'Sun planet - Initialize';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			station.NextState := TRUE;
		401:
			station.StateInfo := 'Sun planet - Move virtual shuttle to start';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.VirtualShuttle;
			station.Operation.MoveInPlane.Position.X := 0.720;
			station.Operation.MoveInPlane.Position.Y := 4.560;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;
		402:
			station.StateInfo := 'Sun planet - Move shuttle to start';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.Shuttles.List[0];
			station.Operation.MoveInPlane.Position.X := 0.880;
			station.Operation.MoveInPlane.Position.Y := 4.560;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;
		403:
			station.StateInfo := 'Sun planet - Move shuttle to start';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.Shuttles.List[1];
			station.Operation.MoveInPlane.Position.X := 0.720;
			station.Operation.MoveInPlane.Position.Y := 4.720;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;
		404:
			station.StateInfo := 'Sun planet - Move shuttle to start';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.Shuttles.List[2];
			station.Operation.MoveInPlane.Position.X := 0.720;
			station.Operation.MoveInPlane.Position.Y := 4.400;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;
		405:
			station.StateInfo := 'Sun planet - Move shuttle to start';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.Shuttles.List[3];
			station.Operation.MoveInPlane.Position.X := 0.560;
			station.Operation.MoveInPlane.Position.Y := 4.560;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;
		406:	
			station.StateInfo := 'Sun planet - Add planets around virtual shuttle';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.VirtualShuttle;
			station.Commands.SunPlanet.Couple := TRUE;
			
			IF station.CommandDone THEN
				station.JumpToState := 410;
			END_IF;
		
		410:
			station.StateInfo := 'Sun planet - Orbit initialize';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			station.Operation.MoveArc.Mode :=  mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveArc.Angular.Angle := 10 * brmTWOPI;
			
			// Set all planets to wait for virtual (sun) planet movement command label
			station.Operation.WaitCommandLabel.TriggerShuttleID := station.VirtualShuttle.ShuttleID;
			station.Operation.WaitCommandLabel.TriggerCmdLb := 100; 
			station.NextState := TRUE;
		411:
			station.StateInfo := 'Sun planet - Add wait for label';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.Shuttles.List[0];
			station.Commands.WaitCommandLabel := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		412:
			station.StateInfo := 'Sun planet - Add arc command';
			// -----------------------------------------------------------------			
			station.Operation.Shuttle := station.Shuttles.List[0];
			station.Commands.MoveArc := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;	
		413:
			station.StateInfo := 'Sun planet - Add wait for label';
			// -----------------------------------------------------------------			
			station.Operation.Shuttle := station.Shuttles.List[1];
			station.Commands.WaitCommandLabel := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		414:
			station.StateInfo := 'Sun planet - Add arc command';
			// -----------------------------------------------------------------			
			station.Operation.Shuttle := station.Shuttles.List[1];
			station.Commands.MoveArc := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;	
		415:
			station.StateInfo := 'Sun planet - Add wait for label';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.Shuttles.List[2];
			station.Commands.WaitCommandLabel := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		416:
			station.StateInfo := 'Sun planet - Add arc command';
			// -----------------------------------------------------------------			
			station.Operation.Shuttle := station.Shuttles.List[2];
			station.Commands.MoveArc := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;	
		417:
			station.StateInfo := 'Sun planet - Add wait for label';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.Shuttles.List[3];
			station.Commands.WaitCommandLabel := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		418:
			station.StateInfo := 'Sun planet - Add arc command';
			// -----------------------------------------------------------------	
			station.Operation.Shuttle := station.Shuttles.List[3];
			station.Commands.MoveArc := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.JumpToState := 420;
			END_IF;
			
		420:
			station.StateInfo := 'Sun planet - Move sun / trigger planet waits';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			
			station.Operation.CommandLabel.ManualMode := TRUE;
			station.Operation.CommandLabel.Label := 100;
			
			station.Operation.Shuttle := station.VirtualShuttle;
			station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := -0.480;
			station.Operation.MoveInPlane.Position.Y := 0;
			station.Operation.MoveInPlane.Velocity := 0.22;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.Operation.CommandLabel.ManualMode := FALSE;
				station.NextState := TRUE;
			END_IF;
		421:
			station.StateInfo := 'Sun planet - Move sun';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode :=  mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := 0.480;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.NextState := TRUE;
			END_IF;
		422:
			station.StateInfo := 'Sun planet - Move sun';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Mode :=  mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Position.X := -0.480;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandAcknowledge THEN
				station.JumpToState := 450;
			END_IF;
			
		450:
			station.StateInfo := 'Sync shuttles';
			// -----------------------------------------------------------------
			station.Commands.WaitUntilAllDone := TRUE;
		
			IF station.CommandDone THEN
	  			station.NextState := TRUE;
			END_IF;	
		451:	
			station.StateInfo := 'Sun planet - remove planets';
			// -----------------------------------------------------------------
			station.Commands.SunPlanet.Decouple := TRUE;
			
			IF station.CommandDone THEN
				station.JumpToState := 1000;
			END_IF;
				
		1000:
			// Return shuttles to the traffic network
			// ----------------------------------------------------------------------------------------------------------------------------------
			station.StateInfo := 'Move shuttles to exit positions';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			
			station.Operation.Shuttle := station.Shuttles.List[2];
			station.Operation.MoveInPlane.Position.X := 0.300;
			station.Operation.MoveInPlane.Position.Y := 4.380;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;
		1001:
			station.StateInfo := 'Move shuttles to exit positions';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.Shuttles.List[0];
			station.Operation.MoveInPlane.Position.X := 0.300;
			station.Operation.MoveInPlane.Position.Y := 4.500;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;
		1002:
			station.StateInfo := 'Move shuttles to exit positions';
			// -----------------------------------------------------------------
			station.Operation.Shuttle := station.Shuttles.List[1];
			station.Operation.MoveInPlane.Position.X := 0.300;
			station.Operation.MoveInPlane.Position.Y := 4.740;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.CommandDone THEN
				station.NextState := TRUE;
			END_IF;
		1003:
			station.StateInfo := 'Move shuttles to exit positions';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Path := mcACP6D_PATH_Y_THEN_X;
			station.Operation.Shuttle := station.Shuttles.List[3];
			station.Operation.MoveInPlane.Position.X := 0.300;
			station.Operation.MoveInPlane.Position.Y := 4.620;
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
