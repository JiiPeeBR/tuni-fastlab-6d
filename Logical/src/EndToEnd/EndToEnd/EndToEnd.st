PROGRAM _INIT
	
    // Access the Task interface
	Task ACCESS ADR(gFastDemo);

	// Register module config interface for common setup/parametrization functionality
	//Fb.MpRecipeRegPar_settings(MpLink := ADR(gSystemSettings), Enable := TRUE , PVName := ADR('gFastDemo.settings'), Category := ADR('FastDemo'));

	// Shuttle parking positions
	// =================================================================================================================
	X := 0.060;
	Y := 0.060;
	FOR i := 0 TO gMAX_INDEX_SHUTTLE DO		
		Local.Target1[i].X := X;
		Local.Target1[i].Y := Y;
		
		X := X + 0.120;
		IF (i > 0) AND (i MOD 7) = 0 THEN
			X := 0.060;
			Y := Y + 0.120;
		END_IF;
	END_FOR;
	
	X := 0.060;
	Y := 4.740;
	FOR i := 0 TO gMAX_INDEX_SHUTTLE DO		
		Local.Target2[i].X := X;
		Local.Target2[i].Y := Y;
		
		X := X + 0.120;
		IF (i > 0) AND (i MOD 7) = 0 THEN
			X := 0.060;
			Y := Y - 0.120;
		END_IF;
	END_FOR;
	
	// PackML setup
	// =================================================================================================================
	Em.Setup.Name := 'End-To-End';
	Em.Setup.ParentName := 'Main';
	Em.Setup.ActivationCondition :=  ACTIVATE_BY_PV;
	
	// Program list definitions
	// =================================================================================================================
	gPrograms[PROGRAM_END_TO_END].Name := Em.Setup.Name;
	gPrograms[PROGRAM_END_TO_END].ShuttleCount := 16;
	
END_PROGRAM
	
PROGRAM _CYCLIC
	
	// Task activation
    // =================================================================================================================
	Em.Setup.Activate := (gMain.Output.SelectedProgram = Em.Setup.Name);
	
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
	Fb.R_TRIG_Abort(CLK := Em.Command.Abort);
	
	IF Fb.R_TRIG_Abort.Q THEN
		Task.Error.State := Em.StateCurrent;
		Task.Error.SubState := Em.SubState;
		Task.Error.Description := Em.StateInfo; 
	END_IF;
	
	// State change event
	Fb.rtStateComplete(CLK := Em.Command.StateComplete);
	
	IF Fb.rtStateComplete.Q THEN
		Em.StateInfo := '';
		brsmemset(ADR(StateCommands), 0, SIZEOF(StateCommands));
		
		// Record information which state caused abort
		IF Em.StateCurrent = STATE_ABORTING THEN
			Task.Error.State := Local.lastState;
			Task.Error.SubState := Local.lastSubState;
			Task.Error.Description := Local.lastStateInfo;
		END_IF;
	END_IF;
	
	// State changed event
	IF Em.StateCurrent <> Local.lastState THEN
		Local.lastState := Em.StateCurrent;
		brsmemset(ADR(SubStateCommands), 0, SIZEOF(SubStateCommands));
	END_IF;
	
	// Substate changed event
	IF Em.SubState <> Local.lastSubState THEN
		Local.lastSubState := Em.SubState;
		Em.StateInfo := '';
		brsmemset(ADR(SubStateCommands), 0, SIZEOF(SubStateCommands));
	END_IF;
	
	
	// PackML equipment module
	// =================================================================================================================
	Em();

	// Function calls
    // =================================================================================================================
	Fb.MoveInPlaneAsync.Assembly := ADR(gAssembly6D_Big);
	Fb.MoveInPlaneAsync.Execute := SubStateCommands.MoveInPlaneAsync;
	Fb.MoveInPlaneAsync();
	
	// Task outputs
	// =================================================================================================================
    
	
	// Task diagnostics
	// =================================================================================================================
//	gTasks.FastDemo.State := Em.StateCurrent;
//	gTasks.FastDemo.SubState := Em.SubState;
//	gTasks.FastDemo.Mode := Em.ModeID;
//	gTasks.FastDemo.StateComplete := Em.Command.StateComplete;
//	gTasks.FastDemo.StateInfo := Em.StateInfo;
//	gTasks.FastDemo.WaitingForTask := Em.Info.WaitingFor.Name;
//	gTasks.FastDemo.Error := Task.Error;

END_PROGRAM
	
PROGRAM _EXIT
	
END_PROGRAM