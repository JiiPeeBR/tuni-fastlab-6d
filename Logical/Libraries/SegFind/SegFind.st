FUNCTION_BLOCK Positioner
	// We are not done
	Done := FALSE;
	
	// Get position
	X_Pos := Position.X;
	Y_Pos := Position.Y;
	
	// Then the position in segments
	Column := REAL_TO_USINT(brmceil(X_Pos / 0.24));
	Row := REAL_TO_USINT(brmceil(Y_Pos / 0.24));
	
	// Default
	Segment := 0;
	
	// Then we need to figure out which segment it is (welcome to switch-case -hell)
	CASE Column OF
		1:
			CASE Row OF
				1:
					Segment := 1;
				2:
					Segment := 2;
				7:
					Segment := 3;
				8:
					Segment := 4;
				13:
					Segment := 5;
				14:
					Segment := 6;
				19:
					Segment := 7;
				20:
					Segment := 8;
					
			END_CASE;
		2:
			Segment := 8 + Row;
		3:
			Segment := 28 + Row;
		4:
			CASE Row OF
				1:
					Segment := 49;
				2:
					Segment := 50;
				7:
					Segment := 51;
				8:
					Segment := 52;
				13:
					Segment := 53;
				14:
					Segment := 54;
				19:
					Segment := 55;
				20:
					Segment := 56;
					
			END_CASE;
	END_CASE;
	
	// Now we are
	Done := TRUE;
END_FUNCTION_BLOCK