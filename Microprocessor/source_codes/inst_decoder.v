`timescale 1ns / 1ps

module inst_decoder(
    input [16:0] instruction,
    output  RW,
    output  [2:0] DA,//DA WIREddress,
    output [1:0] MD ,//muxd select,
    output [1:0] BS, //branch select,
    output PS,//zero toggle,
    output MW,//memory_write,
    output [3:0] FS,//function select
    output MA,//mux a select 
    output MB,// mux  b select 
    output [2:0]AA, //register a address
    output [2:0]BA, // register b address
    output CS, // constant AA_WIRE
    output [2:0] SH, //shift registers
    output output_write_enable );
    
parameter NOP = 5'b00000; // nop
parameter SUB = 5'b00001; // sub r1,r2,r3
parameter JML = 5'b00010; // jml r2, r3
parameter JMP =	5'b00011; // jmp [r2]
parameter AIU =	5'b00100; // aiu r3,r2,06H
parameter ST  = 5'b00101; // st [r2] r1
parameter AND = 5'b00110; // and r3,r2,r1
parameter JMR =	5'b00111; // jmp r2
parameter LSL =	5'b01000; // lsl r3 , 03H
parameter ADI = 5'b01001; // add r3 r2 03H 
parameter OR  = 5'b01010; // xor r4 r3 r2
parameter BZ  = 5'b01011; // bz r2 20H
parameter MOV = 5'b01100; // mov r2 r1
parameter LD  = 5'b01101; // ld r4 [r1]
parameter SLT = 5'b01110; // slt r3 r2 r1
parameter ADD = 5'b01111; // add r3 r2 r1
parameter OUT = 5'b10000; // out r3 [r2] 
parameter NOT = 5'b10001; // not r2 
parameter IN  = 5'b10010; // in r7 [r4]
parameter BNZ = 5'b10011; // bnz r2
parameter XRI = 5'b10100; // or r3 r2 35H
parameter LSR = 5'b10101; // lsR r3 , 03H

reg RW_WIRE;
reg [2:0] DA_WIRE;  //DA WIREtAA WIREddress,
reg[1:0] MD_WIRE ;//muxd select,
reg[1:0] BS_WIRE;  //branch select,
reg  PS_WIRE ; //zero toggle,
reg  MW_WIRE ; //memory write,
reg [3:0] FS_WIRE; //function select
reg MA_WIRE ; //mux a select 
reg MB_WIRE ; // mux  b select 
reg [2:0]AA_WIRE ; //register a address
reg [2:0]BA_WIRE ; // register b address
reg CS_WIRE ; // constant AA WIRE
reg [2:0] SH_WIRE;
reg [4:0] opcode;
reg output_write_enable_wire;

always@(*) begin

opcode = instruction[16:12]; 

case(opcode)
    NOP:begin    //1
    RW_WIRE = 1'b0; DA_WIRE = 3'b000; MD_WIRE = 2'b00;BS_WIRE = 2'b00;PS_WIRE = 1'b0;MW_WIRE = 1'b0;FS_WIRE = 4'b0000; MA_WIRE = 1'b0; MB_WIRE = 1'b0; AA_WIRE = 3'b000; BA_WIRE = 3'b000; CS_WIRE = 1'b0;SH_WIRE=3'h0; output_write_enable_wire = 1'b0;
    end 
    SUB:begin // 2
    RW_WIRE = 1'b1; DA_WIRE = instruction[11:9]; MD_WIRE = 2'b00;BS_WIRE = 2'b00;PS_WIRE = 1'b0;MW_WIRE = 1'b0;FS_WIRE = 4'b0010; MA_WIRE = 1'b0; MB_WIRE = 1'b0; AA_WIRE = instruction[8:6]; BA_WIRE = instruction[5:3]; CS_WIRE = 1'b0;SH_WIRE = 3'h0; output_write_enable_wire = 1'b0; 
    end 
    JML:begin   //3
    RW_WIRE = 1'b1; DA_WIRE = instruction[11:9]; MD_WIRE = 2'b00;BS_WIRE = 2'b11;PS_WIRE = 1'b0;MW_WIRE = 1'b0 ;FS_WIRE = 4'b1000; MA_WIRE = 1'b1; MB_WIRE = 1'b1; AA_WIRE = 3'b000; BA_WIRE = 3'b000; CS_WIRE = 1'b1;SH_WIRE = 3'h0;SH_WIRE=3'h0; output_write_enable_wire = 1'b0; 
    end 
    JMP:begin //4
    RW_WIRE = 1'b0; DA_WIRE = 3'b000; MD_WIRE = 2'b00;BS_WIRE = 2'b11;PS_WIRE = 1'b0;MW_WIRE = 1'b0;FS_WIRE = 4'b0000; MA_WIRE = 1'b0; MB_WIRE = 1'b1; AA_WIRE = 3'b000; BA_WIRE = 3'b000; CS_WIRE = 1'b1;SH_WIRE = 3'h0;  output_write_enable_wire = 1'b0; 
    end 
    AIU:begin //5
    RW_WIRE = 1'b1; DA_WIRE = instruction[11:9]; MD_WIRE = 2'b00;BS_WIRE = 2'b00;PS_WIRE = 1'b0;MW_WIRE = 1'b0;FS_WIRE = 4'b0001; MA_WIRE = 1'b0; MB_WIRE = 1'b1; AA_WIRE = instruction[8:6]; BA_WIRE = 3'b000; CS_WIRE = 1'b1;SH_WIRE = 3'h0; output_write_enable_wire = 1'b0; 
    end
    ST:begin  //6
    RW_WIRE = 1'b0; DA_WIRE = instruction[11:9]; MD_WIRE = 2'b00;BS_WIRE = 2'b00;PS_WIRE = 1'b0;MW_WIRE = 1'b1;FS_WIRE = 4'b0000; MA_WIRE = 1'b0; MB_WIRE = 1'b0; AA_WIRE = instruction[8:6]; BA_WIRE = instruction[5:3]; CS_WIRE = 1'b0; SH_WIRE = 3'h0;output_write_enable_wire = 1'b0; 
    end 
    AND:begin  //7
    RW_WIRE = 1'b1; DA_WIRE = instruction[11:9]; MD_WIRE = 2'b00;BS_WIRE = 2'b00;PS_WIRE = 1'b0;MW_WIRE = 1'b0;FS_WIRE = 4'b1001; MA_WIRE = 1'b0; MB_WIRE = 1'b0; AA_WIRE = instruction[8:6]; BA_WIRE = instruction[5:3]; CS_WIRE = 1'b0; SH_WIRE = 3'h0; output_write_enable_wire = 1'b0;
    end
    JMR:begin  //8
    RW_WIRE = 1'b0; DA_WIRE = 3'b000; MD_WIRE = 2'b00;BS_WIRE = 2'b10;PS_WIRE = 1'b0;MW_WIRE = 1'b0;FS_WIRE = 4'b0000; MA_WIRE = 1'b0; MB_WIRE = 1'b0; AA_WIRE = instruction[8:6]; BA_WIRE = 3'b000; CS_WIRE = 1'b0; SH_WIRE = 3'h0;output_write_enable_wire = 1'b0; 
    end 
    LSL:begin  //9
    RW_WIRE = 1'b1; DA_WIRE = instruction[11:9]; MD_WIRE = 2'b00;BS_WIRE = 2'b00;PS_WIRE = 1'b0;MW_WIRE = 1'b0;FS_WIRE = 4'b0110; MA_WIRE = 1'b0; MB_WIRE = 1'b0; AA_WIRE = instruction[8:6]; BA_WIRE = 3'b000; CS_WIRE = 1'b0;SH_WIRE = instruction[2:0];output_write_enable_wire = 1'b0;  
    end 
    ADI:begin  //10
    RW_WIRE = 1'b1; DA_WIRE = instruction[11:9]; MD_WIRE = 2'b00;BS_WIRE = 2'b00;PS_WIRE = 1'b0;MW_WIRE = 1'b0;FS_WIRE = 4'b0001; MA_WIRE = 1'b0; MB_WIRE = 1'b1; AA_WIRE = instruction[8:6]; BA_WIRE = 3'b000; CS_WIRE = 1'b1;SH_WIRE=3'h0;output_write_enable_wire = 1'b0;  
    end 
    OR:begin //11
    RW_WIRE = 1'b1; DA_WIRE = instruction[11:9]; MD_WIRE = 2'b00;BS_WIRE = 2'b00;PS_WIRE = 1'b0;MW_WIRE = 1'b0;FS_WIRE = 4'b0011; MA_WIRE = 1'b0; MB_WIRE = 1'b0; AA_WIRE = instruction[8:6]; BA_WIRE = instruction[5:3]; CS_WIRE = 1'b0;SH_WIRE=3'h0; output_write_enable_wire = 1'b0; 
    end
    BZ:begin  //12
    RW_WIRE = 1'b0; DA_WIRE = 3'b000; MD_WIRE = 2'b00;BS_WIRE = 2'b01;PS_WIRE = 1'b0;MW_WIRE = 1'b0;FS_WIRE = 4'b1000; MA_WIRE = 1'b0; MB_WIRE = 1'b1; AA_WIRE = instruction[8:6]; BA_WIRE = 3'b000; CS_WIRE = 1'b1;SH_WIRE =3'h0;output_write_enable_wire = 1'b0;  
    end 
    MOV:begin //13
    RW_WIRE = 1'b1; DA_WIRE = instruction[11:9]; MD_WIRE = 2'b00;BS_WIRE = 2'b00;PS_WIRE = 1'b0;MW_WIRE = 1'b0;FS_WIRE = 4'b1000; MA_WIRE = 1'b0; MB_WIRE = 1'b0; AA_WIRE = instruction[8:6]; BA_WIRE = 3'b000; CS_WIRE = 1'b0;SH_WIRE = 3'h0; output_write_enable_wire = 1'b0; 
    end 
    LD:begin  //14
    RW_WIRE = 1'b1; DA_WIRE = instruction[11:9]; MD_WIRE = 2'b01;BS_WIRE = 2'b00;PS_WIRE = 1'b0;MW_WIRE = 1'b0;FS_WIRE = 4'b0000; MA_WIRE = 1'b0; MB_WIRE = 1'b0; AA_WIRE = instruction[8:6]; BA_WIRE = 3'b000; CS_WIRE = 1'b0;SH_WIRE = 3'h0; output_write_enable_wire = 1'b0; 
    end 
    SLT:begin //15
    RW_WIRE = 1'b1; DA_WIRE = instruction[11:9]; MD_WIRE = 2'b00;BS_WIRE = 2'b00;PS_WIRE = 1'b0;MW_WIRE = 1'b0;FS_WIRE = 4'b1010; MA_WIRE = 1'b0; MB_WIRE = 1'b0; AA_WIRE = instruction[8:6]; BA_WIRE = instruction[5:3]; CS_WIRE = 1'b0;SH_WIRE = 3'h0;  output_write_enable_wire = 1'b0;
    end 
    ADD:begin //16
    RW_WIRE = 1'b1; DA_WIRE = instruction[11:9]; MD_WIRE = 2'b00;BS_WIRE = 2'b00;PS_WIRE = 1'b0;MW_WIRE = 1'b0;FS_WIRE = 4'b0001; MA_WIRE = 1'b0; MB_WIRE = 1'b0; AA_WIRE = instruction[8:6]; BA_WIRE = instruction[5:3]; CS_WIRE = 1'b0;SH_WIRE = 3'h0; output_write_enable_wire = 1'b0; 
    end
    OUT:begin  //17
    RW_WIRE = 1'b0; DA_WIRE = 3'b000; MD_WIRE = 2'b00;BS_WIRE = 2'b00;PS_WIRE = 1'b0;MW_WIRE = 1'b1;FS_WIRE = 4'b0000; MA_WIRE = 1'b0; MB_WIRE = 1'b0; AA_WIRE = instruction[8:6]; BA_WIRE = instruction[5:3]; CS_WIRE = 1'b0;SH_WIRE=3'h0; output_write_enable_wire = 1'b1; 
    end 
    NOT:begin //18
    RW_WIRE = 1'b1; DA_WIRE = instruction[11:9]; MD_WIRE = 2'b00;BS_WIRE = 2'b00;PS_WIRE = 1'b0;MW_WIRE = 1'b0;FS_WIRE = 4'b1100; MA_WIRE = 1'b0; MB_WIRE = 1'b0; AA_WIRE = instruction[8:6]; BA_WIRE = 3'b000; CS_WIRE = 1'b0;SH_WIRE=3'h0; output_write_enable_wire = 1'b0; 
    end 
    IN:begin //19
    RW_WIRE = 1'b1; DA_WIRE = instruction[11:9]; MD_WIRE = 2'b10;BS_WIRE = 2'b00;PS_WIRE = 1'b0;MW_WIRE = 1'b0;FS_WIRE = 4'b0000; MA_WIRE = 1'b0; MB_WIRE = 1'b0; AA_WIRE = instruction[8:6]; BA_WIRE = 3'b000; CS_WIRE = 1'b0;SH_WIRE=3'h0; output_write_enable_wire = 1'b0; 
    end 
    BNZ:begin //20
    RW_WIRE = 1'b0; DA_WIRE = 3'b000; MD_WIRE = 2'b00;BS_WIRE = 2'b11;PS_WIRE = 1'b1;MW_WIRE = 1'b0;FS_WIRE = 4'b1000; MA_WIRE = 1'b0; MB_WIRE = 1'b1; AA_WIRE = instruction[8:6]; BA_WIRE = 3'b000; CS_WIRE = 1'b1;SH_WIRE= 3'h0; output_write_enable_wire = 1'b0; 
    end 
    XRI:begin  //21
    RW_WIRE = 1'b1; DA_WIRE = instruction[11:9]; MD_WIRE = 2'b00;BS_WIRE = 2'b00;PS_WIRE = 1'b0;MW_WIRE = 1'b0;FS_WIRE = 4'b0100; MA_WIRE = 1'b0; MB_WIRE = 1'b1; AA_WIRE = instruction[8:6]; BA_WIRE = 3'b000; CS_WIRE = 1'b0;SH_WIRE=3'h0; output_write_enable_wire = 1'b0;  
    end 
    LSR:begin  //22
    RW_WIRE = 1'b1; DA_WIRE = instruction[11:9]; MD_WIRE = 2'b00;BS_WIRE = 2'b00;PS_WIRE = 1'b0;MW_WIRE = 1'b0;FS_WIRE = 4'b0101; MA_WIRE = 1'b0; MB_WIRE = 1'b0; AA_WIRE = instruction[8:6]; BA_WIRE = 3'b000; CS_WIRE = 1'b0;SH_WIRE = instruction[2:0];output_write_enable_wire = 1'b0;  
    end 
    default: begin
    RW_WIRE = 1'b0; DA_WIRE = 3'b000; MD_WIRE = 2'b00;BS_WIRE = 2'b00;PS_WIRE = 1'b0;MW_WIRE = 1'b0;FS_WIRE = 4'b0000; MA_WIRE = 1'b0; MB_WIRE = 1'b0; AA_WIRE = 3'b000; BA_WIRE = 3'b000; CS_WIRE = 1'b0;SH_WIRE=3'h0;output_write_enable_wire = 1'b0;
    end 
    endcase
end

assign RW = RW_WIRE;
assign DA = DA_WIRE;
assign MD = MD_WIRE;
assign BS = BS_WIRE;
assign PS = PS_WIRE;
assign MW = MW_WIRE;
assign FS = FS_WIRE;
assign MA = MA_WIRE;
assign MB = MB_WIRE;
assign AA = AA_WIRE;
assign BA = BA_WIRE;
assign CS = CS_WIRE;
assign SH = SH_WIRE;
assign output_write_enable = output_write_enable_wire;

endmodule
