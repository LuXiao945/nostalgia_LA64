`timescale 1ns / 1ps
//未完成
//^^^^^目前只支持字节扩展,字扩展,和半字扩展,一共3种模式
module General_Sign_Extension(
	input [2:0] mem_width,//数据类型	000比特（bit，简记b）	001字节（Byte，简记B，长度8b）
							  //010半字（Halfword，简记H，长度16b）	011字（Word，简记W，长度32b）		
							  //100双字（Doubleword，简记D，长度64b）
	input [63:0] in,
	output reg [63:0] out
    );
    //循环变量 integer a;
    reg [5:0] width;//符号扩展原始数据宽度,例如：32bit就是32
    reg MSB;//符号位
    always@(*)begin
    	case(mem_width)//提取符号位和数据宽度
    		3'b011:begin MSB = in[31]; width = 6'd32;end
    		3'b001:begin MSB = in[7]; width = 6'd8;end
    		3'b010:begin MSB = in[15]; width = 6'd16;end
    		default:;
    	endcase
    	for(int unsigned a=0;a<64;a=a+1)begin
    		if(a<width)begin
    			out[a] = in[a];
    		end else begin
    			out[a] = MSB;
    		end
    	end
    end
endmodule
