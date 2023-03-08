#include <stdio.h>
int flag[20]={0};
int main(){
    int n, m;
    printf("Please Enter n and m\n");
    scanf("%d%d",&n,&m);
    int i = -1;
    int cnt = 0;
    int number = 0;
    while (number<n)
    {
        cnt = 0;
        while (cnt < m)
        {
            int temp = (i+1)%n;
            if (flag[temp]==0)
            {
                i = temp;
                cnt++;
            } else {
                i++;
            }
        }
        number++;
        flag[i]=1;
        printf("%d ",i+1);
    }
    return 0;
}