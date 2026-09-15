`timescale 1ns / 1ps
//对立即数符号扩展
module Sign_extension(
	input [11:0] i12,
    input [15:0] i16,
    input [13:0] i14,
    input [19:0] i20,
    input [1:0] imm_type,//因为立即数都用i20存储，所以立即数符号扩展需要标志立即数种类
    //00 12bit==== 01 14bit====== 10 16bit ========== 11 20bit
    input imm_extension_mode,//imm扩展模式    0为0扩展 1为符号扩展
    output reg [63:0] imm64
    );
    always@(*)begin
    	if(imm_extension_mode == 1'b1)begin
    			(* parallel_case *)
    			case(imm_type)
    				2'b00:imm64={{52{i12[11]}},i12};
    				2'b01:imm64={{50{i12[13]}},i14};
    				2'b10:imm64={{48{i12[15]}},i16};
    			    2'b11:imm64={{44{i12[19]}},i20};
				endcase
		end else begin
				(* parallel_case *)
    			case(imm_type)
    				2'b00:imm64={52'd0,i12};
    				2'b01:imm64={50'd0,i14};
    				2'b10:imm64={48'd0,i16};
    			    2'b11:imm64={44'd0,i20};
				endcase
		end
    end
endmodule
