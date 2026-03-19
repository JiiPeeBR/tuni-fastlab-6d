#include <brdkSTR_func.h>

/* search for a string in a string */
signed long search(signed long pString, signed long lenString, signed long pSearchString, signed long lenSearch) {
	signed long pos=-1, i=0,j=0;
	if(lenString>lenSearch) {
		for(i=0; i <= lenString-lenSearch; i++) {
			j=0;
			if(((char*)pString)[i] == ((char*)pSearchString)[j]) {	
				while(((char*)pString)[i+j] == ((char*)pSearchString)[j]) {
					j++;
					if(j==lenSearch) {
						pos = i;
						i=lenString-lenSearch+1;
						break;
					}
				}
			}
		}
	}
	return pos;
}

unsigned char dayOfWeek(unsigned char d,unsigned char m, unsigned short y){
	unsigned char t[] = { 0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4 };
	if (m < 3) y -= 1;
	return((y + y / 4 - y / 100 + y / 400 + t[m - 1] + d) % 7);
}
