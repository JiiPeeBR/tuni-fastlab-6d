PROGRAM _INIT
	
    // Access the Task interface
    Task ACCESS ADR(gPower);

    // Register module config interface for common setup/parametrization functionality
	//fb.MpRecipeRegPar_settings(MpLink := ADR(gSystemSettings), Enable := TRUE , PVName := ADR('gPower.settings'), Category := ADR('Power'));
	
	// PackML setup
    // =================================================================================================================
    Cm.Setup.Name := 'Power';
	Cm.Setup.ParentName := 'Main';
	
	Local.AutomaticPowerOnAtStart := TRUE;
	
END_PROGRAM
	
PROGRAM _CYCLIC
	
    // Access Task interface
    // =================================================================================================================
    Task ACCESS ADR(gPower);


    // Inputs
    // =================================================================================================================
    IF NOT Task.Input.Force THEN

    END_IF

    // Task state machine
    // =================================================================================================================
	CASE Cm.State OF
		0:
			Cm.StateInfo := 'Wait until all power units are ready to start';
			// ---------------------------------------------------------------------------------				
			IF Local.AllPowerSuppliesReadyToStart THEN
				Cm.State := Cm.State + 1;	
			END_IF;			
		1:
            Cm.StateInfo := 'Track power off';
			// ---------------------------------------------------------------------------------
			IF Fb.rPowerOn.Q THEN
				Cm.State := Cm.State + 1;
			END_IF;
		2:
			Cm.StateInfo := 'Powering on';
			// ---------------------------------------------------------------------------------
			Commands.PowerOn := TRUE;
			
			IF Local.AllPowerSuppliesPoweredOn THEN
				Cm.State := Cm.State + 1;
			END_IF
		3:
			Cm.StateInfo := 'Track power on';
			// ---------------------------------------------------------------------------------
			IF Fb.rPowerOff.Q THEN
				Cm.State := Cm.State + 1;
			END_IF;
		4:
			Cm.StateInfo := 'Powering off';
			// ---------------------------------------------------------------------------------
			Commands.PowerOff := TRUE;
			
			IF Local.AllPowerSuppliesPoweredOff THEN
				Cm.State := 1;
			END_IF
	END_CASE // End of main Task logic
  
	Task.Error.Acknowledge := FALSE;
	
	Fb.rPowerOn(CLK := Task.Input.Command.PowerOn);
	Fb.rPowerOff(CLK := Task.Input.Command.PowerOff);
	
	brsmemset(ADR(Task.Input.Command), 0, SIZEOF(Task.Input.Command));
      
	// Detect state change events
	// =================================================================================================================
	Local.OnStateEntry := (Cm.State <> Local.LastState) OR (Cm.SubState <> Local.LastSubState);

	IF Local.OnStateEntry THEN
		brsmemset(ADR(Commands), 0, SIZEOF(Commands));
	END_IF;
	
	IF Cm.State <> Local.LastState THEN
		Cm.SubState := 0;
		Local.LastState := Cm.State;
	END_IF

    // Reset current state actions also when substate changes
    IF Cm.SubState <> Local.LastSubState THEN
        Local.LastSubState := Cm.SubState;
	END_IF

    // PackML control module
    // =================================================================================================================
	Cm();
    
	// Power supply axis mapping
    // =================================================================================================================
	Fb.ApsmPowerOn[0].Axis := Fb.ApsmPowerOff[0].Axis := ADR(PSU_A);
	Fb.ApsmPowerOn[1].Axis := Fb.ApsmPowerOff[1].Axis := ADR(PSU_B);
	Fb.ApsmPowerOn[2].Axis := Fb.ApsmPowerOff[2].Axis := ADR(PSU_C);
	Fb.ApsmPowerOn[3].Axis := Fb.ApsmPowerOff[3].Axis := ADR(PSU_D);
	Fb.ApsmPowerOn[4].Axis := Fb.ApsmPowerOff[4].Axis := ADR(PSU_E);
	Fb.ApsmPowerOn[5].Axis := Fb.ApsmPowerOff[5].Axis := ADR(PSU_F);
	Fb.ApsmPowerOn[6].Axis := Fb.ApsmPowerOff[6].Axis := ADR(PSU_G);
	
	// Functions
	// =================================================================================================================
	FOR i := 0 TO AUX_POWER_LAST_INDEX DO
		Fb.ApsmPowerOn[i].Execute := Commands.PowerOn;
		Fb.ApsmPowerOn[i]();
		
		Fb.ApsmPowerOff[i].Execute := Commands.PowerOff;
		Fb.ApsmPowerOff[i]();
	END_FOR;
	
	// Power supply group statuses
	// =================================================================================================================
	Local.AllPowerSuppliesReadyToStart := TRUE;
	Local.AllPowerSuppliesPoweredOn := TRUE;
	Local.AllPowerSuppliesPoweredOff := TRUE;
	
	FOR i := 0 TO AUX_POWER_LAST_INDEX DO
		// Check if all are ready to start
		CASE Task.AuxPowerUnit[i].StatusRunMode OF
			PSU_STATE_INIT, PSU_STATE_ERROR:
				Local.AllPowerSuppliesReadyToStart := FALSE;
		END_CASE;
		
		// Check if all power supplies are on
		IF NOT Task.AuxPowerUnit[i].OutputEnabled THEN
			Local.AllPowerSuppliesPoweredOn := FALSE;
		END_IF;
		
		// Check if all power supplies are off
		IF Task.AuxPowerUnit[i].OutputEnabled THEN
			Local.AllPowerSuppliesPoweredOff := FALSE;
		END_IF;
	END_FOR;
	
	Task.Output.TrackPowerOn := Local.AllPowerSuppliesPoweredOn;
	
	// Task diagnostics
	// =================================================================================================================
	gTasks.Power.State := Cm.State;
	gTasks.Power.SubState := Cm.SubState;
	gTasks.Power.StateInfo := Cm.StateInfo;
	
	Task.StateInfo := Cm.StateInfo;
	Task.State := Cm.State;
	
END_PROGRAM
	
PROGRAM _EXIT
	
END_PROGRAM