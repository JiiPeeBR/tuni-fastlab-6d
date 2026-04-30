
(*  *)
FUNCTION_BLOCK fdMove6D
			   
//	IF NOT Execute THEN
//		state := 0;
//		i := 0;
//	END_IF;
//	
//	CASE state OF
//		0:
//			// --------------------------------------------
//			IF Execute THEN
//				state := 10;
//			END_IF;
//		100:
//			// --------------------------------------------
//			ZoneFound := TRUE;
//		101:		
//			// --------------------------------------------
//			ZoneNotFound := TRUE;
//		102:		
//			// --------------------------------------------
//			Error := TRUE;
//	END_CASE;
//	
//	Move6D.Assembly := ADR(Shuttle);
//	AsmGetZone.Next := (state = 30);
//	AsmGetZone();
//	
//	ShGetInfo.Shuttle := ADR(Shuttle);
//	ShGetInfo();
	
END_FUNCTION_BLOCK
