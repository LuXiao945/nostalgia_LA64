`timescale 1ns / 1ps


module tb_CLO(

    );
    reg [63:0] cnt;
    reg [63:0] in;
    reg [2:0] mem;
    reg LT;
    CLO U_CLO(
    .in(in),
	.mem_width(mem),
	.LT_mode(LT),//0为计算前导，1为计算尾随
	.cnt(cnt)//输出连续1的数量
    );
    reg clk;
    
    initial begin
     clk = 1'b0;
     in = 64'hffffff1fffffffff;
     mem = 3'b100;
     LT = 1'b1;
    end
    always #1 clk = ~clk;
    always@(posedge clk)begin
    	if(in == 64'hffffffffffffffff)begin
    		if(mem == 3'b100)begin
    			in = 64'd0;
    			mem = 3'b011;
    		end else begin
    			$stop;
    		end
    	end else begin
    		in = in+1'b1;
    	end
    	
    end
endmodule
