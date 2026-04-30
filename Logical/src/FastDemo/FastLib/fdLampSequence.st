
(*  *)
FUNCTION_BLOCK fdLampSequence
			   
	IF NOT Execute THEN
		state := 0;
	END_IF;
	
	CASE state OF
		0:
			IF Execute THEN
				state := 10;
			END_IF;
		10:
			TON_delay.IN := TRUE;
			IF TON_delay.Q THEN
				TON_delay.IN := FALSE;
	  			state := 20;
			END_IF;
		20:
			TON_delay.IN := TRUE;
			IF TON_delay.Q THEN
				TON_delay.IN := FALSE;
				state := 30;
			END_IF;
		30:
			TON_delay.IN := TRUE;
			IF TON_delay.Q THEN
				TON_delay.IN := FALSE;
				state := 10;
			END_IF;
	END_CASE;
	
	TON_delay.PT := T#150ms;
	TON_delay();
	
	Lamp1 := (state = 10);
	Lamp2 := (state = 20);
	Lamp3 := (state = 30);
	
END_FUNCTION_BLOCK
