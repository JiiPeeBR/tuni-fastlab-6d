
ACTION execute_station_S4:
	// Point station reference to this station
	station ACCESS ADR(stations[4]);
			
	// Station control logic and mapping
	// -----------------------------------------------------------------
	station.Control.Enable := TRUE;
	station.Control.Station := ADR(S4);
	station.Control.To := ADR(S5);
	station.Macro.Name := 'S4';
	station.Zone.Name := 'Z4';
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
			station.Zone.ZoneCreate.Parameters.BottomLeft.Y := 1.440;
			station.Zone.ZoneCreate.Parameters.TopRight.X := 0.240;
			station.Zone.ZoneCreate.Parameters.TopRight.Y := 1.900;
			station.Zone.ZoneCreate.Parameters.Name := station.Zone.Name;
			station.Commands.Zone.Create := TRUE;
		
			IF station.Zone.ZoneCreate.Done THEN
				// Go back one step and rescan the zones to get the zone reference
				station.State := 20;
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
				station.State := 200;
			END_IF;
			
		200:
			// Station sequence
			// ----------------------------------------------------------------------------------------------------------------------------------
			station.Var.StateInfo := 'Initialize station sequence';
			// -----------------------------------------------------------------
			reset_parameters_all;
			station.ShuttleCount := 0;
			brsmemset(ADR(station.Shuttles), 0, SIZEOF(station.Shuttles));
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
			station.Operation.MoveInPlane.Parameters.Position.X := 0.120;
			station.Operation.MoveInPlane.Parameters.Position.Y := 1.740;
			station.Operation.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_X_THEN_Y;
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
			station.Operation.MoveInPlane.Parameters.Position.X := 0.120;
			station.Operation.MoveInPlane.Parameters.Position.Y := 1.620;
			station.Operation.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_X_THEN_Y;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := 210;
			END_IF;
		210:
			station.Var.StateInfo := 'Init synchronized move';
			// -----------------------------------------------------------------
			reset_parameters_all;
			station.Operation.MoveArc.Parameters.Angular.Angle := 10 * brmTWOPI;
			
			station.Operation.WaitCommandLabel.TriggerXID := station.Shuttles[0].ShuttleID;
			station.Operation.WaitCommandLabel.TriggerCmdLb := 0;
			station.State := station.State + 1;
		211:
			station.Var.StateInfo := 'Shuttle 1 waits for 0';
			// -----------------------------------------------------------------			
			station.Operation.WaitCommandLabel.Shuttle := ADR(station.Shuttles[1].Shuttle6D);
			station.Commands.WaitCommandLabel := TRUE;
			
			IF station.Operation.WaitCommandLabel.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		212:
			station.Var.StateInfo := 'Arc';
			// -----------------------------------------------------------------
			station.Operation.MoveArc.Parameters.Direction := mcACP6D_ARC_CLOCKWISE;
			station.Operation.MoveArc.Parameters.Angular.Center.X := 0;
			station.Operation.MoveArc.Parameters.Angular.Center.Y := -0.060;
			station.Operation.MoveArc.Shuttle := ADR(station.Shuttles[1].Shuttle6D);
			station.Commands.MoveArc := TRUE;
			
			IF station.Operation.MoveArc.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;	
		213:
			station.Var.StateInfo := 'Arc';
			// -----------------------------------------------------------------			
			station.Operation.MoveArc.Parameters.Direction := mcACP6D_ARC_CLOCKWISE;
			station.Operation.MoveArc.Parameters.Angular.Center.X := 0;
			station.Operation.MoveArc.Parameters.Angular.Center.Y := 0.060;
			station.Operation.MoveArc.Shuttle := ADR(station.Shuttles[0].Shuttle6D);
			station.Commands.MoveArc := TRUE;
			
			IF station.Operation.MoveArc.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		214:
			station.Var.StateInfo := 'Move to 2nd start pos';
			// -----------------------------------------------------------------
			reset_parameters_all;
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[0].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.180;
			station.Operation.MoveInPlane.Parameters.Position.Y := 1.860;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		215:
			station.Var.StateInfo := 'Move to 2nd start pos';
			// -----------------------------------------------------------------
			reset_parameters_all;
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[1].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.060;
			station.Operation.MoveInPlane.Parameters.Position.Y := 1.500;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;	
		216:
			station.Var.StateInfo := 'Sync shuttles';
			// -----------------------------------------------------------------
			station.Operation.WaitUntilAllDone.Shuttles[0] := station.Shuttles[0].Shuttle6D;	 
			station.Operation.WaitUntilAllDone.Shuttles[1] := station.Shuttles[1].Shuttle6D;	 	 
			station.Commands.WaitUntilAllDone := TRUE;
		
			IF station.Operation.WaitUntilAllDone.Done THEN
				station.State := 220;
			END_IF;
			
		220:
			station.Var.StateInfo := 'Move pattern for slave shuttle';
			// -----------------------------------------------------------------
			reset_parameters_all;
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[1].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Mode := mcACP6D_MOVE_RELATIVE;
			
			station.Operation.WaitCommandLabel.TriggerXID := station.Shuttles[0].ShuttleID;
			station.Operation.WaitCommandLabel.TriggerCmdLb := 0;
			station.State := station.State + 1;
		221:
			station.Var.StateInfo := '';
			// -----------------------------------------------------------------			
			station.Operation.WaitCommandLabel.Shuttle := ADR(station.Shuttles[1].Shuttle6D);
			station.Commands.WaitCommandLabel := TRUE;
			
			IF station.Operation.WaitCommandLabel.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		222:
			station.Var.StateInfo := 'Shuttle 1 moves';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Position.X := 0.120;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.0;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		223:
			station.Var.StateInfo := 'Shuttle 1 moves';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.120;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		224:
			station.Var.StateInfo := 'Shuttle 1 moves';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Position.X := -0.120;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.0;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		225:
			station.Var.StateInfo := 'Shuttle 1 moves';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.120;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		226:
			station.Var.StateInfo := 'Shuttle 1 moves';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Position.X := 0.120;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.0;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		227:
			station.Var.StateInfo := 'Shuttle 1 moves';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.120;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		228:
			station.Var.StateInfo := 'Shuttle 1 moves';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Position.X := -0.120;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.0;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := 240;
			END_IF;
		
		240:
			station.Var.StateInfo := 'Move pattern for master shuttle';
			// -----------------------------------------------------------------
			reset_parameters_all;
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[0].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Mode := mcACP6D_MOVE_RELATIVE;
			station.State := station.State + 1;
		241:
			station.Var.StateInfo := 'Shuttle 0 moves';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Position.X := -0.120;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.0;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		242:
			station.Var.StateInfo := 'Shuttle 0 moves';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			station.Operation.MoveInPlane.Parameters.Position.Y := -0.120;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		243:
			station.Var.StateInfo := 'Shuttle 0 moves';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Position.X := 0.120;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.0;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		244:
			station.Var.StateInfo := 'Shuttle 0 moves';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			station.Operation.MoveInPlane.Parameters.Position.Y := -0.120;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		245:
			station.Var.StateInfo := 'Shuttle 0 moves';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Position.X := -0.120;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.0;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		246:
			station.Var.StateInfo := 'Shuttle 0 moves';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			station.Operation.MoveInPlane.Parameters.Position.Y := -0.120;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		247:
			station.Var.StateInfo := 'Shuttle 0 moves';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Position.X := 0.120;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.0;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := 1000;
			END_IF;
			
		1000:
			station.Var.StateInfo := 'Sync shuttles';
			// -----------------------------------------------------------------
			station.Operation.WaitUntilAllDone.Shuttles[0] := station.Shuttles[0].Shuttle6D;	 
			station.Operation.WaitUntilAllDone.Shuttles[1] := station.Shuttles[1].Shuttle6D;	 	 
			station.Commands.WaitUntilAllDone := TRUE;
		
			IF station.Operation.WaitUntilAllDone.Done THEN
				station.State := station.State + 1;
			END_IF;
		1001:
			station.Var.StateInfo := 'Clear group';
			// -----------------------------------------------------------------
			station.Commands.Group.Clear := TRUE;
			
			IF station.Group.GroupClear.Done THEN
				station.State := station.State + 1;
			END_IF;	
		1002:
			// Return shuttles to the traffic network
			// ----------------------------------------------------------------------------------------------------------------------------------
			station.Var.StateInfo := 'Move shuttles to exit positions';
			// -----------------------------------------------------------------
			reset_parameters_all;
			
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[0].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Path := mcACP6D_PATH_X_THEN_Y;
			station.Operation.MoveInPlane.Parameters.Position.X := 0.180;
			station.Operation.MoveInPlane.Parameters.Position.Y := 1.860;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := station.State + 1;
			END_IF;
		1003:
			station.Var.StateInfo := 'Move shuttles to exit positions';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[1].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Path := mcACP6D_PATH_X_THEN_Y;
			station.Operation.MoveInPlane.Parameters.Position.X := 0.060;
			station.Operation.MoveInPlane.Parameters.Position.Y := 1.860;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := station.State + 1;
			END_IF;	
		1004:
			station.Var.StateInfo := 'Release shuttles';
			// -----------------------------------------------------------------
			station.Operation.StationQueueControl.ShuttleList[0] := station.Shuttles[0];
			station.Operation.StationQueueControl.ShuttleList[1] := station.Shuttles[1];
			station.Commands.Release := TRUE;
			
			IF station.Operation.StationQueueControl.ShuttleReleaseDone THEN
				station.State := station.State + 1;
			END_IF;
		1005:
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
