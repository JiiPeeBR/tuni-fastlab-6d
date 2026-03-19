FUNCTION_BLOCK CenterMover
	// We are not done
	Done := FALSE;
	
	// Initialize, so we don't have empty values
	MoveCommand.X := 0;
	MoveCommand.Y := 0;
	
	// Once again, welcome to if-else -hell
	IF Segment >= 1 AND Segment <= 8 THEN
		MoveCommand.X := 120;
		CASE Segment OF
			1:
				MoveCommand.Y := 120;
			2:
				MoveCommand.Y := 360;
			3:
				MoveCommand.Y := 1560;
			4:
				MoveCommand.Y := 1800;
			5:
				MoveCommand.Y := 3000;
			6:
				MoveCommand.Y := 3240;
			7:
				MoveCommand.Y := 4440;
			8:
				MoveCommand.Y := 4680;
		END_CASE;
	ELSIF Segment <= 28 THEN
		MoveCommand.X := 360;
		MoveCommand.Y := 240*(Segment-9) + 120;
	ELSIF Segment <= 48 THEN
		MoveCommand.X := 600;
		MoveCommand.Y := 240*(Segment-29) + 120;
	ELSIF Segment >= 49 THEN
		MoveCommand.X := 840;
		CASE Segment OF
			49:
				MoveCommand.Y := 120;
			50:
				MoveCommand.Y := 360;
			51:
				MoveCommand.Y := 1560;
			52:
				MoveCommand.Y := 1800;
			53:
				MoveCommand.Y := 3000;
			54:
				MoveCommand.Y := 3240;
			55:
				MoveCommand.Y := 4440;
			56:
				MoveCommand.Y := 4680;
		END_CASE;
	END_IF;
	
	// I forgot that these are in meters, not millimeters :))))
	MoveCommand.X := MoveCommand.X / 1000;
	MoveCommand.Y := MoveCommand.Y / 1000;
	
	// Now we are
	Done := TRUE;
	END_FUNCTION_BLOCK
