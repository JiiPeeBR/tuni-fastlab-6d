#include <brdkSTR_func.h>

signed long brdkStrToDec(unsigned long pString) {
	signed long i=0,j=0;
	while(((char*)pString)[i]) {
		if(((char*)pString)[i+1] != BRDK_STR_ASCII_NULL) {
			char tmp[3];
			tmp[0] = ((char*)pString)[i++];
			tmp[1] = ((char*)pString)[i++];
			tmp[2] = 0;
			((char*)pString)[j++] = brdkStrAToUdint((unsigned long)&tmp, BRDK_STR_CONVERT_HEX);
		}
		else {
			i = -1;
			break;
		}
		((char*)pString)[j] = BRDK_STR_ASCII_NULL;
	}
	return i;
}
