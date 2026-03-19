#include <brdkSTR_func.h>

signed long brdkStrToUpperCase(unsigned long pString) {
	unsigned long i=0,cnt=0;
	while(((char*)pString)[i]) {
		if((((char*)pString)[i] >= BRDK_STR_ASCII_a) && (((char*)pString)[i] <= BRDK_STR_ASCII_z)) {	/* between a..z */
			((char*)pString)[i] -= BRDK_STR_ASCII_SPACE;
			cnt++;
		} 
		i++;
	}
	return cnt;
}
