`timescale 1ns / 1ps

//程序计数器逻辑实现
module PC(
	input  [63:0] NEXTADDRESS, //下一个取值令地址输入
	output reg [63:0] THISADDRESS,//当前指令地址输出
	input RST ,//复位信号输入
	input CLK  //时钟信号输入
    );
    
    parameter [63:0] LA_CLR_PC = 64'h1c000000 ;//龙芯指令集对pc复位的规定值
    
    always @(posedge CLK)begin
    	if(RST!=1)begin//1为复位 0为不复位
    		THISADDRESS <= NEXTADDRESS;//不复位就把当前的值变成下个pc的值
    	end
    	else begin
			THISADDRESS <= LA_CLR_PC;//复位就将pc值变成指令集规定值
    	end 
    end
    
    
endmodule
