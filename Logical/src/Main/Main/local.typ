
TYPE
	MainFbType : 	STRUCT 
		MpRecipeRegPar_settings : BOOL;
		AssemblyReadInfo : MC_BR_AsmReadInfo_Acp6D;
		AssemblyPowerOn : MC_BR_AsmPowerOn_Acp6D;
		AssemblyPowerOff : MC_BR_AsmPowerOff_Acp6D;
		AssemblyReset : MC_BR_AsmReset_Acp6D;
		AssemblyGetShuttle : MC_BR_AsmGetShuttle_Acp6D;
		assemblyStop : MC_BR_AsmStop_Acp6D;
		AssemblyReadShIDTable : MC_BR_AsmReadShIDTable_Acp6D;
		MoveInPlaneAsync : MC_BR_MoveInPlaneAsync_Acp6D;
		ShuttleGetInfo : MC_BR_ShGetInfo_Acp6D;
	END_STRUCT;
	MainLocalType : 	STRUCT 
		lastState : DINT;
		lastSubState : DINT;
		lastStateInfo : STRING[80];
		shuttleIndex : DINT;
		homePosition : ARRAY[0..gMAX_INDEX_SHUTTLE]OF MainHomePositionType;
	END_STRUCT;
	MainActionsStateType : 	STRUCT 
		getShuttles : BOOL; (*Task actions are not automatically reset*)
	END_STRUCT;
	MainActionsSubstateType : 	STRUCT 
		assemblyPowerOn : BOOL; (*Task actions are not automatically reset*)
		assemblyPowerOff : BOOL; (*Task actions are not automatically reset*)
		assemblyReset : BOOL; (*Task actions are not automatically reset*)
		getNextShuttle : BOOL; (*Task actions are not automatically reset*)
		readShuttleIDs : BOOL; (*Task actions are not automatically reset*)
		homeShuttles : BOOL; (*Task actions are not automatically reset*)
		readShuttleInfo : BOOL;
	END_STRUCT;
	MainHmiType : 	STRUCT 
		isRunning : BOOL;
	END_STRUCT;
	MainHomePositionType : 	STRUCT 
		x : REAL;
		y : REAL;
	END_STRUCT;
END_TYPE
