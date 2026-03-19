#include <brdkSTR_func.h>

signed long brdkStrDTStructureToA(unsigned long pDTStructure, unsigned long pString) {
	/* format will be 2020-01-01 01:01:01,001 */
	DTStructure* dtStruct = (DTStructure*)pDTStructure;
	brdkStrUdintToA(dtStruct->year,(unsigned long)&(((char*)pString)[0]),BRDK_STR_CONVERT_DECIMAL);
	((char*)pString)[4] = BRDK_STR_ASCII_HYPHEN;
	if(dtStruct->month < 10) {
		((char*)pString)[5] = BRDK_STR_ASCII_0;
		brdkStrUdintToA(dtStruct->month,(unsigned long)&(((char*)pString)[6]),BRDK_STR_CONVERT_DECIMAL);
	}
	else brdkStrUdintToA(dtStruct->month,(unsigned long)&(((char*)pString)[5]),BRDK_STR_CONVERT_DECIMAL);
	((char*)pString)[7] = BRDK_STR_ASCII_HYPHEN;
	if(dtStruct->day < 10) {
		((char*)pString)[8] = BRDK_STR_ASCII_0;
		brdkStrUdintToA(dtStruct->day,(unsigned long)&(((char*)pString)[9]),BRDK_STR_CONVERT_DECIMAL);
	}
	else brdkStrUdintToA(dtStruct->day,(unsigned long)&(((char*)pString)[8]),BRDK_STR_CONVERT_DECIMAL);
	((char*)pString)[10] = BRDK_STR_ASCII_SPACE;
	if(dtStruct->hour < 10) {
		((char*)pString)[11] = BRDK_STR_ASCII_0;
		brdkStrUdintToA(dtStruct->hour,(unsigned long)&(((char*)pString)[12]),BRDK_STR_CONVERT_DECIMAL);
	}
	else brdkStrUdintToA(dtStruct->hour,(unsigned long)&(((char*)pString)[11]),BRDK_STR_CONVERT_DECIMAL);
	((char*)pString)[13] = BRDK_STR_ASCII_COLON;
	if(dtStruct->minute < 10) {
		((char*)pString)[14] = BRDK_STR_ASCII_0;
		brdkStrUdintToA(dtStruct->minute,(unsigned long)&(((char*)pString)[15]),BRDK_STR_CONVERT_DECIMAL);
	}
	else brdkStrUdintToA(dtStruct->minute,(unsigned long)&(((char*)pString)[14]),BRDK_STR_CONVERT_DECIMAL);
	((char*)pString)[16] = BRDK_STR_ASCII_COLON;
	if(dtStruct->second < 10) {
		((char*)pString)[17] = BRDK_STR_ASCII_0;
		brdkStrUdintToA(dtStruct->second,(unsigned long)&(((char*)pString)[18]),BRDK_STR_CONVERT_DECIMAL);
	}
	else brdkStrUdintToA(dtStruct->second,(unsigned long)&(((char*)pString)[17]),BRDK_STR_CONVERT_DECIMAL);
	((char*)pString)[19] = BRDK_STR_ASCII_DOT;
	if(dtStruct->millisec < 10) {
		((char*)pString)[20] = BRDK_STR_ASCII_0;
		((char*)pString)[21] = BRDK_STR_ASCII_0;
		brdkStrUdintToA(dtStruct->millisec,(unsigned long)&(((char*)pString)[22]),BRDK_STR_CONVERT_DECIMAL);
	}
	else if(dtStruct->millisec < 100) {
		((char*)pString)[20] = BRDK_STR_ASCII_0;
		brdkStrUdintToA(dtStruct->millisec,(unsigned long)&(((char*)pString)[21]),BRDK_STR_CONVERT_DECIMAL);
	}
	else brdkStrUdintToA(dtStruct->millisec,(unsigned long)&(((char*)pString)[20]),BRDK_STR_CONVERT_DECIMAL);
	((char*)pString)[23] = BRDK_STR_ASCII_NULL;
	return 23; 
}
