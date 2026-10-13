
(*  *)
FUNCTION_BLOCK fdStationQueueControl
			   
	IF NOT Enable THEN
		state := 0;
	END_IF;
	
	CASE state OF
		0:
			// -----------------------------------------------------------------
			IF ReleaseShuttles THEN
				IF Station_Info.NumOccupyingShuttles > 0 THEN
					index := 0;
					state := 100;	
				ELSE
					state := 190;	
				END_IF;
			ELSIF Station_Info.NumOccupyingShuttles > ShuttleCapacity THEN
				// Station is executing current process and there is no room for more shuttles ->
				// release queuing extra shuttles straight forward
				state := 200;
			END_IF;
			
		100:
			// Manual queue release sequence
			// ----------------------------------------------------------------------------------------------------------------------------------
			// Select the next requested shuttle from the shuttle list
			shuttleIDToReleaseNext := 0;
			
			WHILE index <= fdMAX_STATION_SHUTTLE_COUNT DO
				IF ShuttleList[index].ShuttleID > 0 THEN
					shuttleIDToReleaseNext := ShuttleList[index].ShuttleID;
					index := index + 1;
					EXIT;
				END_IF;
				index := index + 1;
			END_WHILE;
			
			IF shuttleIDToReleaseNext > 0 THEN
				// Proceed to release next shuttle
				state := 110;
			ELSE
				// No more shuttles to release
				state := 190;
			END_IF;	
		110:
			// Check which shuttle is currently selected
			// -----------------------------------------------------------------
			IF Station_SelectedShuttle.ShuttleID <> shuttleIDToReleaseNext THEN
				state := 140;
			ELSE
				state := 150;
			END_IF;	
		140:
			// Select next shuttle in the StationControl's shuttle list
			// ----------------------------------------------------------------
			state := 110;
		150:
			// Release the shuttle
			// -----------------------------------------------------------------
			IF Station_ReleaseDone THEN
				state := 100;
			ELSIF Station_ReleaseAborted THEN
				state := 300;	
			END_IF;	
		190:
			// Done
			// -----------------------------------------------------------------
			IF NOT ReleaseShuttles THEN
				state := 0;
			END_IF;
		
		200:
			// Automatic queue release sequence
			// ----------------------------------------------------------------------------------------------------------------------------------
			// Check if we have our last arrived shuttle selected
			IF Station_SelectedShuttle.ShuttleID <> Station_Info.LastArrivedShuttle.ShuttleID THEN
				state := 240;
			ELSE
				state := 250;
			END_IF;
		240:
			// Select next shuttle in the queue
			// -----------------------------------------------------------------
			state := 200;
		250:
			// Release the queuing shuttle
			// -----------------------------------------------------------------
			IF Station_ReleaseDone THEN
				state := 0;
			ELSIF Station_ReleaseAborted THEN
				state := 300;	
			END_IF;	
		
		300:
			// Error
			// -----------------------------------------------------------------
	END_CASE;
	
	ReleaseShuttle := (state = 150) OR (state = 250);
	SelectNextShuttle := (state = 140) OR (state = 240);

	ShuttleReleaseDone := (state = 190);
	Error := (state = 400);
	
END_FUNCTION_BLOCK
