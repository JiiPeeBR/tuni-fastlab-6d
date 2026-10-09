
(*  *)
FUNCTION_BLOCK fdStationQueueControl
			   
	IF NOT Enable THEN
		state := 0;
		ReleaseShuttle := FALSE;
		ShuttleReleaseDone := FALSE;
		ShuttleReleaseAborted := FALSE;
	END_IF;
	
	CASE state OF
		0:
			// -----------------------------------------------------------------
			IF ReleaseShuttles THEN
				IF pStation.Info.NumOccupyingShuttles > 0 THEN
					index := 0;
					state := 100;	
				ELSE
					state := 199;	
				END_IF;
			ELSIF pStation.Info.NumOccupyingShuttles > ShuttleCapacity THEN
				shuttleIDToAutoRelease := pStation.Info.LastArrivedShuttle.ShuttleID;
				// Station is executing current process and there is no room for more shuttles ->
				// release queuing extra shuttles straight forward
				loop := 0;
				state := 200;
			END_IF;
			
		100:
			// Manual queue release sequence
			// ----------------------------------------------------------------------------------------------------------------------------------
			// Select the next requested shuttle from the shuttle list
			shuttleFound := FALSE;
			
			WHILE index <= fdSTATION_SHUTTLE_LAST_INDEX DO
				IF ShuttleList[index].ShuttleID > 0 THEN
					shuttleIDToRelease := ShuttleList[index].ShuttleID;
					shuttleFound := TRUE;
					index := index + 1;
					EXIT;
				END_IF;
				index := index + 1;
			END_WHILE;
			
			IF shuttleFound THEN
				// Proceed to release next shuttle
				loop := 0;
				state := 110;
			ELSE
				// No more shuttles to release
				state := 199;
			END_IF;	
		110:
			// Select shuttle to be released from stations shuttle list
			// -----------------------------------------------------------------
			IF loop > pStation.Info.NumOccupyingShuttles THEN
				// whole list has been checked through and we cant find requested shuttle -> move on
				state := 100;
			ELSIF pStation.SelectedShuttle.ShuttleID = shuttleIDToRelease THEN
				state := 130;
			ELSE
				loop := loop  + 1;
				pStation(SelectNextShuttle := TRUE);
				pStation(SelectNextShuttle := FALSE);
			END_IF;	
		130:
			// Release the shuttle
			// -----------------------------------------------------------------
			ReleaseShuttle := TRUE;
			
			IF pStation.ReleaseDone THEN
				state := 100;
			ELSIF pStation.ReleaseAborted THEN
				state := 300;	
			END_IF;	
		199:
			// Done
			// -----------------------------------------------------------------
			ShuttleReleaseDone := TRUE;
			
			IF NOT ReleaseShuttles THEN
				state := 0;
			END_IF;
		
		200:
			// Automatic queue release sequence
			// ----------------------------------------------------------------------------------------------------------------------------------
			// Select shuttle to be released from stations shuttle list
			// -----------------------------------------------------------------
			IF loop > pStation.Info.NumOccupyingShuttles THEN
				// whole list has been checked through and we cant find requested shuttle -> move on
				state := 0;
			ELSIF pStation.SelectedShuttle.ShuttleID = shuttleIDToAutoRelease THEN
				state := 210;
			ELSE
				loop := loop  + 1;
				pStation(SelectNextShuttle := TRUE);
				pStation(SelectNextShuttle := FALSE);
			END_IF;	
		210:
			// Release the queuing shuttle
			// -----------------------------------------------------------------
			ReleaseShuttle := TRUE;
			
			IF pStation.ReleaseDone THEN
				state := 0;
			ELSIF pStation.ReleaseAborted THEN
				state := 300;	
			END_IF;	
		
		300:
			// Error
			// -----------------------------------------------------------------
			ShuttleReleaseAborted := TRUE;
		
	END_CASE;
	
	IF state <> lastState THEN
		lastState := state;
		ReleaseShuttle := FALSE;
		ShuttleReleaseDone := FALSE;
		ShuttleReleaseAborted := FALSE;
	END_IF;
	
	NumOccypyingShuttles := pStation.Info.NumOccupyingShuttles;
	
END_FUNCTION_BLOCK
