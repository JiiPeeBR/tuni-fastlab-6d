
ACTION reset_parameters_all:
	reset_parameters_MoveInPlane;
	reset_parameters_MoveShortAxis;
	reset_parameters_MoveArc;
	reset_parameters_Move6D;
END_ACTION

ACTION reset_parameters_MoveInPlane:
	brsmemset(ADR(station.Operation.MoveInPlane.Parameters), 0, SIZEOF(station.Operation.MoveInPlane.Parameters));
	
	station.Operation.MoveInPlane.CommandLabel := 0;
	station.Operation.MoveInPlane.Parameters.Velocity := 1.5;
	station.Operation.MoveInPlane.Parameters.Acceleration := 18;
	station.Operation.MoveInPlane.Parameters.EndVelocity := 0;
	station.Operation.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_DIRECT;
	station.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_ABSOLUTE;
END_ACTION

ACTION reset_parameters_MoveShortAxis:
	brsmemset(ADR(station.Operation.MoveShortAxis.Parameters), 0, SIZEOF(station.Operation.MoveShortAxis.Parameters));

	station.Operation.MoveShortAxis.CommandLabel := 0;
	station.Operation.MoveShortAxis.Parameters.Velocity.Rx := 0.1;
	station.Operation.MoveShortAxis.Parameters.Velocity.Ry := 0.1;
	station.Operation.MoveShortAxis.Parameters.Velocity.Rz := 0.1;
	station.Operation.MoveShortAxis.Parameters.Velocity.Z := 0.005;
	station.Operation.MoveShortAxis.Parameters.Position.Rx := 0;
	station.Operation.MoveShortAxis.Parameters.Position.Ry:= 0;
	station.Operation.MoveShortAxis.Parameters.Position.Rz := 0;
	station.Operation.MoveShortAxis.Parameters.Position.Z := gDEFAULT_Z;
	station.Operation.MoveShortAxis.Parameters.Mode := mcACP6D_MOVE_ABSOLUTE;
END_ACTION

ACTION reset_parameters_MoveArc:
	brsmemset(ADR(station.Operation.MoveArc.Parameters), 0, SIZEOF(station.Operation.MoveArc.Parameters));
	
	station.Operation.MoveArc.CommandLabel := 0;
	station.Operation.MoveArc.Parameters.Velocity := 1.5;
	station.Operation.MoveArc.Parameters.Acceleration := 18;
	station.Operation.MoveArc.Parameters.EndVelocity := 0;
	station.Operation.MoveArc.Parameters.Angular.Angle := 0;
	station.Operation.MoveArc.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
	station.Operation.MoveArc.Parameters.Option := mcACP6D_ARC_ANGULAR;
END_ACTION

ACTION reset_parameters_Move6D:
	
END_ACTION

ACTION reset_parameters_WaitCommandLabel:
	station.Operation.WaitCommandLabel.LabelType :=  mcACP6D_SH_WAIT_CMDLB_REGULAR;
	station.Operation.WaitCommandLabel.TriggerCmdLb := 0;
	station.Operation.WaitCommandLabel.TriggerType := mcACP6D_SH_WAIT_CMDLB_START;
	station.Operation.WaitCommandLabel.TriggerXID := 0;
END_ACTION

