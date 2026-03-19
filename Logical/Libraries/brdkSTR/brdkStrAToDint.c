#include <brdkSTR_func.h>

signed long brdkStrAToDint(unsigned long pString, unsigned char base) {
	return brdkStrNAToDint(pString, brdkStrLen(pString), base);
}
