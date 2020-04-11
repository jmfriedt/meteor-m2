// Gwen : comment definir imager() sans virer les classes dans le .cc et .h ?

/*
for i in ../jpeg068*bin ;do echo $i;cp $i jpeg.bin; ./meteor_image >> solution; wc -l solution >> l;done
tmp=load('solution');m=[];for k=1:size(tmp)(1)  a=reshape(tmp(k,:),8,8); m=[m  a'];;end
mm=[]
for k=1:50
  mm=[mm ; m(:,1+(k-1)*1568:1568+(k-1)*1568)];
end


*/

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include "meteor_image.h"

using namespace gr::starcoder::meteor;

int main(int argc,char **argv)
{int fd,len,k,quality=77;
 unsigned char packet[1100];
 imager img=imager();
 
 if (argc>1) quality=atoi(argv[1]);
 fd=open("jpeg.bin",O_RDONLY);
 len=read(fd, packet, 1100);
 close(fd);
 img.dec_mcus(packet, len, 65,0,0,quality);
}
