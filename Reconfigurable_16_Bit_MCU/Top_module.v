`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.04.2022 21:37:13
// Design Name: 
// Module Name: Top_module
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


module Top_module(clk/*,A_register,B_register,bracnhing_address,program_counter,INSTRUCTION,stack_pointer*/);
input clk;
//output [15:0]A_register;
//output [15:0]B_register;
//output [11:0]bracnhing_address;
//output [11:0]program_counter;
//output [15:0]INSTRUCTION;
//output [4:0]stack_pointer;
//inst_decoer wires
wire [3:0]control_wire;
wire [11:0]address_wire;
wire carry_wire;
wire zero_wire;
wire [15:0]A_to_stack_wire;
wire [15:0]stack_to_A_wire;
wire [15:0]instruction_wire;
//PC_SP_STACK
wire [11:0]PC_wire;
wire [11:0]Stack_pointer_wire;

//A register and B register
wire [15:0]A_wire;
wire [15:0]B_wire;

//assign random=control_wire;
instruction_deco block_instruction(.instruction(instruction_wire),.PC_branch(address_wire),.A_TO_STACK(A_to_stack_wire),.C(carry_wire),.Z(zero_wire),
.branch_stack_C_Z_detec(control_wire),.STACK_TO_A(stack_to_A_wire),.A(A_wire),.B(B_wire));

PC_SP_STACK block_PC_STACK(.clk(clk),.branch_stack_C_Z_detec(control_wire),.PC_branch(address_wire),.A_Push(A_to_stack_wire),.PC_out(PC_wire),.A_pop(stack_to_A_wire),
.Carry_in(carry_wire),.Zero_in(zero_wire),.SP(Stack_pointer_wire));

Program_mem block_Program_mem(.address(PC_wire),.instruction_pm(instruction_wire));

//assign A_register=A_wire;
//assign B_register=B_wire;
//assign bracnhing_address=address_wire;
//assign INSTRUCTION=instruction_wire;
//assign program_counter=PC_wire;
//assign stack_pointer=Stack_pointer_wire;
ila_0 my_oscilloscope(.clk(clk),.probe0(A_wire),.probe1(B_wire),.probe2(address_wire),.probe3(instruction_wire),.probe4(PC_wire),.probe5(Stack_pointer_wire));
endmodule
