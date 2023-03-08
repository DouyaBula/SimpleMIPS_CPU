#include <stdio.h>
void hanno(int n, char from, char temporary, char to){
    if (n==1)
    {
        printf("%d %c --> %c\n", n, from, to);
    } else {
        hanno(n-1, from, to, temporary);
        printf("%d %c --> %c\n", n, from, to);
        hanno(n-1, temporary, from, to);
    }
}

int main(){
    int n;
    scanf("%d", &n);
    hanno(n, 'a', 'b', 'c');
}