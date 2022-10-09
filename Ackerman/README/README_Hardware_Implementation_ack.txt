

/////////////Procedure for hardware Implementation/////

======HLS=======
=Open Vivado HLS( High Level Synthesis), Create new project, add the source file 'ackremann.cpp' and the testbench file 'tb_ackremann.cpp'
=Select the board 'xc7z010clg400-1'
=Run C simulation to verify the result 
=Run C-Synthesis which generates synthesizable HDL code and observe timing, latency, Utilization estimates or measures.
=After synthesis run Co-Simulation to verify the functionality of the of the RTL code upon successful simulation 
 export the RTL file, the IP created will be in the 'Solution Directory' of the Project file created. 




====Vivado===
=Open Vivado and create new project, select RTL Project, select the Board Files as 'Zybo'  and then 'Create Block Design'
=In the plain Canvas of Block Design add the 'Zynq Processing system'
=Run Block simulation which Presets the board based on board files.
=Double click IP block to see the details, navigate to PS-PL configuration/HP Slave AXI Interface and enable S AXI HPO Interface
=Navigate to Windows/IP Catalog, the right click Add repository -> select the 'Solution Directory' which got created in the end of Vivido HLS
=Now should be able to see the Ackermann IP in IP catalog proceed adding it to block diagram  
=Add 'Direct Memory Access AXI' IP Blocks, then Disable "Enable Scatter Engine" in DMA Block details.
=Add 'AXI BRAM Controller' IP block.
=Run 'Connection Automation' which automatically instantiates further IP blocks like "Processor System Reset Module", "AXI interconnect",
 "AXI Smart Connect", "Block RAM Generator".
=Run 'Block Automation' and then connect InStream 
 and OutStream of the IP generated to 'Direct Memory AXI' IP.
=Regenerate layout and show interface connections only.
=Validate the Design and Create a HDL wrapper
=Click on 'Generate Bitstream' which generates Bit Stream file.
=To export Bitstream navigate File -> Export -> Export Hardware -> enable include bitstream -> ok.





=====SDK====
=After generating BitStream Launch SDK (Software Development), Use the Helloworld.c Template use the to copy and paste
 the code from 'Hardware_implementation_ack.c' file
=Connect ZYBO board to system via USB port. 
=Click on program FPGA this will program bitstream on FPGA and select the appropriate COM Port to which the Board is connected to from SDK terminal.
=To Create a Application project go to Files -> New -> Application Project give the name of the project.
=Select the Driver and then Click on Run As-> Launch on hardware for Implementation on Hardware.
=In the SDK terminal output gets Displayed and the time elapsed can be noted.





 