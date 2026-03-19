PROGRAM _INIT
	
	gCommInput;
	gCommOutput;
	
    // Access the task interface
	task ACCESS ADR(gMain);

	// Register module config interface for common setup/parametrization functionality
	//fb.MpRecipeRegPar_settings(MpLink := ADR(gSystemSettings), Enable := TRUE , PVName := ADR('gMain.settings'), Category := ADR('Main'));

	// Check for simulator
	//task.IsSimulated := DiagCpuIsSimulated();
  
	// Calculate home positions for shuttles
	FOR i := 0 TO gMAX_INDEX_SHUTTLE DO
		local.homePosition[i].x := 0.420 + DINT_TO_REAL(i MOD 2) * 0.120;
		local.homePosition[i].y := 0.540 + DINT_TO_REAL(i / 2) * 0.120;
	END_FOR;
	
	// PackML setup
	// =================================================================================================================
	em.Setup.Name := 'Main';
	em.Setup.ParentName := '';
		
END_PROGRAM
	
PROGRAM _CYCLIC
	
    // Access task interface
    // =================================================================================================================
	task ACCESS ADR(gMain);


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
		brsmemset(ADR(em_command), 0, SIZEOF(em_command));
	END_IF;
	
	local.lastState := em.StateCurrent;
	local.lastSubState := em.SubState;
	local.lastStateInfo := em.StateInfo;
		
	// PackML equipment module
	// =================================================================================================================
//	em.Command.Abort := em_command.Abort OR task.Input.Command.Abort;
//	em.Command.Clear := em_command.Clear OR task.Input.Command.Clear;
//	em.Command.Complete := em_command.Complete OR task.Input.Command.Complete;
//	em.Command.Hold := em_command.Hold OR task.Input.Command.Hold;
//	em.Command.Reset := em_command.Reset OR task.Input.Command.Reset;
//	em.Command.Start := em_command.Start OR task.Input.Command.Start;
//	em.Command.StateComplete := em_command.StateComplete;
//	em.Command.Stop := em_command.Stop OR task.Input.Command.Stop;
//	em.Command.Suspend := em_command.Suspend OR task.Input.Command.Suspend;
//	em.Command.Unhold := em_command.Unhold OR task.Input.Command.Unhold;
//	em.Command.Unsuspend := em_command.Unsuspend OR task.Input.Command.Unsuspend;
	em();
	
	// Function calls
	// =================================================================================================================
	fb.AssemblyReadInfo.Enable := TRUE;
	fb.AssemblyReadInfo.Assembly := ADR(gAssembly6D_1);
	fb.AssemblyReadInfo();
	
	fb.AssemblyPowerOn.Assembly := ADR(gAssembly6D_1);
	fb.AssemblyPowerOn.Execute := actions_substate.assemblyPowerOn;
	fb.AssemblyPowerOn();
	
	fb.AssemblyPowerOff.Assembly := ADR(gAssembly6D_1);
	fb.AssemblyPowerOff.Execute := actions_substate.assemblyPowerOff;
	fb.AssemblyPowerOff();

	fb.AssemblyReset.Assembly := ADR(gAssembly6D_1);
	fb.AssemblyReset.Execute := actions_substate.assemblyReset;
	fb.AssemblyReset();
	
	fb.AssemblyGetShuttle.Assembly := ADR(gAssembly6D_1);
	fb.AssemblyGetShuttle.Enable := actions_state.getShuttles;
	fb.AssemblyGetShuttle.Next := actions_substate.getNextShuttle;
	fb.AssemblyGetShuttle();
	
	fb.AssemblyReadShIDTable.Assembly := ADR(gAssembly6D_1);
	fb.AssemblyReadShIDTable.Execute := actions_substate.readShuttleIDs;
	fb.AssemblyReadShIDTable();
	
	fb.MoveInPlaneAsync.Assembly := ADR(gAssembly6D_1);
	fb.MoveInPlaneAsync.Execute := actions_substate.homeShuttles;
	fb.MoveInPlaneAsync();
	
	fb.ShuttleGetInfo.Execute := actions_substate.readShuttleInfo;
	fb.ShuttleGetInfo();

	// Task output
	// =================================================================================================================
	task.Output.Assembly := fb.AssemblyReadInfo.AssemblyInfo;
	
	// Task diagnostics
	// =================================================================================================================
	gTasks.Main.State := em.StateCurrent;
	gTasks.Main.SubState := em.SubState;
	gTasks.Main.Mode := em.ModeID;
	gTasks.Main.StateComplete := em.Info.WaitingFor.StateComplete;
	gTasks.Main.StateInfo := em.StateInfo;
	gTasks.Main.WaitingForTask := em.Info.WaitingFor.Name;
	
END_PROGRAM
	
PROGRAM _EXIT
	
END_PROGRAM