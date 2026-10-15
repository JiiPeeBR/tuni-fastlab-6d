
TYPE
	EndToEndFbType : 	STRUCT 
		MpRecipeRegPar_settings : BOOL;
		rtStateComplete : R_TRIG;
		R_TRIG_Abort : R_TRIG;
		MoveInPlaneAsync : MC_BR_MoveInPlaneAsync_Acp6D;
	END_STRUCT;
	EndToEndLocalType : 	STRUCT 
		lastState : DINT;
		lastSubState : DINT;
		lastStateInfo : STRING[80];
		Target1 : ARRAY[0..gMAX_INDEX_SHUTTLE]OF McAcp6DInPlaneAxesType;
		Target2 : ARRAY[0..gMAX_INDEX_SHUTTLE]OF McAcp6DInPlaneAxesType;
	END_STRUCT;
	EndToEndActionsStateType : 	STRUCT 
		ErrorReset : BOOL;
	END_STRUCT;
	EndToEndActionsSubstateType : 	STRUCT 
		MoveInPlaneAsync : BOOL;
	END_STRUCT;
	EndToEndHmiType : 	STRUCT 
		isRunning : BOOL;
	END_STRUCT;
END_TYPE

(**)
