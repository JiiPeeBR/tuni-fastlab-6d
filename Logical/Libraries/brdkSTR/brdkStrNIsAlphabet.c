#include <brdkSTR_func.h>

unsigned char brdkStrNIsAlphabet(unsigned long pString, unsigned long amount) {
	unsigned long i = 0;
	for(; i < amount; i++) {
		if(((char*)pString)[i] > BRDK_STR_ASCII_Z) {	
			if(((char*)pString)[i] < BRDK_STR_ASCII_a || BRDK_STR_ASCII_z < ((char*)pString)[i]) return 0;
		}
		else if(((char*)pString)[i] < BRDK_STR_ASCII_A) return 0;	
	}
	return 1;
}
