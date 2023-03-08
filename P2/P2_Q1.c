#include <stdio.h>

int rank, product;
int matrixA[8][8];
int matrixB[8][8];
int main(){
    scanf("%d", &rank);
    for (int i = 0; i < rank; i++)
    {
        for (int j = 0; j < rank; j++)
        {
            scanf("%d", &matrixA[i][j]);
        }
    }
    
    for (int i = 0; i < rank; i++)
    {
        for (int j = 0; j < rank; j++)
        {
            scanf("%d", &matrixB[i][j]);
        }
    }

    for (int i = 0; i < rank; i++)
    {
        for (int j = 0; j < rank; j++)
        {
            product = 0;
            for (int k = 0; k < rank; k++)
            {
                product += matrixA[i][k]*matrixB[k][j];
            }
            printf("%d", product);
            printf(" ");
        }
        printf("\n");
    }
    return 0;
}