`timescale 10ns / 1ps

module mcu_main(input clk,input reset,input [8:0]fpga_in,output [9:0]fpga_out);

// registers to fetch instructions
reg[7:0] pc_1_reg;
reg[16:0] instruction_reg;

// registers to select decoder
reg [7:0] pc_2_reg ;
reg RW_decode_reg ;//read write signal 
reg [2:0] DA_decode_reg; //mux d selet bits 
reg  [1:0] MD_decode_reg; //mux d decode 
reg [1:0] BS_reg; // bs code
reg  PS_reg ;// zero branch conrol
reg MW_reg; //memory write signal
reg [3:0] FS_reg ;// function select
reg [2:0] SH_reg ; //shift wire 
reg [7:0] MUX_A_out_reg ;  
reg [7:0] MUX_B_out_reg ;
reg output_write_enable_reg;

// execution stage registers 
reg RW_execute_reg ;//read write signal 
reg [2:0] DA_execute_reg; //mux a selet bits 
reg [2:0] MD_execute_reg; //mux d decode
reg [7:0] F_out_reg ; // output from the fout BS_reg
reg [7:0] data_out_reg ;
reg [7:0] inout_reg;

// write back registers
reg[7:0] pc_reg;  // first pc register  

// connecting the wires
wire resetwire;

// instruction fetch wires
wire [7:0] pc_1_wire; //stage 2 pc wire
wire [16:0] instruction_wire;  // instruction 2 stage in decoder

// decoder section wires
wire [7:0] pc_2_wire ;//stage 3 pc register
wire RW_decode_wire ;//read write signal 
wire [2:0] DA_decode_wire; //mux a selet bits 
wire  [1:0] MD_decode_wire; //mux d decode 
wire [1:0] BS_decode_wire; // bs code
wire  PS_wire ;// zero branch conrol
wire MW_wire; //memory write signal
wire [3:0] FS_wire ;// function selct 
wire [2:0] SH_wire ; //shift wire 
wire [7:0] MUX_A_out_wire ; // mux a out 
wire [7:0] MUX_B_out_wire ; // mux b out
wire output_write_enable_wire;

wire cs_wire ;
wire MA_wire;
wire MB_wire;
wire [2:0]AA_wire;
wire [2:0]BA_wire;
wire [7:0] constant_unit_wire;
wire [7:0] a_data_wire;
wire [7:0] b_data_wire;

wire [2:0] DA_hazard_wire;
wire RW_hazard_wire;

// execution stage wires
wire RW_execute_wire ;//read write signal 
wire [2:0] DA_execute_wire; //mux a selet bits 
wire [2:0] MD_execute_wire; //mux d decode
wire [7:0] F_out_wire ; // output from the fout BS_reg
wire [7:0] data_out_wire ;
wire [7:0] inout_wire;

wire zero_flag_wire;
wire carry_wire;
wire negative_flag_wire;
wire [7:0]BrA_wire;

// write back wires
wire [7:0] pc_wire;  // first pc register 

wire [7:0] mux_d_out_wire; 
wire [1:0] BS_wire;
wire B_D_wire;
wire DHS;
wire [1:0]BS_brancher_wire;

assign resetwire = ~reset;

// connecting the modules
Program_memory interface1 (.address(pc_reg),.prog_data(instruction_wire),.reset(reset)); 
assign pc_1_wire = pc_reg + 8'h1;

assign pc_2_wire = pc_1_reg;

assign RW_execute_wire = RW_decode_reg;
constant interface2 (.immidiate_value(instruction_reg[5:0]),.cs(cs_wire),.constant_unit_out(constant_unit_wire));

mux_a interface3 (.MA(MA_wire),.PC_minus1(pc_1_reg),.register_a(a_data_wire),.mux_a_out(MUX_A_out_wire));

mux_b interface4 (.MB(MB_wire),.constantunit_out(constant_unit_wire),.register_b(b_data_wire),.mux_b_out(MUX_B_out_wire));

Register_file interface5 (.clk(clk),.a_address(AA_wire),.b_address(BA_wire),.d_address(DA_execute_reg),.datain(mux_d_out_wire),
                         .write_en(RW_execute_reg),.a_data(a_data_wire),.b_data(b_data_wire));

inst_decoder interface6(.instruction(instruction_reg),.MA(MA_wire),.MB(MB_wire),.AA(AA_wire),.BA(BA_wire),.CS(cs_wire),
                              .RW(RW_decode_wire),.DA(DA_decode_wire),.MD(MD_decode_wire),.BS(BS_decode_wire),.PS(PS_wire),
                              .MW(MW_wire),.FS(FS_wire),.SH(SH_wire),.output_write_enable(output_write_enable_wire));

Data_hazard interface7(.AA(AA_wire),.BA(BA_wire),.DA(DA_decode_reg),.RW(RW_decode_reg),.MA(MA_wire),.MB(MB_wire),.DHS(DHS));

assign MD_execute_wire = MD_decode_reg;
assign DA_execute_wire = DA_decode_reg;

// execution stage connection for modules in them
Data_memory interface8(.clk(clk),.write(MW_reg),.address(MUX_A_out_reg),.datain(MUX_B_out_reg),.dataout(data_out_wire));

adder interface9(.pc(pc_2_reg),.bus_b(MUX_B_out_reg),.BrA(BrA_wire));

alu interface10(.A(MUX_A_out_reg),.B(MUX_B_out_reg),.FS(FS_reg),.sh(SH_reg),.F(F_out_wire),.C(carry_wire),
                .N(negative_flag_wire),.Z(zero_flag_wire));

mcu_io IO_MODULE(.clk(clk),.reset(reset),.output_write_enable(output_write_enable_reg),.output_data_in(MUX_B_out_reg),
                 .output_data_address(MUX_A_out_reg),.input_data_out(inout_wire),.fpga_in(fpga_in),.fpga_out(fpga_out));
                 
// write back stage components 
mux_d interface11(.MD(MD_execute_reg),.alu_out(F_out_reg),.in_out(inout_reg),.mem_data(data_out_reg),.mux_d_out(mux_d_out_wire));

brancher interface12(.BS_in(BS_reg),.ps(PS_wire),.z(zero_flag_wire),.BS_out(BS_brancher_wire));

mux_c interface13(.BS(BS_brancher_wire),.pc_value(pc_reg),.RAA(MUX_A_out_reg),.Braa(BrA_wire),.pc_out(pc_wire));


branchpredictor interface14(.BS(BS_brancher_wire),.B_D(B_D_wire));  //BRANCH PREDICTOR

always @(posedge clk ) begin

if (~reset) begin
pc_1_reg <= 8'h0;
instruction_reg <= 17'h0;

//instruction decode constraint_mode
pc_2_reg <= 8'h0;
RW_decode_reg <= 1'h0;
DA_decode_reg <= 3'h0;
MD_decode_reg <= 2'h0;
BS_reg <= 2'h0;
PS_reg <= 2'h0;
MW_reg <= 1'h0;
FS_reg <= 4'h0;
SH_reg <= 3'h0;
MUX_A_out_reg <= 8'h0;
MUX_B_out_reg <= 8'h0;
output_write_enable_reg <= 1'h0;

// execution stage 
RW_execute_reg <= 1'h0;
DA_execute_reg <= 3'h0;
MD_execute_reg <= 2'h0;
F_out_reg <= 8'h0;
data_out_reg <= 8'h0;
inout_reg <= 8'h0;

//writeback stage 
pc_reg <= 8'h0;

end
else 
begin
//  instruction fetch stage 
if (DHS )
    pc_1_reg <= pc_1_wire;

if (DHS)
    instruction_reg <= instruction_wire;

if (DHS)
    pc_2_reg <= pc_2_wire;

RW_decode_reg <= (RW_decode_wire  & B_D_wire &DHS);
DA_decode_reg <= { DA_decode_wire[2] & DHS & B_D_wire ,DA_decode_wire[1] & DHS & B_D_wire ,DA_decode_wire[0] & DHS & B_D_wire };
MD_decode_reg <= MD_decode_wire;
BS_reg <= {BS_decode_wire[1] & DHS & B_D_wire ,BS_decode_wire[0] & DHS & B_D_wire };        
PS_reg <= PS_wire;
MW_reg <= (MW_wire & DHS & B_D_wire);
FS_reg <= FS_wire;
SH_reg <= SH_wire;
MUX_A_out_reg <= MUX_A_out_wire;
MUX_B_out_reg <= MUX_B_out_wire;
output_write_enable_reg <= output_write_enable_wire;

// execution stage 
RW_execute_reg <= RW_execute_wire;
DA_execute_reg <= DA_execute_wire ;
MD_execute_reg <= MD_execute_wire;
F_out_reg <= F_out_wire;
data_out_reg <= data_out_wire;
inout_reg <= inout_wire;

//  writeback stage 
if (DHS)
    pc_reg <= pc_wire;
end
end
endmodule
