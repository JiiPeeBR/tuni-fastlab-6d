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
	// Record information which state caused abort
	fb.R_TRIG_Abort(CLK := em.Command.Abort);
	
	IF fb.R_TRIG_Abort.Q THEN
		task.Error.State := em.StateCurrent;
		task.Error.SubState := em.SubState;
		task.Error.Description := em.StateInfo; 
	END_IF;
	
	// State change event
	fb.rtStateComplete(CLK := em.Command.StateComplete);
	
	IF fb.rtStateComplete.Q THEN
		em.StateInfo := '';
		brsmemset(ADR(actions_state), 0, SIZEOF(actions_state));
		
		// Record information which state caused abort
		IF em.StateCurrent = STATE_ABORTING THEN
			task.Error.State := local.lastState;
			task.Error.SubState := local.lastSubState;
			task.Error.Description := local.lastStateInfo;
		END_IF;
	END_IF;
		
	// Substate changed event
	IF em.SubState <> local.lastSubState THEN
		em.StateInfo := '';
		brsmemset(ADR(actions_substate), 0, SIZEOF(actions_substate));
		local.lastSubState := em.SubState;
	END_IF;
	
	
	// PackML equipment module
	// =================================================================================================================
	em();

	// Function calls
    // =================================================================================================================
	fb.TrafficControl.Enable := TRUE;
	fb.TrafficControl.MpLink := ADR(TrafficManager_x6d_1); 
	fb.TrafficControl.ActivateRecipe := actions_substate.traffic_activate_recipe;
	fb.TrafficControl.DeactivateRecipe := actions_substate.traffic_deactivate_recipe;
	fb.TrafficControl.ErrorReset := actions_state.error_reset;
	fb.TrafficControl.Halt := actions_substate.traffic_halt;
	fb.TrafficControl.Recover := actions_substate.traffic_recover;
	fb.TrafficControl.Resume := actions_substate.traffic_resume;
	fb.TrafficControl.Stop := actions_substate.traffic_stop;
	fb.TrafficControl();
	
	fb.TON_RecoverTimeout.IN := fb.TrafficControl.RecoverBuffered;
	fb.TON_RecoverTimeout.PT := T#5s;
	fb.TON_RecoverTimeout();
	
	fb.TrafficMonitor.Enable := TRUE;
	fb.TrafficMonitor.MpLink := ADR(TrafficManager_x6d_1);
	fb.TrafficMonitor();
	
	// Station logic calls
	FOR station_num := 0 TO STATION_COUNT DO
		station ACCESS ADR(stations[station_num]);
		
		station.Enable := actions_state.activate_stations;
		station.Parameters.StationNumber := station_num;
		station.Assembly := ADR(gAssembly6D_Big);
		station.TrafficManager := ADR(TrafficManager_x6d_1);
		station();
	END_FOR
		
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
	gTasks.FastDemo.Error := task.Error;

END_PROGRAM
	
PROGRAM _EXIT
	
END_PROGRAM