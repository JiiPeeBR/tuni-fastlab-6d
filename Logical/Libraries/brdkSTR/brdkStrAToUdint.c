#include <brdkSTR_func.h>

unsigned long brdkStrAToUdint(unsigned long pString, unsigned char base) {
	return brdkStrNAToUdint(pString, brdkStrLen(pString), base);
}
