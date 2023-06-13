#include <stdio.h>
#include <stdlib.h>
int calc(int i);

void main(void){
    int i = 20;
    printf("age is %i\n",calc(i));
}

int calc(int i){
    int s;
    s =i*i;
    return s;
}
