`timescale 1ns / 1ps

module MUL_UNIT(
	input [63:0] opnum1,
	input [63:0] opnum2,
	input is_unsign,
	input [2:0] mem_width,
	output reg [127:0] product
    );
    reg [63:0] opnum1_SEXT;
    reg [63:0] opnum2_SEXT;
    General_Sign_Extension U1_General_Sign_Extension(
    .mem_width(mem_width),
    .in(opnum1),
    .out(opnum1_SEXT)
    );
    General_Sign_Extension U2_General_Sign_Extension(
    .mem_width(mem_width),
    .in(opnum2),
    .out(opnum2_SEXT)
    );
    reg [63:0] a;
    reg [63:0] b;
    //根据数据类型选择操作数
	always@(*)begin
		case(mem_width)
			3'b011:begin  a = is_unsign ? {32'd0,opnum1[31:0]} : opnum1_SEXT;
						  b = is_unsign ? {32'd0,opnum2[31:0]} : opnum2_SEXT;
					end
			3'b100:begin a = opnum1; 
						 b = opnum2;
			 		end
			default:;
		endcase
	end
    //将操作数送入乘法器
    always@(*)begin
    	if(is_unsign == 1'b1)begin
    		product = a * b;
    	end else begin
    		product = $signed(a) * $signed(b);
    	end
    end
    
endmodule
