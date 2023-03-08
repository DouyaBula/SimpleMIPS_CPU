#include <stdio.h>
void hannoSingle(int n, char from, char buffer, char to) {
    if (n==1)
    {
        printf("%c --> %c\n",from,to);
    } else {
        hannoSingle(n-1,from,to,buffer);
        hannoSingle(n-1,buffer,from,to);
        printf("%c --> %c\n",from,buffer);
        hannoSingle(n-1,to,from,buffer);
        hannoSingle(n-1,buffer,to,from);
        printf("%c --> %c\n",buffer,to);
        hannoSingle(n-1,from,to,buffer);
        hannoSingle(n-1,buffer,from,to);
    }
    
}
int main(){
    int n;
    scanf("%d", &n);
    hannoSingle(n,'a','b','c');
}