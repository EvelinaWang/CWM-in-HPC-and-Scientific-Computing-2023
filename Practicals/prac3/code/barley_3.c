/**************************************************
 *                                                *
 * First attempt at a code to calcule lost barley *
 * by A. Farmer                                   *
 * 18/05/18                                       *
 *                                                *
 **************************************************/

// Include any headers from the C standard library here
#include <stdio.h>
#include <stdlib.h>

// Define any constants that I need to use here
#define PI 3.14

// This is where I should put my function prototypes
float area_of_circles(float r); 
float area_of_rings(float outer,float inner);
float area_of_rec(float len, float width);

// Now I start my code with main()
int main() {

    // In here I need to delare my variables
    float *radius;
    int num_circles=5;
    float total_area=0;
    radius=(float*)malloc(num_circles*sizeof(float));

    // get data from external txt file and open it
    FILE *fp;
    char filename[200],mode[4];
    printf("enter filename:\n");
    scanf("%s",filename);
    printf("enter mode:\n");
    scanf("%s",mode);

    // test if it can be opened successfully
    if((fp=fopen(filename,mode))!=NULL){
        printf("\n opened %s in the mode %s\n", filename,mode);
    }else{printf("\n Error: File cannot be recognised\n");}

    // get radii from txt file
    for(int i=0;i<num_circles;i++){
        fscanf(fp, "%f", &radius[i]);
        printf("radius is :%f\n",radius[i]);}

    // Now I need to loop through the radii caluclating the area for each
    for(int i = 0;i <num_circles; i++){
    // Next I'll sum up all of the individual areas
        total_area += area_of_circles(radius[i]);}
        printf("%f",total_area);

    /******************************************************************
     *                                                                *
     * Now I know the total area I can use the following information: *
     *                                                                *
     * One square meter of crop produces about 135 grams of barley    *
     *                                                                *
     * One kg of barley sells for about 10 pence                      *
     *                                                                *
     ******************************************************************/

    // Using the above I'll work out how much barley has been lost.
    float loss_in_kg = total_area*0.135;
    float loss_in_pence = loss_in_kg*10;

    // Finally I'll use a printf() to print all values I need to the screen.
    printf("\nTotal area lossed in m^2 is:\t%f\n", total_area);
    printf("Total loss in kg is:\t\t%f\n", loss_in_kg);
    // printf("Percentage of the barley loss is:\t\t%f\n", );
    printf("Monetary loss is:\t\t%f\n",loss_in_pence);

    //finish calculation and clear the memory
    free(radius);
    fclose(fp);
    return(0);
}

// I'll put my functions here:

//calculating circle areas
float area_of_circles(float r){
    float area = PI*r*r;
    return area; }

//calculating ring areas
float area_of_rings(float outer, float inner){
    float area = area_of_circles(outer) - area_of_circles(inner);
    return area;}

//calculating rectangular areas
float area_of_rec(float len, float width){
    float area = len*width;
    return area;}
