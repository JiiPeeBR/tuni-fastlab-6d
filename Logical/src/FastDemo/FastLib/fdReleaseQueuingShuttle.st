
(*  *)
FUNCTION_BLOCK fdStationQueueControl
			   
	IF NOT Enable THEN
		state := 0;
		ReleaseShuttle := FALSE;
		ShuttleReleaseDone := FALSE;
		ShuttleReleaseError := FALSE;
		RETURN;
	END_IF;
	
	CASE state OF
		0:
			// -----------------------------------------------------------------
			IF ReleaseShuttles THEN
				state := 20;
			ELSIF pStationControl.Info.NumOccupyingShuttles > ShuttleCapacity THEN
				// Station is executing current process and there is no room for more shuttles ->
				// release queuing extra shuttles straight forward
				state := 10;
			END_IF;
		10:
			// Select next shuttle in the queue while first one is executing
			// -----------------------------------------------------------------
			// Select last arrived shuttle so we can release it
			WHILE pStationControl.SelectedShuttle.ShuttleID <> pStationControl.Info.LastArrivedShuttle.ShuttleID DO
				pStationControl(SelectNextShuttle := TRUE);
				pStationControl(SelectNextShuttle := FALSE);
			END_WHILE;
			state := 11;	
		11:
			// Release the waiting shuttle
			// -----------------------------------------------------------------
			ReleaseShuttle := TRUE;
			
			IF pStationControl.ReleaseDone THEN
				ReleaseShuttle := FALSE;
				state := 0;
			END_IF;	
		20:
			// Initialize for realease
			// -----------------------------------------------------------------
			i := 0;
			state := 21;
		21:
			// Select the next requested shuttle from the shuttle list
			// -----------------------------------------------------------------		
			shuttleID := 0;
			
			WHILE i <= fdMAX_STATION_SHUTTLE_COUNT DO
				IF ShuttleList[i].ShuttleID > 0 THEN
					shuttleID := ShuttleList[i].ShuttleID;
					i := i + 1;
					EXIT;
				END_IF;
				i := i + 1;
			END_WHILE;
			
			IF shuttleID > 0 THEN
				// Found shuttle to release
				state := 22;
			ELSE
				// No more shuttles to release
	  			state := 100;
			END_IF;	
		22:
			// Find shuttle from stations shuttle table
			// -----------------------------------------------------------------
			state := 21; // Assume we dont find shuttle and just return straight to next one
			
			FOR index := 0 TO pStationControl.Info.NumOccupyingShuttles DO		
				IF pStationControl.SelectedShuttle.ShuttleID = shuttleID THEN
					state := 23;
					EXIT;	
				END_IF
				pStationControl(SelectNextShuttle := TRUE);
				pStationControl(SelectNextShuttle := FALSE);
			END_FOR;
			
		23:
			// Release the waiting shuttle
			// -----------------------------------------------------------------
			ReleaseShuttle := TRUE;
			
			IF pStationControl.ReleaseDone THEN
				ReleaseShuttle := FALSE;
				state := 21;
			END_IF;	
		100:
			// Done
			// -----------------------------------------------------------------
			IF NOT ReleaseShuttles THEN
				state := 0;
			END_IF;
		200:
			// Error
			// -----------------------------------------------------------------
			IF NOT ReleaseShuttles THEN
				state := 0;
			END_IF;
	END_CASE;
	
	ShuttleReleaseDone := (state = 100);
	ShuttleReleaseError := (state = 200);
	
END_FUNCTION_BLOCK
