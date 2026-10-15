
ACTION Station_Sequence_S2:
	// Point station reference to this station
	pStation ACCESS ADR(Stations[2]);
			
	// Station control logic and mapping
	pStation.Control.Enable := TRUE;
	pStation.Control.Station := ADR(S2);
	pStation.Control.To := ADR(B1);
	pStation.Macro.Name := 'S2';
	pStation.Operation.StationQueueControl.ShuttleCapacity := 1;
	
	CASE pStation.State OF
		0:	
			pStation.Var.StateInfo := 'Activating station';
			// -----------------------------------------------------------------
			IF pStation.Control.Active AND pStation.Control.State = mpTRAFFIC_ST_ON_OPEN THEN
				pStation.State := pStation.State + 1;	
			END_IF		
		1:
			pStation.Var.StateInfo := 'Check if station sequence macro exists';
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
			
			pStation.Operation.Spin.Parameters.Acceleration := 35.0;
			pStation.Operation.Spin.Parameters.Angle := 0;
			pStation.Operation.Spin.Parameters.Duration := 2.0;
			pStation.Operation.Spin.Shuttle := ADR(pStation.Macro.Shuttle);
			
			pStation.State := pStation.State + 1;
		11:
			pStation.Var.StateInfo := 'Move to position 1';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.840;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.120;
			
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;
		12:
			pStation.Var.StateInfo := 'Spin 1';
			// -----------------------------------------------------------------
			pStation.Operation.Spin.Parameters.Velocity := 22.0;
			pStation.Commands.Spin := TRUE;
			
			IF pStation.Operation.Spin.Acknowledge THEN
				pStation.State := pStation.State + 1;	
			END_IF;
		13:
			pStation.Var.StateInfo := 'Move position 2';
			// -----------------------------------------------------------------			
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.840;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.360;
			
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := pStation.State + 1;
			END_IF;	
		14:
			pStation.Var.StateInfo := 'Spin 2';
			// -----------------------------------------------------------------
			pStation.Operation.Spin.Parameters.Velocity := -22.0;
			pStation.Commands.Spin := TRUE;
			
			IF pStation.Operation.Spin.Acknowledge THEN
				pStation.State := pStation.State + 1;	
			END_IF;	
		15:
			pStation.Var.StateInfo := 'Check if sequence complete';
			// -----------------------------------------------------------------
			pStation.Var.LoopNum := pStation.Var.LoopNum + 1;
			
			IF pStation.Var.LoopNum > 0 THEN
				// Station sequence complete
				pStation.State := pStation.State + 1;
			ELSE
				// New loop of moves
				pStation.State :=  11;
			END_IF;	
		16:
			pStation.Var.StateInfo := 'Move to last position';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.840;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.360;
			
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
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
			pStation.Var.StateInfo := 'Waiting for shuttle to arrive at station';
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
			// -----------------------------------------------------------------'
			pStation.Operation.StationQueueControl.ShuttleList[0] := pStation.Shuttles[0];
			pStation.Commands.Release := TRUE;
			
			IF pStation.Operation.StationQueueControl.ShuttleReleaseDone THEN
				pStation.State := 0;
			END_IF;
	END_CASE;
	
	// Reset station commands when state changes
	IF pStation.State <> pStation.Var.PreviousState THEN
		pStation.Var.PreviousState := pStation.State;
		brsmemset(ADR(pStation.Commands), 0, SIZEOF(pStation.Commands));
	END_IF;
	
END_ACTION
