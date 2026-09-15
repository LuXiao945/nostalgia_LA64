`timescale 1ns / 1ps

module Barrel_Shifter_64bit(
	input [63:0] in,
	input [5:0] shamt,
	input [2:0] mode,//最低为表示左右,0左1右,高位表示模式,00逻辑,01算术,10循环64bit,11循环32bit
	output reg [63:0] out
    );
    int unsigned a;//移位64次的循环变量
    always@(*)begin
    	case(mode[2:1])//实现循环移位
    		2'b10:begin
    			case(mode[0])
    				1'b0:begin//左移
    					for(a=0;a<64;a=a+1)begin
    						out[(6'(a)+shamt)&63] = in[a];
    					end
    				end
    				1'b1:begin//右移
    					for(a=0;a<64;a=a+1)begin
    						out[a] = in[(6'(a)+shamt)&63];
    					end
    				end
					default:;
    			endcase
    		end
    		2'b11:begin
    			case(mode[0])
    				1'b0:begin//左移
    					for(a=0;a<32;a=a+1)begin
    						out[(6'(a)+shamt)&31] = in[a];
    					end
    				end
    				1'b1:begin//右移
    					for(a=0;a<32;a=a+1)begin
    						out[a] = in[(6'(a)+shamt)&31];
    					end
    				end
					default:;
    			endcase
    		end
    		
    		default:begin
    			case(mode[0])
    				1'b0:begin //逻辑和算术左移
    					for(a=0;a<64;a=a+1)begin
    						if(a<shamt)begin
    							out[a] = 1'b0;
    						end else begin
    							out[a] = in[6'(a)-shamt];
    						end
    					end
    				end
    				1'b1:begin//右移
    					case(mode[2:1])
    						2'b00:begin//逻辑移位
    							for(a=0;a<64;a=a+1)begin
    								if(6'(a)+shamt < 64)begin
    									out[a] = in[6'(a)+shamt];
    								end else begin
    									out[a] = 1'b0;
    								end
    							end
    						end
    						2'b01:begin//算术移位
    							for(a=0;a<64;a=a+1)begin
    								if(6'(a)+shamt < 64)begin
    									out[a] = in[6'(a)+shamt];
    								end else begin
    									out[a] = in[63];
    								end
    							end
    						end
    					default: out = 64'd0;
    					endcase
    				end
					default:;
    			endcase
    		end
    	endcase
    end
endmodule
