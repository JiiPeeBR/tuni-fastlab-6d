(*    
Program: FastDemo

Description
(short summary)

*)
(*========== INPUTS ==========*)

TYPE
	FastDemoInputCommandType : 	STRUCT 
		Activate : BOOL;
	END_STRUCT;
	FastDemoInputStatusType : 	STRUCT 
		SetupComplete : BOOL;
	END_STRUCT;
	FastDemoInputType : 	STRUCT 
		Force : BOOL;
		Command : FastDemoInputCommandType;
		Status : FastDemoInputStatusType;
	END_STRUCT;
END_TYPE

(*========== OUTPUTS ==========*)

TYPE
	FastDemoOutputCommandType : 	STRUCT 
		NewCommand : BOOL;
	END_STRUCT;
	FastDemoOutputStatusType : 	STRUCT 
		NewStatus : BOOL;
	END_STRUCT;
	FastDemoOutputType : 	STRUCT 
		Command : FastDemoOutputCommandType;
		Status : FastDemoOutputStatusType;
	END_STRUCT;
END_TYPE

(*========== ERRORS ==========*)
(*========== SETTINGS ==========*)

TYPE
	FastDemoSettingsType : 	STRUCT 
		Enable : BOOL;
	END_STRUCT;
END_TYPE

(*========== INTERFACE ==========*)

TYPE
	FastDemoType : 	STRUCT 
		Error : GeneralErrorInfoType;
		Input : FastDemoInputType;
		Output : FastDemoOutputType;
		Settings : FastDemoSettingsType;
	END_STRUCT;
END_TYPE
