
ACTION execute_station_S6:
	// Point station reference to this station
	station ACCESS ADR(stations[6]);
			
	// Station control logic and mapping
	// -----------------------------------------------------------------
	station.Control.Enable := TRUE;
	station.Control.Station := ADR(S6);
	station.Control.To := ADR(B2);
	station.Macro.Name := 'S6';
	station.Zone.Name := 'Z6';
	station.Operation.StationQueueControl.ShuttleCapacity := 4;
	
	// -----------------------------------------------------------------
	CASE station.State OF
		0:	
			station.Var.StateInfo := 'Activating station';
			// -----------------------------------------------------------------
			IF station.Control.Active AND station.Control.State = mpTRAFFIC_ST_ON_OPEN THEN
				station.State := station.State + 1;	
			END_IF
		1:
			station.Var.StateInfo := 'Create shuttle group';
			// -----------------------------------------------------------------
			station.Commands.Group.Create := TRUE;
			IF station.Group.GroupCreate.Done THEN
				station.Group.ShuttleGroup := station.Group.GroupCreate.ShuttleGroup;
				station.State := 10;
			END_IF;
		10:
			station.Var.StateInfo := 'Create virtual shuttle';
			// -----------------------------------------------------------------
			IF station.Virtual.Shuttle.controlif = 0 THEN
				station.State := station.State + 1;
			ELSE
				station.State := 20;
			END_IF;
		11:
			station.Var.StateInfo := 'Create virtual shuttle';
			// -----------------------------------------------------------------
			station.Commands.CreateVirtualShuttle := TRUE;
		
			IF station.Virtual.VirtualShCreate.Done THEN
				station.Virtual.Shuttle := station.Virtual.VirtualShCreate.VirtualShuttle;
				station.State := station.State + 1;
			END_IF;
		12:
			station.Var.StateInfo := 'Create virtual shuttle';
			// -----------------------------------------------------------------
			station.Operation.GetShuttleInfo.Shuttle := ADR(station.Virtual.Shuttle);
			
			station.Commands.GetShuttleInfo := TRUE;
		
			IF station.Operation.GetShuttleInfo.Done THEN
				station.Virtual.ShuttleID := station.Operation.GetShuttleInfo.ShuttleInfo.ShuttleID;
				station.State := 20;
			END_IF;
		20:
			station.Var.StateInfo := 'Find station zone by name';
			// -----------------------------------------------------------------
			brsmemset(ADR(station.Zone.Zone), 0, SIZEOF(station.Zone.Zone));
			station.Zone.FindZone.Name := station.Zone.Name;
			station.Commands.Zone.Find := TRUE;
			
			IF station.Zone.FindZone.ZoneFound THEN
				station.Zone.Zone := station.Zone.FindZone.Zone;
				station.State := 30;	
			ELSIF station.Zone.FindZone.ZoneNotFound THEN
	  			station.State := station.State + 1;
			END_IF;
		21:
			station.Var.StateInfo := 'Create zone';
			// -----------------------------------------------------------------
			station.Zone.ZoneCreate.Parameters.BottomLeft.X := 0.000; 
			station.Zone.ZoneCreate.Parameters.BottomLeft.Y := 4.320;
			station.Zone.ZoneCreate.Parameters.TopRight.X := 0.960;
			station.Zone.ZoneCreate.Parameters.TopRight.Y := 4.800;
			station.Zone.ZoneCreate.Parameters.Name := station.Zone.Name;
			station.Commands.Zone.Create := TRUE;
		
			IF station.Zone.ZoneCreate.Done THEN
				// Go back one step and rescan the zones to get the zone reference
				station.State := station.State - 1;
			END_IF;
		30:
			station.Var.StateInfo := 'Check if station sequence macro exists';
			// -----------------------------------------------------------------	
			IF station.Macro.Shuttle.controlif = 0 THEN
				station.State := station.State + 1;
			ELSE
				station.State := 200;
			END_IF;
		31:
			station.Var.StateInfo := 'Check if station sequence macro exists';
			// -----------------------------------------------------------------
			station.Commands.Macro.Create := TRUE;
		
			IF station.Macro.MacroCreate.Done THEN
				station.Macro.Shuttle := station.Macro.MacroCreate.MacroShuttle;
				station.State := 100;
			END_IF;
	
		
		100:
			// 6D movement sequence macro
			// ----------------------------------------------------------------------------------------------------------------------------------
			reset_parameters_all;
			
			station.Var.LoopNum := 0;
			station.Operation.MoveShortAxis.Shuttle := ADR(station.Macro.Shuttle);
			station.State := station.State + 1;		
		101:
			station.Var.StateInfo := 'Z height';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Parameters.Position.Z := 0.004;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.Operation.MoveShortAxis.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;	
		102:
			station.Var.StateInfo := 'X rotation';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Parameters.Position.Rx := 0.050;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.Operation.MoveShortAxis.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		103:
			station.Var.StateInfo := 'X rotation';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Parameters.Position.Rx := -0.050;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.Operation.MoveShortAxis.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		104:
			station.Var.StateInfo := 'X rotation';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Parameters.Position.Rx := 0.000;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.Operation.MoveShortAxis.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		105:
			station.Var.StateInfo := 'Y rotation';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Parameters.Position.Ry := 0.050;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.Operation.MoveShortAxis.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		106:
			station.Var.StateInfo := 'Y rotation';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Parameters.Position.Ry := -0.050;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.Operation.MoveShortAxis.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		107:
			station.Var.StateInfo := 'X rotation';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Parameters.Position.Ry := 0.000;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.Operation.MoveShortAxis.Acknowledge THEN
				station.State := 120;
			END_IF;
			
		120:
			station.Var.StateInfo := 'Z bounce';
			// -----------------------------------------------------------------
			reset_parameters_all;
		
			station.Var.LoopNum := 0;
			station.Operation.MoveShortAxis.Parameters.Velocity.Z := 0.04;
			station.State := station.State + 1;
		121:
			station.Var.StateInfo := 'Z bounce';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Parameters.Position.Z := 0.0005;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.Operation.MoveShortAxis.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;	
		122:
			station.Var.StateInfo := 'Z bounce';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Parameters.Position.Z := 0.004;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.Operation.MoveShortAxis.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		123:
			station.Var.StateInfo := 'Z bounce';
			// -----------------------------------------------------------------
			IF station.Var.LoopNum < 6 THEN
				station.State := 121;
				station.Var.LoopNum := station.Var.LoopNum + 1;
			ELSE
				station.Var.LoopNum := 0;
				station.State := station.State + 1;
			END_IF;
		124:
			station.Var.StateInfo := 'Z bounce';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Parameters.Position.Z := 0.004;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.Operation.MoveShortAxis.Acknowledge THEN
				station.State := 141;
			END_IF;
		141:
			station.Var.StateInfo := 'Reset position';
			// -----------------------------------------------------------------
			reset_parameters_MoveShortAxis;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.Operation.MoveShortAxis.Acknowledge THEN
				station.State := 199;
			END_IF;
			
		199:	
			station.Var.StateInfo := 'Save macro';
			// -----------------------------------------------------------------
			station.Commands.Macro.Save := TRUE;
			
			IF station.Macro.MacroSave.Done THEN
				station.State := 200;
			END_IF;	
			
		200:
			// Station initial sequence
			// ----------------------------------------------------------------------------------------------------------------------------------
			station.Var.StateInfo := 'Initialize station sequence';
			// -----------------------------------------------------------------
			reset_parameters_all;
			
			station.ShuttleCount := 0;
			brsmemset(ADR(station.Shuttles), 0, SIZEOF(station.Shuttles));
			station.State := station.State + 1;
		201:
			station.Var.StateInfo := 'Waiting for shuttle 1 to arrive at station';
			// -----------------------------------------------------------------
			IF station.Control.Info.NumOccupyingShuttles = 1 THEN
				station.Shuttles[station.ShuttleCount] := station.Control.Info.LastArrivedShuttle;
				station.ShuttleCount := station.ShuttleCount + 1;
				station.State := station.State + 1;
			END_IF;	
		202:
			station.Var.StateInfo := 'Move first shuttle to start position';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[0].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.320;
			station.Operation.MoveInPlane.Parameters.Position.Y := 4.720;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := station.State + 1;
			END_IF;
		203:	
			station.Var.StateInfo := 'Waiting for shuttle 2 to arrive at station';
			// -----------------------------------------------------------------
			IF station.Control.Info.NumOccupyingShuttles = 2 THEN		
				station.Shuttles[station.ShuttleCount] := station.Control.Info.LastArrivedShuttle;
				station.ShuttleCount := station.ShuttleCount + 1;
				station.State := station.State + 1;
			END_IF;
		204:
			station.Var.StateInfo := 'Move shuttle 2 to start position';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[1].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.640;
			station.Operation.MoveInPlane.Parameters.Position.Y := 4.720;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := station.State + 1;
			END_IF;
		205:
			station.Var.StateInfo := 'Waiting for shuttle 3 to arrive at station';
			// -----------------------------------------------------------------
			IF station.Control.Info.NumOccupyingShuttles = 3 THEN
				station.Shuttles[station.ShuttleCount] := station.Control.Info.LastArrivedShuttle;
				station.ShuttleCount := station.ShuttleCount + 1;
				station.State := station.State + 1;
			END_IF;	
		206:
			station.Var.StateInfo := 'Move shuttle 3 to start position';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[2].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.320;
			station.Operation.MoveInPlane.Parameters.Position.Y := 4.400;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := station.State + 1;
			END_IF;
		207:	
			station.Var.StateInfo := 'Waiting for shuttle 4 to arrive at station';
			// -----------------------------------------------------------------
			IF station.Control.Info.NumOccupyingShuttles = 4 THEN		
				station.Shuttles[station.ShuttleCount] := station.Control.Info.LastArrivedShuttle;
				station.ShuttleCount := station.ShuttleCount + 1;
				station.State := station.State + 1;
			END_IF;
		208:
			station.Var.StateInfo := 'Move shuttle 4 to start position';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[3].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.640;
			station.Operation.MoveInPlane.Parameters.Position.Y := 4.400;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := station.State + 1;
			END_IF;
		209:
			station.Var.StateInfo := 'Add shuttles to group';
			// -----------------------------------------------------------------
			station.Group.GroupAddShuttle.Parameters.ShuttleList[0].Shuttle := ADR(station.Shuttles[0].Shuttle6D);
			station.Group.GroupAddShuttle.Parameters.ShuttleList[1].Shuttle := ADR(station.Shuttles[1].Shuttle6D);
			station.Group.GroupAddShuttle.Parameters.ShuttleList[2].Shuttle := ADR(station.Shuttles[2].Shuttle6D);
			station.Group.GroupAddShuttle.Parameters.ShuttleList[3].Shuttle := ADR(station.Shuttles[3].Shuttle6D);
			station.Commands.Group.AddShuttle := TRUE;
			
			IF station.Group.GroupAddShuttle.Done THEN
				station.State := station.State + 1;
			END_IF;
		210:
			station.Var.StateInfo := 'Couple grouped shuttles together';
			// -----------------------------------------------------------------
			station.Group.GroupCoupleCtrl.Parameters.Mode := mcACP6D_SH_GROUP_INDV_ROT_REF;
			station.Group.GroupCoupleCtrl.Parameters.Option := mcACP6D_SH_GROUP_COUPLE;
			station.Commands.Group.ChangeCoupling := TRUE;
			
			IF station.Group.GroupCoupleCtrl.Done THEN
				station.State := 300;
			END_IF;
			
		300:
			// Station sequence
			// ----------------------------------------------------------------------------------------------------------------------------------
			station.Var.StateInfo := 'Run macro';
			// -----------------------------------------------------------------
			reset_parameters_all;
			
			station.Macro.MacroRun.Shuttle := ADR(station.Shuttles[0].Shuttle6D);
			station.Macro.Execute := TRUE;
			
			IF station.Macro.MacroRun.Done THEN
				station.Macro.Execute := FALSE;
				station.State := station.State + 1;
			END_IF;
		301:
			station.Var.StateInfo := 'Decouple grouped shuttles';
			// -----------------------------------------------------------------
			station.Group.GroupCoupleCtrl.Parameters.Mode := mcACP6D_SH_GROUP_INDV_ROT_REF;
			station.Group.GroupCoupleCtrl.Parameters.Option := mcACP6D_SH_GROUP_DECOUPLE;
			station.Commands.Group.ChangeCoupling := TRUE;
			
			IF station.Group.GroupCoupleCtrl.Done THEN
				station.State := station.State + 1;
			END_IF;
		302:
			station.Var.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[0].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.420;
			station.Operation.MoveInPlane.Parameters.Position.Y := 4.620;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		303:
			station.Var.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[1].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.540;
			station.Operation.MoveInPlane.Parameters.Position.Y := 4.620;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := station.State + 1;
			END_IF;
		304:
			station.Var.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[2].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.420;
			station.Operation.MoveInPlane.Parameters.Position.Y := 4.500;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := station.State + 1;
			END_IF;
		305:
			station.Var.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[3].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.540;
			station.Operation.MoveInPlane.Parameters.Position.Y := 4.500;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := station.State + 1;
			END_IF;
		306:
			station.Var.StateInfo := 'Couple grouped shuttles';
			// -----------------------------------------------------------------
			station.Group.GroupCoupleCtrl.Parameters.Mode := mcACP6D_SH_GROUP_INDV_ROT_REF;
			station.Group.GroupCoupleCtrl.Parameters.Option := mcACP6D_SH_GROUP_COUPLE;
			station.Commands.Group.ChangeCoupling := TRUE;
			
			IF station.Group.GroupCoupleCtrl.Done THEN
				station.State := station.State + 1;
			END_IF;
		307:
			station.Var.StateInfo := 'Move group to start position';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[0].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.300;
			station.Operation.MoveInPlane.Parameters.Position.Y := 4.620;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := 310;
			END_IF;
			
		310:
			station.Var.StateInfo := 'Move in circles';
			// -----------------------------------------------------------------
			reset_parameters_MoveArc;
			station.Operation.MoveArc.Parameters.EndVelocity := 1.5;
			station.Operation.MoveArc.Shuttle := ADR(station.Shuttles[0].Shuttle6D);
			
			station.Var.LoopNum := 0;
			station.State := station.State + 1;
		311:
			station.Var.StateInfo := '';
			// -----------------------------------------------------------------
			station.Operation.MoveArc.Parameters.Direction := mcACP6D_ARC_CLOCKWISE;
			station.Operation.MoveArc.Parameters.Angular.Angle := brmPI;
			station.Operation.MoveArc.Parameters.Angular.Center.X := 0.120;
			station.Operation.MoveArc.Parameters.Angular.Center.Y := 0.000;
			station.Commands.MoveArc := TRUE;
			
			IF station.Operation.MoveArc.Acknowledge THEN
				station.State := station.State + 1;	
			END_IF;
		312:
			station.Var.StateInfo := '';
			// -----------------------------------------------------------------
			station.Operation.MoveArc.Parameters.Direction := mcACP6D_ARC_COUNTER_CLOCKWISE;
			station.Operation.MoveArc.Parameters.Angular.Angle := brmTWOPI;
			station.Operation.MoveArc.Parameters.Angular.Center.X := 0.120;
			station.Operation.MoveArc.Parameters.Angular.Center.Y := 0.000;
			station.Commands.MoveArc := TRUE;
			
			IF station.Operation.MoveArc.Acknowledge THEN
				station.State := station.State + 1;		
			END_IF;
		313:
			station.Var.StateInfo := '';
			// -----------------------------------------------------------------
			station.Operation.MoveArc.Parameters.Direction := mcACP6D_ARC_CLOCKWISE;
			station.Operation.MoveArc.Parameters.Angular.Angle := brmPI;
			station.Operation.MoveArc.Parameters.Angular.Center.X := -0.120;
			station.Operation.MoveArc.Parameters.Angular.Center.Y := 0.000;
			station.Commands.MoveArc := TRUE;
			
			IF station.Operation.MoveArc.Acknowledge THEN
				station.State := station.State + 1;	
			END_IF;
		314:
			station.Var.StateInfo := '';
			// -----------------------------------------------------------------
			station.Operation.MoveArc.Parameters.Direction := mcACP6D_ARC_COUNTER_CLOCKWISE;
			station.Operation.MoveArc.Parameters.Angular.Angle := brmTWOPI;
			station.Operation.MoveArc.Parameters.Angular.Center.X := -0.120;
			station.Operation.MoveArc.Parameters.Angular.Center.Y := 0.000;
			station.Commands.MoveArc := TRUE;
			
			IF station.Operation.MoveArc.Acknowledge THEN
				station.State := station.State + 1;	
			END_IF;
		315:
			station.Var.StateInfo := '';
			// -----------------------------------------------------------------
			IF station.Var.LoopNum < 3 THEN
				station.State := 311;
				station.Var.LoopNum := station.Var.LoopNum + 1;
			ELSE
				station.Var.LoopNum := 0;
				station.State := station.State + 1;
			END_IF;
		316:
			station.Var.StateInfo := 'End at middle';
			// -----------------------------------------------------------------
			station.Operation.MoveArc.Parameters.EndVelocity := 0;
			station.Operation.MoveArc.Parameters.Direction := mcACP6D_ARC_CLOCKWISE;
			station.Operation.MoveArc.Parameters.Angular.Angle := brmPI;
			station.Operation.MoveArc.Parameters.Angular.Center.X := 0.120;
			station.Operation.MoveArc.Parameters.Angular.Center.Y := 0.000;
			station.Commands.MoveArc := TRUE;
			
			IF station.Operation.MoveArc.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		317:
			station.Var.StateInfo := 'End at middle';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_DIRECT;
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[0].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.420;
			station.Operation.MoveInPlane.Parameters.Position.Y := 4.620;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := 350;
			END_IF;
			
		350:
			station.Var.StateInfo := 'Decouple grouped shuttles';
			// -----------------------------------------------------------------
			reset_parameters_MoveInPlane;
			
			station.Group.GroupCoupleCtrl.Parameters.Mode := mcACP6D_SH_GROUP_INDV_ROT_REF;
			station.Group.GroupCoupleCtrl.Parameters.Option := mcACP6D_SH_GROUP_DECOUPLE;
			station.Commands.Group.ChangeCoupling := TRUE;
			
			IF station.Group.GroupCoupleCtrl.Done THEN
				station.State := station.State + 1;
			END_IF;
		351:
			station.Var.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_Y_THEN_X;
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[0].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.660;
			station.Operation.MoveInPlane.Parameters.Position.Y := 4.740;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := station.State + 1;
			END_IF;
		352:
			station.Var.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_Y_THEN_X;
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[0].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.660;
			station.Operation.MoveInPlane.Parameters.Position.Y := 4.620;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := station.State + 1;
			END_IF;
		353:
			station.Var.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_Y_THEN_X;
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[2].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.420;
			station.Operation.MoveInPlane.Parameters.Position.Y := 4.620;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := station.State + 1;
			END_IF;
		354:
			station.Var.StateInfo := 'Move shuttle to start position';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_X_THEN_Y;
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[3].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.300;
			station.Operation.MoveInPlane.Parameters.Position.Y := 4.620;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := station.State + 1;
			END_IF;
		355:
			station.Var.StateInfo := 'Couple grouped shuttles';
			// -----------------------------------------------------------------
			reset_parameters_MoveInPlane;
			
			station.Group.GroupCoupleCtrl.Parameters.Mode := mcACP6D_SH_GROUP_CMN_ROT_REF;
			station.Group.GroupCoupleCtrl.Parameters.Option := mcACP6D_SH_GROUP_COUPLE;
			station.Commands.Group.ChangeCoupling := TRUE;
			
			IF station.Group.GroupCoupleCtrl.Done THEN
				station.State := 370;
			END_IF;	
		370:
			station.Var.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			reset_parameters_MoveShortAxis;
			
			station.Var.LoopNum := 0;
			station.Operation.MoveShortAxis.Parameters.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveShortAxis.Parameters.Position.Z := 0;
			station.Operation.MoveShortAxis.Parameters.Rotation.Type := mcACP6D_SHORT_AX_ROT_CENTER;
			station.Operation.MoveShortAxis.Parameters.Rotation.Center.X := 0.480;
			station.Operation.MoveShortAxis.Parameters.Rotation.Center.Y := 4.620;
			station.Operation.MoveShortAxis.Parameters.Velocity.Rz := 0.3;
			// Zero the position as we are moving relatively in this sequence
			brsmemset(ADR(station.Operation.MoveShortAxis.Parameters.Position), 0, SIZEOF(station.Operation.MoveShortAxis.Parameters.Position));
			station.Operation.MoveShortAxis.Shuttle := ADR(station.Shuttles[0].Shuttle6D);
			station.State := station.State + 1;
		371:
			station.Var.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Parameters.Position.Rz := 0.15;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.Operation.MoveShortAxis.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;	
		372:
			station.Var.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Parameters.Position.Rz := -0.30;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.Operation.MoveShortAxis.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;	
		373:
			station.Var.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Parameters.Position.Rz := 0.15;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.Operation.MoveShortAxis.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;	
		374:
			station.Var.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			IF station.Var.LoopNum < 1 THEN
				station.State := 371;
				station.Var.LoopNum := station.Var.LoopNum + 1;
			ELSE
				station.Var.LoopNum := 0;
				station.State := station.State + 1;
			END_IF;
		375:
			station.Var.StateInfo := 'Reset Short axis orientation to defaults';
			// -----------------------------------------------------------------
			reset_parameters_MoveShortAxis;
			station.Operation.MoveShortAxis.Shuttle := ADR(station.Shuttles[0].Shuttle6D);
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.Operation.MoveShortAxis.Done THEN
				station.State := station.State + 1;
			END_IF;	
		376:
			station.Var.StateInfo := 'Decouple grouped shuttles';
			// -----------------------------------------------------------------
			station.Group.GroupCoupleCtrl.Parameters.Option := mcACP6D_SH_GROUP_DECOUPLE;
			station.Commands.Group.ChangeCoupling := TRUE;
			
			IF station.Group.GroupCoupleCtrl.Done THEN
				station.State := 400;
			END_IF;	
			
		400:
			station.Var.StateInfo := 'Sun planet - Initialize';
			// -----------------------------------------------------------------
			reset_parameters_all;
			
			station.Operation.SunPlanet.Shuttle := ADR(station.Virtual.Shuttle);
			FOR i := 0 TO 3 DO
				station.Operation.SunPlanet.Parameters.ShuttleList[i].Shuttle := ADR(station.Shuttles[i].Shuttle6D);
			END_FOR;
			
			station.State := station.State + 1;
		401:
			station.Var.StateInfo := 'Sun planet - Move virtual shuttle to start';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Shuttle := ADR(station.Virtual.Shuttle);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.720;
			station.Operation.MoveInPlane.Parameters.Position.Y := 4.560;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := station.State + 1;
			END_IF;
		402:
			station.Var.StateInfo := 'Sun planet - Move shuttle to start';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[0].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.880;
			station.Operation.MoveInPlane.Parameters.Position.Y := 4.560;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := station.State + 1;
			END_IF;
		403:
			station.Var.StateInfo := 'Sun planet - Move shuttle to start';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[1].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.720;
			station.Operation.MoveInPlane.Parameters.Position.Y := 4.720;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := station.State + 1;
			END_IF;
		404:
			station.Var.StateInfo := 'Sun planet - Move shuttle to start';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[2].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.720;
			station.Operation.MoveInPlane.Parameters.Position.Y := 4.400;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := station.State + 1;
			END_IF;
		405:
			station.Var.StateInfo := 'Sun planet - Move shuttle to start';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[3].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.560;
			station.Operation.MoveInPlane.Parameters.Position.Y := 4.560;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := station.State + 1;
			END_IF;
		406:	
			station.Var.StateInfo := 'Sun planet - Create planet';
			// -----------------------------------------------------------------
			station.Operation.SunPlanet.Parameters.Option :=  mcACP6D_PLANET_ADD_SH;
			station.Commands.ChangePlanet := TRUE;
			
			IF station.Operation.SunPlanet.Done THEN
				station.State := 410;
			END_IF;
		
		410:
			station.Var.StateInfo := 'Sun planet - Orbit initialize';
			// -----------------------------------------------------------------
			reset_parameters_all;
			station.Operation.MoveArc.Parameters.Mode :=  mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveArc.Parameters.Angular.Angle := 10 * brmTWOPI;
			station.Operation.WaitCommandLabel.TriggerXID := station.Virtual.ShuttleID;
			station.Operation.WaitCommandLabel.TriggerCmdLb := 0;
			station.State := station.State + 1;
		411:
			station.Var.StateInfo := 'Sun planet - Add wait for label';
			// -----------------------------------------------------------------			
			station.Operation.WaitCommandLabel.Shuttle := ADR(station.Shuttles[0].Shuttle6D);
			station.Commands.WaitCommandLabel := TRUE;
			
			IF station.Operation.WaitCommandLabel.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		412:
			station.Var.StateInfo := 'Sun planet - Add arc command';
			// -----------------------------------------------------------------			
			station.Operation.MoveArc.Shuttle := ADR(station.Shuttles[0].Shuttle6D);
			station.Commands.MoveArc := TRUE;
			
			IF station.Operation.MoveArc.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;	
		413:
			station.Var.StateInfo := 'Sun planet - Add wait for label';
			// -----------------------------------------------------------------			
			station.Operation.WaitCommandLabel.Shuttle := ADR(station.Shuttles[1].Shuttle6D);
			station.Commands.WaitCommandLabel := TRUE;
			
			IF station.Operation.WaitCommandLabel.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		414:
			station.Var.StateInfo := 'Sun planet - Add arc command';
			// -----------------------------------------------------------------			
			station.Operation.MoveArc.Shuttle := ADR(station.Shuttles[1].Shuttle6D);
			station.Commands.MoveArc := TRUE;
			
			IF station.Operation.MoveArc.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;	
		415:
			station.Var.StateInfo := 'Sun planet - Add wait for label';
			// -----------------------------------------------------------------
			station.Operation.WaitCommandLabel.Shuttle := ADR(station.Shuttles[2].Shuttle6D);
			station.Commands.WaitCommandLabel := TRUE;
			
			IF station.Operation.WaitCommandLabel.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		416:
			station.Var.StateInfo := 'Sun planet - Add arc command';
			// -----------------------------------------------------------------			
			station.Operation.MoveArc.Shuttle := ADR(station.Shuttles[2].Shuttle6D);
			station.Commands.MoveArc := TRUE;
			
			IF station.Operation.MoveArc.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;	
		417:
			station.Var.StateInfo := 'Sun planet - Add wait for label';
			// -----------------------------------------------------------------
			station.Operation.WaitCommandLabel.Shuttle := ADR(station.Shuttles[3].Shuttle6D);
			station.Commands.WaitCommandLabel := TRUE;
			
			IF station.Operation.WaitCommandLabel.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		418:
			station.Var.StateInfo := 'Sun planet - Add arc command';
			// -----------------------------------------------------------------	
			station.Operation.MoveArc.Shuttle := ADR(station.Shuttles[3].Shuttle6D);
			station.Commands.MoveArc := TRUE;
			
			IF station.Operation.MoveArc.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;		
		419:
			station.Var.StateInfo := 'Sun planet - Move planet';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Shuttle := ADR(station.Virtual.Shuttle);
			station.Operation.MoveInPlane.Parameters.Position.X := -0.480;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0;
			station.Operation.MoveInPlane.Parameters.Velocity := 0.22;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		420:
			station.Var.StateInfo := 'Sun planet - Move planet';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Position.X := 0.480;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		421:
			station.Var.StateInfo := 'Sun planet - Move planet';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Position.X := -0.480;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := 430;
			END_IF;
		430:
			station.Var.StateInfo := 'Sync shuttles';
			// -----------------------------------------------------------------
			station.Operation.WaitUntilAllDone.Shuttles[0] := station.Shuttles[0].Shuttle6D;	 
			station.Operation.WaitUntilAllDone.Shuttles[1] := station.Shuttles[1].Shuttle6D;	 
			station.Operation.WaitUntilAllDone.Shuttles[2] := station.Shuttles[2].Shuttle6D;	 
			station.Operation.WaitUntilAllDone.Shuttles[3] := station.Shuttles[3].Shuttle6D;	 
			station.Commands.WaitUntilAllDone := TRUE;
		
			IF station.Operation.WaitUntilAllDone.Done THEN
	  			station.State := 450;
			END_IF;
			
		450:	
			station.Var.StateInfo := 'Sun planet - remove planets';
			// -----------------------------------------------------------------
			station.Operation.SunPlanet.Parameters.Option :=  mcACP6D_PLANET_REMOVE_SH;
			station.Commands.ChangePlanet := TRUE;
			
			IF station.Operation.SunPlanet.Done THEN
				//station.State := station.State + 1;
				station.State := 1000;
			END_IF;
			
		1000:
			// Return shuttles to the traffic network
			// ----------------------------------------------------------------------------------------------------------------------------------
			station.Var.StateInfo := 'Move shuttles to exit positions';
			// -----------------------------------------------------------------
			reset_parameters_all;
			
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[2].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.300;
			station.Operation.MoveInPlane.Parameters.Position.Y := 4.380;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := station.State + 1;
			END_IF;
		1001:
			station.Var.StateInfo := 'Move shuttles to exit positions';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[0].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.300;
			station.Operation.MoveInPlane.Parameters.Position.Y := 4.500;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := station.State + 1;
			END_IF;
		1002:
			station.Var.StateInfo := 'Move shuttles to exit positions';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[1].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.300;
			station.Operation.MoveInPlane.Parameters.Position.Y := 4.740;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := station.State + 1;
			END_IF;
		1003:
			station.Var.StateInfo := 'Move shuttles to exit positions';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Path := mcACP6D_PATH_Y_THEN_X;
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[3].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.300;
			station.Operation.MoveInPlane.Parameters.Position.Y := 4.620;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := station.State + 1;
			END_IF;
		1004:
			station.Var.StateInfo := 'Clear group';
			// -----------------------------------------------------------------
			station.Commands.Group.Clear := TRUE;
			
			IF station.Group.GroupClear.Done THEN
				station.State := station.State + 1;
			END_IF;		
		1005:
			station.Var.StateInfo := 'Release shuttles';
			// -----------------------------------------------------------------
			station.Operation.StationQueueControl.ShuttleList[0] := station.Shuttles[0];
			station.Operation.StationQueueControl.ShuttleList[1] := station.Shuttles[1];
			station.Operation.StationQueueControl.ShuttleList[2] := station.Shuttles[2];
			station.Operation.StationQueueControl.ShuttleList[3] := station.Shuttles[3];
			station.Commands.Release := TRUE;
			
			IF station.Operation.StationQueueControl.ShuttleReleaseDone THEN
				station.State := station.State + 1;
			END_IF;
		1006:
			station.Var.StateInfo := 'Wait until shuttles at the station have all left';
			// -----------------------------------------------------------------
			station.Commands.Zone.GetBarrierInfo := TRUE;
			
			IF station.Zone.ZoneGetBarrierInfo.Done THEN
				station.Commands.Zone.GetBarrierInfo := FALSE;
				IF station.Zone.ZoneGetBarrierInfo.BarrierInfo.NumberOfShuttles = 0 THEN
					station.State := 200;	
				END_IF;
			END_IF;
	END_CASE;
	
	// Reset station commands when state changes
	IF station.State <> station.Var.PreviousState THEN
		station.Var.PreviousState := station.State;
		brsmemset(ADR(station.Commands), 0, SIZEOF(station.Commands));
	END_IF;
	
END_ACTION
