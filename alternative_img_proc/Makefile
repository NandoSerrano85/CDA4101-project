bmptool:        bmplib.o main.o
		nvcc bmplib.o main.o -o $@

bmplib.o:       bmplib.cu bmplib.h
		nvcc -c $< -o $@

main.o: main.cu
		nvcc -c main.cu -o $@

clean:
		rm -f bmptool *.o core *~
