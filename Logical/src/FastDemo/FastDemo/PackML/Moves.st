// Move In Plane
// -------------------------------------------------------------------------------------------------------------------
ACTION MoveInPlane_WaitDone:
	pStation.Commands.MoveInPlane := TRUE;
			
	IF pStation.Operation.MoveInPlane.Done THEN
		pStation.State := pStation.State + 1;
	END_IF;	
END_ACTION

ACTION MoveInPlane_AddToBuffer:
	pStation.Commands.MoveInPlane := TRUE;
	
	IF pStation.Operation.MoveInPlane.Acknowledge THEN
		pStation.State := pStation.State + 1;
	END_IF;
END_ACTION


