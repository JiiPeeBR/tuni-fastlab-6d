
ACTION execute_station_S1:
	// Point station reference to this station
	station ACCESS ADR(stations[1]);
			
	// Station control logic and mapping
	station.Control.Enable := TRUE;
	station.Control.Station := ADR(S1);
	station.Control.To := ADR(S2);
	station.Macro.Name := 'S1';
	station.Operation.StationQueueControl.ShuttleCapacity := 1;
		
	CASE station.State OF
		0:	
			station.Var.StateInfo := 'Activating station';
			// -----------------------------------------------------------------
			IF station.Control.Active AND station.Control.State = mpTRAFFIC_ST_ON_OPEN THEN
	  			station.State := station.State + 1;	
			END_IF;
			
		1:
			station.Var.StateInfo := 'Check if station sequence macro exists';
			// -----------------------------------------------------------------
			IF station.Macro.Shuttle.controlif > 0 THEN
				// Macro already created -> go to wait for next shuttle
				station.State := 200;
			ELSE
				station.State := station.State + 1;
			END_IF;
			
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
			
			station.State := station.State + 1;
		11:
			station.Var.StateInfo := 'Move to UL';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveInPlane.Parameters.Position.X := 0.060;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.420;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;
		12:
			station.Var.StateInfo := 'Move to LL';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveInPlane.Parameters.Position.X := 0.060;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.060;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;	
			END_IF;
		13:
			station.Var.StateInfo := 'Move to LR';
			// -----------------------------------------------------------------	
			station.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveInPlane.Parameters.Position.X := 0.180;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.060;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;	
			END_IF;
		14:
			station.Var.StateInfo := 'Move to UR';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveInPlane.Parameters.Position.X := 0.180;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.420;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;	
			END_IF;
		15:
			station.Var.StateInfo := 'Move to UL';
			// -----------------------------------------------------------------	
			station.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveInPlane.Parameters.Position.X := 0.060;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.420;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;	
		16:
			station.Var.StateInfo := 'Move to LR';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveInPlane.Parameters.Position.X := 0.180;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.060;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;	
			END_IF;
		17:
			station.Var.StateInfo := 'Move to LL';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveInPlane.Parameters.Position.X := 0.060;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.060;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;	
			END_IF;	
		18:
			station.Var.StateInfo := 'Move to UR';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveInPlane.Parameters.Position.X := 0.180;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.420;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;	
			END_IF;
		19:
			station.Var.StateInfo := 'Move to UL';
			// -----------------------------------------------------------------	
			station.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveInPlane.Parameters.Position.X := 0.060;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.420;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;
			END_IF;	
		20:
			station.Var.StateInfo := 'Move to LL';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_ABSOLUTE;
			station.Operation.MoveInPlane.Parameters.Position.X := 0.060;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.060;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := 30;	
			END_IF;	
		30:
			station.Var.StateInfo := 'Move right';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Parameters.Position.X := 0.120;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.000;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;	
			END_IF;	
		31:
			station.Var.StateInfo := 'Move up';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.120;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;	
			END_IF;
		32:
			station.Var.StateInfo := 'Move left';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Parameters.Position.X := -0.120;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.000;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;	
			END_IF;
		33:
			station.Var.StateInfo := 'Move up';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.120;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;	
			END_IF;
		34:
			station.Var.StateInfo := 'Move right';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Parameters.Position.X := 0.120;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.000;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;	
			END_IF;	
		35:
			station.Var.StateInfo := 'Move up';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.120;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;	
			END_IF;
		36:
			station.Var.StateInfo := 'Move left';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Parameters.Position.X := -0.120;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.000;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;	
			END_IF;
		37:
			station.Var.StateInfo := 'Move down';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			station.Operation.MoveInPlane.Parameters.Position.Y := -0.120;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;	
			END_IF;
		38:
			station.Var.StateInfo := 'Move right';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Parameters.Position.X := 0.120;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.000;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;	
			END_IF;	
		39:
			station.Var.StateInfo := 'Move down';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			station.Operation.MoveInPlane.Parameters.Position.Y := -0.120;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;	
			END_IF;
		40:
			station.Var.StateInfo := 'Move left';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Parameters.Position.X := -0.120;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.000;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;	
			END_IF;
		41:
			station.Var.StateInfo := 'Move down';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			station.Operation.MoveInPlane.Parameters.Position.Y := -0.120;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := station.State + 1;	
			END_IF;
		42:
			station.Var.StateInfo := 'Move right';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Parameters.Position.X := 0.120;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.000;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Acknowledge THEN
				station.State := 50;	
			END_IF;		
		50:
			station.Var.StateInfo := 'Check if sequence complete';
			// -----------------------------------------------------------------
			IF station.Var.LoopNum < 3 THEN
				station.Var.LoopNum := station.Var.LoopNum + 1;
				station.State :=  11;
			ELSE
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
