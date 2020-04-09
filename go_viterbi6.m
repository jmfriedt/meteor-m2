clear
f=fopen('sortie.bin');dd=fread(f,inf,'uint8');fclose(f);
dec2hex(dd(1:10))'

pn = [
    0xff, 0x48, 0x0e, 0xc0, 0x9a, 0x0d, 0x70, 0xbc, ...
    0x8e, 0x2c, 0x93, 0xad, 0xa7, 0xb7, 0x46, 0xce, ...
    0x5a, 0x97, 0x7d, 0xcc, 0x32, 0xa2, 0xbf, 0x3e, ...
    0x0a, 0x10, 0xf1, 0x88, 0x94, 0xcd, 0xea, 0xb1, ...
    0xfe, 0x90, 0x1d, 0x81, 0x34, 0x1a, 0xe1, 0x79, ...
    0x1c, 0x59, 0x27, 0x5b, 0x4f, 0x6e, 0x8d, 0x9c, ...
    0xb5, 0x2e, 0xfb, 0x98, 0x65, 0x45, 0x7e, 0x7c, ...
    0x14, 0x21, 0xe3, 0x11, 0x29, 0x9b, 0xd5, 0x63, ...
    0xfd, 0x20, 0x3b, 0x02, 0x68, 0x35, 0xc2, 0xf2, ...
    0x38, 0xb2, 0x4e, 0xb6, 0x9e, 0xdd, 0x1b, 0x39, ...
    0x6a, 0x5d, 0xf7, 0x30, 0xca, 0x8a, 0xfc, 0xf8, ...
    0x28, 0x43, 0xc6, 0x22, 0x53, 0x37, 0xaa, 0xc7, ...
    0xfa, 0x40, 0x76, 0x04, 0xd0, 0x6b, 0x85, 0xe4, ...
    0x71, 0x64, 0x9d, 0x6d, 0x3d, 0xba, 0x36, 0x72, ...
    0xd4, 0xbb, 0xee, 0x61, 0x95, 0x15, 0xf9, 0xf0, ...
    0x50, 0x87, 0x8c, 0x44, 0xa6, 0x6f, 0x55, 0x8f, ...
    0xf4, 0x80, 0xec, 0x09, 0xa0, 0xd7, 0x0b, 0xc8, ...
    0xe2, 0xc9, 0x3a, 0xda, 0x7b, 0x74, 0x6c, 0xe5, ...
    0xa9, 0x77, 0xdc, 0xc3, 0x2a, 0x2b, 0xf3, 0xe0, ...
    0xa1, 0x0f, 0x18, 0x89, 0x4c, 0xde, 0xab, 0x1f, ...
    0xe9, 0x01, 0xd8, 0x13, 0x41, 0xae, 0x17, 0x91, ...
    0xc5, 0x92, 0x75, 0xb4, 0xf6, 0xe8, 0xd9, 0xcb, ...
    0x52, 0xef, 0xb9, 0x86, 0x54, 0x57, 0xe7, 0xc1, ...
    0x42, 0x1e, 0x31, 0x12, 0x99, 0xbd, 0x56, 0x3f, ...
    0xd2, 0x03, 0xb0, 0x26, 0x83, 0x5c, 0x2f, 0x23, ...
    0x8b, 0x24, 0xeb, 0x69, 0xed, 0xd1, 0xb3, 0x96, ...
    0xa5, 0xdf, 0x73, 0x0c, 0xa8, 0xaf, 0xcf, 0x82, ...
    0x84, 0x3c, 0x62, 0x25, 0x33, 0x7a, 0xac, 0x7f, ...
    0xa4, 0x07, 0x60, 0x4d, 0x06, 0xb8, 0x5e, 0x47, ...
    0x16, 0x49, 0xd6, 0xd3, 0xdb, 0xa3, 0x67, 0x2d, ...
    0x4b, 0xbe, 0xe6, 0x19, 0x51, 0x5f, 0x9f, 0x05, ...
    0x08, 0x78, 0xc4, 0x4a, 0x66, 0xf5, 0x58 
]; 

longueur=length(dd)/1024;longueur=floor(longueur)
dd=reshape(dd(1:longueur*1024),1024,longueur);

