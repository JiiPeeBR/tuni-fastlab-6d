
ACTION sequence_initialize: 
	CASE em.SubState OF
		0:		
			em.StateInfo := 'Wait assembly to boot up';
			// ---------------------------------------------------------------------------------
			IF em.Info.OnSubStateEntry THEN
				// Clear old shuttle data
				brsmemset(ADR(gShuttles), 0, SIZEOF(gShuttles));
				brsmemset(ADR(task.Error), 0, SIZEOF(task.Error));
			END_IF;
			
			fb.AssemblyReadInfo.Enable := TRUE;
				
			// Wait for the startup phase to be finished
			IF fb.AssemblyReadInfo.Valid THEN
				CASE fb.AssemblyReadInfo.AssemblyInfo.AssemblyState OF
					mcACP6D_ERRORSTOP: 
						// Assembly in error state
						em.SubState := 10;
					mcACP6D_STARTUP: 
						// Assembly is in the startup phase. Configuration is transferred.
						em.SubState := em.SubState + 1;
					mcACP6D_INVALID_CONFIGURATION: 
						// The assembly configuration is invalid. No recovery for this one
					ELSE
						em.SubState := 100;
				END_CASE;
			END_IF
			
		1:
			em.StateInfo := 'Wait assembly to boot up';
			// ---------------------------------------------------------------------------------
			IF em.Info.OnSubStateEntry THEN
				// Zero the found shuttle count
				local.shuttlesCount := 0;
				fb.TON_ShuttleScan(IN := FALSE);
			END_IF;

			fb.TON_ShuttleScan.PT := T#5s;
			fb.TON_ShuttleScan();
			
			CASE fb.AssemblyReadInfo.AssemblyInfo.AssemblyState OF
				mcACP6D_STARTUP:
					// Assembly is in the startup phase. Configuration is transferred.
				ELSE
					IF fb.AssemblyReadInfo.AssemblyInfo.CommunicationReady AND (fb.AssemblyReadInfo.AssemblyInfo.Controller6DState <> mcACP6D_STATE_BOOTING) THEN
						// Wait for shuttle scan to finish, reset timer whenevr shuttle count changes
						fb.TON_ShuttleScan.IN := (local.shuttlesCount = fb.AssemblyReadInfo.AssemblyInfo.ShuttlesCount);
						local.shuttlesCount := fb.AssemblyReadInfo.AssemblyInfo.ShuttlesCount;
						
						IF fb.TON_ShuttleScan.Q THEN
							em.SubState := 0;
						END_IF;
					END_IF;
			END_CASE;
		10:
			em.StateInfo := 'Clear assembly errors';
			// ---------------------------------------------------------------------------------
			actions_substate.assemblyReset := TRUE;
			
			IF fb.AssemblyReset.Done THEN
				em.SubState := 0;
			ELSIF fb.AssemblyReset.Error THEN
				task.Error.Code := fb.AssemblyReset.ErrorID;
				em.Command.Abort := TRUE;
			END_IF
			
		100:
			em.StateInfo := 'Assembly power sequence';
			// ---------------------------------------------------------------------------------
			CASE fb.AssemblyReadInfo.AssemblyInfo.AssemblyState OF
				mcACP6D_READY:
					// Assembly powered on -> power off first
					em.SubState := 101;	
				mcACP6D_DISABLED:
					// Assembly powered off -> power on
  					em.SubState := 102;	
			END_CASE;					
		101:
			em.StateInfo := 'Power off assembly';
			// ---------------------------------------------------------------------------------		
			actions_substate.assemblyPowerOff := TRUE;
					
			IF fb.AssemblyPowerOn.Done THEN
				em.SubState := 102;
			ELSIF fb.AssemblyPowerOn.Error THEN
				task.Error.Code := fb.AssemblyPowerOn.ErrorID;
				em.Command.Abort := TRUE;
			END_IF
		102:
			em.StateInfo := 'Power on assembly';
			// ---------------------------------------------------------------------------------	
			actions_substate.assemblyPowerOn := TRUE;
					
			IF fb.AssemblyPowerOn.Done THEN
				em.SubState := 200;
			ELSIF fb.AssemblyPowerOn.Error THEN
				task.Error.Code := fb.AssemblyPowerOn.ErrorID;
				em.Command.Abort := TRUE;
			END_IF
				
		200:
			em.StateInfo := 'Get all shuttles in the assembly';
			// ---------------------------------------------------------------------------------
			actions_state.getShuttles := TRUE;
						
			IF fb.AssemblyGetShuttle.Valid THEN
				IF fb.AssemblyGetShuttle.TotalCount > 0 THEN
					em.SubState := em.SubState + 1;						
				ELSE
					em.SubState := 210;
				END_IF;
			END_IF		
		201:
			em.StateInfo := 'Get all shuttles in the assembly';
			// ---------------------------------------------------------------------------------
			IF em.Info.OnSubStateEntry THEN
				// Clear old shuttle data
				brsmemset(ADR(gShuttles), 0, SIZEOF(gShuttles));
				local.lastReadShuttleID := 0;
			END_IF;
		
			IF fb.AssemblyGetShuttle.AdditionalInfo.ShuttleID = local.lastReadShuttleID THEN
				actions_substate.getNextShuttle := TRUE;
			ELSE 
				gShuttles.Shuttle[gShuttles.Count].ID := fb.AssemblyGetShuttle.AdditionalInfo.ShuttleID;
				gShuttles.Shuttle[gShuttles.Count].Ref := fb.AssemblyGetShuttle.Shuttle;
				
				local.lastReadShuttleID := fb.AssemblyGetShuttle.AdditionalInfo.ShuttleID;
				gShuttles.Count := gShuttles.Count + 1;
				actions_substate.getNextShuttle := FALSE;
			END_IF;
		
			// Check if we have found all shuttles or our shuttle list is already full
			IF gShuttles.Count > gMAX_INDEX_SHUTTLE OR fb.AssemblyGetShuttle.RemainingCount = 0 THEN
				em.SubState := 300;	
			END_IF;
		210:
			em.StateInfo := 'No shuttles found';
			// ---------------------------------------------------------------------------------
					
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
	
		1000:
			em.StateInfo := 'Done';
			// ---------------------------------------------------------------------------------
			em.Command.StateComplete := TRUE;
	END_CASE;	
END_ACTION
