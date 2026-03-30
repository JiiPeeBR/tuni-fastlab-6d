
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
		Var : FastDemoStationVarType;
		Control : MpTrafficStationControl;
		Commands : FastDemoStationCommandsType;
		Operation : FastDemoStationOperationType;
		Macro : FastDemoStationMacroType;
	END_STRUCT;
	FastDemoStationVarType : 	STRUCT 
		PreviousState : DINT;
		StateInfo : STRING[80];
		LoopNum : DINT;
	END_STRUCT;
	FastDemoStationCommandsType : 	STRUCT 
		Release : BOOL;
		MacroCreate : BOOL;
		MacroSave : BOOL;
		MacroRun : BOOL;
		MacroDelete : BOOL;
		MoveInPlane : BOOL;
		MoveArc : BOOL;
		Spin : BOOL;
	END_STRUCT;
	FastDemoStationOperationType : 	STRUCT 
		MoveInPlane : MC_BR_MoveInPlane_Acp6D;
		MoveArc : MC_BR_MoveArc_Acp6D;
		Spin : MC_BR_RotaryMotionSpin_Acp6D;
	END_STRUCT;
	FastDemoStationMacroType : 	STRUCT 
		Shuttle : Mc6DShuttleType;
		Name : STRING[32];
		MacroCreate : MC_BR_MacroCreate_Acp6D;
		MacroSave : MC_BR_MacroSave_Acp6D;
		MacroRun : MC_BR_MacroRun_Acp6D;
	END_STRUCT;
END_TYPE
