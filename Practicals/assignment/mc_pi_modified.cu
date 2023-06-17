//include libraries
#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <curand.h>
#include <curand_kernel.h>

//define constant
#define PI 3.1415926
#define NUM_ELS	 50

//my kernel
__global__ void mc_pi(float *d_x, float *d_y, int *res){

    //get varaibles from array  
    int index=blockIdx.x*blockDim.x + threadIdx.x;
    float x=d_x[index];
    float y=d_y[index];
   
    //count the number  of elements inside range of circle
    if(x*x + y*y <= 1.0f) {
        atomicAdd(res,1);
    }
}


//main function
int main() {
  
    //declare variables in CPU
    int *h_res=NULL;
    //float *h_x=NULL;
    //float *h_y=NULL;

    //allocate memory in CPU
    h_res = (int*) malloc(1*sizeof(int));
    //h_x = (float*) malloc(NUM_ELS*sizeof(float));
    //h_y = (float*) malloc(NUM_ELS*sizeof(float));

    //generate random variables using curand generator
    //curandGenerator_t gen;

    //Create random number generator
    //curandCreateGenerator(&gen, CURAND_RNG_PSEUDO_DEFAULT);

    //Set the generator options
    //curandSetPseudoRandomGeneratorSeed(gen,1234ULL);

    //generate the randoms
    //curandGenerateUniform(gen, h_x, NUM_ELS);
    //curandGenerateUniform(gen, h_y, NUM_ELS);

    //initialise GPU
    int deviceid=0;
    int devCount=0;

    //count the maximum id number 
    cudaGetDeviceCount(&devCount);

    //error checking
    if(deviceid<devCount){
      cudaSetDevice(deviceid);
     }else return 1;

    //define variable
    size_t array_size = NUM_ELS * sizeof(float);
    size_t int_size = 1 * sizeof(int);
    float *d_x;
    float *d_y;
    int *res;

    //allocate memory in GPU
    cudaMalloc((void**)&d_x,array_size);
    cudaMalloc((void**)&d_y,array_size);
    cudaMalloc((void**)&res,int_size);
    cudaMemset(res, 0, int_size);
    
    //generate random variables using curand generator
    curandGenerator_t gen;

    //Create random number generator
    curandCreateGenerator(&gen, CURAND_RNG_PSEUDO_DEFAULT);

    //Set the generator options
    curandSetPseudoRandomGeneratorSeed(gen,1234ULL);

    //generate the randoms
    curandGenerateUniform(gen, d_x, NUM_ELS);
    curandGenerateUniform(gen, d_y, NUM_ELS);

    //transfer data to GPU
    //cudaMemcpy(d_y,h_y,NUM_ELS*sizeof(float),cudaMemcpyHostToDevice);
    //cudaMemcpy(d_x,h_x,NUM_ELS*sizeof(float),cudaMemcpyHostToDevice);

    //run the kernel
    mc_pi<<<10,5>>>(d_x, d_y,res); 

    //transfer data back to CPU
    cudaMemcpy(h_res,res,1*sizeof(float),cudaMemcpyDeviceToHost);

    //print out the answer
    printf("\nresult is:\t%f\n", 4.0*(*h_res)/NUM_ELS);
  
    //free memories
    cudaFree(d_x);
    cudaFree(d_y);
    cudaFree(res);
    //free(h_x);
    //free(h_y);
    free(h_res);

    return(0);
}

