/*
Team: Packers
PID: 5642858
Class: CDA4101   Section: U02
Affirmation:
"I affirm that this program is entirely
my own work and none of it is the work
of any other person."
*/

#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <unistd.h>
#include "bmplib.h"

#define TRUE = 1

//cuda function
__global__ void compresser(){
    int i = threadIdx.x;

}
//
void middleware(PIXEL* original, int rows, int cols,
                PIXEL** new){
    int numThreads = 1024;
    int numCores = orginal /  numThreads + 1;

    int* gpuAllocation;

    cudaMalloc(&gpuAllocation, orginal*sizeof(int));
    cudaMemcpy(gpuAllocation, ????, original*sizeof(int), cudaMemcpyHostToDevice);
    compressor<<<numCores, numThreads>>>();
    cudaMemcpy(new, gpuAllocation, original*sizeof(int), cudaMemcpyDeviceToHost);
    cudaFree(&gpuAllocation); 
}
int main (int agrc, int agrv){


    int done = 0;
    FILE *inputfile;
    inputfile = fopen("image_list.txt", "r");
    char [256] image_name;
    fgets(image_name, 256, (FILE*)inputfile);
    while(!feof(inputfile)){
        int row = 0, col = 0;
        PIXEL *uncompressed, *compressed;
        readFile(image_name, &row, &col, &uncompressed);


        fgets(image_name, 256, (FILE*)inputfile);
    }
}
