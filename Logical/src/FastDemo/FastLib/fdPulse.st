
(*  *)
FUNCTION_BLOCK fdPulse

	IF NOT Execute THEN
		state := 0;
	END_IF;
	
	CASE state OF
		0:
			IF Execute THEN
				state := 10;
			END_IF;
		10:
			IF TON_on.Q THEN
	  			state := 20;
			END_IF;
		20:
			IF TON_off.Q THEN
				state := 10;
			END_IF;
		100:		
			IF NOT Execute THEN
				state := 0;
			END_IF;	
	END_CASE;
	
	TON_on.IN := (state = 10);
	TON_on.PT := T_on;
	TON_on();
	
	TON_off.IN := (state = 20);
	TON_off.PT := T_off;
	TON_off();
	
	Q := (state = 10);
	
END_FUNCTION_BLOCK
