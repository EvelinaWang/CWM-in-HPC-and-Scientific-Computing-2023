//random number generation
#include <cuda.h>
#include <curand.h>
#include <stdio.h>

//define variables
#define NUM_ELS=50;

//local functions
float mean(float *array, int n);
float std_dev(float *array, int n, float mean);
void print_Histogram(float *array, int n);

int main(void){
    //Declare variable
    curandGenerator_t gen;

    //Create random number generator
    curandCreateGenerator(&gen, CURAND_RNG_PSEUDO_DEFAULT);

    //Set the generator options
    curandSetPseudoRandomGeneratorSeed(gen,1234ULL);

    //allocate memory in GPU
    float *d_input;
    array_size = (float*) malloc(NUM_ELS*sizeof(float));
    cudaMalloc((void**)&d_input,array_size);

    //generate the randoms
    curandGenerateNormal(gen, d_input, NUM_ELS, 0.0f,1.0f);

    //transfer data to CPU
    float *h_input;
    cudaMemcpy(h_input, d_input, array_size,cudaDeviceToHost);

    //free GPU memory
    cudaFree(d_input);

    for(int i=0;i<NUM_ELS;i++){
        printf("%f\n",h_input[i]);
    }

    //use local functions to get values
    float mean_value=mean(h_input,NUM_ELS);
    float standard_deviation=std_dev(h_input,NUM_ELS,mean_value);
    printf("mean is %f and standard deviation is %f\n", mean_value, standard_deviaiton);
    print_Histogram(h_input, NUM_ELS);

    return 0;
}

//function to calculate mean
float mean(float *array, int n){
    float sum=0;
    for(int i=0;i<n;i++){
        sum+=array[i];
    }
    return sum/n;
}

//function to calculate standart deviation
float std_dev(float *array, int n, float mean){
    float sum_2=0;
    for(int i=0;i<n;i++){
        sum_2+=array[i]*array[i];
    }
    std=(sum_2/n)-(mean*mean);
    return std;
}

//print out the histogram of random numbers generated
void print_Histogram(float *array, int n){
    printf("Histogram\n");
    for(int i=0;i<n;i++){
        for(int j=0; j<array[i];j++){
            printf("#");
        }
        printf("\n");
    }
}
