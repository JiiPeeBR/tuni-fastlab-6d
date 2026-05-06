
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
            em.Command.StateComplete := TRUE;

        STATE_RESETTING:
			CASE em.SubState OF
				0:
					em.StateInfo := 'Reset traffic control errors';
					// -----------------------------------------------------------------
					actions_state.error_reset := TRUE;
					IF NOT fb.TrafficControl.Error THEN
	  					em.SubState := 10;
					END_IF;
				10:
					em.StateInfo := 'Wait until all stations are deactivated';
					// -----------------------------------------------------------------
					local.allStationsDeactivated := TRUE;
					
					FOR station_num := 0 TO STATION_COUNT DO
						station ACCESS ADR(stations[station_num]);
						
						IF station.Active THEN
							local.allStationsDeactivated := FALSE;
							EXIT;
						END_IF;	
					END_FOR;
					
					IF local.allStationsDeactivated THEN
	  					em.SubState := 100;
					END_IF;
					
				100:
					em.StateInfo := 'Reset complete';
					// -----------------------------------------------------------------	
					em.Command.StateComplete := TRUE;
			END_CASE;
			
		STATE_IDLE:
			em.StateInfo := '';
			// -----------------------------------------------------------------
			em.Command.StateComplete := TRUE;

		STATE_STARTING:
			CASE em.SubState OF
				0:
					em.StateInfo := 'Move shuttles to recovery points';
					// -----------------------------------------------------------------
					fb.TrafficControl.Velocity := 1.8;
					fb.TrafficControl.Acceleration := 8.0; 
					actions_substate.traffic_recover := TRUE;
					
					IF fb.TrafficControl.RecoverDone OR fb.TON_RecoverTimeout.Q THEN
						em.SubState := 10;
					END_IF;		
				10:
					em.StateInfo := 'Activating traffic recipe';
					// -----------------------------------------------------------------
					actions_substate.traffic_activate_recipe := TRUE;
					
					IF fb.TrafficControl.ActivateRecipeDone THEN
						em.SubState := 100;
					END_IF;
				100:
					em.StateInfo := 'Traffic manager started';
					// -----------------------------------------------------------------
					IF fb.TrafficControl.Error THEN
	  					em.SubState := 200;
					ELSE
						em.Command.StateComplete := TRUE;			
					END_IF;
			END_CASE;
			
        STATE_EXECUTE:
            em.StateInfo := 'Running feature demo';
            // -----------------------------------------------------------------
			em.Command.StateComplete := TRUE;
			
			actions_state.activate_stations := TRUE;
			
			execute_station_S1;
			execute_station_S2;
			execute_station_S3;
			execute_station_S4;
			execute_station_S5;
			execute_station_S6;
			//execute_station_S7;
          
        STATE_COMPLETING:
            em.StateInfo := '';
            // -----------------------------------------------------------------
            em.Command.StateComplete := TRUE;
          
        STATE_COMPLETED:
            em.StateInfo := '';
            // -----------------------------------------------------------------
            em.Command.StateComplete := TRUE;

        STATE_STOPPING:
            em.StateInfo := 'Stop traffic manager';
			// -----------------------------------------------------------------
			actions_substate.traffic_stop := TRUE;
			IF fb.TrafficControl.StopDone THEN
	  			em.Command.StateComplete := TRUE;   
			END_IF;
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
            em.StateInfo := '';
            // -----------------------------------------------------------------
            em.Command.StateComplete := TRUE;

    END_CASE    

          
    // =================================================================================================================	
    // Abort sequence
    // =================================================================================================================
    CASE em.StateCurrent OF
        STATE_ABORTING:
            em.StateInfo := '';
            // -----------------------------------------------------------------
            em.Command.StateComplete := TRUE;
                
        STATE_ABORTED:
            em.StateInfo := '';
            // -----------------------------------------------------------------
            em.Command.StateComplete := TRUE;

        STATE_CLEARING:
            em.StateInfo := '';
            // -----------------------------------------------------------------
            em.Command.StateComplete := TRUE;
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