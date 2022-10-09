`timescale 1ns / 1ps

module vga_grid16(
    input [9:0] x_pos,
    input [9:0] y_pos,
    output reg [1:0] grid_x,
    output reg [1:0] grid_y
    );
	
	// Set x_grid positon
	always @(x_pos)
	begin
		if (x_pos < 160)
			grid_x <= 2'b00;
		else if (x_pos < 320)
			grid_x <= 2'b01;
		else if (x_pos < 480)
			grid_x <= 2'b10;
		else //480-639
			grid_x <= 2'b11;
	end
	
	// Set y_grid position
	always @(y_pos)
	begin
		if (y_pos < 120)
			grid_y <= 2'b00;
		else if (y_pos < 240)
			grid_y <= 2'b01;
		else if (y_pos < 360)
			grid_y <= 2'b10;
		else //360-479
			grid_y <= 2'b11;
	end

endmodule
