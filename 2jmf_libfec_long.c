// from libfec/vtest27.c
// gcc -o jmf_libfec jmf_libfec.c -I./libfec ./libfec/libfec.a 

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h> // read
#include <fec.h>
#define MAXBYTES (11170164/16)

#define VITPOLYA 0x4F
#define VITPOLYB 0x6D
int viterbiPolynomial[2] = {VITPOLYA, VITPOLYB};
 
int main(int argc,char *argv[]){
  int i,framebits,fd;
  unsigned char data[MAXBYTES],*symbols; // [8*2*(MAXBYTES+6)]; // *8 for bytes->bits & *2 Viterbi
  void *vp;

  symbols=(unsigned char*)malloc(8*2*(MAXBYTES+6));
/*
root@rugged:~# ulimit -a
stack size              (kbytes, -s) 8192
-> static allocation (stack) of max 8 MB, after requires malloc on the heap
*/
  fd=open("./extrait.s",O_RDONLY); read(fd,symbols,MAXBYTES*16); close(fd);

  for (i=1;i<MAXBYTES*16;i+=2) symbols[i]=-symbols[i]; // compensate for I/Q constellation rotation
  framebits = MAXBYTES*8;
  set_viterbi27_polynomial(viterbiPolynomial);
  vp=create_viterbi27(framebits);
  init_viterbi27(vp,0);
  update_viterbi27_blk(vp,&symbols[4756+8],framebits+6);
  chainback_viterbi27(vp,data,framebits,0);
  for (i=0;i<20;i++) printf("%02hhX",data[i]);
  printf("\n");
  fd=open("./sortie.bin",O_WRONLY|O_CREAT,S_IRWXU|S_IRWXG|S_IRWXO); 
  write(fd,data,framebits); 
  close(fd);
  exit(0);
}
