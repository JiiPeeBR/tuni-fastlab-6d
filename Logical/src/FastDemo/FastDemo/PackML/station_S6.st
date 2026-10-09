
ACTION StationSequence_S6:
	// Point station reference to this station
	pStation ACCESS ADR(stations[6]);

	// Station parameters
//	pStation.Station := ADR(S6);
//	pStation.NextStation := ADR(B2);
	pStation.Parameters.ShuttleCapacity := 4;
	pStation.Parameters.CreateVirtualShuttle := TRUE;
	pStation.Parameters.Zone.BottomLeft.X := 0;
	pStation.Parameters.Zone.BottomLeft.Y := 4.320;
	pStation.Parameters.Zone.TopRight.X := 0.960;
	pStation.Parameters.Zone.TopRight.Y := 4.800;
	
	CASE pStation.State OF
		0:
			// Initialize station
			// -----------------------------------------------------------------
			IF pStation.Active THEN
				pStation.Loop := 0;
				pStation.TargetState := 100;
				pStation.JumpToTargetState := TRUE;
			END_IF;
			
		100:
			// ----------------------------------------------------------------------------------------------------------------------------------
			pStation.StateInfo := 'Movement settings';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			pStation.Operation.Shuttle := pStation.MacroShuttle;
			pStation.NextState := TRUE;		
		101:
			pStation.StateInfo := 'Z height';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveShortAxis.Position.Z := 0.004;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;	
		102:
			pStation.StateInfo := 'X rotation';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveShortAxis.Position.Rx := 0.050;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		103:
			pStation.StateInfo := 'X rotation';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveShortAxis.Position.Rx := -0.050;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		104:
			pStation.StateInfo := 'X rotation';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveShortAxis.Position.Rx := 0.000;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		105:
			pStation.StateInfo := 'Y rotation';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveShortAxis.Position.Ry := 0.050;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		106:
			pStation.StateInfo := 'Y rotation';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveShortAxis.Position.Ry := -0.050;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		107:
			pStation.StateInfo := 'X rotation';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveShortAxis.Position.Ry := 0.000;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.TargetState := 120;
				pStation.JumpToTargetState := TRUE;
			END_IF;
			
		120:
			pStation.StateInfo := 'Z bounce';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			pStation.Loop := 0;
			pStation.Operation.MoveShortAxis.Velocity.Z := 0.04;
			pStation.NextState := TRUE;
		121:
			pStation.StateInfo := 'Z bounce';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveShortAxis.Position.Z := 0.0005;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;	
		122:
			pStation.StateInfo := 'Z bounce';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveShortAxis.Position.Z := 0.004;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		123:
			pStation.StateInfo := 'Z bounce';
			// -----------------------------------------------------------------
			IF pStation.Loop < 6 THEN
				pStation.TargetState := 121;
				pStation.JumpToTargetState := TRUE;
				pStation.Loop := pStation.Loop + 1;
			ELSE
				pStation.Loop := 0;
				pStation.NextState := TRUE;
			END_IF;
		124:
			pStation.StateInfo := 'Reset position';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			pStation.Commands.MoveShortAxis := TRUE;
			
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
			// ----------------------------------------------------------------------------------------------------------------------------------
			pStation.StateInfo := 'Waiting for 1st shuttle to arrive at station';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			pStation.Loop := 0;
			
			IF pStation.NumOccupyingShuttles = 1 THEN
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
			pStation.StateInfo := 'Move 1st shuttle to start position';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.Shuttles.List[0];
			pStation.Operation.MoveInPlane.Position.X := 0.320;
			pStation.Operation.MoveInPlane.Position.Y := 4.720;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;	
		203:	
			pStation.StateInfo := 'Waiting for 2nd shuttle to arrive at station';
			// -----------------------------------------------------------------
			IF pStation.NumOccupyingShuttles = 2 THEN		
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
			pStation.StateInfo := 'Move 2nd shuttle to start position';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.Shuttles.List[1];
			pStation.Operation.MoveInPlane.Position.X := 0.640;
			pStation.Operation.MoveInPlane.Position.Y := 4.720;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;	
		206:	
			pStation.StateInfo := 'Waiting for 3rd shuttle to arrive at station';
			// -----------------------------------------------------------------
			IF pStation.NumOccupyingShuttles = 3 THEN		
				pStation.NextState := TRUE;
			END_IF;
		207:
			pStation.StateInfo := 'Add last arrived shuttle to the station';
			// -----------------------------------------------------------------
			pStation.Commands.AddShuttle := TRUE;

			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;		
		208:
			pStation.StateInfo := 'Move 3rd shuttle to start position';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.Shuttles.List[2];
			pStation.Operation.MoveInPlane.Position.X := 0.320;
			pStation.Operation.MoveInPlane.Position.Y := 4.400;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;	
		209:	
			pStation.StateInfo := 'Waiting for 4th shuttle to arrive at station';
			// -----------------------------------------------------------------
			IF pStation.NumOccupyingShuttles = 4 THEN		
				pStation.NextState := TRUE;
			END_IF;
		210:
			pStation.StateInfo := 'Add last arrived shuttle to the station';
			// -----------------------------------------------------------------
			pStation.Commands.AddShuttle := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;		
		211:
			pStation.StateInfo := 'Move 4th shuttle to start position';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.Shuttles.List[3];
			pStation.Operation.MoveInPlane.Position.X := 0.640;
			pStation.Operation.MoveInPlane.Position.Y := 4.400;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;
		212:
			pStation.StateInfo := 'Couple grouped shuttles together';
			// -----------------------------------------------------------------
			pStation.Commands.Group.Couple_OwnCenterPoint := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.TargetState := 300;
				pStation.JumpToTargetState := TRUE;
			END_IF;
			
		300:
			// ----------------------------------------------------------------------------------------------------------------------------------
			pStation.StateInfo := 'Run macro';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.Shuttles.List[0];
			pStation.Commands.MacroRun := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;
		301:
			pStation.StateInfo := 'Decouple grouped shuttles';
			// -----------------------------------------------------------------
			pStation.Commands.Group.Decouple := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;
		302:
			pStation.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			
			pStation.Operation.Shuttle := pStation.Shuttles.List[0];
			pStation.Operation.MoveInPlane.Position.X := 0.420;
			pStation.Operation.MoveInPlane.Position.Y := 4.620;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		303:
			pStation.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.Shuttles.List[1];
			pStation.Operation.MoveInPlane.Position.X := 0.540;
			pStation.Operation.MoveInPlane.Position.Y := 4.620;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;
		304:
			pStation.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.Shuttles.List[2];
			pStation.Operation.MoveInPlane.Position.X := 0.420;
			pStation.Operation.MoveInPlane.Position.Y := 4.500;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;
		305:
			pStation.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.Shuttles.List[3];
			pStation.Operation.MoveInPlane.Position.X := 0.540;
			pStation.Operation.MoveInPlane.Position.Y := 4.500;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;
		306:
			pStation.StateInfo := 'Couple grouped shuttles';
			// -----------------------------------------------------------------
			pStation.Commands.Group.Couple_OwnCenterPoint := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;
		307:
			pStation.StateInfo := 'Move group to start position';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.Shuttles.List[0];
			pStation.Operation.MoveInPlane.Position.X := 0.300;
			pStation.Operation.MoveInPlane.Position.Y := 4.620;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.TargetState := 310;
				pStation.JumpToTargetState := TRUE;
			END_IF;
			
		310:
			pStation.StateInfo := 'Move in circles';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			
			pStation.Operation.MoveArc.EndVelocity := 1.5;
			pStation.Operation.Shuttle := pStation.Shuttles.List[0];
			pStation.Loop := 0;
			pStation.NextState := TRUE;
		311:
			pStation.StateInfo := '';
			// -----------------------------------------------------------------
			pStation.Operation.MoveArc.Direction := mcACP6D_ARC_CLOCKWISE;
			pStation.Operation.MoveArc.Angular.Angle := brmPI;
			pStation.Operation.MoveArc.Angular.Center.X := 0.120;
			pStation.Operation.MoveArc.Angular.Center.Y := 0.000;
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;	
			END_IF;
		312:
			pStation.StateInfo := '';
			// -----------------------------------------------------------------
			pStation.Operation.MoveArc.Direction := mcACP6D_ARC_COUNTER_CLOCKWISE;
			pStation.Operation.MoveArc.Angular.Angle := brmTWOPI;
			pStation.Operation.MoveArc.Angular.Center.X := 0.120;
			pStation.Operation.MoveArc.Angular.Center.Y := 0.000;
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;		
			END_IF;
		313:
			pStation.StateInfo := '';
			// -----------------------------------------------------------------
			pStation.Operation.MoveArc.Direction := mcACP6D_ARC_CLOCKWISE;
			pStation.Operation.MoveArc.Angular.Angle := brmPI;
			pStation.Operation.MoveArc.Angular.Center.X := -0.120;
			pStation.Operation.MoveArc.Angular.Center.Y := 0.000;
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;	
			END_IF;
		314:
			pStation.StateInfo := '';
			// -----------------------------------------------------------------
			pStation.Operation.MoveArc.Direction := mcACP6D_ARC_COUNTER_CLOCKWISE;
			pStation.Operation.MoveArc.Angular.Angle := brmTWOPI;
			pStation.Operation.MoveArc.Angular.Center.X := -0.120;
			pStation.Operation.MoveArc.Angular.Center.Y := 0.000;
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;	
			END_IF;
		315:
			pStation.StateInfo := '';
			// -----------------------------------------------------------------
			IF pStation.Loop < 3 THEN
				pStation.TargetState := 311;
				pStation.JumpToTargetState := TRUE;
				pStation.Loop := pStation.Loop + 1;
			ELSE
				pStation.Loop := 0;
				pStation.NextState := TRUE;
			END_IF;
		316:
			pStation.StateInfo := 'End at middle';
			// -----------------------------------------------------------------
			pStation.Operation.MoveArc.EndVelocity := 0;
			pStation.Operation.MoveArc.Direction := mcACP6D_ARC_CLOCKWISE;
			pStation.Operation.MoveArc.Angular.Angle := brmPI;
			pStation.Operation.MoveArc.Angular.Center.X := 0.120;
			pStation.Operation.MoveArc.Angular.Center.Y := 0.000;
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		317:
			pStation.StateInfo := 'End at middle';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Path :=  mcACP6D_PATH_DIRECT;
			pStation.Operation.Shuttle := pStation.Shuttles.List[0];
			pStation.Operation.MoveInPlane.Position.X := 0.420;
			pStation.Operation.MoveInPlane.Position.Y := 4.620;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.TargetState := 350;
				pStation.JumpToTargetState := TRUE;
			END_IF;
			
		350:
			pStation.StateInfo := 'Decouple grouped shuttles';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			
			pStation.Commands.Group.Decouple := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;
		351:
			pStation.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Path :=  mcACP6D_PATH_Y_THEN_X;
			pStation.Operation.Shuttle := pStation.Shuttles.List[0];
			pStation.Operation.MoveInPlane.Position.X := 0.660;
			pStation.Operation.MoveInPlane.Position.Y := 4.740;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;
		352:
			pStation.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Path :=  mcACP6D_PATH_Y_THEN_X;
			pStation.Operation.Shuttle := pStation.Shuttles.List[0];
			pStation.Operation.MoveInPlane.Position.X := 0.660;
			pStation.Operation.MoveInPlane.Position.Y := 4.620;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;
		353:
			pStation.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Path :=  mcACP6D_PATH_Y_THEN_X;
			pStation.Operation.Shuttle := pStation.Shuttles.List[2];
			pStation.Operation.MoveInPlane.Position.X := 0.420;
			pStation.Operation.MoveInPlane.Position.Y := 4.620;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;
		354:
			pStation.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Path :=  mcACP6D_PATH_X_THEN_Y;
			pStation.Operation.Shuttle := pStation.Shuttles.List[3];
			pStation.Operation.MoveInPlane.Position.X := 0.300;
			pStation.Operation.MoveInPlane.Position.Y := 4.620;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;
		355:
			pStation.StateInfo := 'Couple grouped shuttles';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
	
			pStation.Commands.Group.Couple_CommonCenterPoint := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.TargetState := 370;
				pStation.JumpToTargetState := TRUE;
			END_IF;	
		370:
			pStation.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			
			pStation.Loop := 0;
			brsmemset(ADR(pStation.Operation.MoveShortAxis.Position), 0, SIZEOF(pStation.Operation.MoveShortAxis.Position));
			pStation.Operation.MoveShortAxis.Rotation.Type := mcACP6D_SHORT_AX_ROT_CENTER;
			pStation.Operation.MoveShortAxis.Rotation.Center.X := 0.480;
			pStation.Operation.MoveShortAxis.Rotation.Center.Y := 4.620;
			pStation.Operation.MoveShortAxis.Velocity.Rz := 0.3;
			pStation.Operation.MoveShortAxis.Position.Z := 0;
			pStation.Operation.Shuttle := pStation.Shuttles.List[0];
			pStation.NextState := TRUE;
		371:
			pStation.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveShortAxis.Position.Rz := 0.15;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;	
		372:
			pStation.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveShortAxis.Position.Rz := -0.30;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;	
		373:
			pStation.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveShortAxis.Position.Rz := 0.15;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;	
		374:
			pStation.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			IF pStation.Loop < 1 THEN
				pStation.TargetState := 371;
				pStation.JumpToTargetState := TRUE;
				pStation.Loop := pStation.Loop + 1;
			ELSE
				pStation.Loop := 0;
				pStation.NextState := TRUE;
			END_IF;
		375:
			pStation.StateInfo := 'Reset Short axis orientation to defaults';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			pStation.Operation.Shuttle := pStation.Shuttles.List[0];
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;	
		376:
			pStation.StateInfo := 'Decouple grouped shuttles';
			// -----------------------------------------------------------------
			pStation.Commands.Group.Decouple := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.TargetState := 400;
				pStation.JumpToTargetState := TRUE;
			END_IF;	
			
		400:
			pStation.StateInfo := 'Sun planet - Initialize';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			pStation.NextState := TRUE;
		401:
			pStation.StateInfo := 'Sun planet - Move virtual shuttle to start';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.VirtualShuttle;
			pStation.Operation.MoveInPlane.Position.X := 0.720;
			pStation.Operation.MoveInPlane.Position.Y := 4.560;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;
		402:
			pStation.StateInfo := 'Sun planet - Move shuttle to start';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.Shuttles.List[0];
			pStation.Operation.MoveInPlane.Position.X := 0.880;
			pStation.Operation.MoveInPlane.Position.Y := 4.560;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;
		403:
			pStation.StateInfo := 'Sun planet - Move shuttle to start';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.Shuttles.List[1];
			pStation.Operation.MoveInPlane.Position.X := 0.720;
			pStation.Operation.MoveInPlane.Position.Y := 4.720;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;
		404:
			pStation.StateInfo := 'Sun planet - Move shuttle to start';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.Shuttles.List[2];
			pStation.Operation.MoveInPlane.Position.X := 0.720;
			pStation.Operation.MoveInPlane.Position.Y := 4.400;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;
		405:
			pStation.StateInfo := 'Sun planet - Move shuttle to start';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.Shuttles.List[3];
			pStation.Operation.MoveInPlane.Position.X := 0.560;
			pStation.Operation.MoveInPlane.Position.Y := 4.560;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;
		406:	
			pStation.StateInfo := 'Sun planet - Add planets around virtual shuttle';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.VirtualShuttle;
			pStation.Commands.SunPlanet.Couple := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.TargetState := 410;
				pStation.JumpToTargetState := TRUE;
			END_IF;
		
		410:
			pStation.StateInfo := 'Sun planet - Orbit initialize';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			pStation.Operation.MoveArc.Mode :=  mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveArc.Angular.Angle := 10 * brmTWOPI;
			
			// Set all planets to wait for virtual (sun) planet movement command label
			pStation.Operation.WaitCommandLabel.TriggerShuttleID := pStation.VirtualShuttle.ShuttleID;
			pStation.Operation.WaitCommandLabel.TriggerCmdLb := 100; 
			pStation.NextState := TRUE;
		411:
			pStation.StateInfo := 'Sun planet - Add wait for label';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.Shuttles.List[0];
			pStation.Commands.WaitCommandLabel := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		412:
			pStation.StateInfo := 'Sun planet - Add arc command';
			// -----------------------------------------------------------------			
			pStation.Operation.Shuttle := pStation.Shuttles.List[0];
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;	
		413:
			pStation.StateInfo := 'Sun planet - Add wait for label';
			// -----------------------------------------------------------------			
			pStation.Operation.Shuttle := pStation.Shuttles.List[1];
			pStation.Commands.WaitCommandLabel := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		414:
			pStation.StateInfo := 'Sun planet - Add arc command';
			// -----------------------------------------------------------------			
			pStation.Operation.Shuttle := pStation.Shuttles.List[1];
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;	
		415:
			pStation.StateInfo := 'Sun planet - Add wait for label';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.Shuttles.List[2];
			pStation.Commands.WaitCommandLabel := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		416:
			pStation.StateInfo := 'Sun planet - Add arc command';
			// -----------------------------------------------------------------			
			pStation.Operation.Shuttle := pStation.Shuttles.List[2];
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;	
		417:
			pStation.StateInfo := 'Sun planet - Add wait for label';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.Shuttles.List[3];
			pStation.Commands.WaitCommandLabel := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		418:
			pStation.StateInfo := 'Sun planet - Add arc command';
			// -----------------------------------------------------------------	
			pStation.Operation.Shuttle := pStation.Shuttles.List[3];
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.TargetState := 420;
				pStation.JumpToTargetState := TRUE;
			END_IF;
			
		420:
			pStation.StateInfo := 'Sun planet - Move sun / trigger planet waits';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			
			pStation.Operation.CommandLabel.ManualMode := TRUE;
			pStation.Operation.CommandLabel.Label := 100;
			
			pStation.Operation.Shuttle := pStation.VirtualShuttle;
			pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := -0.480;
			pStation.Operation.MoveInPlane.Position.Y := 0;
			pStation.Operation.MoveInPlane.Velocity := 0.22;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.Operation.CommandLabel.ManualMode := FALSE;
				pStation.NextState := TRUE;
			END_IF;
		421:
			pStation.StateInfo := 'Sun planet - Move sun';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode :=  mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := 0.480;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.NextState := TRUE;
			END_IF;
		422:
			pStation.StateInfo := 'Sun planet - Move sun';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Mode :=  mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Position.X := -0.480;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandAcknowledge THEN
				pStation.TargetState := 450;
				pStation.JumpToTargetState := TRUE;
			END_IF;
			
		450:
			pStation.StateInfo := 'Sync shuttles';
			// -----------------------------------------------------------------
			pStation.Commands.WaitUntilAllDone := TRUE;
		
			IF pStation.CommandDone THEN
	  			pStation.NextState := TRUE;
			END_IF;	
		451:	
			pStation.StateInfo := 'Sun planet - remove planets';
			// -----------------------------------------------------------------
			pStation.Commands.SunPlanet.Decouple := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.TargetState := 1000;
				pStation.JumpToTargetState := TRUE;
			END_IF;
				
		1000:
			// Return shuttles to the traffic network
			// ----------------------------------------------------------------------------------------------------------------------------------
			pStation.StateInfo := 'Move shuttles to exit positions';
			// -----------------------------------------------------------------
			set_movement_parameters_to_default_values;
			
			pStation.Operation.Shuttle := pStation.Shuttles.List[2];
			pStation.Operation.MoveInPlane.Position.X := 0.300;
			pStation.Operation.MoveInPlane.Position.Y := 4.380;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;
		1001:
			pStation.StateInfo := 'Move shuttles to exit positions';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.Shuttles.List[0];
			pStation.Operation.MoveInPlane.Position.X := 0.300;
			pStation.Operation.MoveInPlane.Position.Y := 4.500;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;
		1002:
			pStation.StateInfo := 'Move shuttles to exit positions';
			// -----------------------------------------------------------------
			pStation.Operation.Shuttle := pStation.Shuttles.List[1];
			pStation.Operation.MoveInPlane.Position.X := 0.300;
			pStation.Operation.MoveInPlane.Position.Y := 4.740;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.CommandDone THEN
				pStation.NextState := TRUE;
			END_IF;
		1003:
			pStation.StateInfo := 'Move shuttles to exit positions';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Path := mcACP6D_PATH_Y_THEN_X;
			pStation.Operation.Shuttle := pStation.Shuttles.List[3];
			pStation.Operation.MoveInPlane.Position.X := 0.300;
			pStation.Operation.MoveInPlane.Position.Y := 4.620;
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
