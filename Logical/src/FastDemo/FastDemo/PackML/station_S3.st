
ACTION Station_Sequence_S3:
	// Point station reference to this pStation.
	pStation ACCESS ADR(Stations[3]);
			
	// Station control logic and mapping
	pStation.Control.Enable := TRUE;
	pStation.Control.Station := ADR(S3);
	pStation.Control.To := ADR(S5);
	pStation.Macro.Name := 'S3';
	pStation.Operation.StationQueueControl.ShuttleCapacity := 1;
				
	CASE pStation.State OF
		0:	
			pStation.Var.StateInfo := 'Activating pStation.';
			// -----------------------------------------------------------------
			IF pStation.Control.Active AND pStation.Control.State = mpTRAFFIC_ST_ON_OPEN THEN
				pStation.State := pStation.State + 1;	
			END_IF		
		1:
			pStation.Var.StateInfo := 'Check if pStation. sequence macro exists';
			// -----------------------------------------------------------------
			IF pStation.Macro.Shuttle.controlif > 0 THEN
				// Macro already created -> go to wait for next shuttle
				pStation.State := 200;
			ELSE
				pStation.State := pStation.State + 1;
			END_IF	
		2:
			pStation.Var.StateInfo := 'Create new macro';
			// -----------------------------------------------------------------
			pStation.Commands.Macro.Create := TRUE;
			
			IF pStation.Macro.MacroCreate.Done THEN
				pStation.Macro.Shuttle := pStation.Macro.MacroCreate.MacroShuttle;
				pStation.State := 10;
			END_IF;	
		10:
			pStation.Var.StateInfo := 'Movement settings';
			// -----------------------------------------------------------------
			pStation.Var.LoopNum := 0;
			
			pStation.Operation.MoveInPlane.Parameters.Velocity := 2;
			pStation.Operation.MoveInPlane.Parameters.Acceleration := 18;
			pStation.Operation.MoveInPlane.Parameters.EndVelocity := 0;
			pStation.Operation.MoveInPlane.Parameters.Radius := 0;
			pStation.Operation.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_DIRECT;
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Macro.Shuttle);
			
			pStation.Operation.MoveArc.Parameters.Acceleration := 18;
			pStation.Operation.MoveArc.Parameters.Velocity := 1.5;
			pStation.Operation.MoveArc.Parameters.EndVelocity := 1.5;
			pStation.Operation.MoveArc.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveArc.Parameters.Option := mcACP6D_ARC_ANGULAR;
			pStation.Operation.MoveArc.Parameters.Angular.Angle := brmPI;
			pStation.Operation.MoveArc.Shuttle := ADR(pStation.Macro.Shuttle);
			
			pStation.State := pStation.State + 1;
		11:
			pStation.Var.StateInfo := 'Move to position 1';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.840;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 1.680;
			
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		12:
			pStation.Var.StateInfo := '';
			// -----------------------------------------------------------------
			pStation.Operation.MoveArc.Parameters.Direction := mcACP6D_ARC_COUNTER_CLOCKWISE;
			pStation.Operation.MoveArc.Parameters.Angular.Center.X := 0;
			pStation.Operation.MoveArc.Parameters.Angular.Center.Y := 0.060;
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.Operation.MoveArc.Acknowledge THEN
				pStation.State := pStation.State + 1;	
			END_IF;
		13:
			pStation.Var.StateInfo := '';
			// -----------------------------------------------------------------
			pStation.Operation.MoveArc.Parameters.Direction := mcACP6D_ARC_COUNTER_CLOCKWISE;
			pStation.Operation.MoveArc.Parameters.Angular.Center.X := 0;
			pStation.Operation.MoveArc.Parameters.Angular.Center.Y := -0.060;
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.Operation.MoveArc.Acknowledge THEN
				pStation.State := pStation.State + 1;	
			END_IF;
		14:
			pStation.Var.StateInfo := '';
			// -----------------------------------------------------------------
			pStation.Operation.MoveArc.Parameters.Direction := mcACP6D_ARC_CLOCKWISE;
			pStation.Operation.MoveArc.Parameters.Angular.Center.X := 0;
			pStation.Operation.MoveArc.Parameters.Angular.Center.Y := -0.060;
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.Operation.MoveArc.Acknowledge THEN
				pStation.State := pStation.State + 1;	
			END_IF;
			
		15:
			pStation.Var.StateInfo := '';
			// -----------------------------------------------------------------
			pStation.Operation.MoveArc.Parameters.Direction := mcACP6D_ARC_CLOCKWISE;
			pStation.Operation.MoveArc.Parameters.Angular.Center.X := 0;
			pStation.Operation.MoveArc.Parameters.Angular.Center.Y := 0.060;
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.Operation.MoveArc.Acknowledge THEN
				pStation.State := pStation.State + 1;	
			END_IF;
			
		16:
			pStation.Var.StateInfo := 'Check if sequence complete';
			// -----------------------------------------------------------------
			pStation.Var.LoopNum := pStation.Var.LoopNum + 1;
			
			IF pStation.Var.LoopNum > 5 THEN
				// Station sequence complete
				pStation.State := pStation.State + 1;
			ELSE
				// New loop of moves
				pStation.State :=  12;
			END_IF;	
		17:
			pStation.Var.StateInfo := 'Move to last position';
			// -----------------------------------------------------------------
			pStation.Operation.MoveArc.Parameters.Direction := mcACP6D_ARC_COUNTER_CLOCKWISE;
			pStation.Operation.MoveArc.Parameters.Angular.Center.X := 0;
			pStation.Operation.MoveArc.Parameters.Angular.Center.Y := 0.060;
			pStation.Operation.MoveArc.Parameters.EndVelocity := 0;
			pStation.Commands.MoveArc := TRUE;
			
			IF pStation.Operation.MoveArc.Acknowledge THEN
				pStation.State := 100;	
			END_IF;	
		100:	
			pStation.Var.StateInfo := 'Save macro';
			// -----------------------------------------------------------------
			pStation.Commands.Macro.Save := TRUE;
			
			IF pStation.Macro.MacroSave.Done THEN
				pStation.State := 200;
			END_IF;		
		200:	
			pStation.Var.StateInfo := 'Waiting for shuttle to arrive at pStation.';
			// -----------------------------------------------------------------
			IF pStation.Control.Info.Occupied THEN
				pStation.Shuttles[0] := pStation.Control.Info.LastArrivedShuttle;
				pStation.Macro.MacroRun.Shuttle := ADR(pStation.Shuttles[0].Shuttle6D);
				pStation.State := pStation.State + 1;	
			END_IF;
		201:	
			pStation.Var.StateInfo := 'Wait shuttle to complete its moves';
			// -----------------------------------------------------------------
			pStation.Macro.Execute := TRUE;
			
			IF pStation.Macro.MacroRun.Done THEN
				pStation.Macro.Execute := FALSE;
				pStation.State := 1000;
			END_IF;		
		1000:
			pStation.Var.StateInfo := 'Release shuttle to traffic network';
			// -----------------------------------------------------------------
			pStation.Operation.StationQueueControl.ShuttleList[0] := pStation.Shuttles[0];
			pStation.Commands.Release := TRUE;
			
			IF pStation.Operation.StationQueueControl.ShuttleReleaseDone THEN
					pStation.State := 0;
			END_IF;
	END_CASE;
	
	// Reset pStation. commands when state changes
	IF pStation.State <> pStation.Var.PreviousState THEN
		pStation.Var.PreviousState := pStation.State;
		brsmemset(ADR(pStation.Commands), 0, SIZEOF(pStation.Commands));
	END_IF;
	
END_ACTION
