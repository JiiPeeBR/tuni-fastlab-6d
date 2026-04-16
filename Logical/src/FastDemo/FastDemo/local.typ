
TYPE
	FastDemoFbType : 	STRUCT 
		MpRecipeRegPar_settings : BOOL;
		TrafficControl : MpTrafficControl;
		TrafficMonitor : MpTrafficMonitor;
		rtStateComplete : R_TRIG;
		MacroDelete : MC_BR_MacroDelete_Acp6D;
	END_STRUCT;
	FastDemoLocalType : 	STRUCT 
		lastState : DINT;
		lastSubState : DINT;
		lastStateInfo : STRING[80];
		allGroupsDeleted : BOOL;
	END_STRUCT;
	FastDemoActionsStateType : 	STRUCT 
		error_reset : BOOL;
	END_STRUCT;
	FastDemoActionsSubstateType : 	STRUCT 
		traffic_activate_recipe : BOOL; (*Task actions are not automatically reset*)
		traffic_deactivate_recipe : BOOL; (*Task actions are not automatically reset*)
		traffic_halt : BOOL;
		traffic_recover : BOOL;
		traffic_resume : BOOL;
		traffic_stop : BOOL;
		macro_delete : BOOL;
	END_STRUCT;
	FastDemoHmiType : 	STRUCT 
		isRunning : BOOL;
	END_STRUCT;
END_TYPE

(**)
(*Stations*)

TYPE
	FastDemoStationType : 	STRUCT 
		State : DINT;
		SequenceStep : DINT;
		Shuttles : ARRAY[0..STATION_SHUTTLE_LAST_INDEX]OF MpTrafficShuttleInfoType;
		ShuttleCount : DINT;
		Var : FastDemoStationVarType;
		Control : MpTrafficStationControl;
		Commands : FastDemoStationCommandsType;
		Operation : FastDemoStationOperationType;
		Macro : FastDemoStationMacroType;
		Group : FastDemoStationGroupType;
	END_STRUCT;
	FastDemoStationVarType : 	STRUCT 
		PreviousState : DINT;
		StateInfo : STRING[80];
		LoopNum : DINT;
	END_STRUCT;
	FastDemoStationCommandsType : 	STRUCT 
		Release : BOOL;
		Macro : FastDemoStationMacroCommandsType;
		Group : FastDemoStationGroupCommandsType;
		MoveInPlane : BOOL;
		MoveArc : BOOL;
		Spin : BOOL;
		SelectNextShuttle : BOOL;
	END_STRUCT;
	FastDemoStationMacroCommandsType : 	STRUCT 
		Create : BOOL;
		Save : BOOL;
		Delete : BOOL;
	END_STRUCT;
	FastDemoStationGroupCommandsType : 	STRUCT 
		Create : BOOL;
		Clear : BOOL;
		Delete : BOOL;
		AddShuttle : BOOL;
		ChangeCoupling : BOOL;
	END_STRUCT;
	FastDemoStationOperationType : 	STRUCT 
		StationQueueControl : fdStationQueueControl;
		MoveInPlane : MC_BR_MoveInPlane_Acp6D;
		MoveArc : MC_BR_MoveArc_Acp6D;
		Spin : MC_BR_RotaryMotionSpin_Acp6D;
	END_STRUCT;
	FastDemoStationMacroType : 	STRUCT 
		Shuttle : Mc6DShuttleType;
		Name : STRING[32];
		Execute : BOOL;
		MacroCreate : MC_BR_MacroCreate_Acp6D;
		MacroSave : MC_BR_MacroSave_Acp6D;
		MacroRun : MC_BR_MacroRun_Acp6D;
	END_STRUCT;
	FastDemoStationGroupType : 	STRUCT 
		ShuttleGroup : Mc6DShuttleGroupType;
		GroupCreate : MC_BR_ShGroupCreate_Acp6D;
		GroupClear : MC_BR_ShGroupClear_Acp6D;
		GroupCoupleCtrl : MC_BR_ShGroupCoupleCtrl_Acp6D;
		GroupAddShuttle : MC_BR_ShGroupAddShuttle_Acp6D;
		GroupDelete : MC_BR_ShGroupDelete_Acp6D;
	END_STRUCT;
END_TYPE
