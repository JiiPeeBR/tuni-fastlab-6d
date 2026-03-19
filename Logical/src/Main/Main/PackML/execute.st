
ACTION state_execute:
	
	// Start from zero when executing
	IF em.Info.OnStateEntry THEN
		local.shuttleIndex := 0;
	END_IF;
	
	// No need to wait for anything in this state, all polling is just background process
	em_command.StateComplete := TRUE;
	
	CASE em.SubState OF
		0:
			em.StateInfo := 'Update shuttle info';
			// ---------------------------------------------------------------------------------		
			actions_substate.readShuttleInfo := TRUE;
			
			fb.ShuttleGetInfo.Shuttle := ADR(gShuttles.Shuttle[local.shuttleIndex].Ref);
			fb.ShuttleGetInfo.Option := mcACP6D_POSITION_FEEDBACK;

			IF fb.ShuttleGetInfo.Done THEN
				gShuttles.Shuttle[local.shuttleIndex].State := fb.ShuttleGetInfo.ShuttleInfo.State;
				gShuttles.Shuttle[local.shuttleIndex].Position := fb.ShuttleGetInfo.ShuttleInfo.Position;
				gShuttles.Shuttle[local.shuttleIndex].MotionBuffer := fb.ShuttleGetInfo.ShuttleInfo.MotionBuffer;
				em.SubState := 10;
			ELSIF fb.ShuttleGetInfo.Error THEN
				gShuttles.Shuttle[local.shuttleIndex].State := 0;
				brsmemset(ADR(gShuttles.Shuttle[local.shuttleIndex].Position) ,0 ,SIZEOF(gShuttles.Shuttle[local.shuttleIndex].Position));
				brsmemset(ADR(gShuttles.Shuttle[local.shuttleIndex].MotionBuffer) ,0 ,SIZEOF(gShuttles.Shuttle[local.shuttleIndex].MotionBuffer));
				em.SubState := 10;
			END_IF;
			
		10:
			em.StateInfo := 'Get next shuttle';
			// ---------------------------------------------------------------------------------
			local.shuttleIndex := local.shuttleIndex + 1;
			IF local.shuttleIndex > (gShuttles.Count - 1) THEN
	  			local.shuttleIndex := 0;
			END_IF;
			
			em.SubState := 0;
	END_CASE;	
END_ACTION
