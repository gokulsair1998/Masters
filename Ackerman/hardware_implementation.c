/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/





/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */





#include <stdio.h>
#include "xparameters.h"
#include "platform.h"
#include "xil_printf.h"
#include "xackerman.h"
#include "xaxidma.h"
#include "XTime_l.h"




#define MEM_BASE_ADDRESS 0x0A000000
#define TX_BUFFER_BASE (MEM_BASE_ADDRESS + 0X00100000)
#define RX_BUFFER_BASE (MEM_BASE_ADDRESS + 0X00300000)





XAckerman ack;
XAckerman_Config *Ackerman_config;





XAxiDma axidma;
XAxiDma_Config *axi_dma_config;





u32 instreamdata[2];





void initperipherls()
{
    printf("initializing Ackermann Function.... \n");
    Ackerman_config= XAckerman_LookupConfig(XPAR_ACKERMAN_0_DEVICE_ID);
    if (Ackerman_config)
    {
        int status= XAckerman_CfgInitialize(&ack, Ackerman_config);





        if(status!= XST_SUCCESS)
        {
            printf("ERROR IN Ackermann CORE \n");
        }
    }





    printf("initializing AXI DMA  core\n");
    axi_dma_config=XAxiDma_LookupConfig(XPAR_AXIDMA_0_DEVICE_ID);
    if (axi_dma_config)
    {
        int status= XAxiDma_CfgInitialize(&axidma, axi_dma_config);





        if (status!= XST_SUCCESS)
        {
            printf("AXI DMA error \n");
        }
    }





    XAxiDma_IntrDisable(&axidma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);
    XAxiDma_IntrDisable(&axidma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DMA_TO_DEVICE);
    //XAxiDma_IntrEnable(&axidma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);
    //XAxiDma_IntrEnable(&axidma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DMA_TO_DEVICE);
}






int main()
{
    init_platform();
    XTime start,stop;

XTime_GetTime(&start);
    int *m_dma_buffer_Rx= (int*) RX_BUFFER_BASE;
    initperipherls();

    instreamdata[0]=1;
    instreamdata[1]=3;

    XAckerman_Start(&ack);
    Xil_DCacheFlushRange((u32)instreamdata, 2*sizeof(int));
    Xil_DCacheFlushRange((u32)m_dma_buffer_Rx, 1*sizeof(int));
    XAxiDma_SimpleTransfer(&axidma, (u32)instreamdata, 2*sizeof(int), XAXIDMA_DMA_TO_DEVICE) ;
    XAxiDma_SimpleTransfer(&axidma, (u32)m_dma_buffer_Rx, 1*sizeof(int), XAXIDMA_DEVICE_TO_DMA) ;
    Xil_DCacheInvalidateRange((u32)m_dma_buffer_Rx, 1*sizeof(int));
    while(!XAckerman_IsDone(&ack));
XTime_GetTime(&stop);

    printf("calculation complete..\n");

    printf("The input M is %d \n",instreamdata[0]);
    printf("The input N is %d \n",instreamdata[1]);
    printf("The Ackermann Output is: %d\n", m_dma_buffer_Rx[1]);




    printf("Counts per second= %d \nClock cycles=%llu  \n%.2f ",COUNTS_PER_SECOND,(stop-start),((1.0)*(stop-start)/(COUNTS_PER_SECOND/1000000)));



    cleanup_platform();
    return 0;
}
