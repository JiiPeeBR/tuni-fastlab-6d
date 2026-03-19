PROGRAM _INIT
	
    // Access the task interface
    task ACCESS ADR(gPower);

    // Register module config interface for common setup/parametrization functionality
	//fb.MpRecipeRegPar_settings(MpLink := ADR(gSystemSettings), Enable := TRUE , PVName := ADR('gPower.settings'), Category := ADR('Power'));
	
	// PackML setup
    // =================================================================================================================
    cm.Setup.Name := 'Power';
	cm.Setup.ParentName := 'Main';
	
	local.automaticPowerOnAtStart := TRUE;
	
END_PROGRAM
	
PROGRAM _CYCLIC
	
    // Access task interface
    // =================================================================================================================
    task ACCESS ADR(gPower);


    // Inputs
    // =================================================================================================================
    IF NOT task.Input.Force THEN

    END_IF

    // Task state machine
    // =================================================================================================================
    CASE cm.State OF
        0:
            cm.StateInfo := 'Wait for all power units to be ready';
			// ---------------------------------------------------------------------------------
			local.allReadyToStart := TRUE;
			
			FOR i := 0 TO AUX_POWER_LAST_INDEX DO
				// Check if unit is ready
				IF task.AuxPowerUnit[i].StatusRunMode <> 1 THEN
	  				local.allReadyToStart := FALSE;
				END_IF;
			END_FOR;
			
			IF local.automaticPowerOnAtStart THEN
				task.Input.Command.PowerOn := TRUE;
			END_IF;
			
			IF local.allReadyToStart THEN
				cm.State := 10;	
			END_IF;
	
		10:
            cm.StateInfo := 'Track power off';
			// ---------------------------------------------------------------------------------
			IF task.Input.Command.PowerOn THEN
				cm.State := 20;
			END_IF;
			
		20:
			cm.StateInfo := 'Enabling auxiliary power supplies';
			// ---------------------------------------------------------------------------------
			actions.power_on := TRUE;
			IF local.allPowerOn THEN
				cm.State := 30;
			END_IF;
			
		30:
			cm.StateInfo := 'Track power on';
			// ---------------------------------------------------------------------------------
			IF (NOT task.Input.Command.PowerOn) THEN
				cm.State := 40;
			END_IF;
			
		40:
			cm.StateInfo := 'Disabling auxiliary power supplies';
			// ---------------------------------------------------------------------------------
			actions.power_off := TRUE;
			IF local.allPowerOff THEN
				cm.State := 10;
			END_IF;
	END_CASE // End of main task logic
  
	task.Error.Acknowledge := FALSE; 
      
	// Detect state change events
	// =================================================================================================================
	local.onStateEntry := (cm.State <> local.lastState) OR (cm.SubState <> local.lastSubState);

	IF local.onStateEntry THEN
		brsmemset(ADR(actions), 0, SIZEOF(actions));
	END_IF;
	
	IF cm.State <> local.lastState THEN
		cm.SubState := 0;
		local.lastState := cm.State;
	END_IF

    // Reset current state actions also when substate changes
    IF cm.SubState <> local.lastSubState THEN
        local.lastSubState := cm.SubState;
	END_IF

    // PackML control module
    // =================================================================================================================
	cm();
    
	// Power command
    // =================================================================================================================
	FOR i := 0 TO AUX_POWER_LAST_INDEX DO
		task.AuxPowerUnit[i].Command.EnableOutput := actions.power_on;
	END_FOR;
	
	FOR i := 0 TO AUX_POWER_LAST_INDEX DO
		task.AuxPowerUnit[i].Command.DisableOutput := actions.power_off;
	END_FOR;
	
	// Power on status
	// =================================================================================================================
	local.allPowerOn := TRUE;
	local.allPowerOff := TRUE;
	
	FOR i := 0 TO AUX_POWER_LAST_INDEX DO
		IF NOT task.AuxPowerUnit[i].OutputEnabled THEN
			local.allPowerOn := FALSE;
		END_IF;
		
		IF task.AuxPowerUnit[i].OutputEnabled THEN
			local.allPowerOff := FALSE;
		END_IF;
	END_FOR;
	
	task.Output.PowerOn := local.allPowerOn;
	
	// Task diagnostics
	// =================================================================================================================
	gTasks.Power.State := cm.State;
	gTasks.Power.SubState := cm.SubState;
	gTasks.Power.StateInfo := cm.StateInfo;

END_PROGRAM
	
PROGRAM _EXIT
	
END_PROGRAM