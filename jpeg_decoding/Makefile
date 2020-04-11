all: meteor_image

meteor_image: meteor_image.o meteor_bit_io.o main.o
	g++ -Wall -o meteor_image meteor_image.o  meteor_bit_io.o main.o

meteor_image.o: meteor_image.cc
	g++ -Wall -c meteor_image.cc 

meteor_bit_io.o: meteor_bit_io.cc
	g++ -Wall -c meteor_bit_io.cc 

main.o: main.c
	g++ -c main.c

clean:
	rm *.o meteor_image
