
// PackML state machine. Split into different sections that handle 
// different logical sequences of PackML stadards' steps
// INFO: Add mode specific code into states by adding CASE structure
// 	CASE em.ModeID OF
//		MODE_PRODUCTION:
//			*CODE*;
//		MODE_MAINTENANCE:
//			*CODE*;
//		MODE_MANUAL: 
//			*CODE*;
//		END_CASE    
// -----------------------------------------------------------------

ACTION PackML_state_machine:
	// =================================================================================================================	
    // Global PackML events
    // =================================================================================================================
    
    	
    // =================================================================================================================	
    // Normal work sequence
    // =================================================================================================================
    CASE em.StateCurrent OF
        STATE_STOPPED:
            em.StateInfo := '';
			// -----------------------------------------------------------------
			em_command.StateComplete := TRUE;

		STATE_RESETTING:
			// -----------------------------------------------------------------
			state_resetting;
			
		STATE_IDLE:
			em.StateInfo := '';
			// -----------------------------------------------------------------
			em_command.StateComplete := TRUE;

		STATE_STARTING:
			em.StateInfo := '';
			// -----------------------------------------------------------------
			em_command.StateComplete := TRUE;

		STATE_EXECUTE:
			state_execute;
			
		STATE_COMPLETING:
			em.StateInfo := '';
			// -----------------------------------------------------------------
			em_command.StateComplete := TRUE;
          
		STATE_COMPLETED:
			em.StateInfo := '';
			// -----------------------------------------------------------------
			em_command.StateComplete := TRUE;

		STATE_STOPPING:
			em.StateInfo := 'Power off assembly';
			// ---------------------------------------------------------------------------------	
			actions_substate.assemblyPowerOff := TRUE;
					
			IF fb.AssemblyPowerOff.Done THEN
				em_command.StateComplete := TRUE;
			ELSIF fb.AssemblyPowerOff.Error THEN
				task.Error.Code := fb.AssemblyPowerOff.ErrorID;
				em_command.Abort := TRUE;
			END_IF

	END_CASE
        
          
	// =================================================================================================================	
	// Module activation sequence
	// =================================================================================================================
	CASE em.StateCurrent OF
		STATE_DEACTIVATING:
			em.StateInfo := '';
			// -----------------------------------------------------------------
			em_command.StateComplete := TRUE;
                
		STATE_DEACTIVATED:
			em.StateInfo := '';
			// -----------------------------------------------------------------
			em_command.StateComplete := TRUE;

		STATE_ACTIVATING:
			em.StateInfo := '';
			// -----------------------------------------------------------------
			em_command.StateComplete := TRUE;

	END_CASE    

          
	// =================================================================================================================	
	// Abort sequence
	// =================================================================================================================
	CASE em.StateCurrent OF
		STATE_ABORTING:
			em.StateInfo := 'Power off assembly';
			// ---------------------------------------------------------------------------------	
			actions_substate.assemblyPowerOff := TRUE;
					
			IF fb.AssemblyPowerOff.Done THEN
				em_command.StateComplete := TRUE;
			ELSIF fb.AssemblyPowerOff.Error THEN
				task.Error.Code := fb.AssemblyPowerOff.ErrorID;
				em_command.StateComplete := TRUE;
			END_IF
			
		STATE_ABORTED:
			em.StateInfo := 'Error stop';
			// -----------------------------------------------------------------
			em_command.StateComplete := TRUE;

		STATE_CLEARING:
			CASE em.SubState OF
				0:
					em.StateInfo := 'Resetting assembly errors';
					// -----------------------------------------------------------------
					actions_substate.assemblyReset := TRUE;
			
					IF fb.AssemblyReset.Done THEN
						em.SubState := 10;
					ELSIF fb.AssemblyReset.Error THEN
						task.Error.Code := fb.AssemblyReset.ErrorID;
					END_IF
				
				10:
					em.StateInfo := 'Waiting assembly to exit from ';
					// -----------------------------------------------------------------
					IF fb.AssemblyReadInfo.Valid AND fb.AssemblyReadInfo.AssemblyInfo.AssemblyState <> mcACP6D_ERRORSTOP THEN
						brsmemset(ADR(task.Error), 0, SIZEOF(task.Error));
						em_command.StateComplete := TRUE;
					END_IF
			END_CASE;	
	END_CASE    

    
	// =================================================================================================================	
	// Hold sequence
	// =================================================================================================================
	CASE em.StateCurrent OF
		STATE_HOLDING:
			em.StateInfo := '';
			// -----------------------------------------------------------------
			em_command.StateComplete := TRUE;
                
		STATE_HELD:
			em.StateInfo := '';
			// -----------------------------------------------------------------
			em_command.StateComplete := TRUE;

		STATE_UNHOLDING:
			em.StateInfo := '';
			// -----------------------------------------------------------------
			em_command.StateComplete := TRUE;
	END_CASE 


	// =================================================================================================================	       
	// Suspend sequence
	// =================================================================================================================
	CASE em.StateCurrent OF
		STATE_SUSPENDING:
			em.StateInfo := '';
			// -----------------------------------------------------------------
			em_command.StateComplete := TRUE;
                
		STATE_SUSPENDED:
			em.StateInfo := '';
			// -----------------------------------------------------------------
			em_command.StateComplete := TRUE;

        STATE_UNSUSPENDING:
            em.StateInfo := '';
            // -----------------------------------------------------------------
            em_command.StateComplete := TRUE;

    END_CASE

END_ACTION