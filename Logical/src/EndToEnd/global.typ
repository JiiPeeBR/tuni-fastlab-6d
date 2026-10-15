(*    
Program: EndToEnd

Description
(short summary)

*)
(*========== INPUTS ==========*)

TYPE
	EndToEndInputCommandType : 	STRUCT 
		Activate : BOOL;
	END_STRUCT;
	EndToEndInputStatusType : 	STRUCT 
		SetupComplete : BOOL;
	END_STRUCT;
	EndToEndInputType : 	STRUCT 
		Force : BOOL;
		Command : EndToEndInputCommandType;
		Status : EndToEndInputStatusType;
	END_STRUCT;
END_TYPE

(*========== OUTPUTS ==========*)

TYPE
	EndToEndOutputCommandType : 	STRUCT 
		NewCommand : BOOL;
	END_STRUCT;
	EndToEndOutputStatusType : 	STRUCT 
		NewStatus : BOOL;
	END_STRUCT;
	EndToEndOutputType : 	STRUCT 
		Command : EndToEndOutputCommandType;
		Status : EndToEndOutputStatusType;
	END_STRUCT;
END_TYPE

(*========== ERRORS ==========*)
(*========== SETTINGS ==========*)

TYPE
	EndToEndSettingsType : 	STRUCT 
		Enable : BOOL;
	END_STRUCT;
END_TYPE

(*========== INTERFACE ==========*)

TYPE
	EndToEndType : 	STRUCT 
		Error : GeneralErrorInfoType;
		Input : EndToEndInputType;
		Output : EndToEndOutputType;
		Settings : EndToEndSettingsType;
	END_STRUCT;
END_TYPE
