`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01.05.2022 12:29:59
// Design Name:
// Module Name: tb_MCU
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module tb_MCU();
reg clk;
wire [15:0]instruction_wire_tb;
Top_module uut(.clk(clk)/*,.INSTRUCTION(instruction_wire_tb)*/);



always begin
#5 clk=~clk;
// if(instruction_wire_tb[15:12]==4'b1111)
// begin
// $finish;
// end
end
initial
begin
clk=1;
end
endmodule