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
__global__ void compressor(PIXEL * orig, int row, int col){
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    int rows, cols;
    for(rows = 0; rows < row; rows++){
            for(cols = 0; cols < col; cols++){
                    PIXEL * test = orig + rows + cols;
                    printf("%d, %d, %d\n", test -> r, test -> g, test -> b);
                    printf("rows: %d, cols: %d\n", rows, cols);

            }
        }

}
// middleware to handle gpu core and thread usage
void middleware(PIXEL* original, int rows, int cols, PIXEL* new_image){
    int numThreads = 1024;
    int numCores = original*sizeof(int) /  numThreads + 1;

    int* gpuAllocation;

    cudaMalloc(&gpuAllocation, original*sizeof(int));
    cudaMemcpy(gpuAllocation, &original, original*sizeof(int), cudaMemcpyHostToDevice);
    compressor<<<numCores, numThreads>>>(original, rows, cols);
    cudaMemcpy(&new_image, gpuAllocation, original*sizeof(int), cudaMemcpyDeviceToHost);
    cudaFree(&gpuAllocation);
}
int main (int agrc, char **agrv){
    FILE *inputfile;
    inputfile = fopen("image_list.txt", "r");
    char image_name[256];
    fgets(image_name, 256, (FILE*)inputfile);
    while(!feof(inputfile)){
        int row, col;
        PIXEL *uncompressed, *compressed;
        readFile("example.bmp", &row, &col, &uncompressed);
        middleware(uncompressed, row, col, compressed);

        fgets(image_name, 256, (FILE*)inputfile);
    }
}
