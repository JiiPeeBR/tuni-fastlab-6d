
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
			CASE em.SubState OF
				0:
					em.StateInfo := 'Wait submodules to finish their resets';
					// -----------------------------------------------------------------
					IF gTasks.FastDemo.State = STATE_IDLE THEN
						em.SubState := 10;
					END_IF;
				10:
					em.StateInfo := 'Home all shuttles';
					// -----------------------------------------------------------------
					IF em.Info.OnSubStateEntry THEN	
						brsmemset(ADR(fb.MoveInPlaneAsync.Parameters), 0, SIZEOF(fb.MoveInPlaneAsync.Parameters));
					
						fb.MoveInPlaneAsync.Parameters.Velocity := 1.8;
						fb.MoveInPlaneAsync.Parameters.Acceleration := 15;
						fb.MoveInPlaneAsync.Parameters.Mode := mcACP6D_SHUTTLE_SORTED;
						fb.MoveInPlaneAsync.Parameters.Overhang := FALSE;
						fb.MoveInPlaneAsync.Parameters.MoveOnlySelectedShuttles := FALSE;
							
						FOR i := 0 TO gShuttles.Count - 1 DO	
							fb.MoveInPlaneAsync.Parameters.AsyncPar[i].Shuttle := ADR(gShuttles.Shuttle[i].Ref);
							fb.MoveInPlaneAsync.Parameters.AsyncPar[i].X := local.homePosition[i].x;
							fb.MoveInPlaneAsync.Parameters.AsyncPar[i].Y := local.homePosition[i].y;
						END_FOR;
					END_IF;
							
					actions_substate.homeShuttles := TRUE;
							
					IF fb.MoveInPlaneAsync.Done THEN
				 		em.SubState := 20;
					ELSIF fb.MoveInPlaneAsync.Error THEN
						task.Error.Code := fb.MoveInPlaneAsync.ErrorID;	
						em.Command.Abort := TRUE;
					END_IF;
				20:
					em.StateInfo := 'Reset short axis orientation of all shuttles';
					// -----------------------------------------------------------------
					IF em.Info.OnSubStateEntry THEN
						fb.MoveShortAxis.Parameters.Mode :=  mcACP6D_MOVE_ABSOLUTE;
						fb.MoveShortAxis.Parameters.Velocity.Rx := 0.1;
						fb.MoveShortAxis.Parameters.Velocity.Ry := 0.1;
						fb.MoveShortAxis.Parameters.Velocity.Rz := 0.1;
						fb.MoveShortAxis.Parameters.Velocity.Z := 0.01;
						fb.MoveShortAxis.Parameters.Position.Rx := 0;
						fb.MoveShortAxis.Parameters.Position.Ry := 0;
						fb.MoveShortAxis.Parameters.Position.Rz := 0;
						fb.MoveShortAxis.Parameters.Position.Z := gDEFAULT_Z;
						
						local.shuttleIndex := 0;
					END_IF;
					
					fb.MoveShortAxis.Shuttle := ADR(gShuttles.Shuttle[local.shuttleIndex].Ref);
					actions_substate.moveShortAxis := TRUE;
					
					IF fb.MoveShortAxis.Acknowledge THEN
						IF local.shuttleIndex < (gShuttles.Count - 1) THEN
							local.shuttleIndex := local.shuttleIndex + 1;
							actions_substate.moveShortAxis := FALSE;
						ELSE
							em.SubState := em.SubState + 1;		
						END_IF;	
					END_IF;	
				21:
					em.StateInfo := 'Reset short axis orientation of all shuttles';
					// -----------------------------------------------------------------
					IF em.Info.OnSubStateEntry THEN
						local.shuttleIndex := 0;
					END_IF;
					
					fb.ShuttleGetInfo.Shuttle := ADR(gShuttles.Shuttle[local.shuttleIndex].Ref);
					actions_substate.readShuttleInfo := TRUE;
					
					IF fb.ShuttleGetInfo.Done THEN
						// Wait until all shuttles have completed their moves before proceeding
						IF fb.ShuttleGetInfo.ShuttleInfo.State = mcACP6D_SH_STATE_IDLING THEN
							local.shuttleIndex := local.shuttleIndex + 1;
						END_IF;
						actions_substate.readShuttleInfo := FALSE;
					END_IF;
					
					IF local.shuttleIndex >= gShuttles.Count THEN
						// All shuttles read and all are idle
						em.SubState := 100;
					END_IF;
				100:
					em.StateInfo := 'Done';
					// -----------------------------------------------------------------
					em.Command.StateComplete := TRUE;
			END_CASE;
	
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
			em.StateInfo := 'Assembly powered off';
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