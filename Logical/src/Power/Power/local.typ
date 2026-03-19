
TYPE
	PowerFbType : 	STRUCT 
		MpRecipeRegPar_settings : BOOL;
	END_STRUCT;
	PowerLocalType : 	STRUCT 
		onStateEntry : BOOL;
		lastState : DINT;
		lastSubState : DINT;
		actions : PowerActionsType;
		allReadyToStart : BOOL;
		allPowerOn : BOOL;
		allPowerOff : BOOL;
		automaticPowerOnAtStart : BOOL;
	END_STRUCT;
	PowerActionsType : 	STRUCT 
		power_on : BOOL; (*Task actions are not automatically reset*)
		power_off : BOOL; (*Task actions are not automatically reset*)
	END_STRUCT;
	PowerHmiType : 	STRUCT 
		isRunning : BOOL;
	END_STRUCT;
END_TYPE
