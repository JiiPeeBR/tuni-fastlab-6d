
FUNCTION_BLOCK ControlModule (*Control module implementation for OMAC PackML*)
	VAR_INPUT
		Setup : CMSetupType; (*Local setup*) (* *) (*#PAR#;*)
		Interface : CMInterfaceType; (*Publish/Subscribe Interface between Equipment Modules *)
		StateInfo : STRING[255]; (*Status of what the substate is doing or waiting for. Will also be used for logging.*) (* *) (*#CYC#;*)
		State : DINT; (*Control Module state*)
		SubState : DINT := 0; (*The sub state of the module. Can be used for programming the sequence inside a PackML state. Will automatically be reset to 0 by a PackML state change.*) (* *) (*#CYC#;*)
	END_VAR
	VAR_OUTPUT
		Info : CMInfoType; (*Additional information about the component*) (* *) (*#CMD#; *)
	END_VAR
	VAR
		Internal : CMInternalType; (*Internal variables*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK EquipmentModule (*Synchronized PackML state machine handling*) (* $GROUP=mapp Services,$CAT=OMAC PackML,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpPackML.png *)
	VAR_INPUT
		Setup : EMSetupType; (*Local setup*) (* *) (*#PAR#;*)
		Interface : EMInterfaceType; (*Publish/Subscribe Interface between Equipment Modules *)
		SetModeID : DINT := 1; (*Change the packML mode*)
		StateInfo : STRING[255]; (*Status of what the substate is doing or waiting for. Will also be used for logging.*) (* *) (*#CYC#;*)
		Command : EMCommandType; (*Control commands from ISA-TR88.00.02 commands.*) (* *) (*#CMD#;*)
		SubState : DINT := 0; (*The sub state of the module. Can be used for programming the sequence inside a PackML state. Will automatically be reset to 0 by a PackML state change.*) (* *) (*#CYC#;*)
	END_VAR
	VAR_OUTPUT
		StateCurrent : EMPackMLStateEnum := STATE_UNDEFINED; (*Current state*) (* *) (*#CMD#;*)
		ModeID : EMPackMLModeEnum := MODE_PRODUCTION; (*The current mode*) (* *) (*#CMD#;*)
		Info : EMInfoType; (*Additional information about the component*) (* *) (*#CMD#; *)
	END_VAR
	VAR
		Internal : EMInternalType; (*Internal variables*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION EMGetModuleAdrByIdx : UDINT (*Returns the address of an Equipment Module on the heap based on the index*)
	VAR_INPUT
		EmIdx : UDINT; (*Index of the Equipment Module*)
	END_VAR
END_FUNCTION

FUNCTION EMGetModuleIdxByName : UDINT (*Returns the index for an Em with the specified name*)
	VAR_INPUT
		EmName : STRING[255]; (*Name of the Equipment Module*)
	END_VAR
END_FUNCTION

FUNCTION EMGetModuleAdrByName : UDINT (*Returns the address of an Equipment Module on the heap based on its name*)
	VAR_INPUT
		EmName : STRING[255]; (*Name of the Equipment Module*)
	END_VAR
END_FUNCTION

FUNCTION EMGetNumberOfModules : UDINT (*Returns the number of Equipment Modules*)
END_FUNCTION

FUNCTION EMGetNumberOfRootModules : UDINT (*Returns the number of root modules. A root module is an Equipment Module with Level 0*)
END_FUNCTION

FUNCTION EMGetWaitingForByIdx : BOOL (*Get WaitingFor from hierarchy index. Returns true on success*)
	VAR_INPUT
		EmIdx : UDINT; (*Index of the root*)
		WaitingFor : EMStatusType; (*EMStatusType*)
	END_VAR
END_FUNCTION

FUNCTION EMGetInterruptedByByIdx : BOOL (*Get InterruptedBy from hierarchy index. Returns true on success*)
	VAR_INPUT
		EmIdx : UDINT; (*Index of the root*)
		InterruptedBy : EMStatusType; (*EMStatusType*)
	END_VAR
END_FUNCTION

FUNCTION EMGetModuleStatus : BOOL (*Get the status from any Equipment Module using the memory address. Returns true on success*)
	VAR_INPUT
		EmAddress : UDINT; (*Address of the Equipment Module*)
		EMStatus : EMStatusType; (*EMStatusType*)
	END_VAR
END_FUNCTION

FUNCTION EMGetModuleStatusByName : BOOL (*Get the status from any Equipment Module using the configured name. Returns true on success*)
	VAR_INPUT
		EmName : STRING[255]; (*Name of the Equipment Module*)
		EMStatus : EMStatusType; (*EMStatusType*)
	END_VAR
END_FUNCTION

FUNCTION EMGetModuleStatusByIdx : BOOL (*Get the status from any Equipment Module using an index. Returns true on success*)
	VAR_INPUT
		EmIdx : UDINT; (*Index of the Equipment Module*)
		EMStatus : EMStatusType; (*EMStatusType*)
	END_VAR
END_FUNCTION

FUNCTION EMGetParentAdr : UDINT (*Returns the address of the parent Equipment Module on the heap*)
	VAR_INPUT
		EmAddress : UDINT; (*Address of the Equipment Module*)
	END_VAR
END_FUNCTION

FUNCTION EMGetChildrenAdrByIdx : UDINT (*Returns the address of a child Equipment Module using an index*)
	VAR_INPUT
		EmAddress : UDINT; (*Address of the Equipment Module*)
		EmIdx : UDINT; (*Index of the child Equipment Module*)
	END_VAR
END_FUNCTION

FUNCTION EMGetSiblingAdrByIdx : UDINT (*Returns the address of a sibling Equipment Module using an index*)
	VAR_INPUT
		EmAddress : UDINT; (*Address of the Equipment Module*)
		EmIdx : UDINT; (*Index of the sibling Equipment Module*)
	END_VAR
END_FUNCTION

FUNCTION EMGetRootAdrByIdx : UDINT (*Returns the address of a root Equipment Module using an index*)
	VAR_INPUT
		EmIdx : UDINT; (*Index of a root Equipment Module*)
	END_VAR
END_FUNCTION

FUNCTION EMGetUserDataAdr : UDINT (*Returns the address of the published userdata from a remote Equipment Module*)
	VAR_INPUT
		EmAddress : UDINT; (*Address of the Equipment Module*)
	END_VAR
END_FUNCTION

FUNCTION EMSetCommand : BOOL (*Send a command to an Equipment Module using its address. Returns true on success*)
	VAR_INPUT
		EmAddress : UDINT; (*Address of the remote Equipment Module to receive the command*)
		EmAddressInterrupter : UDINT; (*Address of the local Equipment Module interrupting the remote Em *)
		Command : EMPackMLCmdEnum; (*Command*)
	END_VAR
END_FUNCTION

FUNCTION EMSetMode : BOOL (*Function changing the mode of an Equipment Module*) (* $GROUP=mapp Services,$CAT=OMAC PackML,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpPackML.png *)
	VAR_INPUT
		EmAddress : UDINT; (*Address of the target Equipment Module*)
		Mode : DINT; (*Desired mode to change to. The mode must be defined in the mppackmlcore configuration*) (* *) (*#PAR#;*)
	END_VAR
END_FUNCTION

FUNCTION EMSetModeByName : BOOL (*Function changing the mode of an Equipment Module*) (* $GROUP=mapp Services,$CAT=OMAC PackML,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpPackML.png *)
	VAR_INPUT
		EmName : STRING[255]; (*Name of the target Equipment Module*)
		Mode : DINT; (*Desired mode to change to. *) (* *) (*#PAR#;*)
	END_VAR
END_FUNCTION
