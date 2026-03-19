
TYPE
	EMStatusType : 	STRUCT  (*EMStatusType*)
		Name : STRING[255]; (*Em Name*)
		ModeID : UDINT; (*Current Mode*)
		StateCurrent : EMPackMLStateEnum; (*Current State*)
		SubStateCurrent : DINT; (*Current Sub State*)
		StateComplete : BOOL; (*State Complete*)
		StateInfo : STRING[255]; (*Used to describe the action in all states and substates*)
	END_STRUCT;
	EMCommandType : 	STRUCT  (*EMCommandType*)
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
		StateComplete : BOOL; (*Go to next waiting state. Can be set in all acting states and state Execute.*)
	END_STRUCT;
	EMPackMLCmdEnum : 
		( (*Command Enum*)
		CMD_UNDEFINED := 0, (*Undefined Command*)
		CMD_RESET := 1, (*PackML Reset Command*)
		CMD_START := 2, (*PackML Start Command*)
		CMD_STOP := 3, (*PackML Stop Command*)
		CMD_HOLD := 4, (*PackML Hold Command*)
		CMD_UNHOLD := 5, (*PackML Unhold Command*)
		CMD_SUSPEND := 6, (*PackML Suspend Command*)
		CMD_UNSUSPEND := 7, (*PackML Unsuspend Command*)
		CMD_ABORT := 8, (*PackML Abort Command*)
		CMD_CLEAR := 9, (*PackML Clear Command*)
		CMD_COMPLETE := 10, (*PackML Complete Command*)
		CMD_SC := 11 (*PackML State Complete Command*)
		);
	EMPackMLModeEnum : 
		( (*Mode Enum*)
		MODE_UNDEFINED := 0, (*PackML Undefined mode*)
		MODE_PRODUCTION := 1, (*PackML Production mode*)
		MODE_MAINTENANCE := 2, (*PackML Maintenance mode*)
		MODE_MANUAL := 3, (*PackML Manual mode*)
		MODE_CLEAN := 16, (*PackML Cleaning mode*)
		MODE_JOG := 17, (*PackML Jogging mode*)
		MODE_CIP := 18, (*PackML CIP mode*)
		MODE_CALIBRATION := 19 (*PackML Calibration mode*)
		);
	EMPackMLStateEnum : 
		( (*State Enum*)
		STATE_UNDEFINED := 0, (*The system is inactive, no state active*)
		STATE_CLEARING := 1, (*PackML CLEARING state*)
		STATE_STOPPED := 2, (*PackML STOPPED state*)
		STATE_STARTING := 3, (*PackML STARTING state*)
		STATE_IDLE := 4, (*PackML IDLE state*)
		STATE_SUSPENDED := 5, (*PackML SUSPENDED state*)
		STATE_EXECUTE := 6, (*PackML EXECUTE state*)
		STATE_STOPPING := 7, (*PackML STOPPING state*)
		STATE_ABORTING := 8, (*PackML ABORTING state*)
		STATE_ABORTED := 9, (*PackML ABORTED state*)
		STATE_HOLDING := 10, (*PackML HOLDING state*)
		STATE_HELD := 11, (*PackML HELD state*)
		STATE_UNHOLDING := 12, (*PackML UNHOLDING state*)
		STATE_SUSPENDING := 13, (*PackML SUSPENDING state*)
		STATE_UNSUSPENDING := 14, (*PackML UNSUSPENDING state*)
		STATE_RESETTING := 15, (*PackML RESETTING state*)
		STATE_COMPLETING := 16, (*PackML COMPLETING state*)
		STATE_COMPLETED := 17, (*PackML COMPLETED state*)
		STATE_DEACTIVATING := 30, (*Deactivating state. Not a standard PackML state*)
		STATE_DEACTIVATED := 31, (*Deactivated state. Not a standard PackML state*)
		STATE_ACTIVATING := 32 (*Activating state. Not a standard PackML state*)
		);
	EMActivationConditionEnum : 
		( (*Activation Enum*)
		ACTIVATE_AUTOMATIC := 0, (*Activate Em automatically when executed*)
		ACTIVATE_BY_PARENT := 1, (*Activate Em if parent is activated*)
		ACTIVATE_BY_PV := 2 (*Activate Em based on PV value*)
		);
	EMSetupType : 	STRUCT  (*EMSetupType*)
		ParentName : STRING[255]; (*Name of the parent. Leave empty is Em is parent at level 0*)
		Name : STRING[255]; (*Name of the Em. If left empty during first execution, the task name is used as Em name*)
		NameIndex : USINT := EM_MAX_NAME_INDEX; (*Index of the Em if having multiple Em's in an array*)
		Activate : BOOL := FALSE; (*PV for ActivationCondition ACTIVATE_BY_PV*)
		ActivationCondition : EMActivationConditionEnum := ACTIVATE_AUTOMATIC; (*Condition for activating the Em*)
		EnableWaitingFor : BOOL := TRUE; (*Enable the WaitingFor log*)
		EnableInteruptedBy : BOOL := TRUE; (*Enable the InterruptedBy log*)
		Synchronisation : EMSynchronisationType; (*Parameters for Em synchronization*)
		AuditModeChange : BOOL := TRUE; (*Log when mode is changed*)
		AuditStateChange : BOOL := TRUE; (*Log when state is changed*)
		AuditSubStateChange : BOOL := TRUE; (*Log when substate is changed*)
		SkipStopStateComplete : BOOL; (*The StateComplete command is ignored during stop*)
	END_STRUCT;
	EMInfoType : 	STRUCT  (*EMInfoType*)
		ParentName : STRING[255]; (*Name of the Parent Em*)
		ParentStateCurrent : EMPackMLStateEnum; (*Parent Current State*)
		EmName : STRING[255]; (*Name of the Em*)
		EmAddress : UDINT; (*Address of the Em*)
		EmIndex : UDINT; (*Global EM index*)
		UserDataAddress : UDINT; (*Published data address*)
		Level : UDINT; (*Level in the hierarchy. Parent is level 0.*)
		SiblingCount : UDINT; (*Number of Siblings. No siblings means Sibling count 1*)
		ChildCount : UDINT; (*How many children are registered to this module. Even when desynchronised the child count will still be valid.*)
		ParentStateComplete : BOOL; (*The parent is state complete. Can be used to synchronize a state transition*)
		SiblingsStateComplete : BOOL; (*All siblings are state complete. Can be used to synchronize a state transition*)
		ChildrenStateComplete : BOOL; (*All children are state complete. Can be used to synchronize a state transition*)
		WaitingFor : EMStatusType; (*The status for the Em we are waiting for*)
		InteruptedBy : EMStatusType; (*The Em we where interrupted by*)
		TimeInState : REAL; (*The actual time in the current state*)
		TimeInSubState : REAL; (*The actual time in the current sub state*)
		Last : ARRAY[0..EM_MAX_AUDIT_ENTRIES]OF STRING[50]; (*The last state, substate and mode*)
		CycleTime : REAL; (*Cycle Time in seconds*)
		OnStateEntry : BOOL; (*Goes to true on the first scan after a state change*)
		OnSubStateEntry : BOOL; (*Goes to true on the first scan after a substate change*)
	END_STRUCT;
	EMInternalType : 	STRUCT  (*Internal type of the Em*)
		state : USINT; (*Internal state*)
		emAddress : UDINT; (*Address of the instance on the heap memory*)
		userDataAddress : UDINT; (*Address of the user data on the heap memory*)
		subscriptionUserDataAddress : ARRAY[0..EM_MAX_SUBSCRIPTIONS]OF UDINT; (*Address of the user data we are currently subscribing to*)
		subscribedToEMName : ARRAY[0..EM_MAX_SUBSCRIPTIONS]OF STRING[255]; (*Name of the Em we are subscribed to*)
		oldPubSubEnable : BOOL; (*Old Pub/Sub enable*)
	END_STRUCT;
	EMSynchronisationType : 	STRUCT  (*Em synchronization settings type*)
		Override : EMSynchronisationCmdType := (Abort:=FALSE,Stop:=FALSE,Complete:=FALSE,Suspend:=FALSE,Unsuspend:=FALSE,Hold:=FALSE,Unhold:=TRUE,Clear:=TRUE,Reset:=TRUE,Start:=TRUE); (*Commands that are overriden by parrent command*)
		ReactTo : EMSynchronisationCmdType := (Abort:=TRUE,Stop:=TRUE,Complete:=TRUE,Suspend:=TRUE,Unsuspend:=TRUE,Hold:=TRUE,Unhold:=TRUE,Clear:=TRUE,Reset:=TRUE,Start:=TRUE); (*Commands that are reacted to by parent*)
		Escalate : EMSynchronisationCmdType := (Abort:=TRUE,Stop:=TRUE,Complete:=TRUE,Suspend:=TRUE,Unsuspend:=TRUE,Hold:=TRUE,Unhold:=FALSE,Clear:=FALSE,Reset:=FALSE,Start:=FALSE); (*Commands that are escalated to the parrent*)
	END_STRUCT;
	EMSynchronisationCmdType : 	STRUCT  (*Em synchronization settings type*)
		Abort : BOOL := FALSE; (*Synchronization setting for command*)
		Stop : BOOL := FALSE; (*Synchronization setting for command*)
		Complete : BOOL := FALSE; (*Synchronization setting for command*)
		Suspend : BOOL := FALSE; (*Synchronization setting for command*)
		Unsuspend : BOOL := FALSE; (*Synchronization setting for command*)
		Hold : BOOL := FALSE; (*Synchronization setting for command*)
		Unhold : BOOL := FALSE; (*Synchronization setting for command*)
		Clear : BOOL := FALSE; (*Synchronization setting for command*)
		Reset : BOOL := FALSE; (*Synchronization setting for command*)
		Start : BOOL := FALSE; (*Synchronization setting for command*)
	END_STRUCT;
	EMInterfaceType : 	STRUCT  (*Interface type*)
		Enable : BOOL; (*Enable Pub/Sub interface*)
		SubscriptionEMName : ARRAY[0..EM_MAX_SUBSCRIPTIONS]OF STRING[255]; (*Name of the Em where we want cyclic user data from*)
		SubscriptionValid : ARRAY[0..EM_MAX_SUBSCRIPTIONS]OF BOOL; (*True if data is valid. Only true if Em name does exist*)
		Publish : EMUserDataPubSubType; (*The local user data that other Em can subscribe to*)
		Subscribe : ARRAY[0..EM_MAX_SUBSCRIPTIONS]OF EMUserDataPubSubType; (*The user data from the remote Em that we are subscribing to*)
	END_STRUCT;
END_TYPE

(*CM*)

TYPE
	CMInternalType : 	STRUCT  (*Internal type of the Cm*)
		state : USINT; (*Internal state*)
		parentEmAddress : UDINT; (*Address of the instance on the heap memory*)
		subscriptionUserDataAddress : ARRAY[0..EM_MAX_SUBSCRIPTIONS]OF UDINT; (*Address of the user data we are currently subscribing to*)
		subscribedToEMName : ARRAY[0..EM_MAX_SUBSCRIPTIONS]OF STRING[255]; (*Name of the Em we are subscribed to*)
		oldState : DINT; (*Old state*)
		oldSubState : DINT; (*Old sub state*)
		cycleTime : REAL; (*Cycle time for the module task class*)
		oldPubSubEnable : BOOL; (*Old Pub/Sub enable*)
	END_STRUCT;
	CMSetupType : 	STRUCT  (*CMSetupType*)
		ParentName : STRING[255]; (*Name of the parent. Leave empty is Em is parent at level 0*)
		Name : STRING[255]; (*Name of the Em. If left empty during first execution, the task name is used as Em name*)
		NameIndex : USINT := EM_MAX_NAME_INDEX;
		AuditStateChange : BOOL := TRUE; (*Log when state is changed*)
		AuditSubStateChange : BOOL := TRUE; (*Log when substate is changed*)
	END_STRUCT;
	CMInfoType : 	STRUCT  (*CMInfoType*)
		CmName : STRING[255]; (*Name of the Cm*)
		ParentName : STRING[255]; (*Name of the Parent Em*)
		ParentEmAddress : UDINT; (*Address of the Em*)
		ParentEmIndex : UDINT; (*Global EM index*)
		ParentStateCurrent : EMPackMLStateEnum; (*Parent Current State*)
		Level : UDINT; (*Level in the hierarchy. Parent is level 0.*)
		TimeInState : REAL; (*The actual time in the current state*)
		TimeInSubState : REAL; (*The actual time in the current sub state*)
		Last : ARRAY[0..EM_MAX_AUDIT_ENTRIES]OF STRING[50]; (*The last state, substate and mode*)
		CycleTime : REAL; (*Cycle Time in seconds*)
		OnStateEntry : BOOL; (*True in first scan after a state change*)
		OnSubStateEntry : BOOL; (*True in first scan after a substate change*)
	END_STRUCT;
	CMInterfaceType : 	STRUCT  (*Interface type*)
		Enable : BOOL; (*Enable Sub interface*)
		SubscriptionEMName : ARRAY[0..EM_MAX_SUBSCRIPTIONS]OF STRING[255]; (*Name of the Em where we want cyclic user data from*)
		SubscriptionValid : ARRAY[0..EM_MAX_SUBSCRIPTIONS]OF BOOL; (*True if data is valid. Only true if Em name does exist*)
		Subscribe : ARRAY[0..EM_MAX_SUBSCRIPTIONS]OF EMUserDataPubSubType; (*The user data from the remote Em that we are subscribing to*)
	END_STRUCT;
END_TYPE

(******* USER DEFINED *******)

TYPE
	EMUserDataPubSubType : 	STRUCT  (*Local / Remote user data. This datatype can be expanded to fit the needs of the application*)
		State : EMPackMLStateEnum;
		SubState : DINT;
		StateComplete : BOOL;
		CmdAbortCounter : UDINT;
		CmdStopCounter : UDINT;
		Priority : UDINT;
		PrioritySC : BOOL;
	END_STRUCT;
END_TYPE
