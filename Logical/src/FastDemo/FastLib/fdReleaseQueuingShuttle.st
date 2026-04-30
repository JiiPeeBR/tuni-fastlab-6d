
(*  *)
FUNCTION_BLOCK fdStationQueueControl
			   
	IF NOT Enable THEN
		state := 0;
		ReleaseShuttle := FALSE;
		SelectNextShuttle := FALSE;
		LastReleasedShuttleID := 0;
		ShuttleReleaseDone := FALSE;
		ShuttleReleaseError := FALSE;
		RETURN;
	END_IF;
	
	CASE state OF
		0:
			// -----------------------------------------------------------------
			SelectNextShuttle := FALSE;	
			
			IF ReleaseShuttles THEN
				state := 20;
			ELSIF pStationControl.Info.NumOccupyingShuttles > ShuttleCapacity THEN
				// Station is executing current process and there is no room for more shuttles ->
				// release queuing extra shuttles straight forward
				state := 10;
			END_IF;
		10:
			// Check if we have our last arrived shuttle selected
			// -----------------------------------------------------------------
			IF pStationControl.SelectedShuttle.ShuttleID = pStationControl.Info.LastArrivedShuttle.ShuttleID THEN
	  			state := 12;
			ELSE
				lastSelectedIndex := pStationControl.SelectedShuttle.Index;
				SelectNextShuttle := FALSE;	
				state := 11;
			END_IF;
		11:
			// Select next shuttle in the queue
			// -----------------------------------------------------------------
			SelectNextShuttle := TRUE;
			// Wait until selection changes
			IF lastSelectedIndex <> pStationControl.SelectedShuttle.Index THEN
				SelectNextShuttle := FALSE;	
				state := 10;
			END_IF;	
		12:
			// Release the queuing shuttle
			// -----------------------------------------------------------------
			ReleaseShuttle := TRUE;
			
			IF pStationControl.ReleaseDone THEN
				LastReleasedShuttleID := pStationControl.SelectedShuttle.ShuttleID;
				ReleaseShuttle := FALSE;
				state := 0;
			ELSIF pStationControl.ReleaseAborted THEN
				LastReleasedShuttleID := 0;
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
			// Check if we have our last arrived shuttle selected
			// -----------------------------------------------------------------
			IF pStationControl.SelectedShuttle.ShuttleID = shuttleID THEN
				state := 24;
			ELSE
				lastSelectedIndex := pStationControl.SelectedShuttle.Index;
				SelectNextShuttle := FALSE;	
				state := 23;
			END_IF;
		23:
			// Select next shuttle in the queue
			// -----------------------------------------------------------------
			SelectNextShuttle := TRUE;
			// Wait until selection changes
			IF lastSelectedIndex <> pStationControl.SelectedShuttle.Index THEN
				SelectNextShuttle := FALSE;	
				i := 0;
				state := 21;
			END_IF;	
		24:
			// Release the queuing shuttle
			// -----------------------------------------------------------------
			ReleaseShuttle := TRUE;
			
			IF pStationControl.ReleaseDone THEN
				LastReleasedShuttleID := pStationControl.SelectedShuttle.ShuttleID;
				ReleaseShuttle := FALSE;
				state := 21;
			ELSIF pStationControl.ReleaseAborted THEN
				LastReleasedShuttleID := 0;
				ReleaseShuttle := FALSE;
				state := 21;	
			END_IF;	
			
			
			
//			
//		22:
//			// Find shuttle from stations shuttle table
//			// -----------------------------------------------------------------
//			state := 21; // Assume we dont find shuttle and just return straight to next one
//			
//			FOR index := 0 TO pStationControl.Info.NumOccupyingShuttles DO		
//				IF pStationControl.SelectedShuttle.ShuttleID = shuttleID THEN
//					state := 23;
//					EXIT;	
//				END_IF
//				pStationControl(SelectNextShuttle := TRUE);
//				pStationControl(SelectNextShuttle := FALSE);
//			END_FOR;
//			
//		23:
//			// Release the waiting shuttle
//			// -----------------------------------------------------------------
//			ReleaseShuttle := TRUE;
//			
//			IF pStationControl.ReleaseDone THEN
//				ReleaseShuttle := FALSE;
//				state := 21;
//			END_IF;	
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
