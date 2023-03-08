#include <stdio.h>
#include <stdlib.h>
int symbol[7], array[7];
int n;
void FullArray(int index);

int main(){
    scanf("%d", &n);
    FullArray(0);
    return 0;
}

void FullArray(int index) {
    int i;
    // If A
    if (index >= n)
    {
        // Loop A
        for (int i = 0; i < n; i++)
        {
            printf("%d",array[i]);
            printf(" ");
        }
        printf("\n");
        return;
    }
    // Loop B
    for (int i = 0; i < n; i++)
    {
        // If B
        if (symbol[i]==0)
        {
            array[index] = i+1;
            symbol[i]=1;
            FullArray(index+1);
            symbol[i]=0;
        }   
    }
}