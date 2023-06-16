//include libraries
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

//initialise variables
int main() {
  int N=100000000;
  int area=0;

  double time_start=omp_get_wtime();

  #pragma omp parallel default(none) shared(area,N)
  {
    #pragma omp for reduction(+:area)
      {
         for(int i=0; i<N; i++) {
           float x = ((float)rand())/RAND_MAX;
           float y = ((float)rand())/RAND_MAX;
           if(x*x + y*y <= 1.0f) area++;
         }
      }
  }
  printf("\nPi:\t%f\n", (4.0*area)/(float)N);
  return(0);
}

