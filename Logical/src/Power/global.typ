(*    
Program: Power

Description
(short summary)

*)
(*========== STATES ==========*)

TYPE
	PowerStateEnum : 
		(
		POWER_INITIALIZE,
		POWER_IDLE,
		POWER_ERROR
		);
END_TYPE

(*========== INPUTS ==========*)

TYPE
	PowerInputCommandType : 	STRUCT 
		PowerOn : BOOL;
	END_STRUCT;
	PowerInputType : 	STRUCT 
		Force : BOOL;
		Command : PowerInputCommandType;
		SetupComplete : BOOL;
	END_STRUCT;
END_TYPE

(*========== OUTPUTS ==========*)

TYPE
	PowerOutputType : 	STRUCT 
		PowerOn : BOOL;
	END_STRUCT;
END_TYPE

(*========== ERRORS ==========*)

TYPE
	PowerErrorType : 	STRUCT 
		Active : BOOL;
		Acknowledge : BOOL;
		Code : DINT;
		Description : STRING[80];
	END_STRUCT;
END_TYPE

(*========== INTERFACE ==========*)

TYPE
	AuxPowerUnitType : 	STRUCT 
		Command : AuxPowerUnitCommandType;
		CrOk : BOOL;
		OutputEnabled : BOOL;
		StatusRunMode : USINT;
		Current_A : REAL;
		Voltage_V : REAL;
	END_STRUCT;
	AuxPowerUnitCommandType : 	STRUCT 
		EnableOutput : BOOL;
		DisableOutput : BOOL;
		AcknowledgeAllErrors : BOOL;
		AcknowledgeAllWarnings : BOOL;
	END_STRUCT;
	PowerType : 	STRUCT 
		Error : PowerErrorType;
		Input : PowerInputType;
		Output : PowerOutputType;
		AuxPowerUnit : ARRAY[0..AUX_POWER_LAST_INDEX]OF AuxPowerUnitType;
	END_STRUCT;
END_TYPE
