#include <brdkSTR_func.h>

unsigned char brdkStrIsDigit(unsigned long pString) {
	unsigned long len = 0;
	while(((char*)pString)[len]) {
		if (((char*)pString)[len] < BRDK_STR_ASCII_0 || BRDK_STR_ASCII_9 < ((char*)pString)[len]) return 0;
		len++;
	}
	return 1;
}

