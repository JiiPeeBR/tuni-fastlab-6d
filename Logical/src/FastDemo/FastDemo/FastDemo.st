PROGRAM _INIT
	
    // Access the task interface
    task ACCESS ADR(gFastDemo);

    // Register module config interface for common setup/parametrization functionality
    //fb.MpRecipeRegPar_settings(MpLink := ADR(gSystemSettings), Enable := TRUE , PVName := ADR('gFastDemo.settings'), Category := ADR('FastDemo'));

    // Check for simulator
    //task.IsSimulated := DiagCpuIsSimulated();
  
    // PackML setup
    // =================================================================================================================
    em.Setup.Name := 'FastDemo';
	em.Setup.ParentName := 'Main';
	
END_PROGRAM
	
PROGRAM _CYCLIC
	
    // Access task interface
    // =================================================================================================================
    task ACCESS ADR(gFastDemo);


    // Inputs
    // =================================================================================================================
    IF NOT task.Input.Force THEN

    END_IF

	// Task state machine
	// =================================================================================================================
	// PackML state machine execution  
	PackML_state_machine;
      
	// Detect state change events
	// =================================================================================================================
	// State change event
	IF em.Info.OnStateEntry THEN
		brsmemset(ADR(actions_state), 0, SIZEOF(actions_state));
		
		// Record information which state caused abort
		IF em.StateCurrent = STATE_ABORTING THEN
			task.Error.State := local.lastState;
			task.Error.SubState := local.lastSubState;
			task.Error.Description := local.lastStateInfo;
		END_IF;
	END_IF;
	
	// Substate change event
	IF em.Info.OnSubStateEntry THEN
		// Reset actions always when state changes
		brsmemset(ADR(actions_substate), 0, SIZEOF(actions_substate));
	END_IF;
	
	local.lastState := em.StateCurrent;
	local.lastSubState := em.SubState;
	local.lastStateInfo := em.StateInfo;

	// PackML equipment module
	// =================================================================================================================
	em();

	// Function calls
    // =================================================================================================================
	fb.TrafficControl.Enable := TRUE;
	fb.TrafficControl.MpLink := ADR(TrafficManager_x6d_1); 
	fb.TrafficControl.ActivateRecipe := actions_substate.traffic_activate_recipe;
	fb.TrafficControl.DeactivateRecipe := actions_substate.traffic_deactivate_recipe;
	fb.TrafficControl.ErrorReset := actions_substate.error_reset;
	fb.TrafficControl.Halt := actions_substate.traffic_halt;
	fb.TrafficControl.Recover := actions_substate.traffic_recover;
	fb.TrafficControl.Resume := actions_substate.traffic_resume;
	fb.TrafficControl.Stop := actions_substate.traffic_stop;
	fb.TrafficControl();
	
	fb.TrafficMonitor.Enable := TRUE;
	fb.TrafficMonitor.MpLink := ADR(TrafficManager_x6d_1);
    fb.TrafficMonitor();
	
	// Task outputs
    // =================================================================================================================
    
	
	// Task diagnostics
	// =================================================================================================================
	gTasks.FastDemo.State := em.StateCurrent;
	gTasks.FastDemo.SubState := em.SubState;
	gTasks.FastDemo.Mode := em.ModeID;
	gTasks.FastDemo.StateComplete := em.Command.StateComplete;
	gTasks.FastDemo.StateInfo := em.StateInfo;
	gTasks.FastDemo.WaitingForTask := em.Info.WaitingFor.Name;

END_PROGRAM
	
PROGRAM _EXIT
	
END_PROGRAM