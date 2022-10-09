`timescale 1ns / 1ps

module clock_100to25(
    input clk_100M,
    output reg clk_25M = 0
    );
	reg count_bit = 0;
	always @(posedge clk_100M)
	begin
		count_bit = ~ count_bit;
		if (~count_bit)
			clk_25M = ~clk_25M;
	end
	
endmodule
