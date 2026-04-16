
FUNCTION_BLOCK fdStationQueueControl
	VAR_INPUT
		Enable : {REDUND_UNREPLICABLE} BOOL;
		ReleaseShuttles : {REDUND_UNREPLICABLE} BOOL;
		ShuttleList : {REDUND_UNREPLICABLE} ARRAY[0..fdMAX_STATION_SHUTTLE_COUNT] OF MpTrafficShuttleInfoType;
		ShuttleCapacity : {REDUND_UNREPLICABLE} DINT; (*Count how many shuttles process station can handle*)
		pStationControl : REFERENCE TO MpTrafficStationControl;
	END_VAR
	VAR_OUTPUT
		ShuttleReleaseDone : BOOL;
		ShuttleReleaseError : BOOL;
		ReleaseShuttle : BOOL;
	END_VAR
	VAR
		state : DINT;
		i : DINT;
		index : DINT;
		shuttleID : UINT;
	END_VAR
END_FUNCTION_BLOCK