for k=1:longueur
% k
% dec2hex(dd(1:4,k))
 final(:,k)=dd(5:end,k); % vire l'entete de synchro de chaque paquet
 final(:,k)=[bitxor(final(1:255,k)',pn) bitxor(final(1+255:255+255,k)',pn) bitxor(final(1+255*2:255+255*2,k)',pn) bitxor(final(1+255*3:255+255*3,k)',pn)];
% m=find(final(:,k)==167);(final(m+1,k)==163)'
end

final=final(1:1020-128,:);
% http://planet.iitp.ru/english/spacecraft/meteor_m_n2_structure_2_eng.htm (Appendix A)
date_header=final(589:589+7,9)'
% on a trouve' la date dans  CADU numero 9 => on se focalise dessus
date=final(589+8:589+11,9)'
%ans =
%
%    11
%    48
%    33
%   197
% Onboard time: 11:48:33.788

% octave:28> final(1:16,:)                                                               20020081350.pdf NASA p.9 du PDF
%     64    64    64    64    64    64    64    64    64    64    64    64    64    64  <- 01 00000000 VCDU version & Id
%      5     5     5     5     5     5     5     5     5     5     5     5     5     5  <- 000101 VCDU Type http://www.eoc.csiro.au/modis/db_benevento_2005/Posters/Zhu%20Poster.pdf [1]
%    140   140   140   140   140   140   140   140   140   140   140   140   140   140 \                    pdf_ten_eps-metop-sp2gr.pdf p.149 : AVHRR LR VCID=5 pour APID 64..69 
%    163   163   163   163   163   163   163   163   163   163   163   163   163   163 - VCDU counter (3bytes)
%     43    44    45    46    47    48    49    50    51    52    53    54    55    56 /
%      0     0     0     0     0     0     0     0     0     0     0     0     0     0 signaling field=0 for real time data
%      0     0     0     0     0     0     0     0     0     0     0     0     0     0 VCDU insert ...  => encryption flag pdf_ten_eps-metop-sp2gr.pdf p.150 (off)
%      0     0     0     0     0     0     0     0     0     0     0     0     0     0 ... zone         => key number      pdf_ten_eps-metop-sp2gr.pdf p.150 (encryption off)
%      0     0     2     1     0     0     0     0     0     0     0     0     2     0 M_PDU header spare should be 5 bits @ 0 https://public.ccsds.org/Pubs/732x0b1s.pdf p.60
%     18   142    28    54    18   130    78   226     0    20    70    28    82    32 M_PDU 1st header pointer 11 bits pdf_ten_eps-metop-sp2gr.pdf p.147
% end of M-PDU header : next 882 bytes are M-PDU (Virtual channel field)                  |
%     77   166   239   222    73    82    83   199     8    28   232   247   165   183    x=final(9,:)*256+final(10,:)+12 => 30 154 552 322 30 142 90 238 12 32 82 40 606 44
%    133   188   229    42    24    23   220    94    68   117    92   151    87   203    for k=1:length(x);final(x(k),k),end
%     75   177   221   215     0    48    49   128    13   166     8   218   126   212       64 64 64 64 65 65 65 65 68 64 64 64 64 65 -> APID between 64 and 69
%     42   138   254    87    12    32   249    87    34   172   247   107     9   142
%    146   238   236    80   215    96   143   121     0   124    12    89    86   191
%    179   227    64   144    89    59   240   105   105   251    46    43     0   199
%                                                     ^ 
%                                                     \ 8 = 0000 1000 = version ID (000)/Type Indicator (0)/Secondary Header (1=present)/000 APID
%                                                     \68 = APID   cf http://planet.iitp.ru/english/spacecraft/meteor_m_n2_structure_2_eng.htm
%                                                     \0 105=packet length

% [1] http://planet.iitp.ru/english/spacecraft/meteor_m_n2_structure_2_eng.htm : virtual channel ID - 5dec (the scanner information is present), 63dec (the scanner information is missing);

channel_apid=final(12,9)
% cf http://planet.iitp.ru/english/spacecraft/meteor_m_n2_structure_2_eng.htm
P=26;
l=final(16,9);                  % vector with packet lengths: 16=offset from VDU beginning
secondary=final(16-5,9);        % secondary packet indicator is 5 bytes before size
apid=final(16-4,9);             % apid is 4 bytes before
m=final([11:11+P],9);           % ... so show packet from byte 16-4=12 onward
k=1
while ((sum(l)+(k-1)*7)<(1020-128))
  m=[m final([11:11+P]+sum(l)+(k)*7,9)]; % 7 = 8 byte long secondary header-1
  secondary(k+1)=final(16+sum(l)+(k)*7-5,9);
  apid(k+1)=final(16+sum(l)+(k)*7-4,9);
  l(k+1)=final(16+sum(l)+(k)*7,9); % 16=offset from VDU beginning
  k=k+1;
