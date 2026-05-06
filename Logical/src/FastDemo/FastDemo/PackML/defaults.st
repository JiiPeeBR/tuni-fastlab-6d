ACTION set_movement_parameters_to_default_values:
	// Move in plane
	brsmemset(ADR(station.Operation.MoveInPlane), 0, SIZEOF(station.Operation.MoveInPlane));
	station.Operation.MoveInPlane.Velocity := 1.5;
	station.Operation.MoveInPlane.Acceleration := 18;
	station.Operation.MoveInPlane.EndVelocity := 0;
	station.Operation.MoveInPlane.Path := mcACP6D_PATH_DIRECT;
	station.Operation.MoveInPlane.Mode := mcACP6D_MOVE_ABSOLUTE;
	
	// Move short axis
	brsmemset(ADR(station.Operation.MoveShortAxis), 0, SIZEOF(station.Operation.MoveShortAxis));
	station.Operation.MoveShortAxis.Velocity.Rx := 0.1;
	station.Operation.MoveShortAxis.Velocity.Ry := 0.1;
	station.Operation.MoveShortAxis.Velocity.Rz := 0.1;
	station.Operation.MoveShortAxis.Velocity.Z := 0.005;
	station.Operation.MoveShortAxis.Position.Rx := 0;
	station.Operation.MoveShortAxis.Position.Ry:= 0;
	station.Operation.MoveShortAxis.Position.Rz := 0;
	station.Operation.MoveShortAxis.Position.Z := gDEFAULT_Z;
	station.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_ABSOLUTE;
	
	// Move arc
	brsmemset(ADR(station.Operation.MoveArc), 0, SIZEOF(station.Operation.MoveArc));
	station.Operation.MoveArc.Velocity := 1.5;
	station.Operation.MoveArc.Acceleration := 18;
	station.Operation.MoveArc.EndVelocity := 0;
	station.Operation.MoveArc.Angular.Angle := 0;
	station.Operation.MoveArc.Option := mcACP6D_ARC_ANGULAR;
	station.Operation.MoveArc.Mode :=  mcACP6D_MOVE_RELATIVE;
	
	// Move 6D
	brsmemset(ADR(station.Operation.Move6D), 0, SIZEOF(station.Operation.Move6D));
	
	// Wait command label
	station.Operation.WaitCommandLabel.LabelType :=  mcACP6D_SH_WAIT_CMDLB_REGULAR;
	station.Operation.WaitCommandLabel.TriggerCmdLb := 0;
	station.Operation.WaitCommandLabel.TriggerType := mcACP6D_SH_WAIT_CMDLB_START;
	station.Operation.WaitCommandLabel.TriggerShuttleID := 0;
	
END_ACTION

