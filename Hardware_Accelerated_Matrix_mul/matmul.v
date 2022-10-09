module matmul(
input clk,
input [7:0]A_val,
input [7:0]B_val,
input [7:0]A_loc,
input [7:0]B_loc,

output reg [16:0]res1,
output reg [16:0]res2,
output reg [16:0]res3
);
//**********************Change here*****************************
parameter P=3; // P number of rows for Matrix A
parameter Q=3; // Q number of rows for Matrix A
parameter R=3; // R number of rows for Matrix B
parameter S=3; // S number of rows for Matrix B
//**********************Change here*****************************


reg  [7:0]result[0:9];
integer b1_i,b1_j,b2_i,b2_j,b3_i,b3_j;reg  write_flag_A,write_flag_B;
integer row_flg_1,row_flg_2,row_flg_3;
reg [0:16]sum1;
reg [0:16]sum2;
reg [0:16]sum3;


integer i1,i2;

reg [7:0]A[0:(P*Q)];
reg [7:0]B[0:(R*S)];
initial
begin
if(P*Q>=R*S)// (testbench 10 units x highest number of elements)
begin
#(P*Q*10);
end
else
begin
#(R*S*10);
end
write_flag_A=0;
write_flag_B=0;


b1_i=0;//first always block Matrix A pointer
b1_j=0;//first always block Matrix B Column Pointer

b2_i=0;//second always block Matrix A pointer
b2_j=S/3;//second always block Matrix B Column Pointer

b3_i=0;//third always block Matrix A pointer
b3_j=2*(S/3);//third  always block Matrix B Column Pointer

row_flg_1=0;//first always block Matrix A Row pointer
row_flg_2=0;//second always block Matrix A Row pointer
row_flg_3=0;//third always block Matrix A Row pointer

sum1=0;//sum accumulator for first always block
sum2=0;//sum accumulator for second always block
sum3=0;//sum accumulator for third always block

end

always @(posedge clk)//MATRIX A writing block
begin
for(i1=0;i1<(P*Q);i1=i1+1) 
begin
A[A_loc]=A_val;
end
write_flag_A=1;
end

always @(posedge clk)//MATRIX B  writing block
begin
for(i2=0;i2<(R*S);i2=i2+1)
begin
B[B_loc]=B_val;
end
write_flag_B=1;
end

always @(posedge clk)
begin
if(write_flag_A && write_flag_B) // to check whether writing of inputs are done 
begin
sum1 = sum1 + A[b1_i]*B[b1_j];  //Matrix mul operation
b1_i=b1_i+1;         //element iterator for each element in a row of Matrix A
b1_j=b1_j+S;         //element iterator for each element in a column of Matrix B
if((b1_i%R)==0)      // to check row end
     	begin
      b1_i=0;        //intitialize iterator
	result[b1_j] = sum1; //stored in register  
    res1=sum1;           // output to the used first n columns
    sum1=0;
	if(b1_j>((R*S)-1-2*(S/3)))    // to detect block end in the Matrix B
		begin
		b1_j=0;
        row_flg_1=row_flg_1+1;   // to go to the next row in matrix A
		if(row_flg_1>P)
			begin
             sum1=16'bx;       // end of operation
			end
		end
		b1_i=row_flg_1*Q;     //valuates the jump to next row
	end  
end
end 


always @(posedge clk)
begin
if(write_flag_A && write_flag_B)
begin
sum2 = sum2 + A[b2_i]*B[b2_j];
b2_i=b2_i+1;
b2_j=b2_j+S;
if((b2_i%R)==0) 
     	begin
      b2_i=0;
	result[b2_j] = sum2;
    res2=sum2;
    sum2=0;
	if(b2_j>((R*S)-1-(S/3)))
		begin
		b2_j=S/3;
        row_flg_2=row_flg_2+1;
		if(row_flg_2>P)
			begin
            sum2=16'bx;
			end
		end
		b2_i=row_flg_2*Q;
	end  
end
end 

always @(posedge clk)
begin
if(write_flag_A && write_flag_B)
begin
sum3 = sum3 + A[b3_i]*B[b3_j];
b3_i=b3_i+1;
b3_j=b3_j+S;
if((b3_i%R)==0) 
     	begin
      b3_i=0;
	result[b3_j] = sum3;
    res3=sum3;
    sum3=0;
	if(b3_j>( (R*S)-1 ))
		begin
		b3_j=(2*S)/3;
        row_flg_3=row_flg_3+1;
		if(row_flg_3>P)
			begin
			sum3=16'bx;
			end
		end
		b3_i=row_flg_3*Q;
	end  
end
end 
endmodule