// Move In Plane
// -------------------------------------------------------------------------------------------------------------------
ACTION MoveInPlane_WaitDone:
	station.Commands.MoveInPlane := TRUE;
			
	IF station.Operation.MoveInPlane.Done THEN
		station.State := station.State + 1;
	END_IF;	
END_ACTION

ACTION MoveInPlane_AddToBuffer:
	station.Commands.MoveInPlane := TRUE;
	
	IF station.Operation.MoveInPlane.Acknowledge THEN
		station.State := station.State + 1;
	END_IF;
END_ACTION


