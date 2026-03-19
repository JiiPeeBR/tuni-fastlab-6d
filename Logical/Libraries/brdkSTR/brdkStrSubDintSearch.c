#include <brdkSTR_func.h>

signed long brdkStrSubDintSearch(unsigned long pSource, unsigned long pStart, unsigned long pEnd, signed long startOffset, unsigned char base) {
	signed long posEnd, lenSource = brdkStrLen(pSource), lenStart = brdkStrLen(pStart), lenEnd, posGreedyStartOffset;
	signed long posStart = search(pSource, lenSource, pStart, lenStart);
	if(posStart > -1) {
		lenEnd = brdkStrLen(pEnd);
		posGreedyStartOffset = posStart + lenStart + startOffset;
		posEnd = search((unsigned long)&((char*)pSource)[posGreedyStartOffset], lenSource-posGreedyStartOffset, pEnd, lenEnd);
		if(posEnd > -1) {
			/* check if string starts with a hyphen */
			if(((char*)pSource)[posGreedyStartOffset] == BRDK_STR_ASCII_HYPHEN) return -brdkStrNAToUdint((unsigned long)&((char*)pSource)[posGreedyStartOffset+1],posEnd,base);
			else return brdkStrNAToUdint((unsigned long)&((char*)pSource)[posGreedyStartOffset],posEnd,base);
		}
	}
	return -1;
}
