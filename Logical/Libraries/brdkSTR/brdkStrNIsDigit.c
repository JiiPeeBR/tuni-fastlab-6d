#include <brdkSTR_func.h>

unsigned char brdkStrNIsDigit(unsigned long pString, unsigned long amount) {
	unsigned long i = 0;
	for(;i < amount; i++) if (((char*)pString)[i] < BRDK_STR_ASCII_0 || BRDK_STR_ASCII_9 < ((char*)pString)[i]) return 0;
	return 1;
}
