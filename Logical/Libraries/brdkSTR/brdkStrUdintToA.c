#include <brdkSTR_func.h>

signed long brdkStrUdintToA(unsigned long value, unsigned long pString, unsigned char base) {
	int i=0;
	((char*)pString)[0] = 0;
	base = !base ? 10 : base;	/* make sure base is not 0 */
	if (value != 0) {
		while (value > 0) {
			unsigned long rem = value % base;
	       	((char*)pString)[i++] = (rem > 9)? (rem-10) + BRDK_STR_ASCII_A : rem + BRDK_STR_ASCII_0;
	       	value = value/base;
		}
		((char*)pString)[i] = BRDK_STR_ASCII_NULL;	
	}
	else {
		((char*)pString)[i++] = BRDK_STR_ASCII_0;
		((char*)pString)[i] = BRDK_STR_ASCII_NULL;
	}
	brdkStrReverse(pString,0,-1);
	return i;
}
