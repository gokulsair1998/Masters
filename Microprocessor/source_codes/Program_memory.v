`timescale 1ns / 1ps

module Program_memory(address,reset,prog_data);
    input [7:0]address;
    input reset; // active low reset
    output reg [16:0] prog_data; //17 bit instructions

reg [0:16] mem [0:255];

parameter NOP = 5'b00000; //nop           
parameter SUB = 5'b00001; //sub r1,r2,r3 
parameter JML = 5'b00010; //jml r2, r3   
parameter JMP =	5'b00011; //jmp [r2]     
parameter AIU =	5'b00100; //aiu r3,r2,06H
parameter ST  = 5'b00101; //st [r2] r1   
parameter AND = 5'b00110; //and r3,r2,r1 
parameter JMR =	5'b00111; //jmp r2       
parameter LSL =	5'b01000; //lsl r3 , 03H 
parameter ADI = 5'b01001; //add r3 r2 03H
parameter OR  = 5'b01010; //xor r4 r3 r2 
parameter BZ  = 5'b01011; //bz r2 20H   
parameter MOV = 5'b01100; //mov r2 r1   
parameter LD  = 5'b01101; //ld r4 [r1]  
parameter SLT = 5'b01110; //slt r3 r2 r1
parameter ADD = 5'b01111; //add r3 r2 r1
parameter OUT = 5'b10000; //out r3 [r2]
parameter NOT = 5'b10001; //not r2 R1     
parameter IN  = 5'b10010; //in r7 [r4]  
parameter BNZ = 5'b10011; //bnz r2       
parameter XRI = 5'b10100; //or r3 r2 35H 
parameter LSR = 5'b10101; //lsR r3 , 03H 

always@(*) begin
case(address) 

8'd0: prog_data =   { IN , 3'b001 , 3'b000 , 3'b000, 3'b000 }; //IN R1 
8'd1: prog_data =   { LSL , 3'b010 , 3'b001 , 3'b000, 3'b100 }; //LSL R2 R1 4
8'd2: prog_data =   { LSR , 3'b010 , 3'b010 , 3'b000, 3'b100 }; //LSL R2 R2 4
8'd3: prog_data =   { LSR , 3'b011 , 3'b001 , 3'b000, 3'b100 }; //LSL R2 R2 4
8'd4: prog_data =   { OUT , 3'b000 , 3'b010 , 3'b011, 3'b000 }; //out R2 R3 011                                                      
8'd5: prog_data =   { JMR , 3'b000 , 3'b000 , 3'b000, 3'b000 }; //SLT R5 R1 R3

endcase
end
endmodule

