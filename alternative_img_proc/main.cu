#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <cuda.h>
#include <cutil.h>
#include <ctime>
#include "bmplib.h"

unsigned int width, height;
int mask[3][3] = {1,2,1,
                  2,3,2,
                  1,2,1,};

int getPixel(unsigned char * arr, int col, int row){
    int sum = 0;
    for (int j=-1; j<=1; j++){
        for (int i=-1; i<=1; i++){
            int  color = arr[(row + j) * width + (col + i)];
            sum +=  color * mask[i+1][j+1];
        }
    }
return  sum /15;
}

void h_blur(unsigned char *arr, unsigned char *result){
    int  offset = 2 * width;
    for (int row=2; row < height -3; row++){
        for (int col=2; col <width -3; col++){
            result[offset + col] = getPixel(arr , col , row);
        }
        offset  += width;
    }
}
__global__ void d_blur(unsigned char *arr, unsigned char *result, int width, int height){
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    if (row < 2 || col < 2 || row  >= height  -3 || col  >= width  -3 )
        return;

    int  mask [3][3] = {1,2,1, 2,3,2, 1,2,1};

    int sum = 0;
    for (int j=-1; j<=1; j++){
        for (int i=-1; i<=1; i++){
            int  color = arr[(row + j) * width + (col + i)];
            sum +=  color * mask[i+1][j+1];
        }
    }
    result[row * width + col] = sum /15;
}

int main(int argc, char** argv){
    PIXEL* d_resultPixels;
    PIXEL* h_resultPixels;
    PIXEL* h_pixels = NULL;
    PIXEL* d_pixels = NULL;

    readFile("../example.bmp", &width, &height, &h_pixels);

    int img_size = sizeof(unsigned char *) * width * height;
    h_resultPixels = (unsigned char *)malloc(img_size);
    cudaMalloc((void**)&d_pixels, img_size);
    cudaMalloc((void**)&d_resultPixels, img_size);
    cudaMemcpy(d_pixels, h_pixels, img_size, cudaMemcpyHostToDevice);

    clock_t  starttime , endtime , difference;
    starttime = clock ();
    // apply  gaussian  blur
    h_blur(h_pixels , h_resultPixels);
    endtime = clock();
    difference = (endtime  - starttime);
    double  interval = difference / (double)CLOCKS_PER_SEC;
    printf("CPU  execution  time = %f ms\n", interval * 1000);

    writeFile("CPU_reslut.bmp", width, height, h_resultPixels);

    dim3  block (16 ,16);
    dim3  grid (width/16,  height /16);
    unsigned  int  timer = 0;
    cutCreateTimer (& timer);
    cutStartTimer(timer);
    /* CUDA  method  */
    d_blur  <<< grid , block  >>>(d_pixels , d_resultPixels , width , height);
    cudaThreadSynchronize ();
    cutStopTimer(timer);
    printf("CUDA  execution  time = %f ms\n",cutGetTimerValue(timer));
    cudaMemcpy(h_resultPixels , d_resultPixels , ImageSize , cudaMemcpyDeviceToHost);
    writeFile("GPU_reslut.bmp", width, height, h_resultPixels);

}
