#include <brdkSTR_func.h>

unsigned char brdkStrIsEmpty(unsigned long pString) {
	return ((char*)pString)[0] == BRDK_STR_ASCII_NULL;
}
