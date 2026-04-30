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
		local.homePosition[i].x := DINT_TO_REAL(420 + (i MOD 2) * 120) / 1000;
		local.homePosition[i].y := DINT_TO_REAL(540 + (i / 2) * 120) / 1000;
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
	END_IF;
		
	// Substate changed event
	IF em.SubState <> local.lastSubState THEN
		// Reset actions always when state changes
		em.StateInfo := '';
		brsmemset(ADR(actions_substate), 0, SIZEOF(actions_substate));
		local.lastSubState := em.SubState;
	END_IF;
	
	// Command rising edge detection
	// =================================================================================================================
	commands.Abort(CLK := (task.Input.Command.Abort OR gDI.Button3));
	commands.Clear(CLK := (task.Input.Command.Clear OR gDI.Button3));
	commands.Complete(CLK := task.Input.Command.Complete);
	commands.Hold(CLK := task.Input.Command.Hold);
	commands.Reset(CLK := (task.Input.Command.Reset OR gDI.Button1));
	commands.Start(CLK := (task.Input.Command.Start OR gDI.Button1));
	commands.Stop(CLK := (task.Input.Command.Stop OR gDI.Button2));
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
	
	fb.MoveShortAxis.Execute := actions_substate.moveShortAxis;
	fb.MoveShortAxis();
	
	fb.ShuttleGetInfo.Execute := actions_substate.readShuttleInfo;
	fb.ShuttleGetInfo();

	// Task output
	// =================================================================================================================
	task.Output.Assembly := fb.AssemblyReadInfo.AssemblyInfo;
	
	// IO
	// =================================================================================================================
	gDO.Button1_Led := FALSE;
	gDO.Button2_Led := FALSE;
	gDO.Button3_Led := FALSE;
	
	CASE em.StateCurrent OF
		STATE_ACTIVATING:
//			gDO.Button1_Led := fb.LampSequence.Lamp1;
//			gDO.Button2_Led := fb.LampSequence.Lamp2;
			//			gDO.Button3_Led := fb.LampSequence.Lamp3;
			gDO.Button1_Led := TRUE;
			gDO.Button2_Led := TRUE;
			gDO.Button3_Led := TRUE;
			
		STATE_EXECUTE:
			gDO.Button1_Led := TRUE;
		STATE_IDLE:
			gDO.Button1_Led := fb.Pulse_slow.Q;
		STATE_STARTING, STATE_RESETTING:
			gDO.Button1_Led := TRUE;
			
		STATE_STOPPING:
			gDO.Button2_Led := TRUE;
		STATE_STOPPED:
			gDO.Button1_Led := fb.Pulse_slow.Q;
			gDO.Button2_Led := TRUE;
		
		STATE_ABORTING:
			gDO.Button3_Led := TRUE;
		STATE_ABORTED:
			gDO.Button3_Led := fb.Pulse_slow.Q;
		STATE_CLEARING:
			gDO.Button3_Led := TRUE;	
	END_CASE;
	
	fb.Pulse_slow.T_on := T#500ms;
	fb.Pulse_slow.T_off := T#500ms;
	fb.Pulse_slow(Execute := TRUE);
	
	fb.LampSequence(Execute := TRUE);

	// Task diagnostics
	// =================================================================================================================
	gTasks.Main.State := em.StateCurrent;
	gTasks.Main.SubState := em.SubState;
	gTasks.Main.Mode := em.ModeID;
	gTasks.Main.StateComplete := em.Command.StateComplete;
	gTasks.Main.StateInfo := em.StateInfo;
	gTasks.Main.WaitingForTask := em.Info.WaitingFor.Name;
	gTasks.Main.Error := task.Error;
	
END_PROGRAM
	
PROGRAM _EXIT
	
END_PROGRAM