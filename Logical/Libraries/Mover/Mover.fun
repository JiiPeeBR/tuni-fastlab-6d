
FUNCTION_BLOCK QuarterMover
	VAR_INPUT
		Position : McAcp6DShPositionType;
		SegmentPosition : MoveCommandType;
		Execute : BOOL;
	END_VAR
	VAR
		XDiff : REAL;
		YDiff : REAL;
	END_VAR
	VAR_OUTPUT
		MoveCommand : MoveCommandType;
		Done : BOOL;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK CenterMover
	VAR_INPUT
		Segment : USINT;
		Execute : BOOL;
	END_VAR
	VAR_OUTPUT
		MoveCommand : MoveCommandType;
		Done : BOOL;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK Mover
	VAR_INPUT
		Segment : USINT;
		Execute : BOOL;
	END_VAR
	VAR_OUTPUT
		MoveCommand : MoveCommandType;
		Done : BOOL;
	END_VAR
END_FUNCTION_BLOCK
