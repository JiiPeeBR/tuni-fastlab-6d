PROGRAM _INIT
	
    // Access the Task interface
	Task ACCESS ADR(gFastDemo);

	// Register module config interface for common setup/parametrization functionality
	//Fb.MpRecipeRegPar_settings(MpLink := ADR(gSystemSettings), Enable := TRUE , PVName := ADR('gFastDemo.settings'), Category := ADR('FastDemo'));

	// Check for simulator
	//Task.IsSimulated := DiagCpuIsSimulated();
  	
	// PackML setup
	// =================================================================================================================
	Em.Setup.Name := 'FastDemo';
	Em.Setup.ParentName := 'Main';
	Em.Setup.ActivationCondition :=  ACTIVATE_BY_PV;
	
	// Program list definitions
	// =================================================================================================================
	gPrograms[PROGRAM_FASTDEMO].Name := Em.Setup.Name;
	gPrograms[PROGRAM_FASTDEMO].ShuttleCount := 12;
	
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
		brsmemset(ADR(SubStateCommands), 0, SIZEOF(SubStateCommands));
		
		// Record information which state caused abort
		IF Em.StateCurrent = STATE_ABORTING THEN
			Task.Error.State := Local.lastState;
			Task.Error.SubState := Local.lastSubState;
			Task.Error.Description := Local.lastStateInfo;
		END_IF;
		
		FOR StationNumber := 0 TO STATION_COUNT DO
			// Reset station commands when major state changes
			Stations[StationNumber].State := 0;
			brsmemset(ADR(Stations[StationNumber].Var), 0, SIZEOF(Stations[StationNumber].Var));
			brsmemset(ADR(Stations[StationNumber].Commands), 0, SIZEOF(Stations[StationNumber].Commands));
			Stations[StationNumber].Macro.Execute := FALSE;
		END_FOR;
	END_IF;
		
	// Substate changed event
	IF Em.SubState <> Local.lastSubState THEN
		Em.StateInfo := '';
		brsmemset(ADR(SubStateCommands), 0, SIZEOF(SubStateCommands));
		Local.lastSubState := Em.SubState;
	END_IF;
	
	
	// PackML equipment module
	// =================================================================================================================
	Em();

	// Function calls
    // =================================================================================================================
	Fb.TrafficControl.Enable := TRUE;
	Fb.TrafficControl.MpLink := ADR(TrafficManager_x6d_1); 
	Fb.TrafficControl.ActivateRecipe := SubStateCommands.TrafficActivateRecipe;
	Fb.TrafficControl.DeactivateRecipe := SubStateCommands.TrafficDeactivateRecipe;
	Fb.TrafficControl.ErrorReset := StateCommands.ErrorReset;
	Fb.TrafficControl.Halt := SubStateCommands.TrafficHalt;
	Fb.TrafficControl.Recover := SubStateCommands.TrafficRecover;
	Fb.TrafficControl.Resume := SubStateCommands.TrafficResume;
	Fb.TrafficControl.Stop := SubStateCommands.TrafficStop;
	Fb.TrafficControl();
	
	Fb.TON_RecoverTimeout.IN := Fb.TrafficControl.RecoverBuffered;
	Fb.TON_RecoverTimeout.PT := T#5s;
	Fb.TON_RecoverTimeout();
	
	Fb.TrafficMonitor.Enable := TRUE;
	Fb.TrafficMonitor.MpLink := ADR(TrafficManager_x6d_1);
	Fb.TrafficMonitor();
	
	Fb.MacroDelete.Assembly := ADR(gAssembly6D_Big);
	Fb.MacroDelete.Execute := SubStateCommands.MacroDelete;
	Fb.MacroDelete.Command := mcACP6D_MACRO_DELETE_ALL;
	Fb.MacroDelete();
	
	Fb.GroupGet.Assembly := ADR(gAssembly6D_Big);
	Fb.GroupGet.Enable := StateCommands.GroupGetEnable;
	Fb.GroupGet();
	
	Fb.GroupDelete.Execute := SubStateCommands.GroupDelete;
	Fb.GroupDelete();
	
	// Perform all common station operations
	FOR StationNumber := 0 TO STATION_COUNT DO
		pStation ACCESS ADR(Stations[StationNumber]);
		
		// Station control
		pStation.Control.MpLink := ADR(TrafficManager_x6d_1);
		pStation.Control.ErrorReset := StateCommands.ErrorReset;
		pStation.Control.Release := pStation.Operation.StationQueueControl.ReleaseShuttle;
		pStation.Control.SelectNextShuttle := pStation.Operation.StationQueueControl.SelectNextShuttle;
		pStation.Control();
		
		pStation.Operation.StationQueueControl.Enable := StateCommands.ActivateQueueControl;
		pStation.Operation.StationQueueControl.ReleaseShuttles := pStation.Commands.Release;
		pStation.Operation.StationQueueControl.Station_SelectedShuttle := pStation.Control.SelectedShuttle;
		pStation.Operation.StationQueueControl.Station_Info := pStation.Control.Info;
		pStation.Operation.StationQueueControl.Station_ReleaseDone := pStation.Control.ReleaseDone;
		pStation.Operation.StationQueueControl.Station_ReleaseAborted := pStation.Control.ReleaseAborted;
		pStation.Operation.StationQueueControl();
		
		// Movement 
		pStation.Operation.MoveInPlane.Execute := pStation.Commands.MoveInPlane;
		pStation.Operation.MoveInPlane();
		
		pStation.Operation.MoveArc.Execute := pStation.Commands.MoveArc;
		pStation.Operation.MoveArc();
		
		pStation.Operation.Move6D.Execute := pStation.Commands.Move6D;
		pStation.Operation.Move6D();
		
		pStation.Operation.MoveShortAxis.Execute := pStation.Commands.MoveShortAxis;
		pStation.Operation.MoveShortAxis();
		
		pStation.Operation.Spin.Execute := pStation.Commands.Spin;
		pStation.Operation.Spin();
		
		pStation.Operation.TiltAround.Execute := pStation.Commands.TiltAround;
		pStation.Operation.TiltAround();
		
		pStation.Operation.SunPlanet.Execute := pStation.Commands.ChangePlanet;
		pStation.Operation.SunPlanet();
		
		pStation.Operation.GetShuttleInfo.Execute := pStation.Commands.GetShuttleInfo;
		pStation.Operation.GetShuttleInfo();
		
		// Macro		
		pStation.Macro.MacroCreate.Assembly := ADR(gAssembly6D_Big);
		pStation.Macro.MacroCreate.Parameters.Name := pStation.Macro.Name;
		pStation.Macro.MacroCreate.Execute := pStation.Commands.Macro.Create;
		pStation.Macro.MacroCreate();
		
		pStation.Macro.MacroSave.Shuttle := ADR(pStation.Macro.Shuttle);
		pStation.Macro.MacroSave.Execute := pStation.Commands.Macro.Save;
		pStation.Macro.MacroSave();
		
		pStation.Macro.MacroRun.Name := pStation.Macro.Name;
		pStation.Macro.MacroRun.Execute := pStation.Macro.Execute;
		pStation.Macro.MacroRun();
		
		// Group
		pStation.Group.GroupCreate.Execute := pStation.Commands.Group.Create;
		pStation.Group.GroupCreate.Assembly := ADR(gAssembly6D_Big);
		pStation.Group.GroupCreate();
		
		pStation.Group.GroupClear.Execute := pStation.Commands.Group.Clear;
		pStation.Group.GroupClear.ShuttleGroup := ADR(pStation.Group.ShuttleGroup);
		pStation.Group.GroupClear();
		
		pStation.Group.GroupAddShuttle.Execute := pStation.Commands.Group.AddShuttle;
		pStation.Group.GroupAddShuttle.ShuttleGroup := ADR(pStation.Group.ShuttleGroup);
		pStation.Group.GroupAddShuttle();
		
		pStation.Group.GroupCoupleCtrl.Execute := pStation.Commands.Group.ChangeCoupling;
		pStation.Group.GroupCoupleCtrl.ShuttleGroup := ADR(pStation.Group.ShuttleGroup);
		pStation.Group.GroupCoupleCtrl();
		
		// Zone
		pStation.Zone.ZoneCreate.Execute := pStation.Commands.Zone.Create;
		pStation.Zone.ZoneCreate.Assembly := ADR(gAssembly6D_Big);
		pStation.Zone.ZoneCreate();
		
		pStation.Zone.ZoneGetBarrierInfo.Execute := pStation.Commands.Zone.GetBarrierInfo;
		pStation.Zone.ZoneGetBarrierInfo.Zone := ADR(pStation.Zone.Zone);
		pStation.Zone.ZoneGetBarrierInfo();
		
		pStation.Zone.FindZone.Execute := pStation.Commands.Zone.Find;
		pStation.Zone.FindZone.Assembly := ADR(gAssembly6D_Big);
		pStation.Zone.FindZone();
		
		// Virtual
		pStation.Virtual.VirtualShCreate.Execute := pStation.Commands.CreateVirtualShuttle;
		pStation.Virtual.VirtualShCreate.Assembly := ADR(gAssembly6D_Big);
		pStation.Virtual.VirtualShCreate();	
		
		// Wait
		pStation.Operation.WaitCommandLabel.Execute := pStation.Commands.WaitCommandLabel;
		pStation.Operation.WaitCommandLabel();
		
		pStation.Operation.WaitUntilAllDone.Execute := pStation.Commands.WaitUntilAllDone;
		pStation.Operation.WaitUntilAllDone();
	END_FOR;


	// Task outputs
	// =================================================================================================================
    
	
	// Task diagnostics
	// =================================================================================================================
	gTasks.FastDemo.State := Em.StateCurrent;
	gTasks.FastDemo.SubState := Em.SubState;
	gTasks.FastDemo.Mode := Em.ModeID;
	gTasks.FastDemo.StateComplete := Em.Command.StateComplete;
	gTasks.FastDemo.StateInfo := Em.StateInfo;
	gTasks.FastDemo.WaitingForTask := Em.Info.WaitingFor.Name;
	gTasks.FastDemo.Error := Task.Error;

END_PROGRAM
	
PROGRAM _EXIT
	
END_PROGRAM