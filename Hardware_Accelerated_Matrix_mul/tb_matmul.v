module tb_matmul();
reg clk;
reg [7:0]A_val;
reg [7:0]B_val;
reg [7:0]A_loc;
reg [7:0]B_loc;

wire [7:0]res1;
wire [7:0]res2;
wire [7:0]res3;

matmul uut(.clk(clk),.A_val(A_val),.B_val(B_val),.A_loc(A_loc),.B_loc(B_loc),.res1(res1),.res2(res2),.res3(res3));
always begin
    #5 clk=~clk;
end
initial
begin
clk=1;
end

initial // Matrix A 
begin
A_loc<=0;A_val<=0;#10;
A_loc<=1;A_val<=1;#10;
A_loc<=2;A_val<=2;#10;
A_loc<=3;A_val<=3;#10;
A_loc<=4;A_val<=4;#10;
A_loc<=5;A_val<=5;#10;
A_loc<=6;A_val<=6;#10;
A_loc<=7;A_val<=7;#10;
A_loc<=8;A_val<=8;#10;
A_loc<=8'bx;
A_val<=8'bx;
end

initial // Matrix B 
begin
B_loc<=0;B_val<=0;#10;
B_loc<=1;B_val<=1;#10;
B_loc<=2;B_val<=2;#10;
B_loc<=3;B_val<=3;#10;
B_loc<=4;B_val<=4;#10;
B_loc<=5;B_val<=5;#10;
B_loc<=6;B_val<=6;#10;
B_loc<=7;B_val<=7;#10;
B_loc<=8;B_val<=8;#10;
B_loc<=8'bx;
B_val<=8'bx;
end
endmodule
