#include <hls_stream.h>
#include <ap_axi_sdata.h>
#include <ap_int.h>
#include <iostream>
#include <vector>
#include <hls_math.h>
//#define LIMIT 30000;
using namespace std;

typedef ap_axis <32,2,5,6> int_side_ch;


void Ackerman(hls:: stream<int_side_ch> &inStream  , hls:: stream<int_side_ch> &outStream,int Stack[30000])
{
	#pragma HLS INTERFACE axis port=inStream
	#pragma HLS INTERFACE axis port=outStream
	#pragma HLS INTERFACE s_axilite port=return bundle=CRTL_BUS
	#pragma HLS INTERFACE bram port= Stack
    #pragma HLS RESOURCE variable = Stack core=RAM_1P_BRAM
    #pragma HLS ARRAY_RESHAPE variable = Stack complete dim=1

	int_side_ch val_in;
	int_side_ch val_out;
	int m,n;
	val_in= inStream.read();
	m=(unsigned int)val_in.data;
	val_in= inStream.read();
	n=(unsigned int)val_in.data;
     size_t size = 0;
	for ( ; ; )
	{
		#pragma HLS loop_tripcount
	    if (m == 0)
		{
	        n++;
	        if (size-- == 0)
			{
	            break;
	        }
	        m = Stack[size];
	        continue;
	    }
	    if (n == 0)
		{
	        m--;
	        n = 1;
	        continue;
	    }
	    size_t index = size++;
	    Stack[index] = m - 1;
	    n--;
	}
    val_out.data= n;
	outStream.write(val_out);
	return;
}
