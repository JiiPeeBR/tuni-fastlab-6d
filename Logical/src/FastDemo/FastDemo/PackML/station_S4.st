
ACTION Station_Sequence_S4:
	// Point pStation. reference to this pStation.
	pStation ACCESS ADR(Stations[4]);
			
	// Station control logic and mapping
	// -----------------------------------------------------------------
	pStation.Control.Enable := TRUE;
	pStation.Control.Station := ADR(S4);
	pStation.Control.To := ADR(S5);
	pStation.Macro.Name := 'S4';
	pStation.Zone.Name := 'Z4';
	pStation.Operation.StationQueueControl.ShuttleCapacity := 2;
	
	// -----------------------------------------------------------------
	CASE pStation.State OF
		0:	
			pStation.Var.StateInfo := 'Activating pStation.';
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
			pStation.Var.StateInfo := 'Find pStation. zone by name';
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
			pStation.Zone.ZoneCreate.Parameters.BottomLeft.Y := 1.440;
			pStation.Zone.ZoneCreate.Parameters.TopRight.X := 0.240;
			pStation.Zone.ZoneCreate.Parameters.TopRight.Y := 1.900;
			pStation.Zone.ZoneCreate.Parameters.Name := pStation.Zone.Name;
			pStation.Commands.Zone.Create := TRUE;
		
			IF pStation.Zone.ZoneCreate.Done THEN
				// Go back one step and rescan the zones to get the zone reference
				pStation.State := 20;
			END_IF;
		30:
			pStation.Var.StateInfo := 'Check if pStation. sequence macro exists';
			// -----------------------------------------------------------------	
			IF pStation.Macro.Shuttle.controlif = 0 THEN
				pStation.State := pStation.State + 1;
			ELSE
				pStation.State := 200;
			END_IF;
		31:
			pStation.Var.StateInfo := 'Check if pStation. sequence macro exists';
			// -----------------------------------------------------------------
			pStation.Commands.Macro.Create := TRUE;
		
			IF pStation.Macro.MacroCreate.Done THEN
				pStation.Macro.Shuttle := pStation.Macro.MacroCreate.MacroShuttle;
				pStation.State := 200;
			END_IF;
			
		200:
			// Station sequence
			// ----------------------------------------------------------------------------------------------------------------------------------
			pStation.Var.StateInfo := 'Initialize pStation. sequence';
			// -----------------------------------------------------------------
			reset_parameters_all;
			pStation.ShuttleCount := 0;
			brsmemset(ADR(pStation.Shuttles), 0, SIZEOF(pStation.Shuttles));
			pStation.State := pStation.State + 1;
			
		201:
			pStation.Var.StateInfo := 'Waiting for first shuttle to arrive at pStation.';
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
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.120;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 1.740;
			pStation.Operation.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_X_THEN_Y;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		203:	
			pStation.Var.StateInfo := 'Waiting for second shuttle to arrive at pStation.';
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
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.120;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 1.620;
			pStation.Operation.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_X_THEN_Y;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Done THEN
				pStation.State := 210;
			END_IF;
		210:
			pStation.Var.StateInfo := 'Init synchronized move';
			// -----------------------------------------------------------------
			reset_parameters_all;
			pStation.Operation.MoveArc.Parameters.Angular.Angle := 10 * brmTWOPI;
			
			pStation.Operation.WaitCommandLabel.TriggerXID := pStation.Shuttles[0].ShuttleID;
			pStation.Operation.WaitCommandLabel.TriggerCmdLb := 0;
			pStation.State := pStation.State + 1;
		211:
			pStation.Var.StateInfo := 'Shuttle 1 waits for 0';
			// -----------------------------------------------------------------			
			pStation.Operation.WaitCommandLabel.Shuttle := ADR(pStation.Shuttles[1].Shuttle6D);
			pStation.Commands.WaitCommandLabel := TRUE;
			
			IF pStation.Operation.WaitCommandLabel.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		212:
			pStation.Var.StateInfo := 'Arc';
			// -----------------------------------------------------------------
			pStation.Operation.MoveArc.Parameters.Direction := mcACP6D_ARC_CLOCKWISE;
			pStation.Operation.MoveArc.Parameters.Angular.Center.X := 0;
			pStation.Operation.MoveArc.Parameters.Angular.Center.Y := -0.060;
			pStation.Operation.MoveArc.Shuttle := ADR(pStation.Shuttles[1].Shuttle6D);
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.Operation.MoveArc.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;	
		213:
			pStation.Var.StateInfo := 'Arc';
			// -----------------------------------------------------------------			
			pStation.Operation.MoveArc.Parameters.Direction := mcACP6D_ARC_CLOCKWISE;
			pStation.Operation.MoveArc.Parameters.Angular.Center.X := 0;
			pStation.Operation.MoveArc.Parameters.Angular.Center.Y := 0.060;
			pStation.Operation.MoveArc.Shuttle := ADR(pStation.Shuttles[0].Shuttle6D);
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.Operation.MoveArc.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		214:
			pStation.Var.StateInfo := 'Move to 2nd start pos';
			// -----------------------------------------------------------------
			reset_parameters_all;
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[0].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.180;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 1.860;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		215:
			pStation.Var.StateInfo := 'Move to 2nd start pos';
			// -----------------------------------------------------------------
			reset_parameters_all;
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[1].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.060;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 1.500;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;	
		216:
			pStation.Var.StateInfo := 'Sync shuttles';
			// -----------------------------------------------------------------
			pStation.Operation.WaitUntilAllDone.Shuttles[0] := pStation.Shuttles[0].Shuttle6D;	 
			pStation.Operation.WaitUntilAllDone.Shuttles[1] := pStation.Shuttles[1].Shuttle6D;	 	 
			pStation.Commands.WaitUntilAllDone := TRUE;
		
			IF pStation.Operation.WaitUntilAllDone.Done THEN
				pStation.State := 220;
			END_IF;
			
		220:
			pStation.Var.StateInfo := 'Move pattern for slave shuttle';
			// -----------------------------------------------------------------
			reset_parameters_all;
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[1].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Mode := mcACP6D_MOVE_RELATIVE;
			
			pStation.Operation.WaitCommandLabel.TriggerXID := pStation.Shuttles[0].ShuttleID;
			pStation.Operation.WaitCommandLabel.TriggerCmdLb := 0;
			pStation.State := pStation.State + 1;
		221:
			pStation.Var.StateInfo := '';
			// -----------------------------------------------------------------			
			pStation.Operation.WaitCommandLabel.Shuttle := ADR(pStation.Shuttles[1].Shuttle6D);
			pStation.Commands.WaitCommandLabel := TRUE;
			
			IF pStation.Operation.WaitCommandLabel.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		222:
			pStation.Var.StateInfo := 'Shuttle 1 moves';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.120;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.0;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		223:
			pStation.Var.StateInfo := 'Shuttle 1 moves';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.120;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		224:
			pStation.Var.StateInfo := 'Shuttle 1 moves';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := -0.120;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.0;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		225:
			pStation.Var.StateInfo := 'Shuttle 1 moves';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.120;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		226:
			pStation.Var.StateInfo := 'Shuttle 1 moves';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.120;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.0;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		227:
			pStation.Var.StateInfo := 'Shuttle 1 moves';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.120;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		228:
			pStation.Var.StateInfo := 'Shuttle 1 moves';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := -0.120;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.0;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := 240;
			END_IF;
		
		240:
			pStation.Var.StateInfo := 'Move pattern for master shuttle';
			// -----------------------------------------------------------------
			reset_parameters_all;
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[0].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Mode := mcACP6D_MOVE_RELATIVE;
			pStation.State := pStation.State + 1;
		241:
			pStation.Var.StateInfo := 'Shuttle 0 moves';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := -0.120;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.0;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		242:
			pStation.Var.StateInfo := 'Shuttle 0 moves';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := -0.120;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		243:
			pStation.Var.StateInfo := 'Shuttle 0 moves';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.120;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.0;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		244:
			pStation.Var.StateInfo := 'Shuttle 0 moves';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := -0.120;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		245:
			pStation.Var.StateInfo := 'Shuttle 0 moves';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := -0.120;
				pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.0;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		246:
			pStation.Var.StateInfo := 'Shuttle 0 moves';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := -0.120;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		247:
			pStation.Var.StateInfo := 'Shuttle 0 moves';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.120;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.0;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := 1000;
			END_IF;
			
		1000:
			pStation.Var.StateInfo := 'Sync shuttles';
			// -----------------------------------------------------------------
			pStation.Operation.WaitUntilAllDone.Shuttles[0] := pStation.Shuttles[0].Shuttle6D;	 
			pStation.Operation.WaitUntilAllDone.Shuttles[1] := pStation.Shuttles[1].Shuttle6D;	 	 
			pStation.Commands.WaitUntilAllDone := TRUE;
		
			IF pStation.Operation.WaitUntilAllDone.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		1001:
			pStation.Var.StateInfo := 'Clear group';
			// -----------------------------------------------------------------
			pStation.Commands.Group.Clear := TRUE;
			
			IF pStation.Group.GroupClear.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;	
		1002:
			// Return shuttles to the traffic network
			// ----------------------------------------------------------------------------------------------------------------------------------
			pStation.Var.StateInfo := 'Move shuttles to exit positions';
			// -----------------------------------------------------------------
			reset_parameters_all;
			
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[0].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Path := mcACP6D_PATH_X_THEN_Y;
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.180;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 1.860;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;
		1003:
			pStation.Var.StateInfo := 'Move shuttles to exit positions';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Shuttles[1].Shuttle6D);
			pStation.Operation.MoveInPlane.Parameters.Path := mcACP6D_PATH_X_THEN_Y;
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.060;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 1.860;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Done THEN
				pStation.State := pStation.State + 1;
			END_IF;	
		1004:
			pStation.Var.StateInfo := 'Release shuttles';
			// -----------------------------------------------------------------
			pStation.Operation.StationQueueControl.ShuttleList[0] := pStation.Shuttles[0];
			pStation.Operation.StationQueueControl.ShuttleList[1] := pStation.Shuttles[1];
			pStation.Commands.Release := TRUE;
			
			IF pStation.Operation.StationQueueControl.ShuttleReleaseDone THEN
				pStation.State := pStation.State + 1;
			END_IF;
		1005:
			pStation.Var.StateInfo := 'Wait until shuttles at the pStation. have all left';
			// -----------------------------------------------------------------
			pStation.Commands.Zone.GetBarrierInfo := TRUE;
			
			IF pStation.Zone.ZoneGetBarrierInfo.Done THEN
				pStation.Commands.Zone.GetBarrierInfo := FALSE;
				IF pStation.Zone.ZoneGetBarrierInfo.BarrierInfo.NumberOfShuttles = 0 THEN
					pStation.State := 200;	
				END_IF;
			END_IF;
	END_CASE;
	
	// Reset pStation. commands when state changes
	IF pStation.State <> pStation.Var.PreviousState THEN
		pStation.Var.PreviousState := pStation.State;
		brsmemset(ADR(pStation.Commands), 0, SIZEOF(pStation.Commands));
	END_IF;
	
END_ACTION
