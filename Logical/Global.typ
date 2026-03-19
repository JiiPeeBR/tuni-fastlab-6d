
TYPE
	TaskDiagType : 	STRUCT 
		Main : TaskEmStateInfoType;
		Power : TaskCmStateInfoType;
	END_STRUCT;
	TaskEmStateInfoType : 	STRUCT 
		State : EMPackMLStateEnum;
		SubState : DINT;
		Mode : EMPackMLModeEnum;
		StateComplete : BOOL;
		StateInfo : STRING[255];
		WaitingForTask : STRING[255];
		Error : GeneralErrorInfoType;
	END_STRUCT;
	TaskCmStateInfoType : 	STRUCT 
		State : DINT;
		SubState : DINT;
		StateInfo : STRING[255];
		Error : GeneralErrorInfoType;
	END_STRUCT;
	GeneralErrorInfoType : 	STRUCT 
		Code : DINT;
		Description : STRING[80];
		State : DINT;
		SubState : DINT;
	END_STRUCT;
END_TYPE

(**)

TYPE
	ShuttleListType : 	STRUCT 
		Count : UDINT;
		Shuttle : ARRAY[0..gMAX_INDEX_SHUTTLE]OF ShuttleType;
	END_STRUCT;
	ShuttleType : 	STRUCT 
		ID : UINT;
		UID : ShuttleUidType;
		Ref : Mc6DShuttleType;
		Position : McAcp6DShPositionType;
		MotionBuffer : McAcp6DShInfoMotionBufferType;
		State : McAcp6DShStateEnum;
	END_STRUCT;
	ShuttleUidType : 	STRUCT 
		High : UDINT;
		Low : UDINT;
	END_STRUCT;
END_TYPE

(**)
