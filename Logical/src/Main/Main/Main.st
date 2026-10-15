PROGRAM _INIT
	
	gCommInput;
	gCommOutput;
	
	// Access the task interface
	task ACCESS ADR(gMain);

	// Shuttle parking positions
	// =================================================================================================================
	FOR i := 0 TO gMAX_INDEX_SHUTTLE DO
		local.HomePosition[i].X:= DINT_TO_REAL(420 + (i MOD 2) * 120) / 1000;
		local.HomePosition[i].Y := DINT_TO_REAL(540 + (i / 2) * 120) / 1000;
	END_FOR;
	
	X := 0.060;
	Y := 4.740;
	FOR i := 0 TO gMAX_INDEX_SHUTTLE DO		
		local.ServicePosition[i].X := X;
		local.ServicePosition[i].Y := Y;
		
		X := X + 0.120;
		IF (i > 0) AND (i MOD 7) = 0 THEN
			X := 0.060;
			Y := Y - 0.120;
		END_IF;
	END_FOR;
	
	// Program definitions
	// =================================================================================================================
	
	
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
	
	// Automatic cyclic reset of constantly evaluated states
	// =================================================================================================================
	// Button labels are reset every cycle so that by default all buttons are off. State logic sets them accordingly
	Buttons.Button1.Label := '';
	Buttons.Button2.Label := '';
	Buttons.Button3.Label := '';
	brsmemset(ADR(task.CommandAllowed), 0, SIZEOF(task.CommandAllowed));
	
	// Task state machine
	// =================================================================================================================
	// PackML state machine execution  
	PackML_state_machine;
    
	// Global error handling
	// =================================================================================================================
	fb.rShuttlesInAccident(CLK := (task.Output.Assembly.ShuttlesInAccidentCount > 0));

	IF fb.rShuttlesInAccident.Q THEN
		em.Command.Abort := TRUE;
		task.Error.Active := TRUE;
		task.Error.AdditionalInfo := 'Shuttle accident detected';
	END_IF;
	
	// Detect state change events
	// =================================================================================================================
	// Record information which state caused abort
	fb.rAbort(CLK := em.Command.Abort);
	fb.rError(CLK := task.Error.Active);
	
	IF fb.rAbort.Q OR fb.rError.Q THEN
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
		// Reset button
	END_IF;
	
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
	
	brsmemset(ADR(task.Input.Command), 0, SIZEOF(task.Input.Command));
	
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
	
	fb.WaitUntilAllDone.Execute := actions_substate.waitUntilAllDone;
	fb.WaitUntilAllDone();
	
	fb.AssemblyReadShIDTable.Assembly := ADR(gAssembly6D_Big);
	fb.AssemblyReadShIDTable.Execute := actions_substate.readShuttleIDs;
	fb.AssemblyReadShIDTable();
	
	fb.MoveInPlaneAsync.Assembly := ADR(gAssembly6D_Big);
	fb.MoveInPlaneAsync.Execute := actions_substate.homeShuttles;
	fb.MoveInPlaneAsync();
	
	fb.MoveShortAxis.Execute := actions_substate.moveShortAxis;
	fb.MoveShortAxis();
	
	fb.AssemblyGetShuttle.Assembly := ADR(gAssembly6D_Big);
	fb.AssemblyGetShuttle.Enable := actions_state.getShuttles;
	fb.AssemblyGetShuttle.Next := actions_substate.getNextShuttle;
	fb.AssemblyGetShuttle();
	
	// Alarm system
	// =================================================================================================================
	fb.MpAlarmXCore_0.Enable := TRUE;
	fb.MpAlarmXCore_0.MpLink := ADR(gAlarmXCore);
	fb.MpAlarmXCore_0();
	
	fb.AlarmPulse(Execute := fb.MpAlarmXCore_0.ActiveAlarms > 0, T_on := T#500ms, T_off := T#500ms);
	
	// Task output
	// =================================================================================================================
	task.Output.Assembly := fb.AssemblyReadInfo.AssemblyInfo;
	
	// Button logic
	// =================================================================================================================
	// Detect rising edges
	Buttons.Button1.rClick(CLK := Buttons.Button1.State);
	Buttons.Button2.rClick(CLK := Buttons.Button2.State);
	Buttons.Button3.rClick(CLK := Buttons.Button3.State);
	
	// Labels
	Buttons.Button1.Active := brsstrlen(ADR(Buttons.Button1.Label)) > 0;
	Buttons.Button2.Active := brsstrlen(ADR(Buttons.Button2.Label)) > 0;
	Buttons.Button3.Active := brsstrlen(ADR(Buttons.Button3.Label)) > 0;
	
	// Lamps
	Buttons.Button1.LampOn := Buttons.Button1.Active;
	Buttons.Button2.LampOn := Buttons.Button2.Active;
	Buttons.Button3.LampOn := Buttons.Button3.Active;
	
	// Hmi
	// =================================================================================================================
	Hmi.AlarmButtonStyle := SEL(fb.AlarmPulse.Q, 'AlarmOff', 'AlarmOn');
	
	// Fill the program selector list
	brsmemset(ADR(Hmi.ProgramSelectList), 0, SIZEOF(Hmi.ProgramSelectList));
	FOR i := 0 TO gMAX_INDEX_PROGRAMS DO
		IF brsstrlen(ADR(gPrograms[i].Name)) > 0 THEN
			Hmi.ProgramSelectList[i] := '{$'value$':$'0$',$'text$':$'#1$'}';
			str := CONCAT(gPrograms[i].Name, ' - Shuttle count: #2');
			str2 := UINT_TO_STRING(gPrograms[i].ShuttleCount);
			brdkStrReplace(ADR(Hmi.ProgramSelectList[i]), ADR('#1'), ADR(str));
			brdkStrReplace(ADR(Hmi.ProgramSelectList[i]), ADR('#2'), ADR(str2));
		END_IF;
	END_FOR;
	
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