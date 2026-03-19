#ifndef BRDK_STR_FUNCS
#define BRDK_STR_FUNCS 1

#include <brdkSTR.h>
#include <bur/plctypes.h>

#ifdef __cplusplus
	extern "C"
	{
#endif

signed long search(signed long pString, signed long lenString, signed long pSearchString, signed long lenSearch);
unsigned char dayOfWeek(unsigned char d,unsigned char m, unsigned short y);

#ifdef __cplusplus
	};
#endif

#endif
