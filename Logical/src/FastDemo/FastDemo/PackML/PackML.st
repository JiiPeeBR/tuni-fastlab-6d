
// PackML state machine. Split into different sections that handle 
// different logical sequences of PackML stadards' steps
// INFO: Add mode specific code into states by adding CASE structure
// 	CASE Em.ModeID OF
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
    CASE Em.StateCurrent OF
        STATE_STOPPED:
            Em.StateInfo := '';
            // -----------------------------------------------------------------
            Em.Command.StateComplete := TRUE;

        STATE_RESETTING:
			CASE Em.SubState OF
				0:
					Em.StateInfo := 'Reset traffic control errors';
					// -----------------------------------------------------------------
					StateCommands.ErrorReset := TRUE;
					IF NOT Fb.TrafficControl.Error THEN
	  					Em.SubState := 10;
					END_IF;
				10:
					Em.StateInfo := 'Delete all macros';
					// -----------------------------------------------------------------
					SubStateCommands.MacroDelete := TRUE;
					IF Fb.MacroDelete.Done THEN
						FOR StationNumber := 0 TO STATION_COUNT DO
							brsmemset(ADR(Stations[StationNumber].Macro.Shuttle), 0, SIZEOF(Stations[StationNumber].Macro.Shuttle));
						END_FOR;
						Em.SubState := 20;
					END_IF;
				20:
					Em.StateInfo := 'Delete all groups';
					// -----------------------------------------------------------------
					StateCommands.GroupGetEnable := TRUE;
					
					IF Fb.GroupGet.Valid THEN
						IF Fb.GroupGet.TotalCount = 0 THEN
							// Clear all shuttle group references
							FOR StationNumber := 0 TO STATION_COUNT DO
	  							brsmemset(ADR(Stations[StationNumber].Group.ShuttleGroup), 0, SIZEOF(Stations[StationNumber].Group.ShuttleGroup));
							END_FOR;
	  						Em.SubState := 100;
						ELSE
							Fb.GroupDelete.ShuttleGroup := ADR(Fb.GroupGet.ShuttleGroup);
							SubStateCommands.GroupDelete := TRUE;
							IF Fb.GroupDelete.Done THEN
								// Get next group in the assembly
								Fb.GroupGet(Next := TRUE);
								Fb.GroupGet(Next := FALSE);
								SubStateCommands.GroupDelete := FALSE;
							END_IF;
						END_IF;
					END_IF;		
				100:
					Em.StateInfo := 'Reset complete';
					// -----------------------------------------------------------------	
					Em.Command.StateComplete := TRUE;
			END_CASE;
			
		STATE_IDLE:
			Em.StateInfo := '';
			// -----------------------------------------------------------------
			Em.Command.StateComplete := TRUE;

		STATE_STARTING:
			CASE Em.SubState OF
				0:
					Em.StateInfo := 'Move shuttles to recovery points';
					// -----------------------------------------------------------------
					Fb.TrafficControl.Velocity := 1.8;
					Fb.TrafficControl.Acceleration := 8.0; 
					SubStateCommands.TrafficRecover := TRUE;
					
					IF Fb.TrafficControl.RecoverDone OR Fb.TON_RecoverTimeout.Q THEN
						Em.SubState := 10;
					END_IF;		
				10:
					Em.StateInfo := 'Activating traffic recipe';
					// -----------------------------------------------------------------
					SubStateCommands.TrafficActivateRecipe := TRUE;
					
					IF Fb.TrafficControl.ActivateRecipeDone THEN
						Em.SubState := 100;
					END_IF;
				100:
					Em.StateInfo := 'Traffic manager started';
					// -----------------------------------------------------------------
					IF Fb.TrafficControl.Error THEN
	  					Em.SubState := 200;
					ELSE
						Em.Command.StateComplete := TRUE;			
					END_IF;
			END_CASE;
			
        STATE_EXECUTE:
            Em.StateInfo := 'Running feature demo';
            // -----------------------------------------------------------------
			Em.Command.StateComplete := TRUE;
			
			StateCommands.ActivateQueueControl := TRUE;
			
			Station_Sequence_S1;
			Station_Sequence_S2;
			Station_Sequence_S3;
			Station_Sequence_S4;
			Station_Sequence_S5;
			Station_Sequence_S6;
			//Station_Sequence_S7;
          
        STATE_COMPLETING:
            Em.StateInfo := '';
            // -----------------------------------------------------------------
            Em.Command.StateComplete := TRUE;
          
        STATE_COMPLETED:
            Em.StateInfo := '';
            // -----------------------------------------------------------------
            Em.Command.StateComplete := TRUE;

        STATE_STOPPING:
            Em.StateInfo := 'Stop traffic manager';
			// -----------------------------------------------------------------
			SubStateCommands.TrafficStop := TRUE;
			IF Fb.TrafficControl.StopDone THEN
	  			Em.Command.StateComplete := TRUE;   
			END_IF;
	END_CASE
        
          
    // =================================================================================================================	
    // Module activation sequence
    // =================================================================================================================
    CASE Em.StateCurrent OF
        STATE_DEACTIVATING:
            Em.StateInfo := '';
            // -----------------------------------------------------------------
            Em.Command.StateComplete := TRUE;
                
        STATE_DEACTIVATED:
            Em.StateInfo := '';
            // -----------------------------------------------------------------
            Em.Command.StateComplete := TRUE;

        STATE_ACTIVATING:
            Em.StateInfo := '';
            // -----------------------------------------------------------------
            Em.Command.StateComplete := TRUE;

    END_CASE    

          
    // =================================================================================================================	
    // Abort sequence
    // =================================================================================================================
    CASE Em.StateCurrent OF
        STATE_ABORTING:
            Em.StateInfo := '';
            // -----------------------------------------------------------------
            Em.Command.StateComplete := TRUE;
                
        STATE_ABORTED:
            Em.StateInfo := '';
            // -----------------------------------------------------------------
            Em.Command.StateComplete := TRUE;

        STATE_CLEARING:
            Em.StateInfo := '';
            // -----------------------------------------------------------------
            Em.Command.StateComplete := TRUE;
    END_CASE    

    
    // =================================================================================================================	
    // Hold sequence
    // =================================================================================================================
    CASE Em.StateCurrent OF
        STATE_HOLDING:
            Em.StateInfo := '';
            // -----------------------------------------------------------------
            Em.Command.StateComplete := TRUE;
                
        STATE_HELD:
            Em.StateInfo := '';
            // -----------------------------------------------------------------
            Em.Command.StateComplete := TRUE;

        STATE_UNHOLDING:
            Em.StateInfo := '';
            // -----------------------------------------------------------------
            Em.Command.StateComplete := TRUE;
    END_CASE 


    // =================================================================================================================	       
    // Suspend sequence
    // =================================================================================================================
    CASE Em.StateCurrent OF
        STATE_SUSPENDING:
            Em.StateInfo := '';
            // -----------------------------------------------------------------
            Em.Command.StateComplete := TRUE;
                
        STATE_SUSPENDED:
            Em.StateInfo := '';
            // -----------------------------------------------------------------
            Em.Command.StateComplete := TRUE;

        STATE_UNSUSPENDING:
            Em.StateInfo := '';
            // -----------------------------------------------------------------
            Em.Command.StateComplete := TRUE;

    END_CASE

END_ACTION