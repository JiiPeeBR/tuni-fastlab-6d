#include <brdkSTR_func.h>

unsigned char brdkStrIsAlphabet(unsigned long pString) {
	unsigned long len = 0;
	while(((char*)pString)[len]) {
		if (((char*)pString)[len] > BRDK_STR_ASCII_Z) {	
			if(((char*)pString)[len] < BRDK_STR_ASCII_a || BRDK_STR_ASCII_z < ((char*)pString)[len]) return 0;
		}
		else if(((char*)pString)[len] < BRDK_STR_ASCII_A) return 0;	
		len++;
	}
	return 1;
}
