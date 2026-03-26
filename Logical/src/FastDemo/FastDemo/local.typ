
TYPE
	FastDemoFbType : 	STRUCT 
		MpRecipeRegPar_settings : BOOL;
		TrafficControl : MpTrafficControl;
		TrafficMonitor : MpTrafficMonitor;
	END_STRUCT;
	FastDemoLocalType : 	STRUCT 
		lastState : DINT;
		lastSubState : DINT;
		lastStateInfo : STRING[80];
	END_STRUCT;
	FastDemoActionsStateType : 	STRUCT 
		dummy : BOOL; (*Task actions are not automatically reset*)
	END_STRUCT;
	FastDemoActionsSubstateType : 	STRUCT 
		traffic_activate_recipe : BOOL; (*Task actions are not automatically reset*)
		traffic_deactivate_recipe : BOOL; (*Task actions are not automatically reset*)
		traffic_halt : BOOL;
		traffic_recover : BOOL;
		traffic_resume : BOOL;
		traffic_stop : BOOL;
		error_reset : BOOL;
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
		PreviousState : DINT;
		StateInfo : STRING[80];
		LoopNum : DINT;
		Monitor : MpTrafficStationMonitor;
		Control : MpTrafficStationControl;
	END_STRUCT;
	FastDemoStationCommandsType : 	STRUCT 
		release : BOOL;
		move_in_plane : BOOL;
		move_arc : BOOL;
	END_STRUCT;
END_TYPE

(**)

TYPE
	FastDemoStationS1Type : 	STRUCT 
		Station : FastDemoStationType;
		Commands : FastDemoStationCommandsType;
		MoveInPlane : MC_BR_MoveInPlane_Acp6D;
		MoveArc : MC_BR_MoveArc_Acp6D;
	END_STRUCT;
END_TYPE
