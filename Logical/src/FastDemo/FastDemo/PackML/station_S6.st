
ACTION Station_Sequence_S6:
	// Point station reference to this station
	pStation ACCESS ADR(Stations[6]);
			
	// Station control logic and mapping
	// -----------------------------------------------------------------
	pStation.Control.Enable := TRUE;
	pStation.Control.Station := ADR(S6);
	pStation.Control.To := ADR(B2);
	pStation.Macro.Name := 'S6';
	pStation.Zone.Name := 'Z6';
	pStation.Operation.StationQueueControl.ShuttleCapacity := 4;
	
	// -----------------------------------------------------------------
	CASE pStation.State OF
		0:	
			pStation.Var.StateInfo := 'Activating station';
			// -----------------------------------------------------------------
			IF pStation.Control.Active AND pStation.Control.State = mpTRAFFIC_ST_ON_OPEN THEN
				pStation.State := pStation.State + 1;	
			END_IF
		1:
			pStation.Var.StateInfo := 'Create shuttle group';
			// -----------------------------------------------------------------
			pStation.Commands.Group.Create := TRUE;
			IF pStation.Group.GroupCreate.Done THEN
				pStation.Group.ShuttleGroup := pStation.Group.GroupCreate.ShuttleGroup;
				pStation.State := 10;
			END_IF;
		10:
			pStation.Var.StateInfo := 'Create virtual shuttle';
			// -----------------------------------------------------------------
			IF pStation.Virtual.Shuttle.controlif = 0 THEN
				pStation.State := pStation.State + 1;
			ELSE
				pStation.State := 20;
			END_IF;
		11:
			pStation.Var.StateInfo := 'Create virtual shuttle';
			// -----------------------------------------------------------------
			pStation.Commands.CreateVirtualShuttle := TRUE;
		
			IF pStation.Virtual.VirtualShCreate.Done THEN
				pStation.Virtual.Shuttle := pStation.Virtual.VirtualShCreate.VirtualShuttle;
				pStation.State := pStation.State + 1;
			END_IF;
		12:
			pStation.Var.StateInfo := 'Create virtual shuttle';
			// -----------------------------------------------------------------
			pStation.Operation.GetShuttleInfo.Shuttle := ADR(pStation.Virtual.Shuttle);
			
			pStation.Commands.GetShuttleInfo := TRUE;
		
			IF pStation.Operation.GetShuttleInfo.Done THEN
				pStation.Virtual.ShuttleID := pStation.Operation.GetShuttleInfo.ShuttleInfo.ShuttleID;
				pStation.State := 20;
			END_IF;
		20:
			pStation.Var.StateInfo := 'Find station zone by name';
			// -----------------------------------------------------------------
			brsmemset(ADR(pStation.Zone.Zone), 0, SIZEOF(pStation.Zone.Zone));
			pStation.Zone.FindZone.Name := pStation.Zone.Name;
			pStation.Commands.Zone.Find := TRUE;
			
			IF pStation.Zone.FindZone.ZoneFound THEN
				pStation.Zone.Zone := pStation.Zone.FindZone.Zone;
				pStation.State := 30;	
			ELSIF pStation.Zone.FindZone.ZoneNotFound THEN
	  			pStation.State := pStation.State + 1;
			END_IF;
		21:
			pStation.Var.StateInfo := 'Create zone';
			// -----------------------------------------------------------------
			pStation.Zone.ZoneCreate.Parameters.BottomLeft.X := 0.000; 
			pStation.Zone.ZoneCreate.Parameters.BottomLeft.Y := 4.320;
			pStation.Zone.ZoneCreate.Parameters.TopRight.X := 0.960;
			pStation.Zone.ZoneCreate.Parameters.TopRight.Y := 4.800;
			pStation.Zone.ZoneCreate.Parameters.Name := pStation.Zone.Name;
			pStation.Commands.Zone.Create := TRUE;
		
			IF pStation.Zone.ZoneCreate.Done THEN
				// Go back one step and rescan the zones to get the zone reference
				pStation.State := pStation.State - 1;
			END_IF;
		30:
			pStation.Var.StateInfo := 'Check if station sequence macro exists';
			// -----------------------------------------------------------------	
			IF pStation.Macro.Shuttle.controlif = 0 THEN
				pStation.State := pStation.State + 1;
			ELSE
				pStation.State := 200;
			END_IF;
		31:
			pStation.Var.StateInfo := 'Check if station sequence macro exists';
			// -----------------------------------------------------------------
			pStation.Commands.Macro.Create := TRUE;
		
			IF pStation.Macro.MacroCreate.Done THEN
				pStation.Macro.Shuttle := pStation.Macro.MacroCreate.MacroShuttle;
				pStation.State := 100;
			END_IF;
	
		
		100:
			// 6D movement sequence macro
			// ----------------------------------------------------------------------------------------------------------------------------------
			reset_parameters_all;
			
			pStation.Var.LoopNum := 0;
			pStation.Operation.MoveShortAxis.Shuttle := ADR(pStation.Macro.Shuttle);
			pStation.State := pStation.State + 1;		
		101:
			pStation.Var.StateInfo := 'Z height';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Parameters.Position.Z := 0.004;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.Operation.MoveShortAxis.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;	
		102:
			pStation.Var.StateInfo := 'X rotation';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Parameters.Position.Rx := 0.050;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.Operation.MoveShortAxis.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		103:
			pStation.Var.StateInfo := 'X rotation';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Parameters.Position.Rx := -0.050;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.Operation.MoveShortAxis.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		104:
			pStation.Var.StateInfo := 'X rotation';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Parameters.Position.Rx := 0.000;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.Operation.MoveShortAxis.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		105:
			pStation.Var.StateInfo := 'Y rotation';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Parameters.Position.Ry := 0.050;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.Operation.MoveShortAxis.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		106:
			pStation.Var.StateInfo := 'Y rotation';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Parameters.Position.Ry := -0.050;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.Operation.MoveShortAxis.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		107:
			pStation.Var.StateInfo := 'X rotation';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Parameters.Position.Ry := 0.000;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.Operation.MoveShortAxis.Acknowledge THEN
				pStation.State := 120;
			END_IF;
			
		120:
			pStation.Var.StateInfo := 'Z bounce';
			// -----------------------------------------------------------------
			reset_parameters_all;
		
			pStation.Var.LoopNum := 0;
			pStation.Operation.MoveShortAxis.Parameters.Velocity.Z := 0.04;
			pStation.State := pStation.State + 1;
		121:
			pStation.Var.StateInfo := 'Z bounce';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Parameters.Position.Z := 0.0005;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.Operation.MoveShortAxis.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;	
		122:
			pStation.Var.StateInfo := 'Z bounce';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Parameters.Position.Z := 0.004;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.Operation.MoveShortAxis.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		123:
			pStation.Var.StateInfo := 'Z bounce';
			// -----------------------------------------------------------------
			IF pStation.Var.LoopNum < 6 THEN
				pStation.State := 121;
				pStation.Var.LoopNum := pStation.Var.LoopNum + 1;
			ELSE
				pStation.Var.LoopNum := 0;
				pStation.State := pStation.State + 1;
			END_IF;
		124:
			pStation.Var.StateInfo := 'Z bounce';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Parameters.Position.Z := 0.004;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.Operation.MoveShortAxis.Acknowledge THEN
				pStation.State := 141;
			END_IF;
		141:
			pStation.Var.StateInfo := 'Reset position';
			// -----------------------------------------------------------------
			reset_parameters_MoveShortAxis;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.Operation.MoveShortAxis.Acknowledge THEN
				pStation.State := 199;
			END_IF;
			
		199:	
			pStation.Var.StateInfo := 'Save macro';
			// -----------------------------------------------------------------
			pStation.Commands.Macro.Save := TRUE;
			
			IF pStation.Macro.MacroSave.Done THEN
				pStation.State := 200;
			END_IF;	
			
		200:
			// Station initial sequence
			// ----------------------------------------------------------------------------------------------------------------------------------
			pStation.Var.StateInfo := 'Initialize station sequence';
			// -----------------------------------------------------------------
			reset_parameters_all;
			
			pStation.ShuttleCount := 0;
			brsmemset(ADR(pStation.Shuttles), 0, SIZEOF(pStation.Shuttles));
			pStation.State := pStation.State + 1;
		201:
			pStation.Var.StateInfo := 'Waiting for shuttle 1 to arrive at station';
			// -----------------------------------------------------------------
			IF pStation.Control.Info.NumOccupyingShuttles = 1 THEN
				pStation.Shuttles[pStation.ShuttleCount] := pStation.Control.Info.LastArrivedShuttle;
				pStation.ShuttleCount := pStation.ShuttleCount + 1;
				pStation.State := pStation.State + 1;
			END_IF;	
		202:
			pStation.Var.StateInfo := 'Move first shuttle to start position';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[0].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.320;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 4.720;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		203:	
			pStation.Var.StateInfo := 'Waiting for shuttle 2 to arrive at station';
			// -----------------------------------------------------------------
			IF pStation.Control.Info.NumOccupyingShuttles = 2 THEN		
				pStation.Shuttles[pStation.ShuttleCount] := pStation.Control.Info.LastArrivedShuttle;
				pStation.ShuttleCount := pStation.ShuttleCount + 1;
				pStation.State := pStation.State + 1;
			END_IF;
		204:
			pStation.Var.StateInfo := 'Move shuttle 2 to start position';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[1].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.640;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 4.720;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		205:
			pStation.Var.StateInfo := 'Waiting for shuttle 3 to arrive at station';
			// -----------------------------------------------------------------
			IF pStation.Control.Info.NumOccupyingShuttles = 3 THEN
				pStation.Shuttles[pStation.ShuttleCount] := pStation.Control.Info.LastArrivedShuttle;
				pStation.ShuttleCount := pStation.ShuttleCount + 1;
				pStation.State := pStation.State + 1;
			END_IF;	
		206:
			pStation.Var.StateInfo := 'Move shuttle 3 to start position';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[2].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.320;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 4.400;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		207:	
			pStation.Var.StateInfo := 'Waiting for shuttle 4 to arrive at station';
			// -----------------------------------------------------------------
			IF pStation.Control.Info.NumOccupyingShuttles = 4 THEN		
				pStation.Shuttles[pStation.ShuttleCount] := pStation.Control.Info.LastArrivedShuttle;
				pStation.ShuttleCount := pStation.ShuttleCount + 1;
				pStation.State := pStation.State + 1;
			END_IF;
		208:
			pStation.Var.StateInfo := 'Move shuttle 4 to start position';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[3].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.640;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 4.400;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		209:
			pStation.Var.StateInfo := 'Add shuttles to group';
			// -----------------------------------------------------------------
			pStation.Group.GroupAddShuttle.Parameters.ShuttleList[0].Shuttle := ADR(pStation.Shuttles[0].Shuttle6D);
			pStation.Group.GroupAddShuttle.Parameters.ShuttleList[1].Shuttle := ADR(pStation.Shuttles[1].Shuttle6D);
			pStation.Group.GroupAddShuttle.Parameters.ShuttleList[2].Shuttle := ADR(pStation.Shuttles[2].Shuttle6D);
			pStation.Group.GroupAddShuttle.Parameters.ShuttleList[3].Shuttle := ADR(pStation.Shuttles[3].Shuttle6D);
			pStation.Commands.Group.AddShuttle := TRUE;
			
			IF pStation.Group.GroupAddShuttle.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		210:
			pStation.Var.StateInfo := 'Couple grouped shuttles together';
			// -----------------------------------------------------------------
			pStation.Group.GroupCoupleCtrl.Parameters.Mode := mcACP6D_SH_GROUP_INDV_ROT_REF;
			pStation.Group.GroupCoupleCtrl.Parameters.Option := mcACP6D_SH_GROUP_COUPLE;
			pStation.Commands.Group.ChangeCoupling := TRUE;
			
			IF pStation.Group.GroupCoupleCtrl.Done THEN
				pStation.State := 300;
			END_IF;
			
		300:
			// Station sequence
			// ----------------------------------------------------------------------------------------------------------------------------------
			pStation.Var.StateInfo := 'Run macro';
			// -----------------------------------------------------------------
			reset_parameters_all;
			
			pStation.Macro.MacroRun.Shuttle := ADR(pStation.Shuttles[0].Shuttle6D);
			pStation.Macro.Execute := TRUE;
			
			IF pStation.Macro.MacroRun.Done THEN
				pStation.Macro.Execute := FALSE;
				pStation.State := pStation.State + 1;
			END_IF;
		301:
			pStation.Var.StateInfo := 'Decouple grouped shuttles';
			// -----------------------------------------------------------------
			pStation.Group.GroupCoupleCtrl.Parameters.Mode := mcACP6D_SH_GROUP_INDV_ROT_REF;
			pStation.Group.GroupCoupleCtrl.Parameters.Option := mcACP6D_SH_GROUP_DECOUPLE;
			pStation.Commands.Group.ChangeCoupling := TRUE;
			
			IF pStation.Group.GroupCoupleCtrl.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		302:
			pStation.Var.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[0].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.420;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 4.620;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		303:
			pStation.Var.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[1].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.540;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 4.620;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		304:
			pStation.Var.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[2].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.420;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 4.500;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		305:
			pStation.Var.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[3].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.540;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 4.500;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		306:
			pStation.Var.StateInfo := 'Couple grouped shuttles';
			// -----------------------------------------------------------------
			pStation.Group.GroupCoupleCtrl.Parameters.Mode := mcACP6D_SH_GROUP_INDV_ROT_REF;
			pStation.Group.GroupCoupleCtrl.Parameters.Option := mcACP6D_SH_GROUP_COUPLE;
			pStation.Commands.Group.ChangeCoupling := TRUE;
			
			IF pStation.Group.GroupCoupleCtrl.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		307:
			pStation.Var.StateInfo := 'Move group to start position';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[0].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.300;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 4.620;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Done THEN
				pStation.State := 310;
			END_IF;
			
		310:
			pStation.Var.StateInfo := 'Move in circles';
			// -----------------------------------------------------------------
			reset_parameters_MoveArc;
			pStation.Operation.MoveArc.Parameters.EndVelocity := 1.5;
			pStation.Operation.MoveArc.Shuttle := ADR(pStation.Shuttles[0].Shuttle6D);
			
			pStation.Var.LoopNum := 0;
			pStation.State := pStation.State + 1;
		311:
			pStation.Var.StateInfo := '';
			// -----------------------------------------------------------------
			pStation.Operation.MoveArc.Parameters.Direction := mcACP6D_ARC_CLOCKWISE;
			pStation.Operation.MoveArc.Parameters.Angular.Angle := brmPI;
			pStation.Operation.MoveArc.Parameters.Angular.Center.X := 0.120;
			pStation.Operation.MoveArc.Parameters.Angular.Center.Y := 0.000;
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.Operation.MoveArc.Acknowledge THEN
				pStation.State := pStation.State + 1;	
			END_IF;
		312:
			pStation.Var.StateInfo := '';
			// -----------------------------------------------------------------
			pStation.Operation.MoveArc.Parameters.Direction := mcACP6D_ARC_COUNTER_CLOCKWISE;
			pStation.Operation.MoveArc.Parameters.Angular.Angle := brmTWOPI;
			pStation.Operation.MoveArc.Parameters.Angular.Center.X := 0.120;
			pStation.Operation.MoveArc.Parameters.Angular.Center.Y := 0.000;
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.Operation.MoveArc.Acknowledge THEN
				pStation.State := pStation.State + 1;		
			END_IF;
		313:
			pStation.Var.StateInfo := '';
			// -----------------------------------------------------------------
			pStation.Operation.MoveArc.Parameters.Direction := mcACP6D_ARC_CLOCKWISE;
			pStation.Operation.MoveArc.Parameters.Angular.Angle := brmPI;
			pStation.Operation.MoveArc.Parameters.Angular.Center.X := -0.120;
			pStation.Operation.MoveArc.Parameters.Angular.Center.Y := 0.000;
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.Operation.MoveArc.Acknowledge THEN
				pStation.State := pStation.State + 1;	
			END_IF;
		314:
			pStation.Var.StateInfo := '';
			// -----------------------------------------------------------------
			pStation.Operation.MoveArc.Parameters.Direction := mcACP6D_ARC_COUNTER_CLOCKWISE;
			pStation.Operation.MoveArc.Parameters.Angular.Angle := brmTWOPI;
			pStation.Operation.MoveArc.Parameters.Angular.Center.X := -0.120;
			pStation.Operation.MoveArc.Parameters.Angular.Center.Y := 0.000;
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.Operation.MoveArc.Acknowledge THEN
				pStation.State := pStation.State + 1;	
			END_IF;
		315:
			pStation.Var.StateInfo := '';
			// -----------------------------------------------------------------
			IF pStation.Var.LoopNum < 3 THEN
				pStation.State := 311;
				pStation.Var.LoopNum := pStation.Var.LoopNum + 1;
			ELSE
				pStation.Var.LoopNum := 0;
				pStation.State := pStation.State + 1;
			END_IF;
		316:
			pStation.Var.StateInfo := 'End at middle';
			// -----------------------------------------------------------------
			pStation.Operation.MoveArc.Parameters.EndVelocity := 0;
			pStation.Operation.MoveArc.Parameters.Direction := mcACP6D_ARC_CLOCKWISE;
			pStation.Operation.MoveArc.Parameters.Angular.Angle := brmPI;
			pStation.Operation.MoveArc.Parameters.Angular.Center.X := 0.120;
			pStation.Operation.MoveArc.Parameters.Angular.Center.Y := 0.000;
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.Operation.MoveArc.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		317:
			pStation.Var.StateInfo := 'End at middle';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_DIRECT;
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[0].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.420;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 4.620;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Done THEN
				pStation.State := 350;
			END_IF;
			
		350:
			pStation.Var.StateInfo := 'Decouple grouped shuttles';
			// -----------------------------------------------------------------
			reset_parameters_MoveInPlane;
			
			pStation.Group.GroupCoupleCtrl.Parameters.Mode := mcACP6D_SH_GROUP_INDV_ROT_REF;
			pStation.Group.GroupCoupleCtrl.Parameters.Option := mcACP6D_SH_GROUP_DECOUPLE;
			pStation.Commands.Group.ChangeCoupling := TRUE;
			
			IF pStation.Group.GroupCoupleCtrl.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		351:
			pStation.Var.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_Y_THEN_X;
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[0].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.660;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 4.740;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		352:
			pStation.Var.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_Y_THEN_X;
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[0].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.660;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 4.620;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		353:
			pStation.Var.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_Y_THEN_X;
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[2].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.420;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 4.620;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		354:
			pStation.Var.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_X_THEN_Y;
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[3].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.300;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 4.620;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		355:
			pStation.Var.StateInfo := 'Couple grouped shuttles';
			// -----------------------------------------------------------------
			reset_parameters_MoveInPlane;
			
			pStation.Group.GroupCoupleCtrl.Parameters.Mode := mcACP6D_SH_GROUP_CMN_ROT_REF;
			pStation.Group.GroupCoupleCtrl.Parameters.Option := mcACP6D_SH_GROUP_COUPLE;
			pStation.Commands.Group.ChangeCoupling := TRUE;
			
			IF pStation.Group.GroupCoupleCtrl.Done THEN
				pStation.State := 370;
			END_IF;	
		370:
			pStation.Var.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			reset_parameters_MoveShortAxis;
			
			pStation.Var.LoopNum := 0;
			pStation.Operation.MoveShortAxis.Parameters.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveShortAxis.Parameters.Position.Z := 0;
			pStation.Operation.MoveShortAxis.Parameters.Rotation.Type := mcACP6D_SHORT_AX_ROT_CENTER;
			pStation.Operation.MoveShortAxis.Parameters.Rotation.Center.X := 0.480;
			pStation.Operation.MoveShortAxis.Parameters.Rotation.Center.Y := 4.620;
			pStation.Operation.MoveShortAxis.Parameters.Velocity.Rz := 0.3;
			// Zero the position as we are moving relatively in this sequence
			brsmemset(ADR(pStation.Operation.MoveShortAxis.Parameters.Position), 0, SIZEOF(pStation.Operation.MoveShortAxis.Parameters.Position));
			pStation.Operation.MoveShortAxis.Shuttle := ADR(pStation.Shuttles[0].Shuttle6D);
			pStation.State := pStation.State + 1;
		371:
			pStation.Var.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Parameters.Position.Rz := 0.15;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.Operation.MoveShortAxis.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;	
		372:
			pStation.Var.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Parameters.Position.Rz := -0.30;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.Operation.MoveShortAxis.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;	
		373:
			pStation.Var.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Parameters.Position.Rz := 0.15;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.Operation.MoveShortAxis.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;	
		374:
			pStation.Var.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			IF pStation.Var.LoopNum < 1 THEN
				pStation.State := 371;
				pStation.Var.LoopNum := pStation.Var.LoopNum + 1;
			ELSE
				pStation.Var.LoopNum := 0;
				pStation.State := pStation.State + 1;
			END_IF;
		375:
			pStation.Var.StateInfo := 'Reset Short axis orientation to defaults';
			// -----------------------------------------------------------------
			reset_parameters_MoveShortAxis;
			pStation.Operation.MoveShortAxis.Shuttle := ADR(pStation.Shuttles[0].Shuttle6D);
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.Operation.MoveShortAxis.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;	
		376:
			pStation.Var.StateInfo := 'Decouple grouped shuttles';
			// -----------------------------------------------------------------
			pStation.Group.GroupCoupleCtrl.Parameters.Option := mcACP6D_SH_GROUP_DECOUPLE;
			pStation.Commands.Group.ChangeCoupling := TRUE;
			
			IF pStation.Group.GroupCoupleCtrl.Done THEN
				pStation.State := 400;
			END_IF;	
			
		400:
			pStation.Var.StateInfo := 'Sun planet - Initialize';
			// -----------------------------------------------------------------
			reset_parameters_all;
			
			pStation.Operation.SunPlanet.Shuttle := ADR(pStation.Virtual.Shuttle);
			FOR i := 0 TO 3 DO
				pStation.Operation.SunPlanet.Parameters.ShuttleList[i].Shuttle := ADR(pStation.Shuttles[i].Shuttle6D);
			END_FOR;
			
			pStation.State := pStation.State + 1;
		401:
			pStation.Var.StateInfo := 'Sun planet - Move virtual shuttle to start';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Virtual.Shuttle);
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.720;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 4.560;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		402:
			pStation.Var.StateInfo := 'Sun planet - Move shuttle to start';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[0].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.880;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 4.560;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		403:
			pStation.Var.StateInfo := 'Sun planet - Move shuttle to start';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[1].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.720;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 4.720;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		404:
			pStation.Var.StateInfo := 'Sun planet - Move shuttle to start';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[2].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.720;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 4.400;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		405:
			pStation.Var.StateInfo := 'Sun planet - Move shuttle to start';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[3].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.560;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 4.560;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		406:	
			pStation.Var.StateInfo := 'Sun planet - Create planet';
			// -----------------------------------------------------------------
			pStation.Operation.SunPlanet.Parameters.Option :=  mcACP6D_PLANET_ADD_SH;
			pStation.Commands.ChangePlanet := TRUE;
			
			IF pStation.Operation.SunPlanet.Done THEN
				pStation.State := 410;
			END_IF;
		
		410:
			pStation.Var.StateInfo := 'Sun planet - Orbit initialize';
			// -----------------------------------------------------------------
			reset_parameters_all;
			pStation.Operation.MoveArc.Parameters.Mode :=  mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveArc.Parameters.Angular.Angle := 10 * brmTWOPI;
			pStation.Operation.WaitCommandLabel.TriggerXID := pStation.Virtual.ShuttleID;
			pStation.Operation.WaitCommandLabel.TriggerCmdLb := 0;
			pStation.State := pStation.State + 1;
		411:
			pStation.Var.StateInfo := 'Sun planet - Add wait for label';
			// -----------------------------------------------------------------			
			pStation.Operation.WaitCommandLabel.Shuttle := ADR(pStation.Shuttles[0].Shuttle6D);
			pStation.Commands.WaitCommandLabel := TRUE;
			
			IF pStation.Operation.WaitCommandLabel.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		412:
			pStation.Var.StateInfo := 'Sun planet - Add arc command';
			// -----------------------------------------------------------------			
			pStation.Operation.MoveArc.Shuttle := ADR(pStation.Shuttles[0].Shuttle6D);
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.Operation.MoveArc.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;	
		413:
			pStation.Var.StateInfo := 'Sun planet - Add wait for label';
			// -----------------------------------------------------------------			
			pStation.Operation.WaitCommandLabel.Shuttle := ADR(pStation.Shuttles[1].Shuttle6D);
			pStation.Commands.WaitCommandLabel := TRUE;
			
			IF pStation.Operation.WaitCommandLabel.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		414:
			pStation.Var.StateInfo := 'Sun planet - Add arc command';
			// -----------------------------------------------------------------			
			pStation.Operation.MoveArc.Shuttle := ADR(pStation.Shuttles[1].Shuttle6D);
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.Operation.MoveArc.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;	
		415:
			pStation.Var.StateInfo := 'Sun planet - Add wait for label';
			// -----------------------------------------------------------------
			pStation.Operation.WaitCommandLabel.Shuttle := ADR(pStation.Shuttles[2].Shuttle6D);
			pStation.Commands.WaitCommandLabel := TRUE;
			
			IF pStation.Operation.WaitCommandLabel.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		416:
			pStation.Var.StateInfo := 'Sun planet - Add arc command';
			// -----------------------------------------------------------------			
			pStation.Operation.MoveArc.Shuttle := ADR(pStation.Shuttles[2].Shuttle6D);
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.Operation.MoveArc.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;	
		417:
			pStation.Var.StateInfo := 'Sun planet - Add wait for label';
			// -----------------------------------------------------------------
			pStation.Operation.WaitCommandLabel.Shuttle := ADR(pStation.Shuttles[3].Shuttle6D);
			pStation.Commands.WaitCommandLabel := TRUE;
			
			IF pStation.Operation.WaitCommandLabel.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		418:
			pStation.Var.StateInfo := 'Sun planet - Add arc command';
			// -----------------------------------------------------------------	
			pStation.Operation.MoveArc.Shuttle := ADR(pStation.Shuttles[3].Shuttle6D);
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.Operation.MoveArc.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;		
		419:
			pStation.Var.StateInfo := 'Sun planet - Move planet';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Virtual.Shuttle);
			pStation.Operation.MoveInPlane.Parameters.Position.X := -0.480;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0;
			pStation.Operation.MoveInPlane.Parameters.Velocity := 0.22;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		420:
			pStation.Var.StateInfo := 'Sun planet - Move planet';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.480;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		421:
			pStation.Var.StateInfo := 'Sun planet - Move planet';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := -0.480;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := 430;
			END_IF;
		430:
			pStation.Var.StateInfo := 'Sync shuttles';
			// -----------------------------------------------------------------
			pStation.Operation.WaitUntilAllDone.Shuttles[0] := pStation.Shuttles[0].Shuttle6D;	 
			pStation.Operation.WaitUntilAllDone.Shuttles[1] := pStation.Shuttles[1].Shuttle6D;	 
			pStation.Operation.WaitUntilAllDone.Shuttles[2] := pStation.Shuttles[2].Shuttle6D;	 
			pStation.Operation.WaitUntilAllDone.Shuttles[3] := pStation.Shuttles[3].Shuttle6D;	 
			pStation.Commands.WaitUntilAllDone := TRUE;
		
			IF pStation.Operation.WaitUntilAllDone.Done THEN
	  			pStation.State := 450;
			END_IF;
			
		450:	
			pStation.Var.StateInfo := 'Sun planet - remove planets';
			// -----------------------------------------------------------------
			pStation.Operation.SunPlanet.Parameters.Option :=  mcACP6D_PLANET_REMOVE_SH;
			pStation.Commands.ChangePlanet := TRUE;
			
			IF pStation.Operation.SunPlanet.Done THEN
				//pStation.State := pStation.State + 1;
				pStation.State := 1000;
			END_IF;
			
		1000:
			// Return shuttles to the traffic network
			// ----------------------------------------------------------------------------------------------------------------------------------
			pStation.Var.StateInfo := 'Move shuttles to exit positions';
			// -----------------------------------------------------------------
			reset_parameters_all;
			
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[2].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.300;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 4.380;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		1001:
			pStation.Var.StateInfo := 'Move shuttles to exit positions';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[0].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.300;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 4.500;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		1002:
			pStation.Var.StateInfo := 'Move shuttles to exit positions';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[1].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.300;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 4.740;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		1003:
			pStation.Var.StateInfo := 'Move shuttles to exit positions';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Path := mcACP6D_PATH_Y_THEN_X;
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[3].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.300;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 4.620;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		1004:
			pStation.Var.StateInfo := 'Clear group';
			// -----------------------------------------------------------------
			pStation.Commands.Group.Clear := TRUE;
			
			IF pStation.Group.GroupClear.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;		
		1005:
			pStation.Var.StateInfo := 'Release shuttles';
			// -----------------------------------------------------------------
			pStation.Operation.StationQueueControl.ShuttleList[0] := pStation.Shuttles[0];
			pStation.Operation.StationQueueControl.ShuttleList[1] := pStation.Shuttles[1];
			pStation.Operation.StationQueueControl.ShuttleList[2] := pStation.Shuttles[2];
			pStation.Operation.StationQueueControl.ShuttleList[3] := pStation.Shuttles[3];
			pStation.Commands.Release := TRUE;
			
			IF pStation.Operation.StationQueueControl.ShuttleReleaseDone THEN
				pStation.State := pStation.State + 1;
			END_IF;
		1006:
			pStation.Var.StateInfo := 'Wait until shuttles at the station have all left';
			// -----------------------------------------------------------------
			pStation.Commands.Zone.GetBarrierInfo := TRUE;
			
			IF pStation.Zone.ZoneGetBarrierInfo.Done THEN
				pStation.Commands.Zone.GetBarrierInfo := FALSE;
				IF pStation.Zone.ZoneGetBarrierInfo.BarrierInfo.NumberOfShuttles = 0 THEN
					pStation.State := 200;	
				END_IF;
			END_IF;
	END_CASE;
	
	// Reset station commands when state changes
	IF pStation.State <> pStation.Var.PreviousState THEN
		pStation.Var.PreviousState := pStation.State;
		brsmemset(ADR(pStation.Commands), 0, SIZEOF(pStation.Commands));
	END_IF;
	
END_ACTION
