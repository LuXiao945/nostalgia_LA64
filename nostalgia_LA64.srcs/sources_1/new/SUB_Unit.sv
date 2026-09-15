`timescale 1ns / 1ps

module SUB_Unit(
	input [63:0] src1,
	input [63:0] src2,
	output reg [63:0] out,
	output reg ZF,//0标志位
	output reg SF,//符号标准位
	output reg OF,//溢出标志位
	output reg CF//进位借位标志
    );
     reg [64:0] des;
	 reg [63:0] opnum2 ;
	 always@(*)begin
	 	opnum2 = ~src2 + 1'b1;
	 	des = src1 + opnum2;
	 	out = des[63:0];
	 	CF = des[64];
	 	SF = des[63];
	 	ZF = ~(|des[63:0]);
	 	OF = (src1[63]&opnum2[63]&(~des[63]))|((~src1[63])&(~opnum2[63])&des[63]);
	 end
    
endmodule
