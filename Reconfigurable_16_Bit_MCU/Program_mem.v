`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 30.04.2022 20:19:36
// Design Name:
// Module Name: Program_mem
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




module Program_mem(address,instruction_pm);
input [11:0]address;



output reg [15:0]instruction_pm;
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
always@(*) begin
case(address)
//Test1
12'b0:instruction_pm ={IOF,8'b0};
12'd1:instruction_pm ={CLB,8'b0};
12'd2:instruction_pm ={CLA,8'b0};
12'd3:instruction_pm ={LDB,12'h104};
12'd4:instruction_pm ={LDA,12'h102};
12'd5:instruction_pm ={CMB,8'b0};
12'd6:instruction_pm ={INCB,8'b0};
12'd7:instruction_pm ={ADD,8'b0};
12'd8:instruction_pm ={LDB,12'h103};
12'd9:instruction_pm ={AND,8'b0};
12'd10:instruction_pm ={STA,12'h500};
12'd11:instruction_pm ={LDB,12'h500};
12'd12:instruction_pm={HALT,12'b0};



//Test2
//12'b0:instruction_pm ={IOF,8'b0};
//12'd1:instruction_pm ={CLB,8'b0};
//12'd2:instruction_pm ={CLA,8'b0};
//12'd3:instruction_pm ={CLC,8'b0};
//12'd4:instruction_pm ={CLZ,8'b0};
//12'd5:instruction_pm ={LDB,12'h103};
//12'd6:instruction_pm ={ADD,8'b0};
//12'd7:instruction_pm ={DECB,8'b0};
//12'd8:instruction_pm ={ADD,8'b0};
//12'd9:instruction_pm ={SZ,8'b0};
//12'd10:instruction_pm ={JMP,12'd7};
//12'd11:instruction_pm={HALT,12'b0};



//Test3
//12'b0:instruction_pm ={IOF,8'b0};
//12'd1:instruction_pm ={CLB,8'b0};
//12'd2:instruction_pm ={CLA,8'b0};
//12'd3:instruction_pm ={ION,8'b0};
//12'd4:instruction_pm ={LDA,12'h104};
//12'd5:instruction_pm ={POPA,12'b0};
//12'd6:instruction_pm={HALT,12'b0};



//ISR
//12'd3840:instruction_pm ={LDA,12'h000};
//12'd3841:instruction_pm ={LDB,12'h101};
//12'd3842:instruction_pm ={ADD,8'b0};
//12'd3843:instruction_pm ={CLB,8'b0};
//12'd3844:instruction_pm ={RET,12'd0};
//
endcase

end
endmodule