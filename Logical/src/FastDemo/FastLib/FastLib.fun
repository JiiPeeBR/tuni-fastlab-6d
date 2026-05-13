
FUNCTION_BLOCK fdStationQueueControl
	VAR_INPUT
		Enable : BOOL;
		ReleaseShuttles : BOOL;
		ShuttleList : ARRAY[0..fdSTATION_SHUTTLE_LAST_INDEX] OF MpTrafficShuttleInfoType;
		ShuttleCapacity : UINT; (*Count how many shuttles process station can handle*)
		pStation : REFERENCE TO MpTrafficStationControl;
	END_VAR
	VAR_OUTPUT
		ShuttleReleaseDone : BOOL;
		ShuttleReleaseAborted : BOOL;
		ReleaseShuttle : BOOL;
		NumOccypyingShuttles : UINT;
	END_VAR
	VAR
		state : DINT;
		lastState : DINT;
		loop : DINT;
		index : DINT;
		shuttleFound : BOOL;
		shuttleIDToRelease : UINT;
		shuttleIDToAutoRelease : UINT;
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

FUNCTION_BLOCK fdStation
	VAR_INPUT
		Assembly : REFERENCE TO Mc6DAssemblyType;
		TrafficManager : REFERENCE TO MpTrafficManagerType;
		Station : REFERENCE TO MpTrafficStationType;
		NextStation : REFERENCE TO MpTrafficStationType;
		Enable : BOOL;
		NextState : BOOL;
		JumpToState : UINT;
		Parameters : fdStationParametersType;
		Commands : fdStationCommandsType;
		Operation : fdStationOperationType;
		Loop : DINT;
		StateInfo : STRING[80];
	END_VAR
	VAR_OUTPUT
		State : UINT;
		Active : BOOL;
		NumOccupyingShuttles : UINT;
		CommandDone : BOOL;
		CommandAcknowledge : BOOL;
		CommandError : BOOL;
		ErrorID : DINT;
		ErroredSequenceState : DINT;
		Shuttles : fdStationShuttlesType;
		VirtualShuttle : MpTrafficShuttleInfoType;
		MacroShuttle : MpTrafficShuttleInfoType;
	END_VAR
	VAR
		m_sequence_state : DINT;
		m_control : fdStationMemberControlType;
		m_move : fdStationMemberMoveType;
		m_group : fdStationMemberGroupType;
		m_macro : fdStationMemberMacroType;
		m_zone : fdStationMemberZoneType;
		m_cmd : fdStationMemberCommandType;
		m_status : fdStationMemberStatusType;
		m_var : fdStationMemberVarType;
	END_VAR
END_FUNCTION_BLOCK
(**)

FUNCTION_BLOCK fdMove6DSync
	VAR_INPUT
		Shuttle : REFERENCE TO Mc6DShuttleType;
		Execute : BOOL;
		Home : BOOL;
		Parameters : fdMove6DSyncParametersType;
	END_VAR
	VAR_OUTPUT
		Acknowledge : BOOL;
		Done : BOOL;
		Error : BOOL;
		ErrorID : DINT;
		CurrentPosition : McAcp6DShPositionType;
	END_VAR
	VAR
		state : DINT;
		i : DINT;
		ShGetInfo : MC_BR_ShGetInfo_Acp6D;
		Move6D : MC_BR_Move6D_Acp6D;
		m : fdMove6DSyncMemberType;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION fdCalcTimeToTarget : REAL
	VAR_INPUT
		Distance : REAL;
		MaxVelocity : REAL;
		Acceleration : REAL;
	END_VAR
	VAR
		timeToMaxVelocity : REAL;
		distanceToMaxVelocity : REAL;
		distanceToTarget : REAL;
	END_VAR
END_FUNCTION

FUNCTION fdCalcTargetVelocity : REAL
	VAR_INPUT
		Distance : REAL;
		TimeToTarget : REAL;
		Acceleration : REAL;
	END_VAR
	VAR
		minimumVelocity : REAL;
		discriminant : REAL;
		a : REAL;
		b : REAL;
		c : REAL;
		x1 : REAL;
		x2 : REAL;
	END_VAR
END_FUNCTION
