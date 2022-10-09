#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include "xtime_l.h" // XTime_GetTime()
// Macros
#define TIMEDIFF(t1,t2) (t2 - t1)
#define SECONDS(t) (1000000.0 * t / COUNTS_PER_SECOND)
// Globals
XTime start, end;
// Start a test
void startTest() {
 XTime_GetTime(&start);
}
// End a test
void endTest() {
 XTime_GetTime(&end);
 double time_curr = TIMEDIFF(start, end);
 double sec = SECONDS(time_curr);
 printf("Clock cycles = %.2f \n Run-time = %.2f sec...\n", time_curr, sec);
}
int main()
{
	startTest();
int m=3;
int n=1;
	int value[30000];
	    size_t size = 0;

	    for (;;) {
	        if (m == 0) {
	            n++;
	            if (size-- == 0) {
	                break;
	            }
	            m = value[size];
	            continue;
	        }

	        if (n == 0) {
	            m--;
	            n = 1;
	            continue;
	        }

	        size_t index = size++;
	        value[index] = m - 1;
	        n--;
	    }
    endTest();

    printf("Ackerman is %d ", n);
    return 0;
}
