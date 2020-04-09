// from libfec/vtest27.c
// gcc -Wall -o jmf_simplest jmf_simplest.c -I./libfec ./libfec/libfec.a 

#include <stdio.h>
#include <stdlib.h>
#include <fec.h>
#define MAXBYTES (4) 

#define VITPOLYA 0x4F
#define VITPOLYB 0x6D

int viterbiPolynomial[2] = {VITPOLYA, VITPOLYB};
//   mot=0x1ACFFC1D; before Viterbi ...
unsigned char symbols[MAXBYTES*8*2]=   // 4*8 pour bit -> octet et *2 Viterbi
      {1,1,1,1,1,1,0,0, // fc
       1,0,1,0,0,0,1,0, // a2
       1,0,1,1,0,1,1,0, // b6
       0,0,1,1,1,1,0,1, // 3d
       1,0,1,1,0,0,0,0, // b0
       0,0,0,0,1,1,0,1, // 0d
       1,0,0,1,0,1,1,1, // 97
       1,0,0,1,0,1,0,0};// 94
 
int main(int argc,char *argv[]){
  int i,framebits;
  unsigned char data[MAXBYTES]; // *8 for bytes->bits & *2 Viterbi
  void *vp;

  framebits = MAXBYTES*8;
  for (i=0;i<framebits*2;i++) symbols[i]=1-symbols[i];
  for (i=0;i<framebits*2;i++) symbols[i]=symbols[i]*255;
  set_viterbi27_polynomial(viterbiPolynomial);
  vp=create_viterbi27(framebits);
  init_viterbi27(vp,0);
  update_viterbi27_blk(vp,symbols,framebits+6);
  chainback_viterbi27(vp,data,framebits,0);
  for (i=0;i<MAXBYTES;i++) printf("%02hhX",data[i]);
  printf("\n");
  exit(0);
}
