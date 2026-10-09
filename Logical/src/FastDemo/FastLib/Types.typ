
TYPE
	fdMove6DSyncParametersType : 	STRUCT 
		Position : McAcp6DShPositionType;
		Velocity : fdMove6DSyncAllAxesType;
		Acceleration : fdMove6DSyncAllAxesType;
		Mode : McAcp6DMoveModeEnum;
	END_STRUCT;
	fdMove6DSyncAllAxesType : 	STRUCT 
		InPlane : REAL;
		Z : REAL;
		Rx : REAL;
		Ry : REAL;
		Rz : REAL;
	END_STRUCT;
	fdMove6DSyncMemberType : 	STRUCT 
		DistanceToTarget : fdMove6DSyncAllAxesType;
		TimeToTarget : fdMove6DSyncAllAxesType;
		TimeToEndVelocity : fdMove6DSyncAllAxesType;
		LongestTimeToTarget : REAL;
		TargetVelocity : fdMove6DSyncAllAxesType;
		PositionUpdatePending : BOOL;
	END_STRUCT;
END_TYPE

(**)
(*Stations*)

TYPE
	fdStationParametersType : 	STRUCT 
		StationNumber : DINT;
		ShuttleCapacity : UINT;
		CreateVirtualShuttle : BOOL;
		Zone : fdStationParametersZoneType;
		MacroName : STRING[32];
	END_STRUCT;
	fdStationParametersZoneType : 	STRUCT 
		Name : STRING[32];
		BottomLeft : McAcp6DInPlaneAxesType;
		TopRight : McAcp6DInPlaneAxesType;
	END_STRUCT;
	fdStationOperationType : 	STRUCT 
		Shuttle : MpTrafficShuttleInfoType;
		CommandLabel : fdStationOperationCmdLabelType;
		MoveInPlane : McAcp6DInPlaneParType;
		MoveArc : McAcp6DArcParType;
		Spin : McAcp6DRotaryMotionSpinParType;
		Move6D : McAcp6DMove6DParType;
		MoveShortAxis : McAcp6DShortAxParType;
		WaitCommandLabel : fdStationCmdLbParType;
	END_STRUCT;
	fdStationOperationCmdLabelType : 	STRUCT 
		ManualMode : BOOL;
		Label : UINT;
	END_STRUCT;
	fdStationCmdLbParType : 	STRUCT 
		TriggerShuttleID : UINT;
		TriggerCmdLb : UINT;
		TriggerType : McAcp6DShWaitCmdLbTriggerEnum;
		LabelType : McAcp6DShWaitCmdLbLabelEnum;
	END_STRUCT;
	fdStationShuttlesType : 	STRUCT 
		Count : UINT;
		List : ARRAY[0..fdSTATION_SHUTTLE_LAST_INDEX]OF MpTrafficShuttleInfoType;
	END_STRUCT;
	fdStationCommandsType : 	STRUCT 
		AddShuttle : BOOL;
		ErrorReset : BOOL;
		ReleaseAllShuttles : BOOL;
		MoveInPlane : BOOL;
		MoveArc : BOOL;
		MoveShortAxis : BOOL;
		Move6D : BOOL;
		Spin : BOOL;
		SunPlanet : fdStationCommandsSunPlanetType;
		Group : fdStationCommandsGroupType;
		WaitCommandLabel : BOOL;
		WaitUntilAllDone : BOOL;
		MacroRun : BOOL;
		MacroSave : BOOL;
	END_STRUCT;
	fdStationMemberCommandType : 	STRUCT 
		Input : fdStationCommandsType;
		GroupCreate : BOOL;
		GroupAddShuttle : BOOL;
		GroupClear : BOOL;
		GroupDelete : BOOL;
		VirtualShuttleCreate : BOOL;
		GetShuttleInfo : BOOL;
		MacroCreate : BOOL;
		MacroDelete : BOOL;
		ZoneCreate : BOOL;
		ZoneGetBarrierInfo : BOOL;
		ZoneFind : BOOL;
	END_STRUCT;
	fdStationMemberStatusType : 	STRUCT 
		CommandDone : BOOL;
		CommandAcknowdledge : BOOL;
		CommandError : BOOL;
		ErrorID : DINT;
	END_STRUCT;
	fdStationMemberVarType : 	STRUCT 
		SequenceStatePrevious : DINT;
		StateChanged : BOOL;
		ZoneIsEmpty : BOOL;
		Shuttles : fdStationShuttlesType;
		MacroShuttle : MpTrafficShuttleInfoType;
		ShuttleGroup : Mc6DShuttleGroupType;
		ErroredSequenceState : DINT;
		NoCommands : fdStationCommandsType;
		NoCommandActive : BOOL;
		str : STRING[80];
		index : DINT;
		CommandLabel : UINT;
		rNextState : R_TRIG;
		rGoToState : R_TRIG;
	END_STRUCT;
	fdStationMemberControlType : 	STRUCT 
		StationControl : MpTrafficStationControl;
		StationQueueControl : fdStationQueueControl;
		VirtualShuttleCreate : MC_BR_VirtualShCreate_Acp6D;
		GetShuttleInfo : MC_BR_ShGetInfo_Acp6D;
		Enable_EdgeNegative : F_TRIG;
	END_STRUCT;
	fdStationMemberGroupType : 	STRUCT 
		Create : MC_BR_ShGroupCreate_Acp6D;
		Clear : MC_BR_ShGroupClear_Acp6D;
		Delete : MC_BR_ShGroupDelete_Acp6D;
		CoupleCtrl : MC_BR_ShGroupCoupleCtrl_Acp6D;
		AddShuttle : MC_BR_ShGroupAddShuttle_Acp6D;
	END_STRUCT;
	fdStationMemberZoneType : 	STRUCT 
		Zone : Mc6DZoneType;
		Create : MC_BR_ZoneCreate_Acp6D;
		GetBarrierInfo : MC_BR_ZoneGetBarrierInfo_Acp6D;
		Find : fdFindZone;
	END_STRUCT;
	fdStationMemberMacroType : 	STRUCT 
		Create : MC_BR_MacroCreate_Acp6D;
		Delete : MC_BR_MacroDelete_Acp6D;
		Save : MC_BR_MacroSave_Acp6D;
		Run : MC_BR_MacroRun_Acp6D;
	END_STRUCT;
	fdStationMemberMoveType : 	STRUCT 
		MoveInPlane : MC_BR_MoveInPlane_Acp6D;
		MoveArc : MC_BR_MoveArc_Acp6D;
		Spin : MC_BR_RotaryMotionSpin_Acp6D;
		Move6D : MC_BR_Move6D_Acp6D;
		MoveShortAxis : MC_BR_MoveShortAxis_Acp6D;
		WaitCommandLabel : MC_BR_ShWaitCmdLb_Acp6D;
		WaitUntilAllDone : fdWaitUntilAllDone;
		SunPlanet : MC_BR_ShPlanet_Acp6D;
	END_STRUCT;
	fdStationCommandsSunPlanetType : 	STRUCT 
		Couple : BOOL;
		Decouple : BOOL;
	END_STRUCT;
	fdStationCommandsGroupType : 	STRUCT 
		Couple_OwnCenterPoint : BOOL;
		Couple_CommonCenterPoint : BOOL;
		Decouple : BOOL;
	END_STRUCT;
END_TYPE
