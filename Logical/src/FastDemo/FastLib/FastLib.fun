
FUNCTION_BLOCK fdStationQueueControl
	VAR_INPUT
		Enable : BOOL;
		ReleaseShuttles : BOOL;
		ShuttleList : ARRAY[0..fdMAX_STATION_SHUTTLE_COUNT] OF MpTrafficShuttleInfoType;
		ShuttleCapacity : DINT; (*Count how many shuttles process station can handle*)
		Station_SelectedShuttle : MpTrafficStationShInfoType;
		Station_Info : MpTrafficStationCtrlInfoType;
		Station_ReleaseDone : BOOL;
		Station_ReleaseAborted : BOOL;
	END_VAR
	VAR_OUTPUT
		ShuttleReleaseDone : BOOL;
		Error : BOOL;
		ReleaseShuttle : BOOL;
		SelectNextShuttle : BOOL;
	END_VAR
	VAR
		state : DINT;
		index : DINT;
		shuttleIDToReleaseNext : UINT;
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
		Shuttles : {REDUND_UNREPLICABLE} ARRAY[0..fdMAX_WAIT_SHUTTLE_COUNT] OF Mc6DShuttleType;
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
