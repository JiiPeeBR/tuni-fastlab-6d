
ACTION reset_parameters_all:
	reset_parameters_MoveInPlane;
	reset_parameters_MoveShortAxis;
	reset_parameters_MoveArc;
	reset_parameters_Move6D;
END_ACTION

ACTION reset_parameters_MoveInPlane:
	brsmemset(ADR(pStation.Operation.MoveInPlane.Parameters), 0, SIZEOF(pStation.Operation.MoveInPlane.Parameters));
	
	pStation.Operation.MoveInPlane.CommandLabel := 0;
	pStation.Operation.MoveInPlane.Parameters.Velocity := 1.5;
	pStation.Operation.MoveInPlane.Parameters.Acceleration := 18;
	pStation.Operation.MoveInPlane.Parameters.EndVelocity := 0;
	pStation.Operation.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_DIRECT;
	pStation.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_ABSOLUTE;
END_ACTION

ACTION reset_parameters_MoveShortAxis:
	brsmemset(ADR(pStation.Operation.MoveShortAxis.Parameters), 0, SIZEOF(pStation.Operation.MoveShortAxis.Parameters));

	pStation.Operation.MoveShortAxis.CommandLabel := 0;
	pStation.Operation.MoveShortAxis.Parameters.Velocity.Rx := 0.1;
	pStation.Operation.MoveShortAxis.Parameters.Velocity.Ry := 0.1;
	pStation.Operation.MoveShortAxis.Parameters.Velocity.Rz := 0.1;
	pStation.Operation.MoveShortAxis.Parameters.Velocity.Z := 0.005;
	pStation.Operation.MoveShortAxis.Parameters.Position.Rx := 0;
	pStation.Operation.MoveShortAxis.Parameters.Position.Ry:= 0;
	pStation.Operation.MoveShortAxis.Parameters.Position.Rz := 0;
	pStation.Operation.MoveShortAxis.Parameters.Position.Z := gDEFAULT_Z;
	pStation.Operation.MoveShortAxis.Parameters.Mode := mcACP6D_MOVE_ABSOLUTE;
END_ACTION

ACTION reset_parameters_MoveArc:
	brsmemset(ADR(pStation.Operation.MoveArc.Parameters), 0, SIZEOF(pStation.Operation.MoveArc.Parameters));
	
	pStation.Operation.MoveArc.CommandLabel := 0;
	pStation.Operation.MoveArc.Parameters.Velocity := 1.5;
	pStation.Operation.MoveArc.Parameters.Acceleration := 18;
	pStation.Operation.MoveArc.Parameters.EndVelocity := 0;
	pStation.Operation.MoveArc.Parameters.Angular.Angle := 0;
	pStation.Operation.MoveArc.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
	pStation.Operation.MoveArc.Parameters.Option := mcACP6D_ARC_ANGULAR;
END_ACTION

ACTION reset_parameters_Move6D:
	
END_ACTION

ACTION reset_parameters_WaitCommandLabel:
	pStation.Operation.WaitCommandLabel.LabelType :=  mcACP6D_SH_WAIT_CMDLB_REGULAR;
	pStation.Operation.WaitCommandLabel.TriggerCmdLb := 0;
	pStation.Operation.WaitCommandLabel.TriggerType := mcACP6D_SH_WAIT_CMDLB_START;
	pStation.Operation.WaitCommandLabel.TriggerXID := 0;
END_ACTION

