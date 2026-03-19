
FUNCTION_BLOCK Positioner
	VAR_INPUT
		Position : McAcp6DShPositionType;
	END_VAR
	VAR_OUTPUT
		Segment : USINT;
	END_VAR
	VAR
		X_Pos : REAL;
		Y_Pos : REAL;
		Row : USINT;
		Column : USINT;
	END_VAR
	VAR_INPUT
		Execute : BOOL;
	END_VAR
	VAR_OUTPUT
		Done : BOOL;
	END_VAR
END_FUNCTION_BLOCK
