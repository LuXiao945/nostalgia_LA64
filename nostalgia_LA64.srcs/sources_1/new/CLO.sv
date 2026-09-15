`timescale 1ns / 1ps

//用来统计前导1或尾随1的数量，如果想统计前导0请将数据取反后输入
//2026/8/3优化了重复项,防止综合消耗过大
module CLO(
	input [63:0] in,
	input [2:0] mem_width,
	input LT_mode,//0为计算前导，1为计算尾随
	output  [63:0] cnt//输出连续1的数量
    );
    wire [63:0] L64;
    wire [31:0] L32;
    wire [15:0] L16;
    wire [7:0] L8;
    wire [3:0] L4;
    wire [1:0] L2;
    wire cnt64;
    wire cnt32;
    wire cnt16;
    wire cnt8;
    wire cnt4;
    wire cnt2;
    wire cnt1;
    
    wire ZERO ;
    wire is32;
    assign is32 = (mem_width == 3'b011);
    assign ZERO = (is32&&cnt32||cnt64);
    
    
    assign	cnt64 = (& L64) ? 1'b1 : 1'b0;
    
    assign	L64 = (mem_width == 3'b100) ? in : 64'b0;
    assign	cnt32 =is32 ? ((& in[31:0]) ? 1'b1 : 1'b0) : (cnt64 ? 1'b0 : (LT_mode ? (&L64[31:0]):(&L64[63:32])));
    assign	L32 = is32 ? in[31:0] : ((LT_mode^cnt32) ? L64[31:0] : L64[63:32]);
    assign	cnt16 =ZERO ? 1'b0 : (LT_mode ? (&L32[15:0]):(&L32[31:16]));
    assign	L16 = (LT_mode^cnt16) ? L32[15:0] : L32[31:16];
    assign	cnt8 =ZERO ? 1'b0 : (LT_mode ? (&L16[7:0]):(&L16[15:8]));
    assign	L8 = (LT_mode^cnt8) ? L16[7:0] : L16[15:8];
    assign	cnt4 =ZERO ? 1'b0 : (LT_mode ? (&L8[3:0]):(&L8[7:4]));
    assign	L4 = (LT_mode^cnt4) ? L8[3:0] : L8[7:4];
    assign	cnt2 =ZERO ? 1'b0 : (LT_mode ? (&L4[1:0]):(&L4[3:2]));
    assign	L2 = (LT_mode^cnt2) ? L4[1:0] : L4[3:2];
    assign	cnt1 =ZERO ? 1'b0 : (LT_mode ? (&L2[0]):(&L2[1]));
    
    assign cnt = {57'b0,cnt64,cnt32,cnt16,cnt8,cnt4,cnt2,cnt1};
    
endmodule
