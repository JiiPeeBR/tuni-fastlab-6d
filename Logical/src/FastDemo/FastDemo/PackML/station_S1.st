
ACTION Station_Sequence_S1:
	// Point station reference to this station
	pStation ACCESS ADR(Stations[1]);
			
	// Station control logic and mapping
	pStation.Control.Enable := TRUE;
	pStation.Control.Station := ADR(S1);
	pStation.Control.To := ADR(S2);
	pStation.Macro.Name := 'S1';
	pStation.Operation.StationQueueControl.ShuttleCapacity := 1;
		
	CASE pStation.State OF
		0:	
			pStation.Var.StateInfo := 'Activating station';
			// -----------------------------------------------------------------
			IF pStation.Control.Active AND pStation.Control.State = mpTRAFFIC_ST_ON_OPEN THEN
	  			pStation.State := pStation.State + 1;	
			END_IF;
			
		1:
			pStation.Var.StateInfo := 'Check if station sequence macro exists';
			// -----------------------------------------------------------------
			IF pStation.Macro.Shuttle.controlif > 0 THEN
				// Macro already created -> go to wait for next shuttle
				pStation.State := 200;
			ELSE
				pStation.State := pStation.State + 1;
			END_IF;
			
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
			
			reset_parameters_MoveInPlane;
			pStation.Operation.MoveInPlane.Parameters.Velocity := 2;
			pStation.Operation.MoveInPlane.Shuttle := ADR(pStation.Macro.Shuttle);
			pStation.State := pStation.State + 1;
		11:
			pStation.Var.StateInfo := 'Move to UL';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.060;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.420;
			MoveInPlane_AddToBuffer;
		12:
			pStation.Var.StateInfo := 'Move to LL';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.060;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.060;
			MoveInPlane_AddToBuffer;
		13:
			pStation.Var.StateInfo := 'Move to LR';
			// -----------------------------------------------------------------	
			pStation.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.180;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.060;
			MoveInPlane_AddToBuffer;
		14:
			pStation.Var.StateInfo := 'Move to UR';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.180;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.420;
			MoveInPlane_AddToBuffer;
		15:
			pStation.Var.StateInfo := 'Move to UL';
			// -----------------------------------------------------------------	
			pStation.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.060;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.420;
			MoveInPlane_AddToBuffer;	
		16:
			pStation.Var.StateInfo := 'Move to LR';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.180;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.060;
			MoveInPlane_AddToBuffer;
		17:
			pStation.Var.StateInfo := 'Move to LL';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.060;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.060;
			MoveInPlane_AddToBuffer;	
		18:
			pStation.Var.StateInfo := 'Move to UR';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.180;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.420;
			MoveInPlane_AddToBuffer;
		19:
			pStation.Var.StateInfo := 'Move to UL';
			// -----------------------------------------------------------------	
			pStation.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.060;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.420;
			MoveInPlane_AddToBuffer;	
		20:
			pStation.Var.StateInfo := 'Move to LL';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_ABSOLUTE;
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.060;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.060;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := 30;	
			END_IF;	
		30:
			pStation.Var.StateInfo := 'Move right';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.120;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.000;
			MoveInPlane_AddToBuffer;	
		31:
			pStation.Var.StateInfo := 'Move up';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.120;
			MoveInPlane_AddToBuffer;
		32:
			pStation.Var.StateInfo := 'Move left';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Parameters.Position.X := -0.120;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.000;
			MoveInPlane_AddToBuffer;
		33:
			pStation.Var.StateInfo := 'Move up';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.120;
			MoveInPlane_AddToBuffer;
		34:
			pStation.Var.StateInfo := 'Move right';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.120;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.000;
			MoveInPlane_AddToBuffer;	
		35:
			pStation.Var.StateInfo := 'Move up';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.120;
			MoveInPlane_AddToBuffer;
		36:
			pStation.Var.StateInfo := 'Move left';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Parameters.Position.X := -0.120;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.000;
			MoveInPlane_AddToBuffer;
		37:
			pStation.Var.StateInfo := 'Move down';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := -0.120;
			MoveInPlane_AddToBuffer;
		38:
			pStation.Var.StateInfo := 'Move right';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.120;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.000;
			MoveInPlane_AddToBuffer;	
		39:
			pStation.Var.StateInfo := 'Move down';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := -0.120;
			MoveInPlane_AddToBuffer;
		40:
			pStation.Var.StateInfo := 'Move left';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Parameters.Position.X := -0.120;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.000;
			MoveInPlane_AddToBuffer;
		41:
			pStation.Var.StateInfo := 'Move down';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.000;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := -0.120;
			MoveInPlane_AddToBuffer;
		42:
			pStation.Var.StateInfo := 'Move right';
			// -----------------------------------------------------------------
			pStation.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			pStation.Operation.MoveInPlane.Parameters.Position.X := 0.120;
			pStation.Operation.MoveInPlane.Parameters.Position.Y := 0.000;
			pStation.Commands.MoveInPlane := TRUE;
			
			IF pStation.Operation.MoveInPlane.Acknowledge THEN
				pStation.State := 50;	
			END_IF;		
		50:
			pStation.Var.StateInfo := 'Check if sequence complete';
			// -----------------------------------------------------------------
			IF pStation.Var.LoopNum < 3 THEN
				pStation.Var.LoopNum := pStation.Var.LoopNum + 1;
				pStation.State :=  11;
			ELSE
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
			// -----------------------------------------------------------------
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
