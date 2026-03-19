#include <brdkSTR_func.h>

signed long brdkStrAToDTStructure(unsigned long pString, unsigned long pDTStructure) {
	/* format must be 2020-01-01 01:01:01,001 */
	DTStructure* dtStruct = (DTStructure*)pDTStructure;
	/* year */
	if(!brdkStrNIsDigit(pString,4)) return -1;
	dtStruct->year = brdkStrNAToUdint(pString, 4, BRDK_STR_CONVERT_DECIMAL);
	if(((char*)pString)[4] != BRDK_STR_ASCII_HYPHEN) return -1;
	/* month */
	if(!brdkStrNIsDigit((unsigned long)&((char*)pString)[5],2)) return -1;
	dtStruct->month = brdkStrNAToUdint((unsigned long)&((char*)pString)[5], 2, BRDK_STR_CONVERT_DECIMAL);
	if(((char*)pString)[7] != BRDK_STR_ASCII_HYPHEN) return -1;
	/* day */
	if(!brdkStrNIsDigit((unsigned long)&((char*)pString)[8],2)) return -1;
	dtStruct->day = brdkStrNAToUdint((unsigned long)&((char*)pString)[8], 2, BRDK_STR_CONVERT_DECIMAL);
	if(((char*)pString)[10] != BRDK_STR_ASCII_SPACE) return -1;
	/* hour */
	if(!brdkStrNIsDigit((unsigned long)&((char*)pString)[11],2)) return -1;
	dtStruct->hour = brdkStrNAToUdint((unsigned long)&((char*)pString)[11], 2, BRDK_STR_CONVERT_DECIMAL);
	if(((char*)pString)[13] != BRDK_STR_ASCII_COLON) return -1;
	/* minute */
	if(!brdkStrNIsDigit((unsigned long)&((char*)pString)[14],2)) return -1;
	dtStruct->minute = brdkStrNAToUdint((unsigned long)&((char*)pString)[14], 2, BRDK_STR_CONVERT_DECIMAL);
	if(((char*)pString)[16] != BRDK_STR_ASCII_COLON) return -1;
	/* second */
	if(!brdkStrNIsDigit((unsigned long)&((char*)pString)[17],2)) return -1;
	dtStruct->second = brdkStrNAToUdint((unsigned long)&((char*)pString)[17], 2, BRDK_STR_CONVERT_DECIMAL);
	if(((char*)pString)[19] != BRDK_STR_ASCII_DOT) return -1;
	/* millisecond */
	if(!brdkStrNIsDigit((unsigned long)&((char*)pString)[20],3)) return -1;
	dtStruct->millisec = brdkStrNAToUdint((unsigned long)&((char*)pString)[20], 3, BRDK_STR_CONVERT_DECIMAL);
	dtStruct->wday = dayOfWeek(dtStruct->day,dtStruct->month,dtStruct->year);
	return 0;
}
