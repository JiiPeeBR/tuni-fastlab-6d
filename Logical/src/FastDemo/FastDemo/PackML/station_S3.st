
ACTION execute_station_S3:
	// Point station reference to this station
	station ACCESS ADR(stations[3]);
			
	// Station control logic and mapping
	station.Control.Enable := TRUE;
	station.Control.Station := ADR(S3);
	station.Control.To := ADR(S5);
	station.Macro.Name := 'S3';
	station.Operation.StationQueueControl.ShuttleCapacity := 1;
				
	CASE station.State OF
		0:	
			station.Var.StateInfo := 'Activating station';
			// -----------------------------------------------------------------
			IF station.Control.Active AND station.Control.State = mpTRAFFIC_ST_ON_OPEN THEN
				station.State := station.State + 1;	
			END_IF		
		1:
			station.Var.StateInfo := 'Check if station sequence macro exists';
			// -----------------------------------------------------------------
			IF station.Macro.Shuttle.controlif > 0 THEN
				// Macro already created -> go to wait for next shuttle
				station.State := 200;
			ELSE
				station.State := station.State + 1;
			END_IF	
		2:
			station.Var.StateInfo := 'Create new macro';
			// -----------------------------------------------------------------
			station.Commands.Macro.Create := TRUE;
			
			IF station.Macro.MacroCreate.Done THEN
				station.Macro.Shuttle := station.Macro.MacroCreate.MacroShuttle;
				station.State := 10;
			END_IF;	
		10:
			station.Var.StateInfo := 'Movement settings';
			// -----------------------------------------------------------------
			station.Var.LoopNum := 0;
			
			station.Operation.MoveInPlane.Parameters.Velocity := 2;
			station.Operation.MoveInPlane.Parameters.Acceleration := 18;
			station.Operation.MoveInPlane.Parameters.EndVelocity := 0;
			station.Operation.MoveInPlane.Parameters.Radius := 0;
			station.Operation.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_DIRECT;
			station.Operation.MoveInPlane.Shuttle := ADR(station.Macro.Shuttle);
			
			station.Operation.MoveArc.Parameters.Acceleration := 18;
			station.Operation.MoveArc.Parameters.Velocity := 1.5;
			station.Operation.MoveArc.Parameters.EndVelocity := 1.5;
			station.Operation.MoveArc.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveArc.Parameters.Option := mcACP6D_ARC_ANGULAR;
			station.Operation.MoveArc.Parameters.Angular.Angle := brmPI;
			station.Operation.MoveArc.Shuttle := ADR(station.Macro.Shuttle);
			
			station.State := station.State + 1;
		11:
			station.Var.StateInfo := 'Move to position 1';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Position.X := 0.840;
			station.Operation.MoveInPlane.Parameters.Position.Y := 1.680;
			
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		12:
			station.Var.StateInfo := '';
			// -----------------------------------------------------------------
			station.Operation.MoveArc.Parameters.Direction := mcACP6D_ARC_COUNTER_CLOCKWISE;
			station.Operation.MoveArc.Parameters.Angular.Center.X := 0;
			station.Operation.MoveArc.Parameters.Angular.Center.Y := 0.060;
			station.Commands.MoveArc := TRUE;
			
			IF station.Operation.MoveArc.Acknowledge THEN
				station.State := station.State + 1;	
			END_IF;
		13:
			station.Var.StateInfo := '';
			// -----------------------------------------------------------------
			station.Operation.MoveArc.Parameters.Direction := mcACP6D_ARC_COUNTER_CLOCKWISE;
			station.Operation.MoveArc.Parameters.Angular.Center.X := 0;
			station.Operation.MoveArc.Parameters.Angular.Center.Y := -0.060;
			station.Commands.MoveArc := TRUE;
			
			IF station.Operation.MoveArc.Acknowledge THEN
				station.State := station.State + 1;	
			END_IF;
		14:
			station.Var.StateInfo := '';
			// -----------------------------------------------------------------
			station.Operation.MoveArc.Parameters.Direction := mcACP6D_ARC_CLOCKWISE;
			station.Operation.MoveArc.Parameters.Angular.Center.X := 0;
			station.Operation.MoveArc.Parameters.Angular.Center.Y := -0.060;
			station.Commands.MoveArc := TRUE;
			
			IF station.Operation.MoveArc.Acknowledge THEN
				station.State := station.State + 1;	
			END_IF;
			
		15:
			station.Var.StateInfo := '';
			// -----------------------------------------------------------------
			station.Operation.MoveArc.Parameters.Direction := mcACP6D_ARC_CLOCKWISE;
			station.Operation.MoveArc.Parameters.Angular.Center.X := 0;
			station.Operation.MoveArc.Parameters.Angular.Center.Y := 0.060;
			station.Commands.MoveArc := TRUE;
			
			IF station.Operation.MoveArc.Acknowledge THEN
				station.State := station.State + 1;	
			END_IF;
			
		16:
			station.Var.StateInfo := 'Check if sequence complete';
			// -----------------------------------------------------------------
			station.Var.LoopNum := station.Var.LoopNum + 1;
			
			IF station.Var.LoopNum > 5 THEN
				// Station sequence complete
				station.State := station.State + 1;
			ELSE
				// New loop of moves
				station.State :=  12;
			END_IF;	
		17:
			station.Var.StateInfo := 'Move to last position';
			// -----------------------------------------------------------------
			station.Operation.MoveArc.Parameters.Direction := mcACP6D_ARC_COUNTER_CLOCKWISE;
			station.Operation.MoveArc.Parameters.Angular.Center.X := 0;
			station.Operation.MoveArc.Parameters.Angular.Center.Y := 0.060;
			station.Operation.MoveArc.Parameters.EndVelocity := 0;
			station.Commands.MoveArc := TRUE;
			
			IF station.Operation.MoveArc.Acknowledge THEN
				station.State := 100;	
			END_IF;	
		100:	
			station.Var.StateInfo := 'Save macro';
			// -----------------------------------------------------------------
			station.Commands.Macro.Save := TRUE;
			
			IF station.Macro.MacroSave.Done THEN
				station.State := 200;
			END_IF;		
		200:	
			station.Var.StateInfo := 'Waiting for shuttle to arrive at station';
			// -----------------------------------------------------------------
			IF station.Control.Info.Occupied THEN
				station.Shuttles[0] := station.Control.Info.LastArrivedShuttle;
				station.Macro.MacroRun.Shuttle := ADR(station.Shuttles[0].Shuttle6D);
				station.State := station.State + 1;	
			END_IF;
		201:	
			station.Var.StateInfo := 'Wait shuttle to complete its moves';
			// -----------------------------------------------------------------
			station.Macro.Execute := TRUE;
			
			IF station.Macro.MacroRun.Done THEN
				station.Macro.Execute := FALSE;
				station.State := 1000;
			END_IF;		
		1000:
			station.Var.StateInfo := 'Release shuttle to traffic network';
			// -----------------------------------------------------------------
			station.Operation.StationQueueControl.ShuttleList[0] := station.Shuttles[0];
			station.Commands.Release := TRUE;
			
			IF station.Operation.StationQueueControl.ShuttleReleaseDone THEN
				station.State := 0;
			END_IF;
	END_CASE;
	
	// Reset station commands when state changes
	IF station.State <> station.Var.PreviousState THEN
		station.Var.PreviousState := station.State;
		brsmemset(ADR(station.Commands), 0, SIZEOF(station.Commands));
	END_IF;
	
END_ACTION
