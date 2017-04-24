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

typedef struct {
  unsigned char r;
  unsigned char g;
  unsigned char b;
  unsigned int count;
} RESULT;

//cuda function
__global__ void compressor(PIXEL * orig, int width, int height, PIXEL *result){
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    int row = blockIdx.y * blockDim.y + threadIdx.y;

    int rgb[4];
    int n, k, count = 0, mask = 0;
    for(n = 0; n < 2; n++){
            for(k = 0; k < 2; k++){
                    PIXEL * test = orig + row + col;
                    rgb[0] = (int)test -> r;
                    rgb[1] = (int)test -> g;
                    rgb[2] = (int)test -> b;

                    test = orig + row + (col + 1);
                    if((int)test -> r >= (rgb[0]-4) && (int)test -> r <= (rgb[0]+4)){
                        count++;
                    }if((int)test -> r >= (rgb[1]-4) && (int)test -> r <= (rgb[1]+4)){
                        count++;
                    }if((int)test -> r >= (rgb[2]-4) && (int)test -> r <= (rgb[2]+4)){
                        count++;
                    }
                    if(count == 3){
                        mask++;
                        rgb[3] = mask;
                    }
                    printf("%d, %d, %d\n", rgb[0], rgb[1], rgb[2]);
                    printf("rows: %d, cols: %d\n", row, col);

            }
        }

}

// middleware to handle gpu core and thread usage
void middleware(PIXEL* original, int rows, int cols, PIXEL* result){
    dim3  block (16 ,16);
    dim3  grid (cols/16,  rows/16);
    int size = sizeof(unsigned char *) * rows * cols;
    // int numThreads = 1024;
    // int numCores = (rows * cols) /  numThreads + 1;

    PIXEL* gpu_picture;
    printf("middleware\n");
    cudaMalloc((void **)&gpu_picture, size);
    cudaMalloc((void **)&result, size);
    cudaMemcpy(gpu_picture, original, size, cudaMemcpyHostToDevice);
    compressor<<<grid, block>>>(gpu_picture, rows, cols, result);
    cudaMemcpy(result, gpu_picture, (rows * cols), cudaMemcpyDeviceToHost);
    cudaFree(&gpu_picture);
}
int main (int agrc, char **agrv){
    FILE *inputfile;
    inputfile = fopen("image_list.txt", "r");
    char image_name[256];
    fgets(image_name, 256, (FILE*)inputfile);
    while(!feof(inputfile)){
        int row, col;
        PIXEL *uncompressed;
        PIXEL *compressed = NULL;
        readFile("example.bmp", &row, &col, &uncompressed);
        printf("main\n");
        middleware(uncompressed, row, col, compressed);

        fgets(image_name, 256, (FILE*)inputfile);
    }
}
