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
	END_IF;
	
	local.lastState := em.StateCurrent;
	local.lastSubState := em.SubState;
	local.lastStateInfo := em.StateInfo;
	
	// Command rising edge detection
	// =================================================================================================================
	commands.Abort(CLK := task.Input.Command.Abort);
	commands.Clear(CLK := task.Input.Command.Clear);
	commands.Complete(CLK := task.Input.Command.Complete);
	commands.Hold(CLK := task.Input.Command.Hold);
	commands.Reset(CLK := task.Input.Command.Reset);
	commands.Start(CLK := task.Input.Command.Start);
	commands.Stop(CLK := task.Input.Command.Stop);
	commands.Suspend(CLK := task.Input.Command.Suspend);
	commands.Unhold(CLK := task.Input.Command.Unhold);
	commands.Unsuspend(CLK := task.Input.Command.Unsuspend);
	
	IF commands.Abort.Q THEN em.Command.Abort := TRUE; END_IF;
	IF commands.Clear.Q THEN em.Command.Clear := TRUE; END_IF;
	IF commands.Complete.Q THEN em.Command.Complete := TRUE; END_IF;
	IF commands.Hold.Q THEN em.Command.Hold := TRUE; END_IF;
	IF commands.Reset.Q THEN em.Command.Reset := TRUE; END_IF;
	IF commands.Start.Q THEN em.Command.Start := TRUE; END_IF;
	IF commands.Stop.Q THEN em.Command.Stop := TRUE; END_IF;
	IF commands.Suspend.Q THEN em.Command.Suspend := TRUE; END_IF;
	IF commands.Unhold.Q THEN em.Command.Unhold := TRUE; END_IF;
	IF commands.Unsuspend.Q THEN em.Command.Unsuspend := TRUE; END_IF;
	
	// PackML equipment module
	// =================================================================================================================
	em();
	
	// Function calls
	// =================================================================================================================
	fb.AssemblyReadInfo.Assembly := ADR(gAssembly6D_Big);
	fb.AssemblyReadInfo();
	
	fb.AssemblyPowerOn.Assembly := ADR(gAssembly6D_Big);
	fb.AssemblyPowerOn.Execute := actions_substate.assemblyPowerOn;
	fb.AssemblyPowerOn();
	
	fb.AssemblyPowerOff.Assembly := ADR(gAssembly6D_Big);
	fb.AssemblyPowerOff.Execute := actions_substate.assemblyPowerOff;
	fb.AssemblyPowerOff();

	fb.AssemblyReset.Assembly := ADR(gAssembly6D_Big);
	fb.AssemblyReset.Execute := actions_substate.assemblyReset;
	fb.AssemblyReset();
	
	fb.AssemblyStop.Assembly := ADR(gAssembly6D_Big);
	fb.AssemblyStop.Execute := actions_substate.assemblyStop;
	fb.AssemblyStop();
	
	fb.AssemblyGetShuttle.Assembly := ADR(gAssembly6D_Big);
	fb.AssemblyGetShuttle.Enable := actions_state.getShuttles;
	fb.AssemblyGetShuttle.Next := actions_substate.getNextShuttle;
	fb.AssemblyGetShuttle();
	
	fb.AssemblyReadShIDTable.Assembly := ADR(gAssembly6D_Big);
	fb.AssemblyReadShIDTable.Execute := actions_substate.readShuttleIDs;
	fb.AssemblyReadShIDTable();
	
	fb.MoveInPlaneAsync.Assembly := ADR(gAssembly6D_Big);
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
	gTasks.Main.StateComplete := em.Command.StateComplete;
	gTasks.Main.StateInfo := em.StateInfo;
	gTasks.Main.WaitingForTask := em.Info.WaitingFor.Name;
	
END_PROGRAM
	
PROGRAM _EXIT
	
END_PROGRAM