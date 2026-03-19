#include <brdkSTR_func.h>

signed long brdkStrReverseWords(unsigned long pString) {
	signed long i=0,wordPos=-1, cnt=0;
	while(((char*)pString)[i]) {
		if(wordPos<0 && (((char*)pString)[i] != BRDK_STR_ASCII_SPACE)) wordPos = i;	
		if(wordPos>-1 && (((char*)pString)[i+1] == BRDK_STR_ASCII_SPACE || ((char*)pString)[i+1] == 0)) {
			brdkStrReverse(pString,wordPos,i);
            wordPos = -1;
			cnt++;
        }
		i++;
	}
	brdkStrReverse(pString,0,i-1);
	return cnt;
}
