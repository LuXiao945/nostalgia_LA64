`timescale 1ns / 1ps

module Compare_Unit(
	input ZF,//0标志位
	input SF,//符号标准位
	input OF,//溢出标志位
	input CF,//进位借位标志
	input is_unsign,//1为无符号数
	
	output reg equal,//等于
	output reg LT,//小于
	output reg RT//大于
    );
    always@(*)begin
    	equal = 1'b0;
    	LT = 1'b0;
    	//RT = 1'b0;
    	case(ZF)
    		1'b0:begin
    				case(is_unsign)
    					1'b0:begin
    							LT = OF^SF;
    						end
    					1'b1:begin
    							case(CF)
    								1'b0:LT = 1'b0;
    								1'b1:LT = 1'b1;
    							endcase
    						end
    				endcase
    			end
    		1'b1: equal = 1'b1;
    	endcase
    	RT = ~(LT|equal);
    end
endmodule