end

%[final([12:32],9) final([12:32]+105+7,9) final([12:32]+105+47+7+7,9) final([12:32]+105+47+49+7+7+7,9) final([12:32]+105+47+49+69+7+7+7+7,9) ...
% final([12:32]+105+47+49+69+81+7+7+7+7+7,9) final([12:32]+105+47+49+69+81+107+7+7+7+7+7+7,9) final([12:32]+105+47+49+69+81+107+57+7+7+7+7+7+7+7,9)...
% final([12:32]+105+47+49+69+81+107+57+57+7+7+7+7+7+7+7+7,9) final([12:32]+105+47+49+69+81+107+57+57+97+7+7+7+7+7+7+7+7+7,9) final([12:32]+105+47+49+69+81+107+57+57+97+77+7+7+7+7+7+7+7+7+7+7,9)]
m

%    68    68 APID
%    13    13 grouping = 00 (packet 2 to 14) 2 MSbits
%    34    35 counter
%     0     0 _ packet length
%   105    47 /
%     0     0 - day (0)
%     0     0 /
%     2     2 \
%   136   136 - ms of
%   181   181 / day
%   124   124 /
%     0     0 - us of day (0)
%     0     0 /
%    98   112 - number of 1st MCU in given packet (increments by 14) -> size if after compression !
%     0     0 - scan header : 16x0
%     0     0 /
%   255   255 - factor of quality 0xFF F0=250 240
%   240   240 /
%    77    77 value of quality factor
%   243   186 beginning of 14 MCU compressed JPEG
%   197    41

