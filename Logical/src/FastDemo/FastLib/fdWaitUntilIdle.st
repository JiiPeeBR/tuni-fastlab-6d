
(*  *)
FUNCTION_BLOCK fdWaitUntilAllDone
	
	IF NOT Execute THEN
		state := 0;
		i := 0;
		ShGetInfo.Execute := FALSE;
		WaitingFor := 0;
	END_IF;
	
	CASE state OF
		0:
			IF Execute THEN
				state := 10;
			END_IF;
		10:
			IF i > fdMAX_STATION_SHUTTLE_COUNT THEN
				state := 100;
			ELSE
				IF Shuttles[i].controlif = 0 THEN
					// Not a valid shuttle reference. Move to next item in the list
					i := i + 1;
				ELSE 
					state := 20;	
				END_IF;
			END_IF;
		20:
			ShGetInfo.Execute := TRUE;
			
			IF ShGetInfo.Done THEN
				WaitingFor := ShGetInfo.ShuttleInfo.ShuttleID;
				
				IF (ShGetInfo.ShuttleInfo.State =  mcACP6D_SH_STATE_IDLING) AND (ShGetInfo.ShuttleInfo.MotionBuffer.NumberOfCommands = 0) THEN
					i := i + 1;
					state := 10;
				END_IF;
				ShGetInfo.Execute := FALSE;
				
			ELSIF ShGetInfo.Error THEN
				ShGetInfo.Execute := FALSE;
				state := 101;	
			END_IF;
		100:		
			IF NOT Execute THEN
				state := 0;
			END_IF;	
	END_CASE;
	
	ShGetInfo.Shuttle := ADR(Shuttles[i]);
	ShGetInfo();
	
	Done := (state = 100);
	Error := ShGetInfo.Error;
	
END_FUNCTION_BLOCK
