
TYPE
	PowerFbType : 	STRUCT 
		MpRecipeRegPar_settings : BOOL;
		rPowerOn : R_TRIG;
		rPowerOff : R_TRIG;
		ApsmPowerOn : ARRAY[0..AUX_POWER_LAST_INDEX]OF MC_BR_ApsmPowerOn_AcpAx;
		ApsmPowerOff : ARRAY[0..AUX_POWER_LAST_INDEX]OF MC_BR_ApsmPowerOff_AcpAx;
	END_STRUCT;
	PowerLocalType : 	STRUCT 
		OnStateEntry : BOOL;
		LastState : DINT;
		LastSubState : DINT;
		AllPowerSuppliesPoweredOn : BOOL;
		AllPowerSuppliesPoweredOff : BOOL;
		AllPowerSuppliesReadyToStart : BOOL;
		AutomaticPowerOnAtStart : BOOL;
	END_STRUCT;
	PowerCommandsType : 	STRUCT 
		PowerOn : BOOL;
		PowerOff : BOOL;
	END_STRUCT;
	PowerHmiType : 	STRUCT 
		isRunning : BOOL;
	END_STRUCT;
END_TYPE
