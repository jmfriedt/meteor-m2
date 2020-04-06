# meteor-m2
Meteor-M2 signal analysis: supporting material to http://jmfriedt.free.fr/glmf_meteor_eng.pdf presented at FOSDEM2019.

extrait.s is a sample data acquisition: soft bits encoded as signed 8-bit integers (char)

go_viterbi1.m (GNU/Octave) will search for all possible permutation of the header bits to identify the QPSK phase rotation in the dataset

The output should look like

<img src="go_viterbi1_output.png">

with correlation peaks every 16384 samples for one of the constellation 
rotation/permutation state.

go_viterbi2.m aims at demonstrating how the synchronization header is encoded (demonstrated with some dummy sentence to justify the correlation word used in go_viterbi1.m)

viterbi.m convolutional encoding decoder taken from https://github.com/Filios92/Viterbi-Decoder/blob/master/viterbi.m
