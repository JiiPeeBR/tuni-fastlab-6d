
ACTION Station_Sequence_S5:
	// Point station reference to this station
	pStation ACCESS ADR(Stations[5]);
			
	// Station control logic and mapping
	// -----------------------------------------------------------------
	pStation.Control.Enable := TRUE;
	pStation.Control.Station := ADR(S5);
	pStation.Control.To := ADR(S6);
	pStation.Macro.Name := 'S5';
	pStation.Zone.Name := 'Z5';
	pStation.Operation.StationQueueControl.ShuttleCapacity := 2;
		
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
				pStation.State := 200;	
			ELSIF pStation.Zone.FindZone.ZoneNotFound THEN
				pStation.State := pStation.State + 1;
			END_IF;	
		21:
			pStation.Var.StateInfo := 'Create zone';
			// -----------------------------------------------------------------
			pStation.Zone.ZoneCreate.Parameters.BottomLeft.X := 0.720; 
			pStation.Zone.ZoneCreate.Parameters.BottomLeft.Y := 2.880;
			pStation.Zone.ZoneCreate.Parameters.TopRight.X := 0.960;
			pStation.Zone.ZoneCreate.Parameters.TopRight.Y := 3.360;
			pStation.Zone.ZoneCreate.Parameters.Name := pStation.Zone.Name;
			pStation.Commands.Zone.Create := TRUE;
		
			IF pStation.Zone.ZoneCreate.Done THEN
				// Go back one step and rescan the zones to get the zone reference
				pStation.State := 20;
			END_IF;
			
		200:
			pStation.Var.StateInfo := 'Initialize station sequence';
			// -----------------------------------------------------------------
			pStation.ShuttleCount := 0;
			brsmemset(ADR(pStation.Shuttles), 0, SIZEOF(pStation.Shuttles));
			
			pStation.Operation.MoveInPlane.Parameters.Velocity := 1.5;
			pStation.Operation.MoveInPlane.Parameters.Acceleration := 18;
			pStation.Operation.MoveInPlane.Parameters.EndVelocity := 0;
			pStation.Operation.MoveInPlane.Parameters.Radius := 0;
			pStation.Operation.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_DIRECT;
			pStation.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_ABSOLUTE;
			pStation.State := pStation.State + 1;
		201:
			pStation.Var.StateInfo := 'Waiting for first shuttle to arrive at station';
			// -----------------------------------------------------------------
			IF pStation.Control.Info.NumOccupyingShuttles > 0 THEN
				pStation.Shuttles[pStation.ShuttleCount] := pStation.Control.Info.LastArrivedShuttle;
				pStation.ShuttleCount := pStation.ShuttleCount + 1;
				pStation.State := pStation.State + 1;
			END_IF;	
		202:
			pStation.Var.StateInfo := 'Move first shuttle to start position';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[0].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.900;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 2.940;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		203:	
			pStation.Var.StateInfo := 'Waiting for second shuttle to arrive at station';
			// -----------------------------------------------------------------
			IF pStation.Control.Info.NumOccupyingShuttles > 1 THEN		
				pStation.Shuttles[pStation.ShuttleCount] := pStation.Control.Info.LastArrivedShuttle;
				pStation.ShuttleCount := pStation.ShuttleCount + 1;
				pStation.State := pStation.State + 1;
			END_IF;
		204:
			pStation.Var.StateInfo := 'Move second shuttle to start position';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[1].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.780;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 2.940;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		205:
			pStation.Var.StateInfo := 'Add shuttles to group';
			// -----------------------------------------------------------------
			pStation.Group.GroupAddShuttle.Parameters.ShuttleList[0].Shuttle := ADR(pStation.Shuttles[0].Shuttle6D);
			pStation.Group.GroupAddShuttle.Parameters.ShuttleList[1].Shuttle := ADR(pStation.Shuttles[1].Shuttle6D);
			pStation.Commands.Group.AddShuttle := TRUE;
			
			IF pStation.Group.GroupAddShuttle.Done THEN
	  			pStation.State := pStation.State + 1;
			END_IF;
		206:
			pStation.Var.StateInfo := 'Couple grouped shuttles together';
			// -----------------------------------------------------------------
			pStation.Group.GroupCoupleCtrl.Parameters.Mode := mcACP6D_SH_GROUP_CMN_ROT_REF;
			pStation.Group.GroupCoupleCtrl.Parameters.Option := mcACP6D_SH_GROUP_COUPLE;
			pStation.Commands.Group.ChangeCoupling := TRUE;
			
			IF pStation.Group.GroupCoupleCtrl.Done THEN
	  			pStation.State := 300;
			END_IF;
		300:
			pStation.Var.StateInfo := 'Move group';
			// -----------------------------------------------------------------
			pStation.Var.LoopNum := 0;
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[0].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_DIRECT;
			pStation.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			pStation.State := pStation.State + 1;
		301:
			pStation.Var.StateInfo := 'Move group';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.0;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.360;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		302:
			pStation.Var.StateInfo := 'Move group';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.0;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := -0.360;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		303:
			pStation.Var.StateInfo := 'Move group';
			// -----------------------------------------------------------------
			IF pStation.Var.LoopNum < 4 THEN
				pStation.State := 301;
				pStation.Var.LoopNum := pStation.Var.LoopNum + 1;
			ELSE
				pStation.Var.LoopNum := 0;
				pStation.State := 400;
			END_IF;
		400:
			pStation.Var.StateInfo := 'Decouple group';
			// -----------------------------------------------------------------
			pStation.Group.GroupCoupleCtrl.Parameters.Mode := mcACP6D_SH_GROUP_CMN_ROT_REF;
			pStation.Group.GroupCoupleCtrl.Parameters.Option := mcACP6D_SH_GROUP_DECOUPLE;
			pStation.Commands.Group.ChangeCoupling := TRUE;
			
			IF pStation.Group.GroupCoupleCtrl.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		401:
			pStation.Var.StateInfo := 'Move shuttle 1';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[0].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.360;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		402:
			pStation.Var.StateInfo := 'Move shuttle 1';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := -0.060;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.000;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		403:
			pStation.Var.StateInfo := 'Move shuttle 1 to mid';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := -0.120;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		404:
			pStation.Var.StateInfo := 'Move shuttle 2';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[1].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.060;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.000;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		405:
			pStation.Var.StateInfo := 'Move shuttle 2 to mid';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.120;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		406:
			pStation.Var.StateInfo := 'Sync shuttles';
			// -----------------------------------------------------------------
			pStation.Operation.WaitUntilAllDone.Shuttles[0] := pStation.Shuttles[0].Shuttle6D;
			pStation.Operation.WaitUntilAllDone.Shuttles[1] := pStation.Shuttles[1].Shuttle6D;
			pStation.Commands.WaitUntilAllDone := TRUE;
			
			IF pStation.Operation.WaitUntilAllDone.Done THEN
	  			pStation.State := pStation.State + 1;
			END_IF;
		407:
			pStation.Var.StateInfo := 'Group shuttles';
			// -----------------------------------------------------------------
			pStation.Group.GroupCoupleCtrl.Parameters.Mode := mcACP6D_SH_GROUP_CMN_ROT_REF;
			pStation.Group.GroupCoupleCtrl.Parameters.Option := mcACP6D_SH_GROUP_COUPLE;
			pStation.Commands.Group.ChangeCoupling := TRUE;
			
			IF pStation.Group.GroupCoupleCtrl.Done THEN
				pStation.State := 420;
			END_IF;	
		420:
			pStation.Var.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			pStation.Var.LoopNum := 0;
			pStation.Operation.MoveShortAxis.Parameters.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveShortAxis.Parameters.Rotation.Type := mcACP6D_SHORT_AX_ROT_CENTER;
			pStation.Operation.MoveShortAxis.Parameters.Rotation.Center.X := 0.840;
			pStation.Operation.MoveShortAxis.Parameters.Rotation.Center.Y := 3.120;
			pStation.Operation.MoveShortAxis.Parameters.Velocity.Rz := 0.3;
			brsmemset(ADR(pStation.Operation.MoveShortAxis.Parameters.Position), 0, SIZEOF(pStation.Operation.MoveShortAxis.Parameters.Position));
			pStation.Operation.MoveShortAxis.Shuttle := ADR(pStation.Shuttles[0].Shuttle6D);
			pStation.State := pStation.State + 1;
		421:
			pStation.Var.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Parameters.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveShortAxis.Parameters.Position.Rz := 0.15;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.Operation.MoveShortAxis.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;	
		422:
			pStation.Var.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Parameters.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveShortAxis.Parameters.Position.Rz := -0.30;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.Operation.MoveShortAxis.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;	
		423:
			pStation.Var.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			pStation.Operation.MoveShortAxis.Parameters.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveShortAxis.Parameters.Position.Rz := 0.15;
			pStation.Commands.MoveShortAxis := TRUE;
			
			IF pStation.Operation.MoveShortAxis.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;	
		424:
			pStation.Var.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			IF pStation.Var.LoopNum < 2 THEN
				pStation.State := 421;
				pStation.Var.LoopNum := pStation.Var.LoopNum + 1;
			ELSE
				pStation.Var.LoopNum := 0;
				pStation.State := 500;
			END_IF;
		500:
			pStation.Var.StateInfo := 'Group move initialize';
			// -----------------------------------------------------------------
			pStation.Var.LoopNum := 0;
			
			pStation.Operation.MoveArc.Parameters.Acceleration := 18;
			pStation.Operation.MoveArc.Parameters.Velocity := 1.8;
			pStation.Operation.MoveArc.Parameters.EndVelocity := 1.5;
			pStation.Operation.MoveArc.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveArc.Parameters.Option := mcACP6D_ARC_ANGULAR;
			pStation.Operation.MoveArc.Parameters.Direction := mcACP6D_ARC_COUNTER_CLOCKWISE;
			pStation.Operation.MoveArc.Shuttle := ADR(pStation.Shuttles[0].Shuttle6D);
			
			pStation.State := pStation.State + 1;
		501:
			pStation.Var.StateInfo := 'Group move';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.060;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.000;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;	
		502:
			pStation.Var.StateInfo := 'Group move';
			// -----------------------------------------------------------------
			pStation.Operation.MoveArc.Parameters.Angular.Angle :=  10 * brmTWOPI;
			pStation.Operation.MoveArc.Parameters.Angular.Center.X := -0.060;
			pStation.Operation.MoveArc.Parameters.Angular.Center.Y := 0.000;
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.Operation.MoveArc.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;	
		503:
			pStation.Var.StateInfo := 'Group move';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.120;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;	
		504:
			pStation.Var.StateInfo := 'Group move';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := -0.120;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.000;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;	
		505:
			pStation.Var.StateInfo := 'Group move';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := -0.240;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;	
		506:
			pStation.Var.StateInfo := 'Group move';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.120;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.000;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;	
		507:
			pStation.Var.StateInfo := 'Group move';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.240;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Done THEN
				pStation.State := 508;
			END_IF;	
		508:
			pStation.Var.StateInfo := 'decouple shuttles';
			// -----------------------------------------------------------------
			pStation.Group.GroupCoupleCtrl.Parameters.Mode := mcACP6D_SH_GROUP_CMN_ROT_REF;
			pStation.Group.GroupCoupleCtrl.Parameters.Option := mcACP6D_SH_GROUP_DECOUPLE;
			pStation.Commands.Group.ChangeCoupling := TRUE;
			
			IF pStation.Group.GroupCoupleCtrl.Done THEN
				pStation.State := 1000;
			END_IF;	
		1000:
			pStation.Var.StateInfo := 'Clear group';
			// -----------------------------------------------------------------
			pStation.Commands.Group.Clear := TRUE;
			
			IF pStation.Group.GroupClear.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;		
		1001:
			pStation.Var.StateInfo := 'Release first index shuttle (1st arrived)';
			// -----------------------------------------------------------------
			pStation.Operation.StationQueueControl.ShuttleList[0] := pStation.Shuttles[0];
			pStation.Operation.StationQueueControl.ShuttleList[1] := pStation.Shuttles[1];
			pStation.Commands.Release := TRUE;
			
			IF pStation.Operation.StationQueueControl.ShuttleReleaseDone THEN
				pStation.State := 1002;	
			END_IF;
		1002:
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
