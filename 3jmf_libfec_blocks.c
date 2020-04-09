// from libfec/vtest27.c
// gcc -o jmf_libfec jmf_libfec_blocks.c -I./libfec ./libfec/libfec.a 
// gcc -o jmf_libfec jmf_libfec_blocks.c -I./libcorrect/build/include -I./libcorrect/include ./libcorrect/build/lib/libfec.a 

/*
 f=fopen('sortie_block.bin');dd=fread(f,inf,'uint8');fclose(f);
 f=fopen('sortie_long.bin');ddok=fread(f,inf,'uint8');fclose(f);
 k=find(abs(ddok(1:length(dd))-dd)>0) ;
 length(k)
ans =  1811
 k(1)
ans =  236544
*/

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h> // read
#include <fec.h>
#define MAXBYTES (1024) 

#define VITPOLYA 0x4F
#define VITPOLYB 0x6D

int viterbiPolynomial[2] = {VITPOLYA, VITPOLYB};
 
int main(int argc,char *argv[]){
  int res,i,framebits,fdi,fdo;
  unsigned char data[MAXBYTES],symbols[8*2*(MAXBYTES+6)]; // *8 for bytes->bits & *2 Viterbi
  void *vp;

  fdi=open("./extrait.s",O_RDONLY); 
  fdo=open("./sortie.bin",O_WRONLY|O_CREAT,S_IRWXU|S_IRWXG|S_IRWXO); 
  read(fdi,symbols,4756+8);  // offset
  framebits = MAXBYTES*8;

do {
  res=read(fdi,symbols,2*framebits+50);
  lseek(fdi,-50,SEEK_CUR);
  for (i=1;i<2*framebits;i+=2) symbols[i]=-symbols[i]; // compensate for I/Q constellation rotation
  set_viterbi27_polynomial(viterbiPolynomial);
  vp=create_viterbi27(framebits);
  init_viterbi27(vp,0);
  update_viterbi27_blk(vp,symbols,framebits+6);
  chainback_viterbi27(vp,data,framebits,0);
  write(fdo,data,MAXBYTES); 
  for (i=0;i<15;i++) printf("%02hhX",data[i]);
  printf(" ... ",res);
  for (i=1024-15-1;i<1024;i++) printf("%02hhX",data[i]);
  printf("\n");
} while (res==(2*framebits+50));
  close(fdi);
  close(fdo);
  exit(0);
}

