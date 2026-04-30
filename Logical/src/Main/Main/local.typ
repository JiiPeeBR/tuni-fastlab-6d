
TYPE
	MainFbType : 	STRUCT 
		MpRecipeRegPar_settings : BOOL;
		AssemblyReadInfo : MC_BR_AsmReadInfo_Acp6D;
		AssemblyPowerOn : MC_BR_AsmPowerOn_Acp6D;
		AssemblyPowerOff : MC_BR_AsmPowerOff_Acp6D;
		AssemblyReset : MC_BR_AsmReset_Acp6D;
		AssemblyGetShuttle : MC_BR_AsmGetShuttle_Acp6D;
		AssemblyStop : MC_BR_AsmStop_Acp6D;
		AssemblyReadShIDTable : MC_BR_AsmReadShIDTable_Acp6D;
		MoveInPlaneAsync : MC_BR_MoveInPlaneAsync_Acp6D;
		ShuttleGetInfo : MC_BR_ShGetInfo_Acp6D;
		R_TRIG_Abort : R_TRIG;
		TON_ShuttleScan : TON;
		MoveShortAxis : MC_BR_MoveShortAxis_Acp6D;
		rtStateComplete : R_TRIG;
		Pulse_slow : fdPulse;
		LampSequence : fdLampSequence;
	END_STRUCT;
	MainLocalType : 	STRUCT 
		lastSubState : DINT;
		shuttleIndex : DINT;
		homePosition : ARRAY[0..gMAX_INDEX_SHUTTLE]OF MainHomePositionType;
		shuttlesCount : USINT;
		lastReadShuttleID : UINT;
	END_STRUCT;
	MainActionsStateType : 	STRUCT 
		getShuttles : BOOL; (*Task actions are not automatically reset*)
	END_STRUCT;
	MainActionsSubstateType : 	STRUCT 
		assemblyPowerOn : BOOL; (*Task actions are not automatically reset*)
		assemblyPowerOff : BOOL; (*Task actions are not automatically reset*)
		assemblyReset : BOOL; (*Task actions are not automatically reset*)
		assemblyStop : BOOL; (*Task actions are not automatically reset*)
		readShuttleIDs : BOOL; (*Task actions are not automatically reset*)
		homeShuttles : BOOL; (*Task actions are not automatically reset*)
		readShuttleInfo : BOOL;
		getNextShuttle : BOOL;
		moveShortAxis : BOOL;
	END_STRUCT;
	MainHmiType : 	STRUCT 
		isRunning : BOOL;
	END_STRUCT;
	MainHomePositionType : 	STRUCT 
		x : REAL;
		y : REAL;
	END_STRUCT;
	MainCommandsType : 	STRUCT 
		Abort : R_TRIG; (*Go to state Aborting - Can be set in all states except Aborting and Aborted.*)
		Clear : R_TRIG; (*Go to state Clearing - Can only be set in state Aborted.*)
		Stop : R_TRIG; (*Go to state Stopping - Can be set in all states except Aborting, Aborted, Clearing, Stopping and Stopped.*)
		Reset : R_TRIG; (*Go to state Resetting - Can only be set in state Stopped.*)
		Start : R_TRIG; (*Go to state Starting - Can only be set in state Idle.*)
		Hold : R_TRIG; (*Go to state Holding. Can only be set in state Execute.*)
		Unhold : R_TRIG; (*Go to state Unholding. Can only be set in state Held.*)
		Suspend : R_TRIG; (*Go to state Suspending. Can only be set in state Execute.*)
		Unsuspend : R_TRIG; (*Go to state Unsuspending. Can only be set in state Suspended.*)
		Complete : R_TRIG; (*Go to state Completing. Can only be set in state Execute*)
	END_STRUCT;
END_TYPE
