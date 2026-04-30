
FUNCTION_BLOCK fdStationQueueControl
	VAR_INPUT
		Enable : {REDUND_UNREPLICABLE} BOOL;
		ReleaseShuttles : {REDUND_UNREPLICABLE} BOOL;
		SelectNextShuttle : {REDUND_UNREPLICABLE} BOOL;
		ShuttleList : {REDUND_UNREPLICABLE} ARRAY[0..fdMAX_STATION_SHUTTLE_COUNT] OF MpTrafficShuttleInfoType;
		ShuttleCapacity : {REDUND_UNREPLICABLE} DINT; (*Count how many shuttles process station can handle*)
		pStationControl : REFERENCE TO MpTrafficStationControl;
	END_VAR
	VAR_OUTPUT
		ShuttleReleaseDone : BOOL;
		ShuttleReleaseError : BOOL;
		ReleaseShuttle : BOOL;
		LastReleasedShuttleID : UINT;
	END_VAR
	VAR
		state : DINT;
		i : DINT;
		index : DINT;
		shuttleID : UINT;
		lastSelectedIndex : UINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK fdTiltAround
	VAR_INPUT
		Execute : {REDUND_UNREPLICABLE} BOOL;
		MaxAngle : {REDUND_UNREPLICABLE} REAL;
		Steps : {REDUND_UNREPLICABLE} DINT;
		Velocity : McAcp6DShortAxAxesType;
		Shuttle : REFERENCE TO Mc6DShuttleType;
	END_VAR
	VAR_OUTPUT
		Acknowledge : BOOL;
		Error : BOOL;
	END_VAR
	VAR
		state : DINT;
		step : DINT;
		MoveShortAxis : MC_BR_MoveShortAxis_Acp6D;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK fdWaitUntilAllDone
	VAR_INPUT
		Execute : {REDUND_UNREPLICABLE} BOOL;
		Shuttles : {REDUND_UNREPLICABLE} ARRAY[0..fdMAX_STATION_SHUTTLE_COUNT] OF Mc6DShuttleType;
	END_VAR
	VAR_OUTPUT
		Done : BOOL;
		Error : BOOL;
		WaitingFor : UINT;
	END_VAR
	VAR
		state : DINT;
		i : DINT;
		ShGetInfo : MC_BR_ShGetInfo_Acp6D;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK fdPulse
	VAR_INPUT
		Execute : {REDUND_UNREPLICABLE} BOOL;
		T_on : {REDUND_UNREPLICABLE} TIME;
		T_off : {REDUND_UNREPLICABLE} TIME;
	END_VAR
	VAR_OUTPUT
		Q : BOOL;
	END_VAR
	VAR
		state : DINT;
		TON_on : TON;
		TON_off : TON;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK fdLampSequence
	VAR_INPUT
		Execute : {REDUND_UNREPLICABLE} BOOL;
	END_VAR
	VAR_OUTPUT
		Lamp1 : BOOL;
		Lamp2 : BOOL;
		Lamp3 : BOOL;
	END_VAR
	VAR
		state : DINT;
		TON_delay : TON;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK fdFindZone
	VAR_INPUT
		Assembly : REFERENCE TO Mc6DAssemblyType; (*The assembly reference establishes the connection between the function block and the assembly.*)
		Execute : BOOL;
		Name : STRING[32];
	END_VAR
	VAR_OUTPUT
		ZoneFound : BOOL;
		ZoneNotFound : BOOL;
		Error : BOOL;
		Zone : Mc6DZoneType; (* Zone reference *)
		ZoneInfo : McAcp6DGetZoneAddInfoType;
	END_VAR
	VAR
		state : DINT;
		i : DINT;
		AsmGetZone : MC_BR_AsmGetZone_Acp6D;
		lastZoneID : UINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK fdMove6D
	VAR_INPUT
		Shuttle : REFERENCE TO Mc6DShuttleType; (*The assembly reference establishes the connection between the function block and the assembly.*)
		Execute : BOOL;
		Parameters : fdMove6DParametersType;
	END_VAR
	VAR_OUTPUT
		Acknowledge : BOOL;
		Done : BOOL;
		Error : BOOL;
	END_VAR
	VAR
		state : DINT;
		i : DINT;
		ShGetInfo : MC_BR_ShGetInfo_Acp6D;
		Move6D : MC_BR_Move6D_Acp6D;
	END_VAR
END_FUNCTION_BLOCK
