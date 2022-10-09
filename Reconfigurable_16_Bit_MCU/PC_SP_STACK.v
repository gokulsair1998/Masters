//prog counter
module PC_SP_STACK(clk,branch_stack_C_Z_detec,PC_branch,A_Push,PC_out,A_pop,Carry_in,Zero_in,SP);



input [3:0]branch_stack_C_Z_detec;
input [11:0]PC_branch; //PC address to jump
input [15:0]A_Push; // A register value for PUSH
input Carry_in;
input Zero_in;
input clk;



output reg [11:0]PC_out;
output reg [15:0]A_pop;
reg [15:0]Stack[4095:0];//16 stack locations
reg [11:0]interrupt_addr=12'd3839;
output reg [11:0]SP; // there are 16 stack locations extra bit to say full
reg intr_reg;
reg [15:0]temp;



reg [1:0]count;
initial
begin
SP<=12'hFFF;
PC_out<=12'b0;
Stack[12'h0]=16'hABCE;
end



always @(posedge clk)
begin
if(branch_stack_C_Z_detec==4'b0000 ||branch_stack_C_Z_detec==4'b1001) //JMP PC <----Address
begin



PC_out=PC_branch;



end



else if(branch_stack_C_Z_detec==4'b0001) //JSR Stack <---- PC, PC <---- address, SP <---- SP-1
begin
Stack[SP]={4'b0000,PC_out}; //Stack <---- PC
PC_out=PC_branch; //PC <---- address
SP=SP-1; //SP <---- SP-1
// if(SP<5'b11111) //check SP out of bound(0-1=-1 this is all ones in binary) if empty SP=0
// begin
// SP=5'b00000;
// end
end



else if(branch_stack_C_Z_detec==4'b0010) //PUSHA
begin
Stack[SP]=A_Push;
SP=SP-1; //SP <---- SP-1
// if(SP==5'b11111) //check stack is full(0-1=-1 this is all ones in binary); if empty SP=0
// begin
// SP=5'b00000;
// end
end



else if(branch_stack_C_Z_detec==4'b0011) //POPA
begin
SP=SP+1; //SP <---- SP+1
// if(SP==5'b10000) //check stack is empty; if SP= 16
// begin
// SP=5'b01111;
// end
A_pop=Stack[SP];
end



else if(branch_stack_C_Z_detec==4'b0100)//RET
begin
// $display("i am ret");
SP=SP+1;
// if(SP==5'b10000) //check stack is full; if full SP= 16
// begin
// SP=5'b01111;
// end
temp=Stack[SP];

// $display("%h",temp);
PC_out=temp[11:0];//



end
else if(branch_stack_C_Z_detec==4'b0101)//SC
begin
if(Carry_in)
begin
PC_out=PC_out+1;
end
end
else if(branch_stack_C_Z_detec==4'b0110)//SZ
begin
if(Zero_in)
PC_out=PC_out+1;
end
else if(branch_stack_C_Z_detec==4'b0111)//intrr
begin
if(3840>PC_out)// ISR starts at 3840
begin
Stack[SP]={4'b0000,PC_out}; //Stack <---- PC
SP=SP-1; //SP <---- SP-1
PC_out=interrupt_addr; //PC <---- address
end
end
else if(branch_stack_C_Z_detec==4'b1000)//intrr off
begin
// don't do anything
end

if(branch_stack_C_Z_detec==4'b1001)
begin
PC_out=PC_out;
end

if(branch_stack_C_Z_detec!=4'b0000 && branch_stack_C_Z_detec!=4'b1001)
begin
PC_out=PC_out+1;
end
else
begin
//NOP
end


end
endmodule