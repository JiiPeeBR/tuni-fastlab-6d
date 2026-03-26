
ACTION sequence_initialize: 
	CASE em.SubState OF
		0:		
			em.StateInfo := 'Wait assembly to boot up';
			// ---------------------------------------------------------------------------------
			IF em.Info.OnStateEntry THEN
				// Clear old shuttle data
				brsmemset(ADR(gShuttles), 0, SIZEOF(gShuttles));
				brsmemset(ADR(task.Error), 0, SIZEOF(task.Error));
			END_IF;
			
			fb.AssemblyReadInfo.Enable := TRUE;
				
			//Wait for the startup phase to be finished
			IF fb.AssemblyReadInfo.Valid THEN
				IF (fb.AssemblyReadInfo.AssemblyInfo.AssemblyState = mcACP6D_ERRORSTOP) THEN
					task.Error.Code := fb.AssemblyReadInfo.ErrorID;
					em.SubState := 10;
				ELSIF (fb.AssemblyReadInfo.AssemblyInfo.AssemblyState <> mcACP6D_STARTUP AND fb.AssemblyReadInfo.AssemblyInfo.CommunicationReady) THEN
					IF fb.AssemblyReadInfo.AssemblyInfo.AssemblyState = mcACP6D_DISABLED THEN
						// Assembly powered off -> power on
						em.SubState := 100;	
					ELSE
						// Assembly powered on -> power off first
						em.SubState := 20;
					END_IF;
				END_IF
			END_IF
			
		10:
			em.StateInfo := 'Clear initial errors';
			// ---------------------------------------------------------------------------------
			actions_substate.assemblyReset := TRUE;
			
			IF fb.AssemblyReset.Done THEN
				em.SubState := 0;
			ELSIF fb.AssemblyReset.Error THEN
				task.Error.Code := fb.AssemblyReset.ErrorID;
				em.Command.Abort := TRUE;
			END_IF
			
		20:
			em.StateInfo := 'Power off assembly';
			// ---------------------------------------------------------------------------------		
			actions_substate.assemblyPowerOff := TRUE;
					
			IF fb.AssemblyPowerOn.Done THEN
				em.SubState := 100;
			ELSIF fb.AssemblyPowerOn.Error THEN
				task.Error.Code := fb.AssemblyPowerOn.ErrorID;
				em.Command.Abort := TRUE;
			END_IF
		
		100:
			em.StateInfo := 'Power on assembly';
			// ---------------------------------------------------------------------------------
			IF em.Info.OnStateEntry THEN
				// Clear old shuttle data
				brsmemset(ADR(gShuttles), 0, SIZEOF(gShuttles));
			END_IF;
					
			actions_substate.assemblyPowerOn := TRUE;
					
			IF fb.AssemblyPowerOn.Done THEN
				em.SubState := 200;
			ELSIF fb.AssemblyPowerOn.Error THEN
				task.Error.Code := fb.AssemblyPowerOn.ErrorID;
				em.Command.Abort := TRUE;
			END_IF
				
		200:
			em.StateInfo := 'Read shuttle info - Start reading';
			// ---------------------------------------------------------------------------------	
			actions_state.getShuttles := TRUE;
						
			IF fb.AssemblyGetShuttle.Valid THEN
				gShuttles.Count := fb.AssemblyGetShuttle.TotalCount;
				
				IF (fb.AssemblyGetShuttle.TotalCount = 0) THEN
					// No shuttles detected - halt execution
					em.SubState := 999;
				ELSE
					em.SubState := 201;	
				END_IF;
			END_IF
					
		201:
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
				em.SubState := 300;
			END_IF
					
		300:
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
				
				em.SubState := 1000;
				
			ELSIF fb.AssemblyReadShIDTable.Error THEN
				task.Error.Code := fb.AssemblyReadShIDTable.ErrorID;
				em.Command.Abort := TRUE;
			END_IF;
				
		999:
			em.StateInfo := 'No shuttles detected';
			// ---------------------------------------------------------------------------------
			
		1000:
			em.StateInfo := 'Done';
			// ---------------------------------------------------------------------------------
			em.Command.StateComplete := TRUE;
	END_CASE;	
END_ACTION
