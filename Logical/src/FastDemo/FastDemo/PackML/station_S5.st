
ACTION execute_station_S5:
	// Point station reference to this station
	station ACCESS ADR(stations[5]);
			
	// Station control logic and mapping
	// -----------------------------------------------------------------
	station.Control.Enable := TRUE;
	station.Control.Station := ADR(S5);
	station.Control.To := ADR(S6);
	station.Macro.Name := 'S5';
	station.Zone.Name := 'Z5';
	station.Operation.StationQueueControl.ShuttleCapacity := 2;
		
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
				station.State := 200;	
			ELSIF station.Zone.FindZone.ZoneNotFound THEN
				station.State := station.State + 1;
			END_IF;	
		21:
			station.Var.StateInfo := 'Create zone';
			// -----------------------------------------------------------------
			station.Zone.ZoneCreate.Parameters.BottomLeft.X := 0.720; 
			station.Zone.ZoneCreate.Parameters.BottomLeft.Y := 2.880;
			station.Zone.ZoneCreate.Parameters.TopRight.X := 0.960;
			station.Zone.ZoneCreate.Parameters.TopRight.Y := 3.360;
			station.Zone.ZoneCreate.Parameters.Name := station.Zone.Name;
			station.Commands.Zone.Create := TRUE;
		
			IF station.Zone.ZoneCreate.Done THEN
				// Go back one step and rescan the zones to get the zone reference
				station.State := 20;
			END_IF;
			
		200:
			station.Var.StateInfo := 'Initialize station sequence';
			// -----------------------------------------------------------------
			station.ShuttleCount := 0;
			brsmemset(ADR(station.Shuttles), 0, SIZEOF(station.Shuttles));
			
			station.Operation.MoveInPlane.Parameters.Velocity := 1.5;
			station.Operation.MoveInPlane.Parameters.Acceleration := 18;
			station.Operation.MoveInPlane.Parameters.EndVelocity := 0;
			station.Operation.MoveInPlane.Parameters.Radius := 0;
			station.Operation.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_DIRECT;
			station.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_ABSOLUTE;
			station.State := station.State + 1;
		201:
			station.Var.StateInfo := 'Waiting for first shuttle to arrive at station';
			// -----------------------------------------------------------------
			IF station.Control.Info.NumOccupyingShuttles > 0 THEN
				station.Shuttles[station.ShuttleCount] := station.Control.Info.LastArrivedShuttle;
				station.ShuttleCount := station.ShuttleCount + 1;
				station.State := station.State + 1;
			END_IF;	
		202:
			station.Var.StateInfo := 'Move first shuttle to start position';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[0].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.900;
			station.Operation.MoveInPlane.Parameters.Position.Y := 2.940;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := station.State + 1;
			END_IF;
		203:	
			station.Var.StateInfo := 'Waiting for second shuttle to arrive at station';
			// -----------------------------------------------------------------
			IF station.Control.Info.NumOccupyingShuttles > 1 THEN		
				station.Shuttles[station.ShuttleCount] := station.Control.Info.LastArrivedShuttle;
				station.ShuttleCount := station.ShuttleCount + 1;
				station.State := station.State + 1;
			END_IF;
		204:
			station.Var.StateInfo := 'Move second shuttle to start position';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[1].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.780;
			station.Operation.MoveInPlane.Parameters.Position.Y := 2.940;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := station.State + 1;
			END_IF;
		205:
			station.Var.StateInfo := 'Add shuttles to group';
			// -----------------------------------------------------------------
			station.Group.GroupAddShuttle.Parameters.ShuttleList[0].Shuttle := ADR(station.Shuttles[0].Shuttle6D);
			station.Group.GroupAddShuttle.Parameters.ShuttleList[1].Shuttle := ADR(station.Shuttles[1].Shuttle6D);
			station.Commands.Group.AddShuttle := TRUE;
			
			IF station.Group.GroupAddShuttle.Done THEN
	  			station.State := station.State + 1;
			END_IF;
		206:
			station.Var.StateInfo := 'Couple grouped shuttles together';
			// -----------------------------------------------------------------
			station.Group.GroupCoupleCtrl.Parameters.Mode := mcACP6D_SH_GROUP_CMN_ROT_REF;
			station.Group.GroupCoupleCtrl.Parameters.Option := mcACP6D_SH_GROUP_COUPLE;
			station.Commands.Group.ChangeCoupling := TRUE;
			
			IF station.Group.GroupCoupleCtrl.Done THEN
	  			station.State := 300;
			END_IF;
		300:
			station.Var.StateInfo := 'Move group';
			// -----------------------------------------------------------------
			station.Var.LoopNum := 0;
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[0].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_DIRECT;
			station.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			station.State := station.State + 1;
		301:
			station.Var.StateInfo := 'Move group';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Position.X := 0.0;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.360;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		302:
			station.Var.StateInfo := 'Move group';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Position.X := 0.0;
			station.Operation.MoveInPlane.Parameters.Position.Y := -0.360;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		303:
			station.Var.StateInfo := 'Move group';
			// -----------------------------------------------------------------
			IF station.Var.LoopNum < 4 THEN
				station.State := 301;
				station.Var.LoopNum := station.Var.LoopNum + 1;
			ELSE
				station.Var.LoopNum := 0;
				station.State := 400;
			END_IF;
		400:
			station.Var.StateInfo := 'Decouple group';
			// -----------------------------------------------------------------
			station.Group.GroupCoupleCtrl.Parameters.Mode := mcACP6D_SH_GROUP_CMN_ROT_REF;
			station.Group.GroupCoupleCtrl.Parameters.Option := mcACP6D_SH_GROUP_DECOUPLE;
			station.Commands.Group.ChangeCoupling := TRUE;
			
			IF station.Group.GroupCoupleCtrl.Done THEN
				station.State := station.State + 1;
			END_IF;
		401:
			station.Var.StateInfo := 'Move shuttle 1';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[0].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.360;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		402:
			station.Var.StateInfo := 'Move shuttle 1';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Position.X := -0.060;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.000;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		403:
			station.Var.StateInfo := 'Move shuttle 1 to mid';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			station.Operation.MoveInPlane.Parameters.Position.Y := -0.120;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		404:
			station.Var.StateInfo := 'Move shuttle 2';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[1].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.060;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.000;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		405:
			station.Var.StateInfo := 'Move shuttle 2 to mid';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.120;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		406:
			station.Var.StateInfo := 'Sync shuttles';
			// -----------------------------------------------------------------
			station.Operation.WaitUntilAllDone.Shuttles[0] := station.Shuttles[0].Shuttle6D;
			station.Operation.WaitUntilAllDone.Shuttles[1] := station.Shuttles[1].Shuttle6D;
			station.Commands.WaitUntilAllDone := TRUE;
			
			IF station.Operation.WaitUntilAllDone.Done THEN
	  			station.State := station.State + 1;
			END_IF;
		407:
			station.Var.StateInfo := 'Group shuttles';
			// -----------------------------------------------------------------
			station.Group.GroupCoupleCtrl.Parameters.Mode := mcACP6D_SH_GROUP_CMN_ROT_REF;
			station.Group.GroupCoupleCtrl.Parameters.Option := mcACP6D_SH_GROUP_COUPLE;
			station.Commands.Group.ChangeCoupling := TRUE;
			
			IF station.Group.GroupCoupleCtrl.Done THEN
				station.State := 420;
			END_IF;	
		420:
			station.Var.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			station.Var.LoopNum := 0;
			station.Operation.MoveShortAxis.Parameters.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveShortAxis.Parameters.Rotation.Type := mcACP6D_SHORT_AX_ROT_CENTER;
			station.Operation.MoveShortAxis.Parameters.Rotation.Center.X := 0.840;
			station.Operation.MoveShortAxis.Parameters.Rotation.Center.Y := 3.120;
			station.Operation.MoveShortAxis.Parameters.Velocity.Rz := 0.3;
			brsmemset(ADR(station.Operation.MoveShortAxis.Parameters.Position), 0, SIZEOF(station.Operation.MoveShortAxis.Parameters.Position));
			station.Operation.MoveShortAxis.Shuttle := ADR(station.Shuttles[0].Shuttle6D);
			station.State := station.State + 1;
		421:
			station.Var.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Parameters.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveShortAxis.Parameters.Position.Rz := 0.15;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.Operation.MoveShortAxis.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;	
		422:
			station.Var.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Parameters.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveShortAxis.Parameters.Position.Rz := -0.30;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.Operation.MoveShortAxis.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;	
		423:
			station.Var.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			station.Operation.MoveShortAxis.Parameters.Mode := mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveShortAxis.Parameters.Position.Rz := 0.15;
			station.Commands.MoveShortAxis := TRUE;
			
			IF station.Operation.MoveShortAxis.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;	
		424:
			station.Var.StateInfo := 'Rotate shuttles';
			// -----------------------------------------------------------------
			IF station.Var.LoopNum < 2 THEN
				station.State := 421;
				station.Var.LoopNum := station.Var.LoopNum + 1;
			ELSE
				station.Var.LoopNum := 0;
				station.State := 500;
			END_IF;
		500:
			station.Var.StateInfo := 'Group move initialize';
			// -----------------------------------------------------------------
			station.Var.LoopNum := 0;
			
			station.Operation.MoveArc.Parameters.Acceleration := 18;
			station.Operation.MoveArc.Parameters.Velocity := 1.8;
			station.Operation.MoveArc.Parameters.EndVelocity := 1.5;
			station.Operation.MoveArc.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveArc.Parameters.Option := mcACP6D_ARC_ANGULAR;
			station.Operation.MoveArc.Parameters.Direction := mcACP6D_ARC_COUNTER_CLOCKWISE;
			station.Operation.MoveArc.Shuttle := ADR(station.Shuttles[0].Shuttle6D);
			
			station.State := station.State + 1;
		501:
			station.Var.StateInfo := 'Group move';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Position.X := 0.060;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.000;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;	
		502:
			station.Var.StateInfo := 'Group move';
			// -----------------------------------------------------------------
			station.Operation.MoveArc.Parameters.Angular.Angle :=  10 * brmTWOPI;
			station.Operation.MoveArc.Parameters.Angular.Center.X := -0.060;
			station.Operation.MoveArc.Parameters.Angular.Center.Y := 0.000;
			station.Commands.MoveArc := TRUE;
			
			IF station.Operation.MoveArc.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;	
		503:
			station.Var.StateInfo := 'Group move';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.120;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;	
		504:
			station.Var.StateInfo := 'Group move';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Position.X := -0.120;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.000;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;	
		505:
			station.Var.StateInfo := 'Group move';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			station.Operation.MoveInPlane.Parameters.Position.Y := -0.240;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;	
		506:
			station.Var.StateInfo := 'Group move';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Position.X := 0.120;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.000;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;	
		507:
			station.Var.StateInfo := 'Group move';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.240;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := 508;
			END_IF;	
		508:
			station.Var.StateInfo := 'decouple shuttles';
			// -----------------------------------------------------------------
			station.Group.GroupCoupleCtrl.Parameters.Mode := mcACP6D_SH_GROUP_CMN_ROT_REF;
			station.Group.GroupCoupleCtrl.Parameters.Option := mcACP6D_SH_GROUP_DECOUPLE;
			station.Commands.Group.ChangeCoupling := TRUE;
			
			IF station.Group.GroupCoupleCtrl.Done THEN
				station.State := 1000;
			END_IF;	
		1000:
			station.Var.StateInfo := 'Clear group';
			// -----------------------------------------------------------------
			station.Commands.Group.Clear := TRUE;
			
			IF station.Group.GroupClear.Done THEN
				station.State := station.State + 1;
			END_IF;		
		1001:
			station.Var.StateInfo := 'Release first index shuttle (1st arrived)';
			// -----------------------------------------------------------------
			station.Operation.StationQueueControl.ShuttleList[0] := station.Shuttles[0];
			station.Operation.StationQueueControl.ShuttleList[1] := station.Shuttles[1];
			station.Commands.Release := TRUE;
			
			IF station.Operation.StationQueueControl.ShuttleReleaseDone THEN
				station.State := 1002;	
			END_IF;
		1002:
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
