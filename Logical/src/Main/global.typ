(*    
Program: Main

Description
(short summary)

*)
(*========== INPUTS ==========*)

TYPE
	MainInputCommandType : 	STRUCT 
		Abort : BOOL; (*Go to state Aborting - Can be set in all states except Aborting and Aborted.*)
		Clear : BOOL; (*Go to state Clearing - Can only be set in state Aborted.*)
		Stop : BOOL; (*Go to state Stopping - Can be set in all states except Aborting, Aborted, Clearing, Stopping and Stopped.*)
		Reset : BOOL; (*Go to state Resetting - Can only be set in state Stopped.*)
		Start : BOOL; (*Go to state Starting - Can only be set in state Idle.*)
		Hold : BOOL; (*Go to state Holding. Can only be set in state Execute.*)
		Unhold : BOOL; (*Go to state Unholding. Can only be set in state Held.*)
		Suspend : BOOL; (*Go to state Suspending. Can only be set in state Execute.*)
		Unsuspend : BOOL; (*Go to state Unsuspending. Can only be set in state Suspended.*)
		Complete : BOOL; (*Go to state Completing. Can only be set in state Execute*)
	END_STRUCT;
	MainInputStatusType : 	STRUCT 
		SetupComplete : BOOL;
	END_STRUCT;
	MainInputType : 	STRUCT 
		Force : BOOL;
		Command : MainInputCommandType;
		Status : MainInputStatusType;
	END_STRUCT;
END_TYPE

(*========== OUTPUTS ==========*)

TYPE
	MainOutputCommandType : 	STRUCT 
		NewCommand : BOOL;
	END_STRUCT;
	MainOutputStatusType : 	STRUCT 
		NewStatus : BOOL;
	END_STRUCT;
	MainOutputType : 	STRUCT 
		Command : MainOutputCommandType;
		Status : MainOutputStatusType;
		Assembly : McAcp6DAsmInfoType;
	END_STRUCT;
END_TYPE

(*========== SETTINGS ==========*)

TYPE
	MainSettingsType : 	STRUCT 
		Enable : BOOL;
	END_STRUCT;
END_TYPE

(*========== INTERFACE ==========*)

TYPE
	MainType : 	STRUCT 
		Error : GeneralErrorInfoType;
		Input : MainInputType;
		Output : MainOutputType;
		Settings : MainSettingsType;
	END_STRUCT;
END_TYPE
