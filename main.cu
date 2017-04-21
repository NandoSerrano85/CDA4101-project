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
    int img_pix[10000][10000][3] = {{{0}}};
    int n = blockIdx.x * blockDim.x + threadIdx.x;
    int k = blockIdx.y * blockDim.y + threadIdx.y;
    int rows, cols;
    for(rows = 0; rows < row; rows++){
            for(cols = 0; cols < col; cols++){
                    PIXEL * test = orig + rows + cols;
                    img_pix[n][k][0] = (int)test -> r;
                    img_pix[n][k][1] = (int)test -> g;
                    img_pix[n][k][2] = (int)test -> b;
                    printf("%d, %d, %d\n", img_pix[n][k][0], img_pix[n][k][1], img_pix[n][k][2]);
                    printf("rows: %d, cols: %d\n", rows, cols);

            }
        }

}
// middleware to handle gpu core and thread usage
void middleware(PIXEL* original, int rows, int cols, PIXEL* newImg){
    int numThreads = 512;
    int numCores = (rows * cols) /  numThreads + 1;

    int* gpuAllocation;

    cudaMalloc(&gpuAllocation, (rows * cols));
    cudaMemcpy(gpuAllocation, original, (rows * cols), cudaMemcpyHostToDevice);
    compressor<<<numCores, numThreads>>>(original, rows, cols);
    cudaMemcpy(newImg, gpuAllocation, (rows * cols), cudaMemcpyDeviceToHost);
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
