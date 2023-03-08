#include <stdio.h>
int matrixMain[11][11];
int matrixCore[11][11];
//////
int m1, n1, m2, n2;
int row, coloum;

int convolution(int i, int j);
int main(){
    scanf("%d%d%d%d", &m1, &n1, &m2, &n2);
    
    for (int i = 0; i < m1; i++)
    {
        for (int j = 0; j < n1; j++)
        {
            scanf("%d", &matrixMain[i][j]);
        }
    }
    
    for (int i = 0; i < m2; i++)
    {
        for (int j = 0; j < n2; j++)
        {
            scanf("%d", &matrixCore[i][j]);
        }
    }

    row = 1 + m1 - m2;
    coloum = 1 + n1 - n2;
    for (int i = 0; i < row; i++)
    {
        for (int j = 0; j < coloum; j++)
        {
            int result = convolution(i, j);
            printf("%d ", result);
        }
        printf("\n");
    }
    
    return 0;
}

int convolution(int iReg, int jReg){
    int sum = 0;
    for (int i = 0; i < m2; i++)
    {
        for (int j = 0; j < n2; j++)
        {
            sum += matrixMain[iReg+i][jReg+j]*matrixCore[i][j];
        }   
    }
    return sum;
}