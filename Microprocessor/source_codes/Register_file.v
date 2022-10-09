`timescale 1ns / 1ps

module Register_file(clk,a_address,b_address,d_address,datain,write_en,a_data,b_data);

input clk;
input [2:0]a_address;
input [2:0]b_address;
input [2:0]d_address;
input [7:0]datain;
input write_en;
output [7:0]a_data;
output [7:0]b_data;
reg [7:0]Register_file[7:0];

//assign Register_file[3'h0] = 8'h0;

initial begin
Register_file [3'b000]= 8'h0;
Register_file [3'b001]= 8'h0;
Register_file [3'b010]= 8'h0;
Register_file [3'b011]= 8'h0;
Register_file [3'b100]= 8'h0;
Register_file [3'b101]= 8'h0;
Register_file [3'b110]= 8'h0;
Register_file [3'b111]= 8'h0;
end
always@(negedge clk )begin
    if(d_address == 3'h0 && write_en)begin
        Register_file[d_address] <= 8'h0;
    end else if( write_en )  begin
        Register_file[d_address] <= datain;
    end
    end
    
assign a_data = Register_file [a_address];
assign b_data = Register_file [b_address ];                              
endmodule

