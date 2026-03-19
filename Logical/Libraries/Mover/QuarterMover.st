FUNCTION_BLOCK QuarterMover
	// We are not done
	Done := FALSE;
	
	// Initialize, so we don't have empty values
	MoveCommand.X := SegmentPosition.X;
	MoveCommand.Y := SegmentPosition.Y;
	
	// Let's determine where in relation to the center the segment is
	XDiff := Position.X - SegmentPosition.X;
	YDiff := Position.Y - SegmentPosition.Y;
	
	// Then the good old if-else -hell :)
	IF (XDiff < 0) AND (YDiff < 0) THEN
		MoveCommand.X := MoveCommand.X - 0.06;
		MoveCommand.Y := MoveCommand.Y - 0.06;
	ELSIF (XDiff < 0) AND (YDiff > 0) THEN
		MoveCommand.X := MoveCommand.X - 0.06;
		MoveCommand.Y := MoveCommand.Y + 0.06;
	ELSIF (XDiff > 0) AND (YDiff < 0) THEN
		MoveCommand.X := MoveCommand.X + 0.06;
		MoveCommand.Y := MoveCommand.Y - 0.06;
	ELSIF (XDiff > 0) AND (YDiff > 0) THEN
		MoveCommand.X := MoveCommand.X + 0.06;
		MoveCommand.Y := MoveCommand.Y + 0.06;
	END_IF;
	
	// Now we are
	Done := TRUE;
	END_FUNCTION_BLOCK
