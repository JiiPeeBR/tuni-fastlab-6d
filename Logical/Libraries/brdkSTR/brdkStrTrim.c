#include <brdkSTR_func.h>

signed long brdkStrTrim(unsigned long pString, signed long direction) {
	signed long i,j=0,len;
	if(direction == BRDK_STR_BOTH_TRIM || direction == BRDK_STR_LEFT_TRIM) {
		len = brdkStrLen(pString);
		while(((char*)pString)[0] == BRDK_STR_ASCII_SPACE) {
			for(i=0;i < len;i++) ((char*)pString)[i] = ((char*)pString)[i+1];	/* moves all characters one place left */
			len--;
			j++;
		}
	}
	if(direction == BRDK_STR_BOTH_TRIM || direction == BRDK_STR_RIGHT_TRIM) {
		len = brdkStrLen(pString)-1;
		while(((char*)pString)[len] == BRDK_STR_ASCII_SPACE && len > -1) {
			((char*)pString)[len--] = BRDK_STR_ASCII_NULL;
			j++;
		}
	}
	return j;
}
