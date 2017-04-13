/* Practice for cuda */

#include <emmintrin.h> //????? not sure what this is for
#include <sys/time.h>
#include <stdio.h>

/* Kernel definition
* when using __global__ it is called Kernel
*/
__global__ void vector_add(float* A, float* B, float* C){
    int i = threadIdx.x;
    
}
