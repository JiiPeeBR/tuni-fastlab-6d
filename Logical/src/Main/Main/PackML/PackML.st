
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
            em.StateInfo := 'Assembly stopped';
			// -----------------------------------------------------------------
			em.Command.StateComplete := TRUE;

		STATE_RESETTING:
			em.StateInfo := 'Home all shuttles';
			// -----------------------------------------------------------------
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
				em.Command.StateComplete := TRUE;
			ELSIF fb.MoveInPlaneAsync.Error THEN
				task.Error.Code := fb.MoveInPlaneAsync.ErrorID;	
				em.Command.Abort := TRUE;
			END_IF;
			
		STATE_IDLE:
			em.StateInfo := '';
			// -----------------------------------------------------------------
			em.Command.StateComplete := TRUE;

		STATE_STARTING:
			em.StateInfo := '';
			// -----------------------------------------------------------------
			em.Command.StateComplete := TRUE;

		STATE_EXECUTE:
			// -----------------------------------------------------------------
			state_execute;
			
		STATE_COMPLETING:
			em.StateInfo := '';
			// -----------------------------------------------------------------
			em.Command.StateComplete := TRUE;
          
		STATE_COMPLETED:
			em.StateInfo := '';
			// -----------------------------------------------------------------
			em.Command.StateComplete := TRUE;

		STATE_STOPPING:
			em.StateInfo := 'Stop assembly';
			// ---------------------------------------------------------------------------------
			actions_substate.assemblyStop := TRUE;
			
			IF fb.AssemblyStop.Done THEN
				em.Command.StateComplete := TRUE;
			ELSIF fb.AssemblyStop.Error THEN
				task.Error.Code := fb.AssemblyPowerOff.ErrorID;
				em.Command.Abort := TRUE;
			END_IF
	END_CASE
        
          
	// =================================================================================================================	
	// Module activation sequence
	// =================================================================================================================
	CASE em.StateCurrent OF
		STATE_DEACTIVATING:
			em.StateInfo := '';
			// -----------------------------------------------------------------
			em.Command.StateComplete := TRUE;
                
		STATE_DEACTIVATED:
			em.StateInfo := '';
			// -----------------------------------------------------------------
			em.Command.StateComplete := TRUE;

		STATE_ACTIVATING:
			// -----------------------------------------------------------------
			sequence_initialize;
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
				em.Command.StateComplete := TRUE;
			ELSIF fb.AssemblyPowerOff.Error THEN
				task.Error.Code := fb.AssemblyPowerOff.ErrorID;
				em.Command.StateComplete := TRUE;
			END_IF
			
		STATE_ABORTED:
			em.StateInfo := 'Error stop';
			// -----------------------------------------------------------------
			em.Command.StateComplete := TRUE;

		STATE_CLEARING:
			// -----------------------------------------------------------------
			sequence_initialize;
	END_CASE    

    
	// =================================================================================================================	
	// Hold sequence
	// =================================================================================================================
	CASE em.StateCurrent OF
		STATE_HOLDING:
			em.StateInfo := '';
			// -----------------------------------------------------------------
			em.Command.StateComplete := TRUE;
                
		STATE_HELD:
			em.StateInfo := '';
			// -----------------------------------------------------------------
			em.Command.StateComplete := TRUE;

		STATE_UNHOLDING:
			em.StateInfo := '';
			// -----------------------------------------------------------------
			em.Command.StateComplete := TRUE;
	END_CASE 


	// =================================================================================================================	       
	// Suspend sequence
	// =================================================================================================================
	CASE em.StateCurrent OF
		STATE_SUSPENDING:
			em.StateInfo := '';
			// -----------------------------------------------------------------
			em.Command.StateComplete := TRUE;
                
		STATE_SUSPENDED:
			em.StateInfo := '';
			// -----------------------------------------------------------------
			em.Command.StateComplete := TRUE;

        STATE_UNSUSPENDING:
            em.StateInfo := '';
            // -----------------------------------------------------------------
            em.Command.StateComplete := TRUE;

    END_CASE

END_ACTION