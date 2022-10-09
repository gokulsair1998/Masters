module instruction_deco(instruction,PC_branch,A_TO_STACK,C,Z,branch_stack_C_Z_detec,STACK_TO_A,A,B);
input [15:0]instruction;




output reg [11:0]PC_branch;
output reg [15:0]A_TO_STACK;
output reg C;// carry
output reg Z;// zero
output reg [3:0]branch_stack_C_Z_detec;
input [15:0]STACK_TO_A;



output reg [15:0]A;
output reg [15:0]B;



reg [15:0]Data_memory[4095:0];
reg [3:0]opcode1;
reg [11:0]address1;
reg [7:0]opcode2;
reg [11:0]address2;
reg [16:0]outputreg;



initial
begin
A<=0;
B<=0;
Data_memory[12'h000]<=16'hABCD;
Data_memory[12'h100]<=16'h0000;
Data_memory[12'h101]<=16'h0001;
Data_memory[12'h102]<=16'h0002;
Data_memory[12'h103]<=16'h0003;
Data_memory[12'h104]<=16'hFFFF;
Data_memory[12'h105]<=16'hAAAA;
//data mem
end
parameter LDA = 4'b0000; //Value 0 eg: ld [M],A done
parameter LDB = 4'b0001; //Value 1 eg: ld [M],B done
parameter STA = 4'b0010;
parameter STB = 4'b0011;
parameter JMP = 4'b0100;
parameter JSR = 4'b1000;
parameter PUSHA = 4'b1010;
parameter POPA = 4'b1100;
parameter RET = 4'b1110;
parameter HALT =4'b0101;



parameter ADD = 8'b01110001;
parameter AND = 8'b01110010;
parameter CLA = 8'b01110011;
parameter CLB = 8'b01110100;
parameter CMB = 8'b01110101;
parameter INCB = 8'b01110110;
parameter DECB = 8'b01110111;
parameter CLC = 8'b01111000;
parameter CLZ = 8'b01111001;
parameter ION = 8'b01111010;
parameter IOF = 8'b01111011;
parameter SC = 8'b01111100;
parameter SZ = 8'b01111101;




always@(*)
begin
if(instruction[15:8]!=ION && instruction[15:8]!=IOF)
begin
if(instruction[15:12]!=4'b0111)
begin
opcode1 = instruction[15:12];
address1= instruction[11:0];
case(opcode1)
LDA:begin
A<=Data_memory[address1];
branch_stack_C_Z_detec<=4'b1111;//inc PC directly
end
LDB:begin
B<=Data_memory[address1];
branch_stack_C_Z_detec<=4'b1111;//inc PC directly
end
STA:begin
Data_memory[address1]<=A;
branch_stack_C_Z_detec<=4'b1111;//inc PC directly
end
STB:begin
Data_memory[address1]<=B;
branch_stack_C_Z_detec<=4'b1111;//inc PC directly
end
JMP:begin
PC_branch<=address1;
branch_stack_C_Z_detec<=4'b0000;
end
JSR:begin
PC_branch<=address1;
branch_stack_C_Z_detec<=4'b0001;
end
PUSHA:begin
branch_stack_C_Z_detec<=4'b010;
A_TO_STACK<=A;
end
POPA:begin
branch_stack_C_Z_detec<=4'b0011;
A<=STACK_TO_A;
end
RET:begin
branch_stack_C_Z_detec<=4'b0100;
end
HALT:begin
branch_stack_C_Z_detec<=4'b1001;
end
endcase
end



if(instruction[15:12]==4'b0111)
begin
opcode2 = instruction[15:8];
case(opcode2)
ADD:begin
outputreg=A+B;
A=outputreg[15:0];
branch_stack_C_Z_detec<=4'b1111;//inc PC directly
end
AND:begin
A=A&B;
branch_stack_C_Z_detec<=4'b1111;//inc PC directly
end
CLA:begin
A=0;
branch_stack_C_Z_detec<=4'b1111;//inc PC directly
end
CLB:begin
B=0;
branch_stack_C_Z_detec<=4'b1111;//inc PC directly
end
CMB:begin
B=~B;
branch_stack_C_Z_detec<=4'b1111;//inc PC directly
end
INCB:begin
B=B+1;
branch_stack_C_Z_detec<=4'b1111;//inc PC directly
end
DECB:begin
B=B-1;
branch_stack_C_Z_detec<=4'b1111;//inc PC directly
end
CLC:begin
C=0;
branch_stack_C_Z_detec<=4'b1111;//inc PC directly
end
CLZ:begin
Z=0;
branch_stack_C_Z_detec<=4'b1111;//inc PC directly
end
SC:begin
if(C==1)
begin
branch_stack_C_Z_detec=4'b0101;
end
end
SZ:begin
if(Z==1)
begin
branch_stack_C_Z_detec=4'b0110;
end
end
endcase
end
end



else if(instruction[15:8]==ION)
begin
branch_stack_C_Z_detec=4'b0111;
end



else if(instruction[15:8]==IOF)
begin
branch_stack_C_Z_detec=4'b1000;
end
Z=(B==16'b0);
C = outputreg[16];
end



endmodule