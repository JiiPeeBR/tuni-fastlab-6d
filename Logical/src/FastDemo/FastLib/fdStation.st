
(* *)
FUNCTION_BLOCK fdStation

	// Station enable control
	// ----------------------------------------------------------------------------------------
	m_control.Enable_EdgeNegative(CLK := Enable);
	
	IF m_control.Enable_EdgeNegative.Q THEN
		IF Active THEN
			// Jump to 
	  		m_sequence_state := 90;	
		ELSE
			m_sequence_state := 0;	
		END_IF;
	END_IF;
	
	// External state control
	// ----------------------------------------------------------------------------------------
	IF Active THEN
		IF NextState THEN
			State := State + 1;
			m_var.StateChanged := TRUE;
		ELSIF JumpToState <> State THEN
			State := JumpToState;
			m_var.StateChanged := TRUE;
		END_IF;

		IF m_var.StateChanged THEN
			m_var.StateChanged := FALSE;
			NextState := FALSE;
			JumpToState := State;;
			brsmemset(ADR(Commands), 0, SIZEOF(Commands));
			JumpToState := State;;
		END_IF;  
	END_IF;

	// Check if all commands are reset
	// -----------------------------------------------------------------
	m_var.NoCommandActive := (brsmemcmp(ADR(m_var.NoCommands), ADR(Commands), SIZEOF(Commands)) = 0);

	// Station command sequence
	// -----------------------------------------------------------------
	CASE m_sequence_state OF
		0:
			StateInfo := 'Station disabled';
			// -----------------------------------------------------------------
			Active := FALSE;
			State := 0;
			NextState := FALSE;
			JumpToState := 0;
			Loop := 0;
			brsmemset(ADR(Commands), 0, SIZEOF(Commands));
			brsmemset(ADR(Operation), 0, SIZEOF(Operation));
			brsmemset(ADR(m_var), 0, SIZEOF(m_var));
			brsmemset(ADR(m_cmd), 0, SIZEOF(m_cmd));
			brsmemset(ADR(m_status), 0, SIZEOF(m_status));
			
			IF Enable THEN
	  			m_sequence_state := m_sequence_state + 1;
			END_IF;
		1:
			StateInfo := 'Wait for station to be active and open';
			// -----------------------------------------------------------------
			IF m_control.StationControl.Active AND m_control.StationControl.State = mpTRAFFIC_ST_ON_OPEN THEN
				m_sequence_state := m_sequence_state + 1;
			END_IF
		2:
			StateInfo := 'Create shuttle group';
			// -----------------------------------------------------------------
			m_cmd.GroupCreate := TRUE;
			IF m_group.Create.Done THEN
				m_var.ShuttleGroup := m_group.Create.ShuttleGroup;
				m_sequence_state := 10;
			ELSIF m_group.Create.Error THEN
				m_status.ErrorID := m_group.Create.ErrorID;
			END_IF;
		10:
			StateInfo := 'Check if virtual shuttle exists';
			// -----------------------------------------------------------------
			IF NOT Parameters.CreateVirtualShuttle THEN
				// Virtual shuttle not needed in this station -> move on
				brsmemset(ADR(VirtualShuttle), 0, SIZEOF(VirtualShuttle));
				m_sequence_state := 20;
			ELSE
				IF VirtualShuttle.Shuttle6D.controlif = 0 THEN
					// Virtual shuttle does not exist -> create new one
					m_sequence_state := m_sequence_state + 1;		
				ELSE
					// Virtual shuttle already exists in this station -> read its information
					m_sequence_state := 12;		
				END_IF;
			END_IF;
		11:
			StateInfo := 'Create virtual shuttle';
			// -----------------------------------------------------------------
			m_cmd.VirtualShuttleCreate := TRUE;

			IF m_control.VirtualShuttleCreate.Done THEN
				VirtualShuttle.Shuttle6D := m_control.VirtualShuttleCreate.VirtualShuttle;
				m_sequence_state := m_sequence_state + 1;
			ELSIF m_control.VirtualShuttleCreate.Error THEN
				m_status.ErrorID := m_control.VirtualShuttleCreate.ErrorID;
			END_IF;
		12:
			StateInfo := 'Read virtual shuttle ID';
			// -----------------------------------------------------------------
			m_control.GetShuttleInfo.Shuttle := ADR(VirtualShuttle.Shuttle6D);
			m_cmd.GetShuttleInfo := TRUE;

			IF m_control.GetShuttleInfo.Done THEN
				VirtualShuttle.ShuttleID := m_control.GetShuttleInfo.ShuttleInfo.ShuttleID;
				m_sequence_state := 20;
			ELSIF m_control.GetShuttleInfo.Error THEN
				m_status.ErrorID := m_control.GetShuttleInfo.ErrorID;
			END_IF;
			
		20:
			StateInfo := 'Find station zone by name';
			// -----------------------------------------------------------------
			IF brsstrlen(ADR(Parameters.Zone.Name)) = 0 THEN
				m_var.str := DINT_TO_STRING(Parameters.StationNumber);
				Parameters.Zone.Name := CONCAT('Zone', m_var.str);
			END_IF;

			brsmemset(ADR(m_zone.Zone), 0, SIZEOF(m_zone.Zone));
			m_zone.Find.Name := Parameters.Zone.Name;
			m_cmd.ZoneFind := TRUE;

			IF m_zone.Find.ZoneFound THEN
				m_zone.Zone := m_zone.Find.Zone;
				m_sequence_state := 30;
			ELSIF m_zone.Find.ZoneNotFound THEN
				m_sequence_state := m_sequence_state + 1;
			END_IF;
		21:
			StateInfo := 'Create zone';
			// -----------------------------------------------------------------
			m_zone.Create.Parameters.BottomLeft := Parameters.Zone.BottomLeft;
			m_zone.Create.Parameters.TopRight := Parameters.Zone.TopRight;
			m_zone.Create.Parameters.Name := Parameters.Zone.Name;
			m_cmd.ZoneCreate := TRUE;

			IF m_zone.Create.Done THEN
				// Go back one step and rescan the zones to get the zone reference
				m_sequence_state := 20;
			ELSIF m_zone.Create.Error THEN
				m_status.ErrorID := m_zone.Create.ErrorID;
			END_IF;
			
		30:
			StateInfo := 'Delete old macro if it exists';
			// -----------------------------------------------------------------
			IF brsstrlen(ADR(Parameters.MacroName)) = 0 THEN
				m_var.str := DINT_TO_STRING(Parameters.StationNumber);
				Parameters.MacroName := CONCAT('Macro', m_var.str);
			END_IF;

			m_macro.Delete.Name := Parameters.MacroName;
			m_cmd.MacroDelete := TRUE;

			// Move forward if "macro name not defined" error is received
			IF (m_macro.Delete.Done) OR (m_macro.Delete.Error AND m_macro.Delete.ErrorID = - 1065811714) THEN
				m_sequence_state := m_sequence_state + 1;
			ELSIF m_macro.Delete.Error THEN
				m_status.ErrorID := m_macro.Delete.ErrorID;
			END_IF;
		31:
			StateInfo := 'Create new macro';
			// -----------------------------------------------------------------
			m_macro.Create.Parameters.Name := Parameters.MacroName;
			m_cmd.MacroCreate := TRUE;

			IF m_macro.Create.Done THEN
				m_var.MacroShuttle.Shuttle6D := m_macro.Create.MacroShuttle;
				m_sequence_state := 100;
			ELSIF m_macro.Create.Error THEN
				m_status.ErrorID := m_macro.Create.ErrorID;
			END_IF;
			
		90:
			StateInfo := 'Deactivating - Clear group';
			// -----------------------------------------------------------------
			m_cmd.GroupClear := TRUE;
			IF m_group.Clear.Done THEN
	  			m_sequence_state := m_sequence_state + 1;
			END_IF;
		91:
			StateInfo := 'Deactivating - Delete group';
			// -----------------------------------------------------------------
			m_cmd.GroupDelete := TRUE;
			IF m_group.Delete.Done THEN
				m_sequence_state := m_sequence_state + 1;
			END_IF;
		92:
			StateInfo := 'Deactivating - Decouple planet system';
			// -----------------------------------------------------------------
			FOR m_var.index := 0 TO fdSTATION_SHUTTLE_LAST_INDEX DO
				m_move.SunPlanet.Parameters.ShuttleList[m_var.index].Shuttle := ADR(m_var.Shuttles.List[m_var.index].Shuttle6D);
			END_FOR;
			
			m_move.SunPlanet.Parameters.Option := mcACP6D_PLANET_REMOVE_SH;
			m_cmd.Input.SunPlanet.Decouple := TRUE;
			
			IF m_move.SunPlanet.Done OR (m_move.SunPlanet.ErrorID = -1065795584) THEN
				// Error -1065795584 indicates invalid parameters. A generic issue if shuttles are not currently 
				// grouped around sun shuttle. -> just move on
	  			m_sequence_state := m_sequence_state + 1;
			END_IF;
		93:
			StateInfo := 'Deactivating - Delete macro';
			// -----------------------------------------------------------------
			m_cmd.MacroDelete := TRUE;
			IF m_macro.Delete.Done THEN
				m_sequence_state := 99;
			END_IF;
		99:
			StateInfo := 'Deactivating - Deactivation complete';
			// -----------------------------------------------------------------
			m_sequence_state := 0;
			
		100:
			// Waiting for commands
			// -----------------------------------------------------------------
			Active := TRUE;

			IF Commands.AddShuttle THEN
				m_sequence_state := 110;
			ELSIF Commands.ReleaseAllShuttles THEN
				m_sequence_state := 120;
			ELSIF Commands.MacroRun THEN
				m_sequence_state := 130;
			ELSIF Commands.MacroSave THEN
				m_sequence_state := 140;
			ELSIF Commands.MoveInPlane THEN
				m_sequence_state := 150;
			ELSIF Commands.MoveArc THEN
				m_sequence_state := 160;
			ELSIF Commands.MoveShortAxis THEN
				m_sequence_state := 170;
			ELSIF Commands.Move6D THEN
				m_sequence_state := 180;
			ELSIF Commands.Spin THEN
				m_sequence_state := 190;
			ELSIF Commands.WaitCommandLabel THEN
				m_sequence_state := 200;
			ELSIF Commands.WaitUntilAllDone THEN
				m_sequence_state := 210;
			ELSIF Commands.Group.Couple_CommonCenterPoint THEN
				m_sequence_state := 220;
			ELSIF Commands.Group.Couple_OwnCenterPoint THEN
				m_sequence_state := 221;
			ELSIF Commands.Group.Decouple THEN
				m_sequence_state := 230;
			ELSIF Commands.SunPlanet.Couple THEN
				m_sequence_state := 240;
			ELSIF Commands.SunPlanet.Decouple THEN
				m_sequence_state := 250;
			END_IF;

		110:
			// Add new shuttle to station if there is room for it
			// -----------------------------------------------------------------
			IF m_var.NoCommandActive THEN
				m_sequence_state := 100;
			ELSIF m_var.Shuttles.Count <= fdSTATION_SHUTTLE_LAST_INDEX THEN
				m_var.Shuttles.List[m_var.Shuttles.Count] := m_control.StationControl.Info.LastArrivedShuttle;
				m_var.Shuttles.Count := m_var.Shuttles.Count + 1;
				m_sequence_state := m_sequence_state + 1;
			ELSE
				m_status.CommandError := TRUE;
				m_status.ErrorID := m_sequence_state;
			END_IF;

		111:
			// Clear group before adding ALL shuttles as we cant add one by one
			// -----------------------------------------------------------------
			m_cmd.GroupClear := TRUE;

			m_status.CommandError := m_group.Clear.Error;
			m_status.ErrorID := m_group.Clear.ErrorID;

			IF m_var.NoCommandActive THEN
				m_sequence_state := 100;
			ELSIF m_group.Clear.Done THEN
				m_sequence_state := m_sequence_state + 1;
			END_IF;
		112:
			// Add shuttles to shuttle group
			// -----------------------------------------------------------------
			brsmemset(ADR(m_group.AddShuttle.Parameters.ShuttleList), 0, SIZEOF(m_group.AddShuttle.Parameters.ShuttleList));

			FOR m_var.index := 0 TO m_var.Shuttles.Count - 1 DO
				m_group.AddShuttle.Parameters.ShuttleList[m_var.index].Shuttle := ADR(m_var.Shuttles.List[m_var.index].Shuttle6D);
			END_FOR;

			m_cmd.GroupAddShuttle := TRUE;

			m_status.CommandDone := m_group.AddShuttle.Done;
			m_status.CommandError := m_group.AddShuttle.Error;
			m_status.ErrorID := m_group.AddShuttle.ErrorID;

			IF m_var.NoCommandActive THEN
				m_sequence_state := 100;
			END_IF;

		120:
			// Clear group
			// -----------------------------------------------------------------
			m_cmd.GroupClear := TRUE;

			m_status.CommandError := m_group.Clear.Error;
			m_status.ErrorID := m_group.Clear.ErrorID;

			IF m_var.NoCommandActive THEN
				m_sequence_state := 100;
			ELSIF m_group.Clear.Done THEN
				m_sequence_state := m_sequence_state + 1;
			END_IF;

		121:
			// Release shuttles from station
			// -----------------------------------------------------------------
			m_cmd.Input.ReleaseAllShuttles := TRUE;

			m_status.CommandError := m_control.StationQueueControl.ShuttleReleaseAborted;
			m_status.ErrorID := m_sequence_state;

			IF m_var.NoCommandActive THEN
				m_sequence_state := 100;
			ELSIF m_control.StationQueueControl.ShuttleReleaseDone THEN
				m_sequence_state := m_sequence_state + 1;
			END_IF;

		122:
			// Wait until shuttles have left the station
			// -----------------------------------------------------------------
			m_cmd.ZoneGetBarrierInfo := TRUE;

			m_status.CommandError := m_zone.GetBarrierInfo.Error;
			m_status.ErrorID := m_zone.GetBarrierInfo.ErrorID;

			IF m_var.NoCommandActive THEN
				m_sequence_state := 100;
			ELSIF m_zone.GetBarrierInfo.Done THEN
				m_cmd.ZoneGetBarrierInfo := FALSE;
				IF m_zone.GetBarrierInfo.BarrierInfo.NumberOfShuttles = 0 THEN
					m_var.Shuttles.Count := 0;
					brsmemset(ADR(m_var.Shuttles.List), 0, SIZEOF(m_var.Shuttles.List));
					m_status.CommandDone := TRUE;
				END_IF;
			END_IF;

		130:
			// Run macro command
			// -----------------------------------------------------------------
			m_macro.Run.Name := Parameters.MacroName;
			m_cmd.Input.MacroRun := TRUE;

			m_status.CommandDone := m_macro.Run.Done;
			m_status.CommandAcknowdledge := m_macro.Run.Acknowledge;
			m_status.CommandError := m_macro.Run.Error;
			m_status.ErrorID := m_macro.Run.ErrorID;

			IF m_var.NoCommandActive THEN
				m_sequence_state := 100;
			END_IF;

		140:
			// Save macro command
			// -----------------------------------------------------------------
			m_cmd.Input.MacroSave := TRUE;

			m_status.CommandDone := m_macro.Save.Done;
			m_status.CommandError := m_macro.Save.Error;
			m_status.ErrorID := m_macro.Save.ErrorID;

			IF m_var.NoCommandActive THEN
				m_sequence_state := 100;
			END_IF;

		150:
			// Move in plane command
			// -----------------------------------------------------------------
			m_move.MoveInPlane.Parameters := Operation.MoveInPlane;
			m_cmd.Input.MoveInPlane := TRUE;

			m_status.CommandDone := m_move.MoveInPlane.Done;
			m_status.CommandAcknowdledge := m_move.MoveInPlane.Acknowledge;
			m_status.CommandError := m_move.MoveInPlane.Error;
			m_status.ErrorID := m_move.MoveInPlane.ErrorID;

			IF m_var.NoCommandActive THEN
				m_sequence_state := 100;
			END_IF;

		160:
			// Move arc command
			// -----------------------------------------------------------------
			m_move.MoveArc.Parameters := Operation.MoveArc;
			m_cmd.Input.MoveArc := TRUE;

			m_status.CommandDone := m_move.MoveArc.Done;
			m_status.CommandAcknowdledge := m_move.MoveArc.Acknowledge;
			m_status.CommandError := m_move.MoveArc.Error;
			m_status.ErrorID := m_move.MoveArc.ErrorID;

			IF m_var.NoCommandActive THEN
				m_sequence_state := 100;
			END_IF;

		170:
			// Move short axis command
			// -----------------------------------------------------------------
			m_move.MoveShortAxis.Parameters := Operation.MoveShortAxis;
			m_cmd.Input.MoveShortAxis := TRUE;

			m_status.CommandDone := m_move.MoveShortAxis.Done;
			m_status.CommandAcknowdledge := m_move.MoveShortAxis.Acknowledge;
			m_status.CommandError := m_move.MoveShortAxis.Error;
			m_status.ErrorID := m_move.MoveShortAxis.ErrorID;

			IF m_var.NoCommandActive THEN
				m_sequence_state := 100;
			END_IF;

		180:
			// Move 6D command
			// -----------------------------------------------------------------
			m_move.Move6D.Parameters := Operation.Move6D;
			m_cmd.Input.Move6D := TRUE;

			m_status.CommandDone := m_move.Move6D.Done;
			m_status.CommandAcknowdledge := m_move.Move6D.Acknowledge;
			m_status.CommandError := m_move.Move6D.Error;
			m_status.ErrorID := m_move.Move6D.ErrorID;

			IF m_var.NoCommandActive THEN
				m_sequence_state := 100;
			END_IF;

		190:
			// Spin command
			// -----------------------------------------------------------------
			m_move.Spin.Parameters := Operation.Spin;
			m_cmd.Input.Spin := TRUE;

			m_status.CommandDone := m_move.Spin.Done;
			m_status.CommandAcknowdledge := m_move.Spin.Acknowledge;
			m_status.CommandError := m_move.Spin.Error;
			m_status.ErrorID := m_move.Spin.ErrorID;

			IF m_var.NoCommandActive THEN
				m_sequence_state := 100;
			END_IF;

		200:
			// Wait command label command
			// -----------------------------------------------------------------
			m_move.WaitCommandLabel.TriggerXID := Operation.WaitCommandLabel.TriggerShuttleID;
			m_move.WaitCommandLabel.TriggerType := Operation.WaitCommandLabel.TriggerType;
			m_move.WaitCommandLabel.TriggerCmdLb := Operation.WaitCommandLabel.TriggerCmdLb;
			m_move.WaitCommandLabel.LabelType := Operation.WaitCommandLabel.LabelType;
			m_cmd.Input.WaitCommandLabel := TRUE;

			m_status.CommandDone := m_move.WaitCommandLabel.Done;
			m_status.CommandAcknowdledge := m_move.WaitCommandLabel.Acknowledge;
			m_status.CommandError := m_move.WaitCommandLabel.Error;
			m_status.ErrorID := m_move.WaitCommandLabel.ErrorID;

			IF m_var.NoCommandActive THEN
				m_sequence_state := 100;
			END_IF;

		210:
			// Wait until all done command
			// -----------------------------------------------------------------
			FOR m_var.index := 0 TO fdSTATION_SHUTTLE_LAST_INDEX DO
				m_move.WaitUntilAllDone.Shuttles[m_var.index] := m_var.Shuttles.List[m_var.index].Shuttle6D;
			END_FOR;
			m_cmd.Input.WaitUntilAllDone := TRUE;

			m_status.CommandDone := m_move.WaitUntilAllDone.Done;
			m_status.CommandError := m_move.WaitUntilAllDone.Error;

			IF m_var.NoCommandActive THEN
				m_sequence_state := 100;
			END_IF;

		220:
			// Group couple command
			// -----------------------------------------------------------------
			m_group.CoupleCtrl.Parameters.Option := mcACP6D_SH_GROUP_COUPLE;
			m_group.CoupleCtrl.Parameters.Mode := mcACP6D_SH_GROUP_CMN_ROT_REF;
			m_cmd.Input.Group.Couple_CommonCenterPoint := TRUE;

			m_status.CommandDone := m_group.CoupleCtrl.Done;
			m_status.CommandError := m_group.CoupleCtrl.Error;
			m_status.ErrorID := m_group.CoupleCtrl.ErrorID;

			IF m_var.NoCommandActive THEN
				m_sequence_state := 100;
			END_IF;
		221:
			// Group couple command
			// -----------------------------------------------------------------
			m_group.CoupleCtrl.Parameters.Option := mcACP6D_SH_GROUP_COUPLE;
			m_group.CoupleCtrl.Parameters.Mode := mcACP6D_SH_GROUP_INDV_ROT_REF;
			m_cmd.Input.Group.Couple_OwnCenterPoint := TRUE;

			m_status.CommandDone := m_group.CoupleCtrl.Done;
			m_status.CommandError := m_group.CoupleCtrl.Error;
			m_status.ErrorID := m_group.CoupleCtrl.ErrorID;

			IF m_var.NoCommandActive THEN
				m_sequence_state := 100;
			END_IF;

		230:
			// Group decouple command
			// -----------------------------------------------------------------
			m_group.CoupleCtrl.Parameters.Option := mcACP6D_SH_GROUP_DECOUPLE;
			m_cmd.Input.Group.Decouple := TRUE;

			m_status.CommandDone := m_group.CoupleCtrl.Done;
			m_status.CommandError := m_group.CoupleCtrl.Error;
			m_status.ErrorID := m_group.CoupleCtrl.ErrorID;

			IF m_var.NoCommandActive THEN
				m_sequence_state := 100;
			END_IF;

		240:
			// Sun planet couple command
			// -----------------------------------------------------------------
			FOR m_var.index := 0 TO fdSTATION_SHUTTLE_LAST_INDEX DO
				m_move.SunPlanet.Parameters.ShuttleList[m_var.index].Shuttle := ADR(m_var.Shuttles.List[m_var.index].Shuttle6D);
			END_FOR;

			m_move.SunPlanet.Parameters.Option := mcACP6D_PLANET_ADD_SH;
			m_cmd.Input.SunPlanet.Couple := TRUE;

			m_status.CommandDone := m_move.SunPlanet.Done;
			m_status.CommandError := m_move.SunPlanet.Error;
			m_status.ErrorID := m_move.SunPlanet.ErrorID;

			IF m_var.NoCommandActive THEN
				m_sequence_state := 100;
			END_IF;

		250:
			// Sun planet decouple command
			// -----------------------------------------------------------------
			FOR m_var.index := 0 TO fdSTATION_SHUTTLE_LAST_INDEX DO
				m_move.SunPlanet.Parameters.ShuttleList[m_var.index].Shuttle := ADR(m_var.Shuttles.List[m_var.index].Shuttle6D);
			END_FOR;

			m_move.SunPlanet.Parameters.Option := mcACP6D_PLANET_REMOVE_SH;
			m_cmd.Input.SunPlanet.Decouple := TRUE;

			m_status.CommandDone := m_move.SunPlanet.Done;
			m_status.CommandError := m_move.SunPlanet.Error;
			m_status.ErrorID := m_move.SunPlanet.ErrorID;

			IF m_var.NoCommandActive THEN
				m_sequence_state := 100;
			END_IF;

