`timescale 1ns / 1ps

module tb_RAT();
//

	reg [4:0] src00;
	reg [4:0] src01;
	reg [4:0] des0;
	reg src00_valid;
	reg src01_valid;
	reg des0_valid;
	reg   [6:0] old_des0;
	
	reg [4:0] src10;
	reg [4:0] src11;
	reg [4:0] des1;
	reg src10_valid;
	reg src11_valid;
	reg des1_valid;
	reg   [6:0] psrc10;
	reg   [6:0] psrc11;
	reg   [6:0] pdes1;
	reg   [6:0] old_des1;
	
	reg [4:0] src20;
	reg [4:0] src21;
	reg [4:0] des2;
	reg src20_valid;
	reg src21_valid;
	reg des2_valid;
	reg   [6:0] psrc20;
	reg   [6:0] psrc21;
	reg   [6:0] pdes2;
	reg   [6:0] old_des2;
	
	reg [4:0] src30;
	reg [4:0] src31;
	reg [4:0] des3;
	reg src30_valid;
	reg src31_valid;
	reg des3_valid;
	reg  [6:0] psrc30;
	reg  [6:0] psrc31;
	reg  [6:0] pdes3;
	reg [6:0] old_des3;
	
	reg [4:0] src40;
	reg [4:0] src41;
	reg [4:0] des4;
	reg src40_valid;
	reg src41_valid;
	reg des4_valid;
	reg [6:0] psrc40;
	reg [6:0] psrc41;
	reg [6:0] pdes4;
	reg [6:0] old_des4;
	
	reg [4:0] src50;
	reg [4:0] src51;
	reg [4:0] des5;
	reg src50_valid;
	reg src51_valid;
	reg des5_valid;
	reg   [6:0] psrc50;
	reg   [6:0] psrc51;
	reg   [6:0] pdes5;
	reg   [6:0] old_des5;













//---------------------------------------------------------
reg clk;
reg rst;
reg [6:0] deallocation_reg_id [5:0];
reg [5:0] deallocation ;
wire [2:0] use_num;
wire [6:0] free_reg_id [5:0];//输出的空闲寄存器id
wire [5:0] valid;



initial begin
	






















	clk = 1'b0;
	rst = 1'b1;
	deallocation = 6'b000000;
	#10
	rst = 1'b0;
	
	

	
end 
	always #5 clk = ~clk;
	always #10 begin 
	
	src00_valid = $urandom_range(1, 0);
src01_valid = $urandom_range(1, 0);
des0_valid = $urandom_range(1, 0);
src10_valid = $urandom_range(1, 0); 
src11_valid = $urandom_range(1, 0); 
des1_valid = $urandom_range(1, 0);  
src20_valid = $urandom_range(1, 0);
src21_valid = $urandom_range(1, 0);
des2_valid = $urandom_range(1, 0); 
src30_valid = $urandom_range(1, 0);
src31_valid = $urandom_range(1, 0);
des3_valid = $urandom_range(1, 0); 
src40_valid = $urandom_range(1, 0);
src41_valid = $urandom_range(1, 0);
des4_valid = $urandom_range(1, 0); 
src50_valid = $urandom_range(1, 0);
src51_valid = $urandom_range(1, 0);
des5_valid = $urandom_range(1, 0); 



//------------------------------------------------

src00 = $urandom_range(31, 0);
src01 = $urandom_range(31, 0);
des0  = $urandom_range(31, 0);
src10 = $urandom_range(31, 0);
src11 = $urandom_range(31, 0);
des1  = $urandom_range(31, 0);
src20 = $urandom_range(31, 0);
src21 = $urandom_range(31, 0);
des2  = $urandom_range(31, 0);
src30 = $urandom_range(31, 0);
src31 = $urandom_range(31, 0);
des3  = $urandom_range(31, 0);
src40 = $urandom_range(31, 0);
src41 = $urandom_range(31, 0);
des4  = $urandom_range(31, 0);
src50 = $urandom_range(31, 0);
src51 = $urandom_range(31, 0);
des5  = $urandom_range(31, 0);


	
	
	
	
	
	end
FreeList U_freelist(
	.CLK(clk),
	.RST(rst),
	.deallocation_reg_id(deallocation_reg_id),//释放的寄存器id
	.deallocation_valid(deallocation),//释放的id有效位
	.use_num(use_num),//rat使用的id数量
	.free_reg_id(free_reg_id),//输出的空闲寄存器id
	.valid(valid)//空闲寄存器使能,用来告诉rat输出的哪些id有效
);
//---------------------------------------------------------------------------
// RAT 实例化模板
// 注意：free_reg_id 为非打包数组，需用 {} 或匹配的数组连接
//---------------------------------------------------------------------------
RAT u_RAT (
    // 时钟与复位
    .clk                    (clk                        ),
    .rst                    (rst                        ),

    // ---- 第0组 ----
    .src00                  (src00                      ),
    .src01                  (src01                      ),
    .des0                   (des0                       ),
    .src00_valid            (src00_valid                ),
    .src01_valid            (src01_valid                ),
    .des0_valid             (des0_valid                 ),
    .psrc00                 (psrc00                     ),
    .psrc01                 (psrc01                     ),
    .pdes0                  (pdes0                      ),
    .old_des0               (old_des0                   ),

    // ---- 第1组 ----
    .src10                  (src10                      ),
    .src11                  (src11                      ),
    .des1                   (des1                       ),
    .src10_valid            (src10_valid                ),
    .src11_valid            (src11_valid                ),
    .des1_valid             (des1_valid                 ),
    .psrc10                 (psrc10                     ),
    .psrc11                 (psrc11                     ),
    .pdes1                  (pdes1                      ),
    .old_des1               (old_des1                   ),

    // ---- 第2组 ----
    .src20                  (src20                      ),
    .src21                  (src21                      ),
    .des2                   (des2                       ),
    .src20_valid            (src20_valid                ),
    .src21_valid            (src21_valid                ),
    .des2_valid             (des2_valid                 ),
    .psrc20                 (psrc20                     ),
    .psrc21                 (psrc21                     ),
    .pdes2                  (pdes2                      ),
    .old_des2               (old_des2                   ),

    // ---- 第3组 ----
    .src30                  (src30                      ),
    .src31                  (src31                      ),
    .des3                   (des3                       ),
    .src30_valid            (src30_valid                ),
    .src31_valid            (src31_valid                ),
    .des3_valid             (des3_valid                 ),
    .psrc30                 (psrc30                     ),
    .psrc31                 (psrc31                     ),
    .pdes3                  (pdes3                      ),
    .old_des3               (old_des3                   ),

    // ---- 第4组 ----
    .src40                  (src40                      ),
    .src41                  (src41                      ),
    .des4                   (des4                       ),
    .src40_valid            (src40_valid                ),
    .src41_valid            (src41_valid                ),
    .des4_valid             (des4_valid                 ),
    .psrc40                 (psrc40                     ),
    .psrc41                 (psrc41                     ),
    .pdes4                  (pdes4                      ),
    .old_des4               (old_des4                   ),

    // ---- 第5组 ----
    .src50                  (src50                      ),
    .src51                  (src51                      ),
    .des5                   (des5                       ),
    .src50_valid            (src50_valid                ),
    .src51_valid            (src51_valid                ),
    .des5_valid             (des5_valid                 ),
    .psrc50                 (psrc50                     ),
    .psrc51                 (psrc51                     ),
    .pdes5                  (pdes5                      ),
    .old_des5               (old_des5                   ),

    // ---- 空闲物理寄存器列表（非打包数组） ----
    .free_reg_id            (free_reg_id                ), // 需匹配 [6:0] free_reg_id [5:0]
    .free_reg_valid         (valid       		        ),

    // ---- 状态/控制输出 ----
    .use_num                (use_num                    ),
    .stop_rat               (stop_rat                   )
);







endmodule
