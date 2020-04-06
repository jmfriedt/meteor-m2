# meteor-m2
Meteor-M2 signal analysis

extrait.s is a sample data acquisition: soft bits encoded as signed 8-bit integers (char)

go_viterbi1.m (GNU/Octave) will search for all possible permutation of the header bits to identify the QPSK phase rotation in the dataset

go_viterbi2.m aims at demonstrating how the synchronization header is encoded (demonstrated with some dummy sentence to justify the correlation word used in go_viterbi1.m)
