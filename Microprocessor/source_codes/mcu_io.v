`timescale 1ns / 1ps

module mcu_io(
	 input clk,  
	 input reset,
	 input output_write_enable, 
	 input [7:0] output_data_in, 
	 input [7:0] output_data_address, 
	 output reg [7:0] input_data_out, 
	 input [8:0] fpga_in, // FPGA input pins
	 output [9:0] fpga_out // FPGA output pins
    );

	vga_out VGA_OUT(.clk(clk),
			  .write_enable(output_write_enable),
			  .position(output_data_address),
			  .value(output_data_in),
			  .vgaRed(fpga_out[9:7]),
			  .vgaGreen(fpga_out[6:4]),
			  .vgaBlue(fpga_out[3:2]),
			  .Hsync(fpga_out[1]),
			  .Vsync(fpga_out[0])
    );
	 
	 always @(fpga_in[8])
	 begin
		if (!reset)
			input_data_out <= 8'd0;
		else
			input_data_out <= fpga_in[7:0];
	 end
endmodule
