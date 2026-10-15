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
		PowerOff : BOOL;
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
		TrackPowerOn : BOOL;
		TotalPowerDraw : REAL;
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
		CrOk : BOOL;
		OutputEnabled : BOOL;
		StatusRunMode : USINT;
		Current_A : REAL;
		Voltage_V : REAL;
	END_STRUCT;
	PowerType : 	STRUCT 
		Error : PowerErrorType;
		Input : PowerInputType;
		Output : PowerOutputType;
		AuxPowerUnit : ARRAY[0..AUX_POWER_LAST_INDEX]OF AuxPowerUnitType;
		StateInfo : STRING[80];
		State : DINT;
	END_STRUCT;
END_TYPE
