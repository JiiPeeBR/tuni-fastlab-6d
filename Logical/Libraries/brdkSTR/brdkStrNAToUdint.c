#include <brdkSTR_func.h>

unsigned long brdkStrNAToUdint(unsigned long pString, unsigned long amount, unsigned char base) {
	unsigned long value = 0,i;
	if(amount > 0) {
		for(i=0; i < amount; i++) {
			switch(base) {

				case 0: case 10:
					if(((char*)pString)[i] >= BRDK_STR_ASCII_0 && ((char*)pString)[i] <= BRDK_STR_ASCII_9) value = (value * 10) + (((char*)pString)[i]-BRDK_STR_ASCII_0);			/* 0x30 = 0, 0x39 = 9 */
					else {
						value = 0;
						i = amount;	
					}
					break;

				case 2:
					if(((char*)pString)[i] >= BRDK_STR_ASCII_0 && ((char*)pString)[i] <= BRDK_STR_ASCII_1) value += (((char*)pString)[i]-BRDK_STR_ASCII_0)*(1<<(amount-1-i));			/* 0x30 = 0, 0x31 = 1 */		
					else {
						value = 0;
						i = amount;	
					}
					break;

				case 16:
					if(((char*)pString)[i] >= BRDK_STR_ASCII_0 && ((char*)pString)[i] <= BRDK_STR_ASCII_9) 	value += (((char*)pString)[i]-BRDK_STR_ASCII_0)*(1<<(4*(amount-1-i)));		/* 0x30 = 0, 0x39 = 9 */
					else if(((char*)pString)[i] >= BRDK_STR_ASCII_A && ((char*)pString)[i] <= BRDK_STR_ASCII_F) value += (((char*)pString)[i]-BRDK_STR_ASCII_7)*(1<<(4*(amount-1-i)));	/* 0x41 = A, 0x46 = F */
					else if(((char*)pString)[i] >= BRDK_STR_ASCII_a && ((char*)pString)[i] <= BRDK_STR_ASCII_f)value += (((char*)pString)[i]-BRDK_STR_ASCII_W)*(1<<(4*(amount-1-i)));	/* 0x61 = a, 0x66 = f */
					else {
						value = 0;
						i = amount;	
					}
					break;

				default:
					value = 0;
					i = amount;
					break;

			}
		}	
	}
	return value;
}
