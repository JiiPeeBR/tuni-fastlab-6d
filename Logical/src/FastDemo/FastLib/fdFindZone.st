
(*  *)
FUNCTION_BLOCK fdFindZone
	
	IF NOT Execute THEN
		state := 0;
		i := 0;
		AsmGetZone.Enable := FALSE;
		ZoneFound := FALSE;
		ZoneNotFound := FALSE;
		Error := FALSE;
		brsmemset(ADR(ZoneInfo), 0, SIZEOF(ZoneInfo));
		brsmemset(ADR(Zone), 0, SIZEOF(Zone));
	END_IF;
	
	CASE state OF
		0:
			// --------------------------------------------
			IF Execute THEN
				state := 10;
			END_IF;
		10:
			// --------------------------------------------
			AsmGetZone.Enable := TRUE;
			IF AsmGetZone.Valid THEN
				IF AsmGetZone.TotalCount = 0 THEN
					state := 101;
				ELSE
					state := 20;	
				END_IF;
			END_IF;
		20:
			// --------------------------------------------
			lastZoneID := AsmGetZone.AdditionalInfo.ZoneID;
			
			IF brsmemcmp(ADR(AsmGetZone.AdditionalInfo.Name), ADR(Name), SIZEOF(Name)) = 0 THEN
				// Names match -> found
				Zone := AsmGetZone.Zone;
				ZoneInfo := AsmGetZone.AdditionalInfo;
				state := 100;
			ELSE
				IF AsmGetZone.RemainingCount = 0 THEN
					state := 101;
				ELSE
					state := 30;
				END_IF;
			END_IF;
		30:
			// --------------------------------------------
			IF AsmGetZone.AdditionalInfo.ZoneID <> lastZoneID THEN
				state := 20;	
			END_IF;
			
		100:
			// --------------------------------------------
			ZoneFound := TRUE;
		101:		
			// --------------------------------------------
			ZoneNotFound := TRUE;
		102:		
			// --------------------------------------------
			Error := TRUE;
	END_CASE;
	
	AsmGetZone.Assembly := ADR(Assembly);
	AsmGetZone.Next := (state = 30);
	AsmGetZone();
	
END_FUNCTION_BLOCK
