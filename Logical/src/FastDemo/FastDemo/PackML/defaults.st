ACTION set_movement_parameters_to_default_values:
	// Move in plane
	brsmemset(ADR(pStation.Operation.MoveInPlane), 0, SIZEOF(pStation.Operation.MoveInPlane));
	pStation.Operation.MoveInPlane.Velocity := 1.5;
	pStation.Operation.MoveInPlane.Acceleration := 18;
	pStation.Operation.MoveInPlane.EndVelocity := 0;
	pStation.Operation.MoveInPlane.Path := mcACP6D_PATH_DIRECT;
	pStation.Operation.MoveInPlane.Mode := mcACP6D_MOVE_ABSOLUTE;
	
	// Move short axis
	brsmemset(ADR(pStation.Operation.MoveShortAxis), 0, SIZEOF(pStation.Operation.MoveShortAxis));
	pStation.Operation.MoveShortAxis.Velocity.Rx := 0.1;
	pStation.Operation.MoveShortAxis.Velocity.Ry := 0.1;
	pStation.Operation.MoveShortAxis.Velocity.Rz := 0.1;
	pStation.Operation.MoveShortAxis.Velocity.Z := 0.005;
	pStation.Operation.MoveShortAxis.Position.Rx := 0;
	pStation.Operation.MoveShortAxis.Position.Ry:= 0;
	pStation.Operation.MoveShortAxis.Position.Rz := 0;
	pStation.Operation.MoveShortAxis.Position.Z := gDEFAULT_Z;
	pStation.Operation.MoveShortAxis.Mode := mcACP6D_MOVE_ABSOLUTE;
	
	// Move arc
	brsmemset(ADR(pStation.Operation.MoveArc), 0, SIZEOF(pStation.Operation.MoveArc));
	pStation.Operation.MoveArc.Velocity := 1.5;
	pStation.Operation.MoveArc.Acceleration := 18;
	pStation.Operation.MoveArc.EndVelocity := 0;
	pStation.Operation.MoveArc.Angular.Angle := 0;
	pStation.Operation.MoveArc.Option := mcACP6D_ARC_ANGULAR;
	pStation.Operation.MoveArc.Mode :=  mcACP6D_MOVE_RELATIVE;
	
	// Move 6D
	brsmemset(ADR(pStation.Operation.Move6D), 0, SIZEOF(pStation.Operation.Move6D));
	
	// Wait command label
	pStation.Operation.WaitCommandLabel.LabelType :=  mcACP6D_SH_WAIT_CMDLB_REGULAR;
	pStation.Operation.WaitCommandLabel.TriggerCmdLb := 0;
	pStation.Operation.WaitCommandLabel.TriggerType := mcACP6D_SH_WAIT_CMDLB_START;
	pStation.Operation.WaitCommandLabel.TriggerShuttleID := 0;
	
END_ACTION

