
TYPE
	TaskDiagType : 	STRUCT 
		Main : TaskEmStateInfoType;
		Power : TaskCmStateInfoType;
		FastDemo : TaskEmStateInfoType;
	END_STRUCT;
	TaskEmStateInfoType : 	STRUCT 
		StateInfo : STRING[255];
		State : EMPackMLStateEnum;
		SubState : DINT;
		Mode : EMPackMLModeEnum;
		StateComplete : BOOL;
		WaitingForTask : STRING[255];
		Error : GeneralErrorInfoType;
	END_STRUCT;
	TaskCmStateInfoType : 	STRUCT 
		StateInfo : STRING[255];
		State : DINT;
		SubState : DINT;
		Error : GeneralErrorInfoType;
	END_STRUCT;
	GeneralErrorInfoType : 	STRUCT 
		Code : DINT;
		Description : STRING[80];
		AdditionalInfo : STRING[80];
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

TYPE
	DigitalInputs : 	STRUCT 
		Button1 : BOOL;
		Button2 : BOOL;
		Button3 : BOOL;
	END_STRUCT;
	DigitalOutputs : 	STRUCT 
		Button1_Led : BOOL;
		Button2_Led : BOOL;
		Button3_Led : BOOL;
	END_STRUCT;
END_TYPE