END_CASE;

	// Sequence step change event
	// ----------------------------------------------------------------------------------------
	IF m_sequence_state <> m_var.SequenceStatePrevious THEN
		IF m_sequence_state = 2000 THEN
			m_var.ErroredSequenceState := m_var.SequenceStatePrevious;
		ELSE
			m_var.ErroredSequenceState := 0;
		END_IF;

		m_var.SequenceStatePrevious := m_sequence_state;
		brsmemset(ADR(m_cmd), 0, SIZEOF(m_cmd));
		brsmemset(ADR(m_status), 0, SIZEOF(m_status));
	END_IF;
	
	// Command label handling
	// ----------------------------------------------------------------------------------------
	IF Operation.CommandLabel.ManualMode THEN
		// Set command label from input parameters
		m_var.CommandLabel := Operation.CommandLabel.Label;
	ELSE
		// If manual mode is not on set command label automatically based on current state
		m_var.CommandLabel := State;
	END_IF;

	// Station control
	// ----------------------------------------------------------------------------------------
	m_control.StationControl.MpLink := ADR(TrafficManager);
	m_control.StationControl.Enable := Enable;
	m_control.StationControl.Station := ADR(Station);
	m_control.StationControl.To := ADR(NextStation);
	m_control.StationControl.ErrorReset := m_cmd.Input.ErrorReset;
	m_control.StationControl.Release := m_control.StationQueueControl.ReleaseShuttle;
	m_control.StationControl();

	m_control.StationQueueControl.Enable := Active;
	m_control.StationQueueControl.ShuttleList := m_var.Shuttles.List;
	m_control.StationQueueControl.ShuttleCapacity := Parameters.ShuttleCapacity;
	m_control.StationQueueControl.ReleaseShuttles := m_cmd.Input.ReleaseAllShuttles;
	m_control.StationQueueControl.pStation := ADR(m_control.StationControl);
	m_control.StationQueueControl();

	m_control.VirtualShuttleCreate.Execute := m_cmd.VirtualShuttleCreate;
	m_control.VirtualShuttleCreate.Assembly := ADR(Assembly);
	m_control.VirtualShuttleCreate();

	m_control.GetShuttleInfo.Execute := m_cmd.GetShuttleInfo;
	m_control.GetShuttleInfo();

	// Movement
	// ----------------------------------------------------------------------------------------
	m_move.MoveInPlane.Execute := m_cmd.Input.MoveInPlane;
	m_move.MoveInPlane.Shuttle := ADR(Operation.Shuttle.Shuttle6D);
	m_move.MoveInPlane.CommandLabel := m_var.CommandLabel;
	m_move.MoveInPlane();

	m_move.MoveArc.Execute := m_cmd.Input.MoveArc;
	m_move.MoveArc.Shuttle := ADR(Operation.Shuttle.Shuttle6D);
	m_move.MoveArc.CommandLabel := m_var.CommandLabel;
	m_move.MoveArc();

	m_move.Move6D.Execute := m_cmd.Input.Move6D;
	m_move.Move6D.Shuttle := ADR(Operation.Shuttle.Shuttle6D);
	m_move.Move6D.CommandLabel := m_var.CommandLabel;
	m_move.Move6D();

	m_move.MoveShortAxis.Execute := m_cmd.Input.MoveShortAxis;
	m_move.MoveShortAxis.Shuttle := ADR(Operation.Shuttle.Shuttle6D);
	m_move.MoveShortAxis.CommandLabel := m_var.CommandLabel;
	m_move.MoveShortAxis();

	m_move.Spin.Execute := m_cmd.Input.Spin;
	m_move.Spin.Shuttle := ADR(Operation.Shuttle.Shuttle6D);
	m_move.Spin.CommandLabel := m_var.CommandLabel;
	m_move.Spin();

	m_move.WaitCommandLabel.Execute := m_cmd.Input.WaitCommandLabel;
	m_move.WaitCommandLabel.Shuttle := ADR(Operation.Shuttle.Shuttle6D);
	m_move.WaitCommandLabel.CommandLabel := m_var.CommandLabel;
	m_move.WaitCommandLabel();

	m_move.WaitUntilAllDone.Execute := m_cmd.Input.WaitUntilAllDone;
	m_move.WaitUntilAllDone();

	// Sun Planet
	// ----------------------------------------------------------------------------------------
	m_move.SunPlanet.Execute := m_cmd.Input.SunPlanet.Couple OR m_cmd.Input.SunPlanet.Decouple;
	m_move.SunPlanet.Shuttle := ADR(Operation.Shuttle.Shuttle6D);
	m_move.SunPlanet();

	// Macro
	// ----------------------------------------------------------------------------------------
	m_macro.Create.Execute := m_cmd.MacroCreate;
	m_macro.Create.Assembly := ADR(Assembly);
	m_macro.Create();

	m_macro.Delete.Execute := m_cmd.MacroDelete;
	m_macro.Delete.Assembly := ADR(Assembly);
	m_macro.Delete();

	m_macro.Save.Execute := m_cmd.Input.MacroSave;
	m_macro.Save.Shuttle := ADR(m_var.MacroShuttle.Shuttle6D);
	m_macro.Save();

	m_macro.Run.Execute := m_cmd.Input.MacroRun;
	m_macro.Run.Shuttle := ADR(Operation.Shuttle.Shuttle6D);
	m_macro.Run.CommandLabel := m_var.CommandLabel;
	m_macro.Run();

	// Zone
	// ----------------------------------------------------------------------------------------
	m_zone.Create.Execute := m_cmd.ZoneCreate;
	m_zone.Create.Assembly := ADR(Assembly);
	m_zone.Create();

	m_zone.Find.Execute := m_cmd.ZoneFind;
	m_zone.Find.Assembly := ADR(Assembly);
	m_zone.Find();

	m_zone.GetBarrierInfo.Execute := m_cmd.ZoneGetBarrierInfo;
	m_zone.GetBarrierInfo.Zone := ADR(m_zone.Zone);
	m_zone.GetBarrierInfo();

	// Group
	// ----------------------------------------------------------------------------------------
	m_group.Create.Execute := m_cmd.GroupCreate;
	m_group.Create.Assembly := ADR(Assembly);
	m_group.Create();

	m_group.Clear.Execute := m_cmd.GroupClear;
	m_group.Clear.ShuttleGroup := ADR(m_var.ShuttleGroup);
	m_group.Clear();

	m_group.AddShuttle.Execute := m_cmd.GroupAddShuttle;
	m_group.AddShuttle.ShuttleGroup := ADR(m_var.ShuttleGroup);
	m_group.AddShuttle();

	m_group.CoupleCtrl.Execute := m_cmd.Input.Group.Couple_CommonCenterPoint OR m_cmd.Input.Group.Couple_OwnCenterPoint OR m_cmd.Input.Group.Decouple;
	m_group.CoupleCtrl.ShuttleGroup := ADR(m_var.ShuttleGroup);
	m_group.CoupleCtrl();
	
	m_group.Delete.Execute := m_cmd.GroupDelete;
	m_group.Delete.ShuttleGroup := ADR(m_var.ShuttleGroup);
	m_group.Delete();

	// Station outputs
	// ----------------------------------------------------------------------------------------
	Shuttles := m_var.Shuttles;
	MacroShuttle := m_var.MacroShuttle;
	NumOccupyingShuttles := m_control.StationControl.Info.NumOccupyingShuttles;

	CommandDone := m_status.CommandDone;
	CommandAcknowledge := m_status.CommandAcknowdledge;
	CommandError := m_status.CommandError;
	ErrorID := m_status.ErrorID;
	ErroredSequenceState := m_var.ErroredSequenceState;

END_FUNCTION_BLOCK
