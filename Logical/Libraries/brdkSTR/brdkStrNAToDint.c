#include <brdkSTR_func.h>

signed long brdkStrNAToDint(unsigned long pString, unsigned long amount, unsigned char base) {
	/* check if string starts with a hypen */
	if(amount == 0) return 0;
	if(((char*)pString)[0] == BRDK_STR_ASCII_HYPHEN) return -brdkStrNAToUdint(pString+1,amount-1, BRDK_STR_CONVERT_DECIMAL);
	else return brdkStrNAToUdint(pString, amount, base);
}
