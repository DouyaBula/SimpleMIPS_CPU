#include <stdio.h>
int number;
int flag = 1;
char string[21];
int main(){
    scanf("%d", &number);
    for (int i = 0; i < number; i++)
    {
        scanf(" %c", &string[i]);//处理掉了回车，MIPS中不用
    }
    
    for (int i = 0; i < number/2; i++)
    {
        if (string[i]!=string[number-1-i])
        {
            flag = 0;
            break;
        }
    }
    
    printf("%d", flag);
    return 0;
}