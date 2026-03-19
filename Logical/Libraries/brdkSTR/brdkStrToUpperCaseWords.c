#include <brdkSTR_func.h>

signed long brdkStrToUpperCaseWords(unsigned long pString) {
	unsigned long i=0,cnt=0;
	if(((char*)pString)[i]) {
		if(((char*)pString)[i] >= BRDK_STR_ASCII_a && ((char*)pString)[i] <= BRDK_STR_ASCII_z) {	/* check the first character */
	 		((char*)pString)[i] -= BRDK_STR_ASCII_SPACE;
			cnt++;
		}
	}
	i++;
	while(((char*)pString)[i]) {
		if((((char*)pString)[i] >= BRDK_STR_ASCII_a) && (((char*)pString)[i] <= BRDK_STR_ASCII_z) && ((char*)pString)[i-1] == BRDK_STR_ASCII_SPACE){	/* between a..z and a space before */
			((char*)pString)[i] -= BRDK_STR_ASCII_SPACE;
			cnt++;	
		} 
		i++;
	}
	return cnt;
}
