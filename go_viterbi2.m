% cf www.invocom.et.put.poznan.pl/~invocom/C/P1-7/en/P1-7/p1-7_1_6.htm
%    pour la structure de la matrice
% home.netcom.com/~chip.f/viterbi/algrthms.html donne la meme solution que ci dessous
d=[0 1 0 1 1 1]
G1=[1 1 1]
G2=[1 0 1]
G=[G1(1) G2(1) G1(2) G2(2) G1(3) G2(3)   0     0     0     0     0    0;
     0    0    G1(1) G2(1) G1(2) G2(2) G1(3) G2(3)   0     0     0    0;
     0    0       0    0   G1(1) G2(1) G1(2) G2(2) G1(3) G2(3)   0    0;
     0    0       0    0     0     0   G1(1) G2(1) G1(2) G2(2) G1(3) G2(3);
     0    0       0    0     0     0     0     0   G1(1) G2(1) G1(2) G2(2);
     0    0       0    0     0     0     0     0     0     0   G1(1) G2(1);
]
mod(d*G,2)

d=[0 1 0 1 1 1 0 0 1 0 1 0 0 0 1]; % mot a encoder
Gg=[];
for k=1:length(G1)
  Gg=[Gg G1(k) G2(k)];             % fabrique la version interlacee des deux polynomes generateurs
end
G=[Gg zeros(1,2*length(d)-length(Gg))] % premiere ligne de la matrice de convolution
for k=1:length(d)-length(G1)
  G=[G ; zeros(1,2*k) Gg zeros(1,2*length(d)-length(Gg)-2*k)] ;
end
G=[G ; zeros(1,2*length(d)-4) Gg(1:4)]; % dernieres lignes de la matrice de convolution
G=[G ; zeros(1,2*length(d)-2) Gg(1:2)];
mod(d*G,2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % '1'=0x31           0x32            0x33              0x34              0x34
d=[0 0 1 1 0 0 0 1  0 0 1 1 0 0 1 0  0 0 1 1 0 0 1 1  0 0 1 1 0 1 0 0  0 0 1 1 0 1 0 0]; % mot a encoder
d=[0 0 0 1 1 0 1 0  1 1 0 0 1 1 1 1  1 1 1 1 1 1 0 0  0 0 0 1 1 1 0 1 ]; % 1A CF FC 1D 00
% d=[0 0 1 1 0 0 0 1  0 0 1 1 0 0 1 0  0 0 1 1 0 0 1 1   ]; % mot a encoder
G1=[1 1 1 1 0 0 1 ] % 4F
G2=[1 0 1 1 0 1 1 ] % 6D
Gg=[];
for k=1:length(G1)
  Gg=[Gg G1(k) G2(k)];             % fabrique la version interlacee des deux polynomes generateurs
end
G=[Gg zeros(1,2*length(d)-length(Gg))]; % premiere ligne de la matrice de convolution
for k=1:length(d)-length(G1)
  G=[G ; zeros(1,2*k) Gg zeros(1,2*length(d)-length(Gg)-2*k)] ;
end
for k=length(Gg)-2:-2:2
  G=[G ; zeros(1,2*length(d)-(length(Gg(1:k)))) Gg(1:k)]; % dernieres lignes de la matrice de convolution
end
mod(d*G,2)
% return
res=1-mod(d*G,2);
dec2hex(res(1:4:end)*8+res(2:4:end)*4+res(3:4:end)*2+res(4:4:end))'
printf("\n v.s. 0x035d49c24ff2686b or 0xfca2b63db00d9794\n")

% jmfriedt@rugged:~/sdr/meteor2/viterbi$ echo "123" | ./encode  > t
% jmfriedt@rugged:~/sdr/meteor2/viterbi$ xxd t
% 000011101000110100000010001100111000110001000000 1111111010100010
% 24 bit in -> 48 bit out
% 000011101000110100000010001100111000110001000000

% jmfriedt@rugged:~/sdr/meteor2/viterbi$ echo "12344" |  ./encode > t
% jmfriedt@rugged:~/sdr/meteor2/viterbi$ xxd t
% 000011101000110100000010001100111000110001000000111100001100100110110101101110011011101111010010
% Matlab :
% 00001110100011010000001000110011100011000100000011110000110010011011010110111001

% -> coherence entre viterbi de Matlab (par matrice) et Viterbi de gr-fec

% after swapping polyomials
% echo "12344" | ./encode > t
% 000011010100111000000001001100110100110010000000111100001100011001111010011101100111011111100001
% Octave :
% 00001101010011100000000100110011010011001000000011110000110001100111101001110110


