bmptool:        bmplib.o main.o
		nvcc bmplib.o main.o -o $@

bmplib.o:       bmplib.c bmplib.h
		$(CC) -Wall -c $< -o $@

main.o: main.cu
		nvcc -c main.cu -o$@

clean:
		rm -f bmptool *.o core *~
