`timescale 1ns / 1ps

module mcu_tb();
    
reg clk_s;
reg reset;
reg [8:0]fpga_in = 9'h36;
wire [9:0] fpga_out;
mcu_main uut(
.clk(clk_s),.reset(reset),
.fpga_in(fpga_in),
.fpga_out(fpga_out))
;

initial begin
clk_s = 0;
reset = 1;
#3;
reset = 0;
#5;
reset = 1;

#200;
//delay
#300;
end

always begin
clk_s = 0;
forever #2 clk_s = ~clk_s;
end
endmodule
