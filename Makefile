bmptool:        bmplib.o main.o
		$(CC) bmplib.o main.o -o $@

bmplib.o:       bmplib.c bmplib.h
		$(CC) -Wall -c $< -o $@

main.o: main.cu bmplib.h
		nvcc main.cu -o bmptool

clean:
		rm -f bmptool *.o core *~
