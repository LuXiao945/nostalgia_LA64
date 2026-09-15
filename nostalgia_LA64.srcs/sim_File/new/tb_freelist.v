`timescale 1ns / 1ps

module tb_freelist(
);
reg clk;
reg rst;
reg [6:0] deallocation_reg_id [5:0];
reg [5:0] deallocation ;
reg [2:0] use_num;

initial begin
	clk = 1'b0;
	rst = 1'b1;
	#1
	rst = 1'b0;
	use_num = 3'd6;
	#25
	deallocation_reg_id[0] = 6'b010000;
	deallocation_reg_id[1] = 6'b100000;
	deallocation_reg_id[2] = 6'b001000;
	deallocation_reg_id[3] = 6'b000100;
	deallocation_reg_id[4] = 6'b000010;
	deallocation_reg_id[5] = 6'b000001;
	
end 
	always #1 clk = ~clk;
FreeList U_freelist(
	.CLK(clk),
	.RST(rst),
	.deallocation_reg_id(deallocation_reg_id),//释放的寄存器id
	.deallocation_valid(deallocation),//释放的id有效位
	.use_num(use_num),//rat使用的id数量
	.free_reg_id(),//输出的空闲寄存器id
	.valid()//空闲寄存器使能,用来告诉rat输出的哪些id有效
);
endmodule
