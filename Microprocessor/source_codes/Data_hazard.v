`timescale 1ns / 1ps

module Data_hazard(input [2:0] AA,input [2:0] BA,input [2:0] DA,input RW,input MA,input MB,output DHS);

reg or_1,comp_1,comp_2,HA,HB;

always@(AA,BA,DA,RW,MA,MB)
begin    
or_1 = DA[0]|DA[1]|DA[2];

if (AA ^ DA)  //comparator 1 
    comp_1 = 1'b0;
else
    comp_1 = 1'b1;

if (BA ^ DA)  //comparator 2 
    comp_2 = 1'b0;
else
    comp_2 = 1'b1; 
HA = RW & or_1 & ~MA & comp_1;
HB = RW & or_1 & ~MB & comp_2;    

end  
 
assign DHS = ~(HA | HB);
 
endmodule

module branchpredictor(
input [1:0] BS,
output B_D);
assign B_D = ~(BS[0] | BS [1]);
endmodule