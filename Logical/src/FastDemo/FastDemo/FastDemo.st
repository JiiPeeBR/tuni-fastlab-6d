PROGRAM _INIT
	
    // Access the Task interface
    Task ACCESS ADR(gFastDemo);
  
    // PackML setup
    // =================================================================================================================
    em.Setup.Name := 'FastDemo';
	em.Setup.ParentName := 'Main';
	
END_PROGRAM
	
PROGRAM _CYCLIC
	
    // Access Task interface
    // =================================================================================================================
    Task ACCESS ADR(gFastDemo);

    // Inputs
    // =================================================================================================================
    IF NOT Task.Input.Force THEN

	END_IF
	
	// Task state machine
	// =================================================================================================================
	// PackML state machine execution  
	PackML_state_machine;
	
	// Detect state change events
	// =================================================================================================================
	// Record information which state caused abort
	Fb.R_TRIG_Abort(CLK := em.Command.Abort);
	
	IF Fb.R_TRIG_Abort.Q THEN
		Task.Error.State := em.StateCurrent;
		Task.Error.SubState := em.SubState;
		Task.Error.Description := em.StateInfo; 
	END_IF;
	
	// State change event
	Fb.rtStateComplete(CLK := em.Command.StateComplete);
	
	IF Fb.rtStateComplete.Q THEN
		em.StateInfo := '';
		brsmemset(ADR(StateCommands), 0, SIZEOF(StateCommands));
		
		// Record information which state caused abort
		IF em.StateCurrent = STATE_ABORTING THEN
			Task.Error.State := Local.lastState;
			Task.Error.SubState := Local.lastSubState;
			Task.Error.Description := Local.lastStateInfo;
		END_IF;
	END_IF;
		
	// Substate changed event
	IF em.SubState <> Local.lastSubState THEN
		em.StateInfo := '';
		brsmemset(ADR(SubStateCommands), 0, SIZEOF(SubStateCommands));
		Local.lastSubState := em.SubState;
	END_IF;
	
	
	// PackML equipment module
	// =================================================================================================================
	em();

	// Station configuration
	// -------------------------------------------------------------------------------------------------------------------
	stations[1].Station := ADR(S1);
	stations[2].Station := ADR(S2);
	stations[3].Station := ADR(S3);
	stations[4].Station := ADR(S4);
	stations[5].Station := ADR(S5);
	stations[6].Station := ADR(S6);
	
	// Function calls
	// =================================================================================================================
	Fb.TrafficControl.Enable := TRUE;
	Fb.TrafficControl.MpLink := ADR(TrafficManager_x6d_1); 
	Fb.TrafficControl.ActivateRecipe := SubStateCommands.traffic_activate_recipe;
	Fb.TrafficControl.DeactivateRecipe := SubStateCommands.traffic_deactivate_recipe;
	Fb.TrafficControl.ErrorReset := StateCommands.error_reset;
	Fb.TrafficControl.Halt := SubStateCommands.traffic_halt;
	Fb.TrafficControl.Recover := SubStateCommands.traffic_recover;
	Fb.TrafficControl.Resume := SubStateCommands.traffic_resume;
	Fb.TrafficControl.Stop := SubStateCommands.traffic_stop;
	Fb.TrafficControl();
	
	Fb.TON_RecoverTimeout.IN := Fb.TrafficControl.RecoverBuffered;
	Fb.TON_RecoverTimeout.PT := T#5s;
	Fb.TON_RecoverTimeout();
	
	Fb.TrafficMonitor.Enable := TRUE;
	Fb.TrafficMonitor.MpLink := ADR(TrafficManager_x6d_1);
	Fb.TrafficMonitor();
		
	// Station logic calls
	FOR station_num := 0 TO STATION_COUNT DO
		pStation ACCESS ADR(stations[station_num]);
		
		pStation.Enable := StateCommands.activate_stations;
		pStation.Parameters.StationNumber := station_num;
		pStation.Assembly := ADR(gAssembly6D_Big);
		pStation.TrafficManager := ADR(TrafficManager_x6d_1);
		pStation();
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
	gTasks.FastDemo.Error := Task.Error;

END_PROGRAM
	
PROGRAM _EXIT
	
END_PROGRAM