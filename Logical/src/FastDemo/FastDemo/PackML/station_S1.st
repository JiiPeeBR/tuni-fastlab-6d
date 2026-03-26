
ACTION execute_station_S1: 	
	// Initialze when system enters this main state
	IF em.Info.OnStateEntry THEN
		station_S1.Station.State := 0;
		station_S1.Station.LoopNum := 0;
		station_S1.Station.Control.ErrorReset := FALSE;
		brsmemset(ADR(station_S1.Commands), 0, SIZEOF(station_S1.Commands));
	END_IF
	
	IF station_S1.Station.State <> station_S1.Station.PreviousState THEN
		station_S1.Station.PreviousState := station_S1.Station.State;
		brsmemset(ADR(station_S1.Commands), 0, SIZEOF(station_S1.Commands));
	END_IF;
	
	// Station control logic
	station_S1.Station.Control.Enable := TRUE;
	station_S1.Station.Control.MpLink := ADR(TrafficManager_x6d_1);
	station_S1.Station.Control.Station := ADR(S1);
	station_S1.Station.Control.To := ADR(S2);
	station_S1.Station.Control.Release := station_S1.Commands.release;
	station_S1.Station.Control();
	
	station_S1.MoveInPlane.Execute := station_S1.Commands.move_in_plane;
	station_S1.MoveInPlane();
	
	CASE station_S1.Station.State OF
		0:	
			station_S1.Station.StateInfo := 'Activating station';
			// -----------------------------------------------------------------
			IF station_S1.Station.Control.Active AND station_S1.Station.Control.State = mpTRAFFIC_ST_ON_OPEN THEN
	  			station_S1.Station.State := station_S1.Station.State + 1;	
			END_IF;
			
		1:	
			station_S1.Station.StateInfo := 'Waiting for shuttle to arrive at station';
			// -----------------------------------------------------------------
			IF station_S1.Station.Control.Info.Occupied THEN
				station_S1.MoveInPlane.Shuttle := ADR(station_S1.Station.Control.SelectedShuttle.Shuttle6D);
	  			station_S1.Station.State := station_S1.Station.State + 1;	
			END_IF;
		2:
			station_S1.Station.StateInfo := 'Move to initial position';
			// -----------------------------------------------------------------
			station_S1.Station.LoopNum := 0;
			
			station_S1.MoveInPlane.Parameters.Velocity := 2.5;
			station_S1.MoveInPlane.Parameters.Acceleration := 20;
			station_S1.MoveInPlane.Parameters.EndVelocity := 2.5;
			station_S1.MoveInPlane.Parameters.Radius := 0.035;
			
			station_S1.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_X_THEN_Y;
			station_S1.MoveInPlane.Parameters.Position.X := 0.060;
			station_S1.MoveInPlane.Parameters.Position.Y := 0.240;
			
			station_S1.Commands.move_in_plane := TRUE;
			
			IF station_S1.MoveInPlane.Acknowledge THEN
				station_S1.Station.State := 10;	
			END_IF;
		
		10:
			station_S1.Station.StateInfo := 'Move position 2';
			// -----------------------------------------------------------------
			station_S1.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_Y_THEN_X;
			station_S1.MoveInPlane.Parameters.Position.X := 0.120;
			station_S1.MoveInPlane.Parameters.Position.Y := 0.060;
			
			station_S1.Commands.move_in_plane := TRUE;
			
			IF station_S1.MoveInPlane.Acknowledge THEN
				station_S1.Station.State := station_S1.Station.State + 1;	
			END_IF;
		
		11:
			station_S1.Station.StateInfo := 'Move positon 3';
			// -----------------------------------------------------------------			
			station_S1.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_X_THEN_Y;
			station_S1.MoveInPlane.Parameters.Position.X := 0.180;
			station_S1.MoveInPlane.Parameters.Position.Y := 0.240;
			
			station_S1.Commands.move_in_plane := TRUE;
			
			IF station_S1.MoveInPlane.Acknowledge THEN
				station_S1.Station.State := station_S1.Station.State + 1;	
			END_IF;
		
		12:
			station_S1.Station.StateInfo := 'Move position 4';
			// -----------------------------------------------------------------
			station_S1.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_Y_THEN_X;
			station_S1.MoveInPlane.Parameters.Position.X := 0.120;
			station_S1.MoveInPlane.Parameters.Position.Y := 0.420;
			
			station_S1.Commands.move_in_plane := TRUE;
			
			IF station_S1.MoveInPlane.Acknowledge THEN
				station_S1.Station.State := station_S1.Station.State + 1;	
			END_IF;
		
		13:	
			station_S1.Station.StateInfo := 'Move position 1';
			// -----------------------------------------------------------------
			station_S1.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_X_THEN_Y;
			station_S1.MoveInPlane.Parameters.Position.X := 0.060;
			station_S1.MoveInPlane.Parameters.Position.Y := 0.240;
			
			station_S1.Commands.move_in_plane := TRUE;
			
			IF station_S1.MoveInPlane.Acknowledge THEN
				station_S1.Station.State := station_S1.Station.State + 1;	
			END_IF;
			
		14:
			station_S1.Station.StateInfo := 'Check if sequence complete';
			// -----------------------------------------------------------------
			station_S1.Station.LoopNum := station_S1.Station.LoopNum + 1;
			
			IF station_S1.Station.LoopNum > 3 THEN
				// Station sequence complete
				station_S1.Station.State :=  100;
			ELSE
				// New loop of moves
				station_S1.Station.State :=  10;
			END_IF;
			
		100:
			station_S1.Station.StateInfo := 'Wait shuttle to complete its moves';
			// -----------------------------------------------------------------
			station_S1.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_Y_THEN_X;
			station_S1.MoveInPlane.Parameters.Position.X := 0.120;
			station_S1.MoveInPlane.Parameters.Position.Y := 0.060;
			station_S1.MoveInPlane.Parameters.EndVelocity := 0;
			
			station_S1.Commands.move_in_plane := TRUE;
			
			IF station_S1.MoveInPlane.Done THEN
				station_S1.Station.State := 200;	
			END_IF;
					
		200:
			station_S1.Station.StateInfo := 'Release shuttle to traffic network';
			// -----------------------------------------------------------------
			station_S1.Commands.release := TRUE;
			
			IF station_S1.Station.Control.ReleaseDone THEN
				station_S1.Station.State := 0;
			END_IF;
	END_CASE;
	
END_ACTION
