
ACTION execute_station_S5:
	// Point station reference to this station
	station ACCESS ADR(stations[5]);
			
	// Station control logic and mapping
	// -----------------------------------------------------------------
	station.Control.Enable := TRUE;
	station.Control.Station := ADR(S5);
	station.Control.To := ADR(S6);
	station.Macro.Name := 'S5';
	station.Operation.StationQueueControl.ShuttleCapacity := 2;
		
	// -----------------------------------------------------------------
	CASE station.State OF
		0:	
			station.Var.StateInfo := 'Activating station';
			// -----------------------------------------------------------------
			IF station.Control.Active AND station.Control.State = mpTRAFFIC_ST_ON_OPEN THEN
				station.State := station.State + 1;	
			END_IF
		1:
			station.Var.StateInfo := 'Create shuttle group';
			// -----------------------------------------------------------------
			station.Commands.Group.Create := TRUE;
			IF station.Group.GroupCreate.Done THEN
				station.Group.ShuttleGroup := station.Group.GroupCreate.ShuttleGroup;
				station.State := 200;
			END_IF;
			
		200:
			station.Var.StateInfo := 'Initialize station sequence';
			// -----------------------------------------------------------------
			station.ShuttleCount := 0;
			brsmemset(ADR(station.Shuttles), 0, SIZEOF(station.Shuttles));
			
			station.Operation.MoveInPlane.Parameters.Velocity := 2;
			station.Operation.MoveInPlane.Parameters.Acceleration := 18;
			station.Operation.MoveInPlane.Parameters.EndVelocity := 0;
			station.Operation.MoveInPlane.Parameters.Radius := 0;
			station.Operation.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_DIRECT;
			station.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_ABSOLUTE;
			station.State := station.State + 1;
		201:
			station.Var.StateInfo := 'Waiting for first shuttle to arrive at station';
			// -----------------------------------------------------------------
			IF station.Control.Info.NumOccupyingShuttles > 0 THEN
				station.Shuttles[station.ShuttleCount] := station.Control.Info.LastArrivedShuttle;
				station.ShuttleCount := station.ShuttleCount + 1;
				station.State := station.State + 1;
			END_IF;	
		202:
			station.Var.StateInfo := 'Move first shuttle to start position';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[0].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.900;
			station.Operation.MoveInPlane.Parameters.Position.Y := 2.940;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := station.State + 1;
			END_IF;
		203:	
			station.Var.StateInfo := 'Waiting for second shuttle to arrive at station';
			// -----------------------------------------------------------------
			IF station.Control.Info.NumOccupyingShuttles > 1 THEN		
				station.Shuttles[station.ShuttleCount] := station.Control.Info.LastArrivedShuttle;
				station.ShuttleCount := station.ShuttleCount + 1;
				station.State := station.State + 1;
			END_IF;
		204:
			station.Var.StateInfo := 'Move second shuttle to start position';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[1].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Position.X := 0.780;
			station.Operation.MoveInPlane.Parameters.Position.Y := 2.940;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := station.State + 1;
			END_IF;
		205:
			station.Var.StateInfo := 'Add shuttles to group';
			// -----------------------------------------------------------------
			station.Group.GroupAddShuttle.Parameters.ShuttleList[0].Shuttle := ADR(station.Shuttles[0].Shuttle6D);
			station.Group.GroupAddShuttle.Parameters.ShuttleList[1].Shuttle := ADR(station.Shuttles[1].Shuttle6D);
			station.Commands.Group.AddShuttle := TRUE;
			
			IF station.Group.GroupAddShuttle.Done THEN
	  			station.State := station.State + 1;
			END_IF;
		206:
			station.Var.StateInfo := 'Couple grouped shuttles together';
			// -----------------------------------------------------------------
			station.Group.GroupCoupleCtrl.Parameters.Mode := mcACP6D_SH_GROUP_CMN_ROT_REF;
			station.Group.GroupCoupleCtrl.Parameters.Option := mcACP6D_SH_GROUP_COUPLE;
			station.Commands.Group.ChangeCoupling := TRUE;
			
			IF station.Group.GroupCoupleCtrl.Done THEN
	  			station.State := 300;
			END_IF;
		300:
			station.Var.StateInfo := 'Move group';
			// -----------------------------------------------------------------
			station.Operation.MoveInPlane.Shuttle := ADR(station.Shuttles[0].Shuttle6D);
			station.Operation.MoveInPlane.Parameters.Path :=  mcACP6D_PATH_DIRECT;
			station.Operation.MoveInPlane.Parameters.Mode :=  mcACP6D_MOVE_RELATIVE;
			station.Operation.MoveInPlane.Parameters.Position.X := 0.0;
			station.Operation.MoveInPlane.Parameters.Position.Y := 0.360;
			station.Commands.MoveInPlane := TRUE;
			
			IF station.Operation.MoveInPlane.Done THEN
				station.State := station.State + 1;
			END_IF;
		301:
			station.Var.StateInfo := 'Clear group';
			// -----------------------------------------------------------------
			station.Commands.Group.Clear := TRUE;
			
			IF station.Group.GroupClear.Done THEN
	  			station.State := 1000;
			END_IF;		
		1000:
			station.Var.StateInfo := 'Release first index shuttle (1st arrived)';
			// -----------------------------------------------------------------
			station.Operation.StationQueueControl.ShuttleList[0] := station.Shuttles[1];
			station.Operation.StationQueueControl.ShuttleList[1] := station.Shuttles[0];
			station.Commands.Release := TRUE;
			
			IF station.Operation.StationQueueControl.ShuttleReleaseDone THEN
				station.State := 200;	
			END_IF;
	END_CASE;
	
	// Reset station commands when state changes
	IF station.State <> station.Var.PreviousState THEN
		station.Var.PreviousState := station.State;
		brsmemset(ADR(station.Commands), 0, SIZEOF(station.Commands));
	END_IF;
	
END_ACTION
