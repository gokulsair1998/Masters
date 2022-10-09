`timescale 1ns / 1ps

module alu(
           input [7:0] A,B, // ALU 8-bit Inputs                 
           input [3:0] FS,// Function select
           input [2:0] sh, //shift input
           output [7:0] F, // 8-bit Output
           output C, // Carry Out Flag
           output N ,//negative flag
           output V ,// overflow flag
           output Z // zero flag
           );
           
reg [8:0] outputreg ;//output register to store values
reg zeroflag;
reg overflowflag;
reg carryflag;
reg negativeflag;
reg [7:0]overflowregister;
reg [2:0] shift;

parameter d = 0;
parameter nop = 4'b0000; 
parameter add = 4'b0001; 
parameter sub = 4'b0010; 
parameter xor2 = 4'b0011; 
parameter or2 = 4'b0100; 
parameter logicshift_right = 4'b0101; 
parameter logicshift_left = 4'b0110; 
parameter compliment = 4'b0111; 
parameter bypass =	4'b1000; 
parameter and2 = 4'b1001; 
parameter greater_comparison = 4'b1010; 
parameter equality_comparison = 4'b1011; 
parameter not2 = 4'b1100; 

always @(A,B,FS,sh)
begin

case(FS)
    add:outputreg = A + B; 
    sub:outputreg = A + ~B + 1; 
    and2:outputreg = A & B; 
    or2:outputreg = A | B; 
    xor2:outputreg = A ^ B; 
    bypass:outputreg = A; 
    not2:outputreg = ~A; 
    greater_comparison:outputreg = A>B ? 1'b0 : 1'b1 ;
    equality_comparison:outputreg = A==B ? 8'h0 : 8'h1; 
    logicshift_right:outputreg = A >> sh; 
    logicshift_left:outputreg = A << sh; 
    compliment:outputreg = ~A;
    default:outputreg = 9'h0;
endcase

zeroflag = (outputreg == 0)? 1'b1: 1'b0; // zero flag=1, when the output register value is 0
negativeflag = outputreg[7]; // negative flag=1,when there is a one in the seventh bit
carryflag = outputreg[8]; // carrry flag=1, if there is a carry

if (FS == 1 )begin
  overflowflag = ( (A[7] == B[7]) && (A[7] !=  outputreg[7])) ? 1'b1 : 1'b0;
   end
  else if (FS == 2 )begin
   overflowregister = ~B+8'b1;
  overflowflag = ((A[7] == overflowregister[7]) && (A[7] !=  outputreg[7])) ? 1'b1 : 1'b0;
   end
end

assign F = outputreg[7:0];
assign N = negativeflag;
assign C = carryflag;
assign V = overflowflag;
assign Z = zeroflag;

endmodule