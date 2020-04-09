// gcc -o jmf_rs jmf_rs.c -I./libfec ./libfec/libfec.a 

#include <stdio.h>
#include <stdlib.h>
#include <fec.h>
#include <stdint.h>

int main()
{int j;
 uint8_t rsWorkBuffer[255]; 

 uint8_t tmppar[32]; 
 uint8_t tmpdata[223]; 

 for (j=0;j<255; j++) rsWorkBuffer[j]=(rand()&0xff);  // received data
 for (j=0;j<223;j++)  tmpdata[j]=rsWorkBuffer[j];     // backup data
 encode_rs_ccsds(tmpdata,tmppar,0);                   // create RS code
 for (j=223;j<255;j++) rsWorkBuffer[j]=tmppar[j-223]; // append RS after data
 rsWorkBuffer[42]=42; tmpdata[42]=42;                 // introduce errors
 rsWorkBuffer[43]=42; tmpdata[43]=42;
 rsWorkBuffer[44]=42; tmpdata[44]=42;
 rsWorkBuffer[240]=42;tmppar[240-223]=42;
 printf("RS:%d\n",decode_rs_ccsds(rsWorkBuffer, NULL, 0, 0)); // check that RS can correct
 for (j=0;j<223;j++) 
    if (rsWorkBuffer[j]!=tmpdata[j]) {printf("%d: %hhd -> %hhd\n",j,tmpdata[j],rsWorkBuffer[j]);}
 for (j=223;j<255;j++) 
    if (rsWorkBuffer[j]!=tmppar[j-223]) {printf("%d: %hhd -> %hhd\n",j,tmppar[j-223],rsWorkBuffer[j]);}
}
