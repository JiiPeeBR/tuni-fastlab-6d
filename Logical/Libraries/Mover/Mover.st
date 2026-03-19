FUNCTION_BLOCK Mover
	// We are not done
	Done := FALSE;
	
	// Initialize, so we don't have empty values
	MoveCommand.X := 0;
	MoveCommand.Y := 0;
	
	// Let's try stuff
	IF Segment = 1 THEN
		MoveCommand.X := 0.72;
		MoveCommand.Y := 0;
	ELSIF Segment <= 8 THEN
		MoveCommand.X := 0.24 * (Segment MOD 2);
		MoveCommand.Y := -0.24 * (1 - (Segment MOD 2));
	ELSIF (Segment = 10) OR (Segment = 16) OR (Segment = 22) THEN
		MoveCommand.X := -0.24;
		MoveCommand.Y := 0;
	ELSIF (Segment >= 11) AND (Segment <= 27) THEN
		MoveCommand.X := 0;
		MoveCommand.Y := 0.24*(5 - ((Segment - 6*REAL_TO_USINT(brmceil((Segment - 3)/6))+2) MOD 6)) - 1.2;
	ELSIF (Segment = 35) OR (Segment = 41) OR (Segment = 47) THEN
		MoveCommand.X := 0.24;
		MoveCommand.Y := 0;
	ELSIF (Segment >= 30) AND (Segment <= 46) THEN
		MoveCommand.X := 0;
		MoveCommand.Y := 1.2 - 0.24*((Segment - 6*REAL_TO_USINT(brmceil((Segment - 3)/6))) MOD 6);
	ELSIF (Segment >= 49) AND (Segment <= 55) THEN
		MoveCommand.X := -0.24 * (1 - (Segment MOD 2));
		MoveCommand.Y := 0.24 * (Segment MOD 2);
	ELSIF Segment = 56 THEN
		MoveCommand.X := -0.72;
		MoveCommand.Y := 0;
	ELSIF Segment = 9 THEN    // Everything after this is just ductape and dreams
		MoveCommand.X := 0.48;
		MoveCommand.Y := 0;
	ELSIF Segment = 29 THEN
		MoveCommand.X := 0.24;
		MoveCommand.Y := 0;
	ELSIF Segment = 28 THEN
		MoveCommand.X := -0.24;
		MoveCommand.Y := 0;
	ELSIF Segment = 48 THEN
		MoveCommand.X := -0.48;
		MoveCommand.Y := 0;
	END_IF;
	
	// Now we are
	Done := TRUE;
END_FUNCTION_BLOCK
