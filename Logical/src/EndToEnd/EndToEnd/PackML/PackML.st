
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
			Em.StateInfo := '';
			// -----------------------------------------------------------------
			Em.Command.StateComplete := TRUE;
			
		STATE_IDLE:
			Em.StateInfo := '';
			// -----------------------------------------------------------------
			Em.Command.StateComplete := TRUE;

		STATE_STARTING:
			Em.StateInfo := 'Traffic manager started';
			// -----------------------------------------------------------------
			Em.Command.StateComplete := TRUE;			
			
		STATE_EXECUTE:
			Em.StateInfo := 'Running feature demo';
			// -----------------------------------------------------------------
			CASE Em.SubState OF
				0:
					// -----------------------------------------------------------------
					IF Em.Info.OnSubStateEntry THEN	
						brsmemset(ADR(Fb.MoveInPlaneAsync.Parameters), 0, SIZEOF(Fb.MoveInPlaneAsync.Parameters));
					
						Fb.MoveInPlaneAsync.Parameters.Velocity := 1.8;
						Fb.MoveInPlaneAsync.Parameters.Acceleration := 15;
						Fb.MoveInPlaneAsync.Parameters.Mode := mcACP6D_SHUTTLE_UNSORTED;
							
						FOR i := 0 TO gShuttles.Count - 1 DO	
							Fb.MoveInPlaneAsync.Parameters.AsyncPar[i].Shuttle := ADR(gShuttles.Shuttle[i].Ref);
							Fb.MoveInPlaneAsync.Parameters.AsyncPar[i].X := Local.Target1[i].X;
							Fb.MoveInPlaneAsync.Parameters.AsyncPar[i].Y := Local.Target1[i].Y;
						END_FOR;
					END_IF;
					
					SubStateCommands.MoveInPlaneAsync := TRUE;
							
					IF Fb.MoveInPlaneAsync.Done THEN
						Em.SubState := 	Em.SubState := + 1;
					ELSIF Fb.MoveInPlaneAsync.Error THEN
						Task.Error.Code := Fb.MoveInPlaneAsync.ErrorID;	
						Em.Command.Abort := TRUE;
					END_IF;
				
				1:
					// -----------------------------------------------------------------
					IF Em.Info.OnSubStateEntry THEN	
						brsmemset(ADR(Fb.MoveInPlaneAsync.Parameters), 0, SIZEOF(Fb.MoveInPlaneAsync.Parameters));
					
						Fb.MoveInPlaneAsync.Parameters.Velocity := 1.8;
						Fb.MoveInPlaneAsync.Parameters.Acceleration := 15;
						Fb.MoveInPlaneAsync.Parameters.Mode := mcACP6D_SHUTTLE_UNSORTED;
							
						FOR i := 0 TO gShuttles.Count - 1 DO	
							Fb.MoveInPlaneAsync.Parameters.AsyncPar[i].Shuttle := ADR(gShuttles.Shuttle[i].Ref);
							Fb.MoveInPlaneAsync.Parameters.AsyncPar[i].X := Local.Target2[i].X;
							Fb.MoveInPlaneAsync.Parameters.AsyncPar[i].Y := Local.Target2[i].Y;
						END_FOR;
					END_IF;
					
					SubStateCommands.MoveInPlaneAsync := TRUE;
							
					IF Fb.MoveInPlaneAsync.Done THEN
						Em.SubState := 	0;
					ELSIF Fb.MoveInPlaneAsync.Error THEN
						Task.Error.Code := Fb.MoveInPlaneAsync.ErrorID;	
						Em.Command.Abort := TRUE;
					END_IF;
			END_CASE;
			
			Em.Command.StateComplete := TRUE;
			  
		STATE_COMPLETING:
			Em.StateInfo := '';
			// -----------------------------------------------------------------
			Em.Command.StateComplete := TRUE;
          
		STATE_COMPLETED:
			Em.StateInfo := '';
			// -----------------------------------------------------------------
			Em.Command.StateComplete := TRUE;

		STATE_STOPPING:
			Em.StateInfo := '';
			// -----------------------------------------------------------------
			Em.Command.StateComplete := TRUE;   
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