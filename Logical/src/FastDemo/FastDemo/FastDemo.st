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
	fb.rtStateComplete(CLK := em.Command.StateComplete);
	
	IF fb.rtStateComplete.Q THEN
		brsmemset(ADR(actions_state), 0, SIZEOF(actions_state));
		
		// Record information which state caused abort
		IF em.StateCurrent = STATE_ABORTING THEN
			task.Error.State := local.lastState;
			task.Error.SubState := local.lastSubState;
			task.Error.Description := local.lastStateInfo;
		END_IF;
		
		FOR station_num := 0 TO STATION_COUNT DO
			// Reset station commands when major state changes
			stations[station_num].State := 0;
			brsmemset(ADR(stations[station_num].Var), 0, SIZEOF(stations[station_num].Var));
			brsmemset(ADR(stations[station_num].Commands), 0, SIZEOF(stations[station_num].Commands));
		END_FOR;
	END_IF;
		
	// Substate changed event
	IF em.SubState <> local.lastSubState THEN
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
	fb.TrafficControl.ErrorReset := actions_state.error_reset;
	fb.TrafficControl.Halt := actions_substate.traffic_halt;
	fb.TrafficControl.Recover := actions_substate.traffic_recover;
	fb.TrafficControl.Resume := actions_substate.traffic_resume;
	fb.TrafficControl.Stop := actions_substate.traffic_stop;
	fb.TrafficControl();
	
	fb.TrafficMonitor.Enable := TRUE;
	fb.TrafficMonitor.MpLink := ADR(TrafficManager_x6d_1);
	fb.TrafficMonitor();
	
	fb.MacroDelete.Assembly := ADR(gAssembly6D_Big);
	fb.MacroDelete.Execute := actions_substate.macro_delete;
	fb.MacroDelete.Command := mcACP6D_MACRO_DELETE_ALL;
	fb.MacroDelete();
	
	// Perform all common station operations
	FOR station_num := 0 TO STATION_COUNT DO
		str := DINT_TO_STRING(station_num);
		station ACCESS ADR(stations[station_num]);
		
		// Station control
		station.Control.MpLink := ADR(TrafficManager_x6d_1);
		station.Control.ErrorReset := actions_state.error_reset;
		station.Control.Release := station.Commands.Release;
		station.Control();
		
		// Movement 
		station.Operation.MoveInPlane.Execute := station.Commands.MoveInPlane;
		station.Operation.MoveInPlane();
		
		station.Operation.MoveArc.Execute := station.Commands.MoveArc;
		station.Operation.MoveArc();
		
		station.Operation.Spin.Execute := station.Commands.Spin;
		station.Operation.Spin();
		
		// Macro
		station.Macro.Name := CONCAT('S', str);
		
		station.Macro.MacroCreate.Assembly := ADR(gAssembly6D_Big);
		station.Macro.MacroCreate.Parameters.Name := station.Macro.Name;
		station.Macro.MacroCreate.Execute := station.Commands.MacroCreate;
		station.Macro.MacroCreate();
		
		station.Macro.MacroSave.Shuttle := ADR(station.Macro.Shuttle);
		station.Macro.MacroSave.Execute := station.Commands.MacroSave;
		station.Macro.MacroSave();
		
		station.Macro.MacroRun.Name := station.Macro.Name;
		station.Macro.MacroRun.Execute := station.Commands.MacroRun;
		station.Macro.MacroRun();
	END_FOR;
	
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