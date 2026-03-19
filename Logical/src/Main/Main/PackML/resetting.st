
ACTION state_resetting: 
	CASE em.SubState OF
		0:
			em.StateInfo := 'Wait assembly to boot up';
			// ---------------------------------------------------------------------------------					
			//Wait for the startup phase to be finished
			IF fb.AssemblyReadInfo.Valid THEN
				IF (fb.AssemblyReadInfo.AssemblyInfo.AssemblyState = mcACP6D_ERRORSTOP) THEN
					em.SubState := 10;
				ELSIF (fb.AssemblyReadInfo.AssemblyInfo.AssemblyState <> mcACP6D_STARTUP) THEN
					em.SubState := 20;
				END_IF
			END_IF
		
		10:
			em.StateInfo := 'Reset assembly errors';
			// ---------------------------------------------------------------------------------
			IF em.Info.OnStateEntry THEN
				// Clear old shuttle data
				brsmemset(ADR(gShuttles), 0, SIZEOF(gShuttles));
			END_IF;
										
			actions_substate.assemblyReset := TRUE;
			
			IF fb.AssemblyReset.Done THEN
				em.SubState := 10;
			ELSIF fb.AssemblyReset.Error THEN
				task.Error.Code := fb.AssemblyReset.ErrorID;
			END_IF
			
		20:
			em.StateInfo := 'Power on assembly';
			// ---------------------------------------------------------------------------------
			IF em.Info.OnStateEntry THEN
				// Clear old shuttle data
				brsmemset(ADR(gShuttles), 0, SIZEOF(gShuttles));
			END_IF;
					
			actions_substate.assemblyPowerOn := TRUE;
					
			IF fb.AssemblyPowerOn.Done THEN
				em.SubState := 100;
			ELSIF fb.AssemblyPowerOn.Error THEN
				task.Error.Code := fb.AssemblyPowerOn.ErrorID;
				em_command.Abort := TRUE;
			END_IF
				
		100:
			em.StateInfo := 'Read shuttle info - Start reading';
			// ---------------------------------------------------------------------------------	
			actions_state.getShuttles := TRUE;
						
			IF fb.AssemblyGetShuttle.Valid THEN
				gShuttles.Count := fb.AssemblyGetShuttle.TotalCount;
				
				IF (fb.AssemblyGetShuttle.TotalCount = 0) THEN
					// No shuttles detected - halt execution
					em.SubState := 999;
				ELSE
					em.SubState := 110;	
				END_IF;
			END_IF
					
		110:
			em.StateInfo := 'Read shuttle info - Get next';
			// ---------------------------------------------------------------------------------
			// Read shuttle information
			// Prevent access to wrong memory area
			i := LIMIT(0, UINT_TO_DINT(fb.AssemblyGetShuttle.TotalCount - fb.AssemblyGetShuttle.RemainingCount - 1), gMAX_INDEX_SHUTTLE);
						
			gShuttles.Shuttle[i].ID := fb.AssemblyGetShuttle.AdditionalInfo.ShuttleID;
			gShuttles.Shuttle[i].Ref := fb.AssemblyGetShuttle.Shuttle;
			
			IF (fb.AssemblyGetShuttle.RemainingCount > 0) THEN
				// Toggle get next shuttle input on/off until we have read all
				actions_substate.getNextShuttle := NOT actions_substate.getNextShuttle;	
			ELSE
				em.SubState := 200;
			END_IF
					
		200:
			em.StateInfo := 'Read shuttle IDs';
			// ---------------------------------------------------------------------------------
			actions_substate.readShuttleIDs := TRUE;
			
			IF fb.AssemblyReadShIDTable.Done THEN
				FOR i := 0 TO gShuttles.Count - 1 DO
					FOR x := 0 TO gShuttles.Count - 1 DO
						IF fb.AssemblyReadShIDTable.ShIDTable.ShuttleIDs[x] = gShuttles.Shuttle[i].ID THEN
							gShuttles.Shuttle[i].UID.Low := fb.AssemblyReadShIDTable.ShIDTable.UIDLow[x];
							gShuttles.Shuttle[i].UID.High := fb.AssemblyReadShIDTable.ShIDTable.UIDHigh[x];
							EXIT;
						END_IF;
					END_FOR;
				END_FOR;
				
				em.SubState := 300;
			ELSIF fb.AssemblyReadShIDTable.Error THEN
				task.Error.Code := fb.AssemblyReadShIDTable.ErrorID;
				em_command.Abort := TRUE;
			END_IF;
			
		300:
			em.StateInfo := 'Home all shuttles';
			// ---------------------------------------------------------------------------------
			IF em.Info.OnSubStateEntry THEN	
				brsmemset(ADR(fb.MoveInPlaneAsync.Parameters), 0, SIZEOF(fb.MoveInPlaneAsync.Parameters));
				
				fb.MoveInPlaneAsync.Parameters.Velocity := 2;
				fb.MoveInPlaneAsync.Parameters.Acceleration := 15;
				fb.MoveInPlaneAsync.Parameters.Mode := mcACP6D_SHUTTLE_SORTED;
				fb.MoveInPlaneAsync.Parameters.Overhang := FALSE;
						
				FOR i := 0 TO gShuttles.Count - 1 DO	
					fb.MoveInPlaneAsync.Parameters.AsyncPar[i].Shuttle := ADR(gShuttles.Shuttle[i].Ref);
					fb.MoveInPlaneAsync.Parameters.AsyncPar[i].X := local.homePosition[i].x;
					fb.MoveInPlaneAsync.Parameters.AsyncPar[i].Y := local.homePosition[i].y;
				END_FOR;
			END_IF;
						
			actions_substate.homeShuttles := TRUE;
						
			IF fb.MoveInPlaneAsync.Done THEN
				em.SubState := 1000;
			ELSIF fb.MoveInPlaneAsync.Error THEN
				task.Error.Code := fb.MoveInPlaneAsync.ErrorID;	
				em_command.Abort := TRUE;
			END_IF;
			
		999:
			em.StateInfo := 'No shuttles detected';
			// ---------------------------------------------------------------------------------
			
		1000:
			em.StateInfo := 'Done';
			// ---------------------------------------------------------------------------------
			em_command.StateComplete := TRUE;
	END_CASE;	
END_ACTION
