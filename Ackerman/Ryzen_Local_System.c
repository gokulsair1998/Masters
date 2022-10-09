#include <assert.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <sysinfoapi.h>
#include <sys/time.h>

int m=3;
int n=11;
int ip1,ip2;
struct timeval stop, start;

int main() {
gettimeofday(&start, NULL);
ip1=m;
ip2=n;
int Stack[30000];
    size_t size = 0;

    for (;;) {
        if (m == 0) {
            n++;
            if (size-- == 0) {
                break;
            }
            m = Stack[size];
            continue;
        }
 
        if (n == 0) {
            m--;
            n = 1;
            continue;
        }

        size_t index = size++;
        Stack[index] = m - 1;
        n--;
    }
gettimeofday(&stop, NULL);
printf("The ackerman of %d and %d is %d\n",ip1,ip2,n);
printf("took %lu us\n", (stop.tv_sec - start.tv_sec) * 1000000 + stop.tv_usec - start.tv_usec);
    return 0;
}