%l(1)=final(16,9);                  % vector with packet lengths
%jpeg=[final([1:l(1)]+12+19-1,9)']; % read payload (14 MCU): 243 197 ...
%l(2)=final(16+l(1)+7,9);           % next packet header (next packet length)
%jpeg=[jpeg final([1:l(2)]+12+19+l(1)-1+7,9)'];
%l(3)=final(16+sum(l)+7+7,9)
%jpeg=[jpeg final([1:l(3)]+12+19+sum(l(1:end-1))-1+7+7,9)']; % ... and so on
%whos jpeg*  % COMMENT SAVOIR SI 1ER OCTET EST LE DEBUT D'UNE SEQUENCE JPEG ?
% au lieu de regarder APID 68, on va chercher APID 64 qui commence en fin de ce paquet
% on recommence donc avec APID=64

l
l(end)=l(end)-(925-892);                                      % le paquet continue sur CADU 10 ! on n'a que 46 octets dans de CADU 9
final([1:l(k)]+12+19+sum(l(1:k-1))-1+7*(k-1),9)'

%for k=9:length(l)-1 % 9:11
%  jpeg=final([1:l(k)-7]+12+19+sum(l(1:k-1))-1+7*(k-1),9); % commence bien par 173 166 ... puis 238 148 et 235 77   -> -7 car length=user+secondary-1
%  f=fopen(['jpeg09_',num2str(k,'%03d'),'.bin'],'w');                                                             % => user=length-secondary+1=length-7
%  fwrite(f,jpeg,'uint8');
%  fclose(f);
%end
% on a maintenant "length" octets representant JPEG compresse'e sur lesquels appliquer
% Huffman -> RLE -> iDCT

k=11;
jpeg=final([1:l(k)]+12+19+sum(l(1:k-1))-1+7*(k-1),9); 
% PROBLEME DE TRANSITION: il nous faudrait 79-7=72 octets, on a a pris 46 et il en resterait 27 on ne peut en avoir que 20 ... 7 qui restent ?!
final([1:22]+9,10)';               % debut de la ligne 10 : commence par 20 28 117 : 20=1st packet header
jpeg=[jpeg ; final([1:20]+10,10)]; % on annoncait 79 octets dans le dernier paquet : il en manque 925-892=33
final([1:22]+31,10)';              % debut du MCU de la ligne 10

%%%%%%%%% 10 %%%%

clear l secondary apid m
l=final(36,10);                   % vector with packet lengths
secondary=final(36-5,10);
apid=final(36-4,10);
m=final([32:32+P],10);
k=1;
while ((sum(l)+(k-1)*7+32)<(1020-128))
  m=[m final([32:32+P]+sum(l)+(k)*7,10)];
  secondary(k+1)=final(36+sum(l)+(k)*7-5,10);
  apid(k+1)=final(36+sum(l)+(k)*7-4,10);
  l(k+1)=final(36-1+sum(l)+(k)*7,10)*256+final(36+sum(l)+(k)*7,10); % 16=offset from VDU beginning
  k=k+1;
end

l
for k=1:length(l)-1
  jpeg=final([1:l(k)]+32+19+sum(l(1:k-1))-1+7*(k-1),10); 
%  f=fopen(['jpeg10_',num2str(k,'%03d'),'.bin'],'w');
%  fwrite(f,jpeg,'uint8');
%  fclose(f);
end

jpeg=[jpeg ; final([1:20]+10,11)]; % on annoncait 79 octets dans le dernier paquet : il en manque 925-892=33
final([1:22]+31,10)';              % debut du MCU de la ligne 10
%  f=fopen(['jpeg09_',num2str(k,'%03d'),'.bin'],'w');                                                             % => user=length-secondary+1=length-7
%  fwrite(f,jpeg,'uint8');
%  fclose(f);

%%%%%%%%% 11 %%%%

% colonne=12;
for colonne=1:longueur
  first_head=final(9,colonne)*256+final(10,colonne);             % 70 pour colonne 11
  final([1:first_head+1]+9,colonne)';       % debut de la ligne 11 : premier header en 70
  final([1:22]+first_head+11,colonne)';      % debut du MCU de la ligne 11
  
  clear l secondary apid m counter quality
  l=final(first_head+16-1,colonne)*256+final(first_head+16,colonne);                   % vector with packet lengths
  secondary=final(first_head+16-5,colonne);
  apid=final(first_head+16-4,colonne);
  counter=final(first_head+16-3,colonne)*256+final(first_head+16-2,colonne);
  quality=final(first_head+16-4+18,colonne); % quality=APID+18
  m=final([first_head+12:first_head+12+P],colonne);
  k=1;
  while ((sum(l)+(k)*7+first_head+12+P)<(1020-128))
    m=[m final([first_head+12:first_head+12+P]+sum(l)+(k)*7,colonne)];
    secondary(k+1)=final(first_head+16+sum(l)+(k)*7-5,colonne);
    apid(k+1)=final(first_head+16+sum(l)+(k)*7-4,colonne);
    counter(k+1)=final(first_head+16+sum(l)+(k)*7-3,colonne)*256+final(first_head+16+sum(l)+(k)*7-2,colonne);
    quality(k+1)=final(first_head+16+sum(l)+(k)*7-4+18,colonne);
    l(k+1)=final(first_head+16-1+sum(l)+(k)*7,colonne)*256+final(first_head+16+sum(l)+(k)*7,colonne); % 16=offset from VDU beginning
    k=k+1;
  end
% m
  
%  l
  for k=1:length(l)-1
    jpeg=final([1:l(k)]+first_head+12+19+sum(l(1:k-1))-1+7*(k-1),colonne); 
    f=fopen(['jpeg',num2str(apid(k),'%03d'),'_',num2str(colonne,'%03d'),'_',num2str(k,'%03d'),'_',num2str(counter(k),'%05d'),'_',num2str(quality(k),'%03d'),'.bin'],'w');
    fwrite(f,jpeg,'uint8');
    fclose(f);
  end
  
  k=length(l);
  jpeg=final([1+first_head+12+19+sum(l(1:k-1))-1+7*(k-1):end],colonne); 
  first_head=final(9,colonne+1)*256+final(10,colonne+1);
  jpeg=[jpeg ; final([1:first_head]+10,colonne+1)]; % on annoncait 79 octets dans le dernier paquet : il en manque 925-892=33
    f=fopen(['jpeg',num2str(apid(k),'%03d'),'_',num2str(colonne,'%03d'),'_',num2str(k,'%03d'),'_',num2str(counter(k),'%05d'),'_',num2str(quality(k),'%03d'),'.bin'],'w');
    fwrite(f,jpeg,'uint8');
    fclose(f);
% apid
counter
end
