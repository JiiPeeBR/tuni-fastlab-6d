#include <brdkSTR_func.h>

signed long brdkStrToLowerCase(unsigned long pString) {
	unsigned long i=0, cnt=0;
	while(((char*)pString)[i]) {
		if((((char*)pString)[i] >= BRDK_STR_ASCII_A) && (((char*)pString)[i] <= BRDK_STR_ASCII_Z)) {	/* between A..Z */
			((char*)pString)[i] += BRDK_STR_ASCII_SPACE;
			cnt++;
		} 
		i++;
	}
	return cnt;
}
