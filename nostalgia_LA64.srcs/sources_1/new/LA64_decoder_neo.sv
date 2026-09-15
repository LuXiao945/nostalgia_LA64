`timescale 1ns / 1ps
//暂时不对浮点指令解码
//nop指令暂时不解码
//div指令暂时不支持
module LA64_decoder_neo(
	input [31:0] i,
	input CLK,
	input RST,
	//output reg is_32bit,//1为32 0为64此项由mem_width代替
	output reg [3:0] src1_sel,//源操作数选择
	output reg [3:0] src2_sel,//0000保留0001src1 0010src2 0011pc 0100imm 0101src3
	output reg [4:0] src1,//一般赋值为rj
	output reg src1_valid,
	output reg [4:0] src2,//一般赋值为rk
	output reg src2_valid,
	output reg [4:0] src3,//只在浮点指令被使用
	output reg src3_valid,
	output reg [4:0] des,//目的寄存器地址 一般为rd
	output reg des_valid,
	output reg undefined,//未定义指令，1为未定义
	output reg [63:0] imm,//立即数解码时符号扩展后全部使用imm存储
	//output reg [2:0] reg_num,//标志这条指令的寄存器数量
	
	//output reg is_imm,//表示含有立即数
	//发射队列根据ex_unit选择合适的执行单元
	output reg [2:0] ex_unit,//执行单元类型000为alu 001为fpu 002为跳转单元，003为访存单元 004为特权指令
	output reg [5:0] u_op,//微操作码,继续细分不同执行单元中的操作
						//在alu中 000000为加 (000001为减)不设置为减法
						//000001将移位后的结果(opnum2)直接输出  000010和000011为加载立即数所需，验证这条指令仅用于加载立即数而不被其他程序混用，可改成000000直接用加法相加
						//000100为减法 000101为小于填充1否则填充0   000110用于PCALAU12I指令，加法器输出低12位抹0
						//000111与 001000或 001001或非 001010异或 001011乘法[31:0] 001100乘法[63:32] 001101乘法[63:0] 001110乘法[127:64]
						//001111 将opnum1直接输出   010000前导及尾随1/0统计 010001 BYTEPICK.W
						//010010BYTEPICK.D   010011REVB.2H 010100REVB.4H  010101REVB.2W  010110REVB.D
						//010111 REVH.2h    011000REVH.D   011001BITREV.4B 011010BITREV.8B   011011BITREV.W    011100BITREV.D
						//011101 BSTR 011110BSTRPINK  011111MASKEQZ 100000MASKNEZ
	//output reg regrename,//寄存器重命名信号，表示当前指令有src或des需要重命名，防止无效操作					
	output reg is_branch,//识别跳转指令,给分支预测单元发送信号					
						
	output reg des_we,//目的寄存器写信号
	
	output reg [2:0] mem_width,//数据类型	000比特（bit，简记b）	001字节（Byte，简记B，长度8b）
							  //010半字（Halfword，简记H，长度16b）	011字（Word，简记W，长度32b）		
							  //100双字（Doubleword，简记D，长度64b）
	output reg [5:0] shamt,//表示移位器的移位位数暂时设为2^6=64 全0不需要移位
	
	output reg ExtensionMode,//扩展模式,0为0扩展,1为符号扩展,默认为1
	output reg is_unsign,//1为无符号数,比较大小时用到,默认为0
	output reg need_ext,//1为由数据类型判断是否需要扩展0为强制不扩展，用来控制alu运算后的结果是否通过扩展单元   默认为1
						//具体实现为100数据类型不需要扩展，其他类型都需要
	output reg [2:0] shift_mode,//最低为表示左右,0左1右,高位表示模式,00逻辑,01算术,10循环64bit,11循环32bit//默认为000
	output reg shamt_choose,//0为shamt，1为rk中[4:0]数据，默认为0
	output reg LT_mode,//0为计算前导，1为计算尾随,默认为0
	output reg [2:0] sa,//用于BYTEPICK.W/d指令,存放sa2或sa3
	//BSTR指令所需,当32位时将msbw和lsbw高位补0后输出，当64位时直接将msbd和lsbd输出
	//默认值为msbd 和lsbd
	output reg [5:0] msb,
	output reg [5:0] lsb
    );
    //定义指令拆分关键词
	wire [19:0] i20;
    wire [4:0] ui5;
    wire [4:0] lsbw;
    wire [11:0] i12;
    wire [15:0] i16;
    wire [13:0] i14;
    wire [13:0] csr;
    wire [7:0] level;
    wire [7:0] seq;
    wire [4:0] fa;
    wire [4:0] cond; 
    wire [4:0] rj;
	wire [4:0] rd;
	wire [4:0] fj;
	wire [4:0] fd;
	wire [4:0] fk;
	wire [4:0] rk;
	wire [4:0] fcsr;//先不做由于该字段在手册156页中位置不定
	wire [1:0] sa2;
	wire [2:0] sa3;
	wire [7:0] offs;
	wire [5:0] ui6;
	wire [4:0] msbw;
	wire [5:0] msbd;
	wire [5:0] lsbd;
	wire [14:0] long_code;
	wire [2:0] cd;
	wire [2:0] cj;
	wire [4:0] code;
	wire [2:0] ca;
	wire [4:0] op;
	wire [15:0]offs1;//[15:0]
	wire [4:0]offs2;//[20:16]
	wire [9:0]offs3;//[25:16]
	wire [14:0] long_level;
	wire [14:0] hint;
    //指令各部分拆分
    assign rd = i[4:0];
    assign rj = i[9:5];
    assign rk = i[14:10];
    assign sa2= i[16:15];
    assign sa3= i[17:15];
    assign long_code = i[14:0];
    assign ui5 = i[14:10];
    assign ui6 = i[15:10];
    assign lsbw = i[14:10];
    assign msbw = i[20:16];
    assign lsbd = i[15:10];
    assign msbd = i[21:16];
    assign fd = i[4:0];
    assign fj = i[9:5];
    assign fk = i[14:10];
    assign cd = i[2:0];
    assign cj = i[7:5];
    assign i12 = i[21:10];
    assign csr = i[23:10];
    assign code = i[4:0];
    assign level = i[17:10];
    assign seq = i[17:10];
    assign long_level = i[14:0];
    assign fa = i[19:15];
    assign op = i[4:0];
    assign cond = i[19:15];
    assign ca = i[17:15];
    assign i16 = i[25:10];
    assign i20 = i[24:5];
    assign i14 = i[23:10];
    assign hint = i[14:0];
    assign offs2 = i[4:0];
    assign offs1 = i[25:10];
    assign offs3 = i[9:0];
    //将指令的操作码拆分，便于译码
    wire [9:0] opcode1 ;//将操作码拆分,便于译码
    wire [6:0] opcode2 ;
    wire [4:0] opcode3 ;
    wire [1:0] branch_op ;//相同opcode有2条指令，根据手册161页，由i[9，8]来对bceqz00，01bcnez做区分
    
    
    assign opcode1 = i[31:22];
    assign opcode2  = i[21:15];
    assign opcode3  = i[14:10];
    assign branch_op = i[9:8];
    
    //实现立即数符号扩展函数
    //一般src2选择imm
    reg [1:0] imm_type;//默认为00  12bit
    reg imm_extension_mode;//imm扩展模式    0为0扩展 1为符号扩展
    Sign_extension U_Sign_extension(
     .i12(i12),
     .i16(i16),
     .i14(i14),
     .i20(i20),
     .imm_type(imm_type),//因为立即数都用i20存储，所以立即数符号扩展需要标志立即数种类
    //00 12bit==== 01 14bit====== 10 16bit ========== 11 20bit
     .imm_extension_mode(imm_extension_mode),//imm扩展模式    0为0扩展 1为符号扩展 默认为1
     .imm64(imm)
    );
    
    //多级case嵌套译码
    always@(*)begin
    	is_branch = 1'b0;//译码时将branch设置为非，遇到跳转指令再设置为1
    	undefined = 1'b0;//指令未定义
    	//regrename = 1'b1;//需要寄存器重命名
    	src1_valid = 1'b0;
    	src2_valid = 1'b0;
    	src3_valid = 1'b0;
    	des_valid = 1'b0;
    	des_we = 1'b1;//目的寄存器写使能
    	shamt = 6'b000000;
    	ExtensionMode = 1'b1;
    	imm_type = 2'b00;
    	is_unsign = 1'b0;
    	imm_extension_mode = 1'b1;//imm扩展模式默认为符号扩展
    	need_ext = 1'b1;
    	shift_mode = 3'b000;
    	shamt_choose = 1'b0;
    	LT_mode = 1'b0;
    	sa = 3'b000;
    	msb = msbd;
    	lsb = lsbd;
    	(* parallel_case *)
    	casez(opcode1)
    		10'b0000000000:begin
    							(* parallel_case *)
    							casez(opcode2)
    							7'b0000000:begin
    											(* parallel_case *)
    											casez(opcode3)
    												5'b00100:begin
    																src1 = rj;
    																src2 = rk;
    																src1_sel = 4'b0001;
    																src2_sel = 4'b0010;
    																des = rd;
    																ex_unit = 3'b000;
    																u_op = 6'b010000;
    																mem_width = 3'b011;
    																LT_mode = 1'b0;
    															end//CLO.W
    												5'b00101:begin
    																src1 = rj;
    																src2 = rk;
    																src1_sel = 4'b1001;//统计前导0等于将输入取反，然后统计前导1的数量
    																src2_sel = 4'b0010;
    																des = rd;
    																ex_unit = 3'b000;
    																u_op = 6'b010000;
    																mem_width = 3'b011;
    																LT_mode = 1'b0;
    															end//CLZ.W
    												5'b00110:begin
    																src1 = rj;
    																src2 = rk;
    																src1_sel = 4'b0001;
    																src2_sel = 4'b0010;
    																des = rd;
    																ex_unit = 3'b000;
    																u_op = 6'b010000;
    																mem_width = 3'b011;
    																LT_mode = 1'b1;
    															end//CTO.W
    												5'b00111:begin
    																src1 = rj;
    																src2 = rk;
    																src1_sel = 4'b1001;//统计尾随0等于将输入取反，然后统计尾随1的数量
    																src2_sel = 4'b0010;
    																des = rd;
    																ex_unit = 3'b000;
    																u_op = 6'b010000;
    																mem_width = 3'b011;
    																LT_mode = 1'b1;
    															end//CTZ.W
    												5'b01000:begin
    																src1 = rj;
    																src2 = rk;
    																src1_sel = 4'b0001;
    																src2_sel = 4'b0010;
    																des = rd;
    																ex_unit = 3'b000;
    																u_op = 6'b010000;
    																mem_width = 3'b100;
    																LT_mode = 1'b0;
    															end//CLO.D
    												5'b01001:begin
    																src1 = rj;
    																src2 = rk;
    																src1_sel = 4'b1001;//统计前导0等于将输入取反，然后统计前导1的数量
    																src2_sel = 4'b0010;
    																des = rd;
    																ex_unit = 3'b000;
    																u_op = 6'b010000;
    																mem_width = 3'b100;
    																LT_mode = 1'b0;
    															end//CLZ.D
    												5'b01010:begin
    																src1 = rj;
    																src2 = rk;
    																src1_sel = 4'b0001;
    																src2_sel = 4'b0010;
    																des = rd;
    																ex_unit = 3'b000;
    																u_op = 6'b010000;
    																mem_width = 3'b100;
    																LT_mode = 1'b1;
    															end//CTO.D
    												5'b01011:begin
    																src1 = rj;
    																src2 = rk;
    																src1_sel = 4'b1001;//统计尾随0等于将输入取反，然后统计尾随1的数量
    																src2_sel = 4'b0010;
    																des = rd;
    																ex_unit = 3'b000;
    																u_op = 6'b010000;
    																mem_width = 3'b100;
    																LT_mode = 1'b1;
    															end//CTZ.D
    												5'b01100:begin
    																src1 = rj;
    																src2 = rk;
    																src1_sel = 4'b0001;
    																src2_sel = 4'b0010;
    																des = rd;
    																ex_unit = 3'b000;
    																u_op = 6'b010011;
    																mem_width = 3'b011;
    															end//REVB.2H
    												5'b01101:begin
    																src1 = rj;
    																src2 = rk;
    																src1_sel = 4'b0001;
    																src2_sel = 4'b0010;
    																des = rd;
    																ex_unit = 3'b000;
    																u_op = 6'b010100;
    																mem_width = 3'b100;
    															end//REVB.4H 
    												5'b01110:begin
    																src1 = rj;
    																src2 = rk;
    																src1_sel = 4'b0001;
    																src2_sel = 4'b0010;
    																des = rd;
    																ex_unit = 3'b000;
    																u_op = 6'b010101;
    																mem_width = 3'b100;
    															end//REVB.2W
    												5'b01111:begin
    																src1 = rj;
    																src2 = rk;
    																src1_sel = 4'b0001;
    																src2_sel = 4'b0010;
    																des = rd;
    																ex_unit = 3'b000;
    																u_op = 6'b010110;
    																mem_width = 3'b100;
    															end//REVB.D
    												5'b10000:begin
    																src1 = rj;
    																src2 = rk;
    																src1_sel = 4'b0001;
    																src2_sel = 4'b0010;
    																des = rd;
    																ex_unit = 3'b000;
    																u_op = 6'b010111;
    																mem_width = 3'b100;
    															end//REVH.2W
    												5'b10001:begin
    																src1 = rj;
    																src2 = rk;
    																src1_sel = 4'b0001;
    																src2_sel = 4'b0010;
    																des = rd;
    																ex_unit = 3'b000;
    																u_op = 6'b011000;
    																mem_width = 3'b100;
    															end//REVH.D	
    												5'b10010:begin
    																src1 = rj;
    																src2 = rk;
    																src1_sel = 4'b0001;
    																src2_sel = 4'b0010;
    																des = rd;
    																ex_unit = 3'b000;
    																u_op = 6'b011001;
    																mem_width = 3'b011;
    															end//BITREV.4B
    												5'b10011:begin
    																src1 = rj;
    																src2 = rk;
    																src1_sel = 4'b0001;
    																src2_sel = 4'b0010;
    																des = rd;
    																ex_unit = 3'b000;
    																u_op = 6'b011010;
    																mem_width = 3'b100;
    															end//BITREV.8B
    												5'b10100:begin
    																src1 = rj;
    																src2 = rk;
    																src1_sel = 4'b0001;
    																src2_sel = 4'b0010;
    																des = rd;
    																ex_unit = 3'b000;
    																u_op = 6'b011011;
    																mem_width = 3'b011;
    															end//BITREV.W
    												5'b10101:begin
    																src1 = rj;
    																src2 = rk;
    																src1_sel = 4'b0001;
    																src2_sel = 4'b0010;
    																des = rd;
    																ex_unit = 3'b000;
    																u_op = 6'b011100;
    																mem_width = 3'b100;
    															end//BITREV.D	
    												5'b10110:begin
    																src1 = rj;
    																src2 = rk;
    																src1_sel = 4'b0001;
    																src2_sel = 4'b0010;
    																des = rd;
    																ex_unit = 3'b000;
    																u_op = 6'b001111;
    																mem_width = 3'b010;
    															end//EXT.W.H
    												5'b10111:begin
    																src1 = rj;
    																src2 = rk;
    																src1_sel = 4'b0001;
    																src2_sel = 4'b0010;
    																des = rd;
    																ex_unit = 3'b000;
    																u_op = 6'b001111;
    																mem_width = 3'b001;
    															end//EXT.W.B
    											endcase
    										end
    							7'b00010??:begin
    											src1 = rj;
    											src2 = rk;
    											src1_sel = 4'b0010;
    											src2_sel = 4'b0001;
    											des = rd;
    											ex_unit = 3'b000;
    											u_op = 6'b000000;
    											mem_width = 3'b011;
    											shamt = sa2 + 1'b1;
    										end//ALSL.W
    							7'b00011??:begin
    											src1 = rj;
    											src2 = rk;
    											src1_sel = 4'b0010;
    											src2_sel = 4'b0001;
    											des = rd;
    											ex_unit = 3'b000;
    											u_op = 6'b000000;
    											mem_width = 3'b011;
    											shamt = sa2 + 1'b1;
    											ExtensionMode = 1'b0;
    										end//ALSL.WU
    							7'b00100??:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0001;
    												src2_sel = 4'b0010;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b010001;
    												mem_width = 3'b011;
    												sa = {1'b0,sa2};
    										end//BYTEPICK.W
    							7'b0011???:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0001;
    												src2_sel = 4'b0010;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b010010;
    												mem_width = 3'b100;
    												sa = sa3;
    										end//BYTEPICK.D
  								7'b0100000:begin 
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0001;
    												src2_sel = 4'b0010;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b000000;
    												mem_width = 3'b011;
    												
    											end//add.w
    							7'b0100001:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0001;
    												src2_sel = 4'b0010;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b000000;
    												mem_width = 3'b100;
    											end//add.d
    							7'b0100010:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0001;
    												src2_sel = 4'b0010;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b000100;
    												mem_width = 3'b011;
    											end//sub.w	
    							7'b0100011:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0001;
    												src2_sel = 4'b0010;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b000100;
    												mem_width = 3'b100;
    											end//sub.d		
    							7'b0100100:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0001;
    												src2_sel = 4'b0010;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b000101;
    												mem_width = 3'b100;
    											end//slt
    							7'b0100101:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0001;
    												src2_sel = 4'b0010;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b000101;
    												mem_width = 3'b100;
    												is_unsign = 1'b1;
    											end//sltu
    							7'b0100110:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0001;
    												src2_sel = 4'b0010;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b011111;
    												mem_width = 3'b100;
    											end//MASKEQZ
    							7'b0100111:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0001;
    												src2_sel = 4'b0010;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b100000;
    												mem_width = 3'b100;
    											end//MASKNEZ
    							7'b0101000:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0001;
    												src2_sel = 4'b0010;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b001001;
    												mem_width = 3'b100;
    											end//NOR
    							7'b0101001:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0001;
    												src2_sel = 4'b0010;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b000111;
    												mem_width = 3'b100;
    											end//AND
    							7'b0101010:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0001;
    												src2_sel = 4'b0010;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b001000;
    												mem_width = 3'b100;
    											end//OR
    							7'b0101011:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0001;
    												src2_sel = 4'b0010;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b001010;
    												mem_width = 3'b100;
    											end//XOR
    							7'b0101100:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0001;
    												src2_sel = 4'b1010;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b001000;
    												mem_width = 3'b100;
    											end//ORN
    							7'b0101101:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0001;
    												src2_sel = 4'b1010;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b000111;
    												mem_width = 3'b100;
    											end//ANDN
    							7'b0101110:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0010;
    												src2_sel = 4'b0001;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b000001;
    												mem_width = 3'b011;
    												shamt_choose = 1'b1;
    												shift_mode = 3'b000;
    											end//SLL.W
    							7'b0101111:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0010;
    												src2_sel = 4'b0001;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b000001;
    												mem_width = 3'b011;
    												shamt_choose = 1'b1;
    												shift_mode = 3'b001;
    											end//SRL.W
    							7'b0110000:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0010;
    												src2_sel = 4'b0001;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b000001;
    												mem_width = 3'b011;
    												shamt_choose = 1'b1;
    												shift_mode = 3'b011;
    											end//SRA.W
    							7'b0110001:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0010;
    												src2_sel = 4'b0001;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b000001;
    												mem_width = 3'b100;
    												shamt_choose = 1'b1;
    												shift_mode = 3'b000;
    											end//SLL.D
    							7'b0110010:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0010;
    												src2_sel = 4'b0001;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b000001;
    												mem_width = 3'b100;
    												shamt_choose = 1'b1;
    												shift_mode = 3'b001;
    											end//SRL.D
    							7'b0110011:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0010;
    												src2_sel = 4'b0001;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b000001;
    												mem_width = 3'b100;
    												shamt_choose = 1'b1;
    												shift_mode = 3'b011;
    											end//SRA.D
    							7'b0110110:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0010;
    												src2_sel = 4'b0001;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b000001;
    												mem_width = 3'b011;
    												shamt_choose = 1'b1;
    												shift_mode = 3'b111;
    											end//ROTR.W
    							7'b0110111:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0010;
    												src2_sel = 4'b0001;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b000001;
    												mem_width = 3'b100;
    												shamt_choose = 1'b1;
    												shift_mode = 3'b101;
    											end//ROTR.D
    							7'b0111000:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0001;
    												src2_sel = 4'b0010;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b001011;
    												mem_width = 3'b011;
    											end//mul.w
    							7'b0111001:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0001;
    												src2_sel = 4'b0010;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b001100;
    												mem_width = 3'b011;
    											end//MULH.W
    							7'b0111010:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0001;
    												src2_sel = 4'b0010;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b001100;
    												mem_width = 3'b011;
    												is_unsign = 1'b1;
    											end//MULH.WU
    							7'b0111011:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0001;
    												src2_sel = 4'b0010;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b001101;
    												mem_width = 3'b100;
    											end//MUL.D
    							7'b0111100:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0001;
    												src2_sel = 4'b0010;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b001110;
    												mem_width = 3'b100;
    											end//MULH.D
    							7'b0111101:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0001;
    												src2_sel = 4'b0010;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b001110;
    												mem_width = 3'b100;
    												is_unsign = 1'b1;
    											end//MULH.DU
    							7'b0111110:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0001;
    												src2_sel = 4'b0010;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b001101;
    												mem_width = 3'b011;
    												need_ext = 1'b0;
    											end//MULW.D.W
    							7'b0111111:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0001;
    												src2_sel = 4'b0010;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b001101;
    												mem_width = 3'b011;
    												is_unsign = 1'b1;
    												need_ext = 1'b0;
    											end//MULW.D.WU
    							7'b10110??:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0010;
    												src2_sel = 4'b0001;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b000000;
    												mem_width = 3'b100;
    												shamt = sa2 + 1'b1;
    											end//ALSL.D
    								
    								
    								
    								
    								
    								
    							endcase
    						end
    		10'b0000000001:begin
    						(* parallel_case *)
    						casez(opcode2)
    							7'b0000001:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0010;
    												src2_sel = 4'b0001;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b000001;
    												mem_width = 3'b011;
    												shamt = {1'b0,ui5};
    												shift_mode = 3'b000;
    											end//SLLI.W
    							7'b000001?:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0010;
    												src2_sel = 4'b0001;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b000001;
    												mem_width = 3'b100;
    												shamt = ui6;
    												shift_mode = 3'b000;
    											end//SLLI.D
    							7'b0001001:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0010;
    												src2_sel = 4'b0001;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b000001;
    												mem_width = 3'b011;
    												shamt = {1'b0,ui5};
    												shift_mode = 3'b001;
    											end//SRLI.W
    							7'b000101?:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0010;
    												src2_sel = 4'b0001;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b000001;
    												mem_width = 3'b100;
    												shamt = ui6;
    												shift_mode = 3'b001;
    											end//SRLI.D
    							7'b0010001:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0010;
    												src2_sel = 4'b0001;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b000001;
    												mem_width = 3'b011;
    												shamt = {1'b0,ui5};
    												shift_mode = 3'b011;
    											end//SRAI.W
    							7'b001001?:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0010;
    												src2_sel = 4'b0001;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b000001;
    												mem_width = 3'b100;
    												shamt = ui6;
    												shift_mode = 3'b011;
    											end//SRAI.D
    							7'b0011001:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0010;
    												src2_sel = 4'b0001;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b000001;
    												mem_width = 3'b011;
    												shamt = {1'b0,ui5};
    												shift_mode = 3'b111;
    											end//ROTRI.W
    							7'b001101?:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0010;
    												src2_sel = 4'b0001;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b000001;
    												mem_width = 3'b100;
    												shamt = ui6;
    												shift_mode = 3'b101;
    											end//ROTRI.D
    							7'b1?????0:begin
    												src1 = rj;
    												src2 = rd;
    												src1_sel = 4'b0001;
    												src2_sel = 4'b0010;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b011101;
    												mem_width = 3'b011;
    												msb = {1'b0,msbw};
    												lsb = {1'b0,lsbw};
    											end//BSTRINS.W
    							7'b1?????1:begin
    												src1 = rj;
    												src2 = rk;
    												src1_sel = 4'b0001;
    												src2_sel = 4'b0010;
    												des = rd;
    												ex_unit = 3'b000;
    												u_op = 6'b011110;
    												mem_width = 3'b011;
    												msb = {1'b0,msbw};
    												lsb = {1'b0,lsbw};
    											end//BSTRPICK.W
    						endcase
    						end
    		10'b0000000010:begin
    							src1 = rj;
    							src2 = rd;
    							src1_sel = 4'b0001;
    							src2_sel = 4'b0010;
    							des = rd;
    							ex_unit = 3'b000;
    							u_op = 6'b011101;
    							mem_width = 3'b100;
    						end//BSTRINS.D
    		10'b0000000011:begin
    							src1 = rj;
    							src2 = rk;
    							src1_sel = 4'b0001;
    							src2_sel = 4'b0010;
    							des = rd;
    							ex_unit = 3'b000;
    							u_op = 6'b011110;
    							mem_width = 3'b100;
    						end//BSTRPICK.D
    		10'b0000000100:;
    		10'b0000001000:begin
    							src1 = rj;
    							src2 = rk;
    							src1_sel = 4'b0001;
    							src2_sel = 4'b0100;
    							des = rd;
    							ex_unit = 3'b000;
    							u_op = 6'b000101;
    							mem_width = 3'b100;
    						end//SLTI
    		10'b0000001001:begin
    							src1 = rj;
    							src2 = rk;
    							src1_sel = 4'b0001;
    							src2_sel = 4'b0100;
    							des = rd;
    							ex_unit = 3'b000;
    							u_op = 6'b000101;
    							mem_width = 3'b100;
    							is_unsign = 1'b1;
    						end//SLTUI
    		10'b0000001010:begin
    							src1 = rj;
    							src2 = rk;
    							src1_sel = 4'b0001;
    							src2_sel = 4'b0100;
    							des = rd;
    							ex_unit = 3'b000;
    							u_op = 6'b000000;
    							mem_width = 3'b011;
    						end//addi.w
    		10'b0000001011:begin
    							src1 = rj;
    							src2 = rk;
    							src1_sel = 4'b0001;
    							src2_sel = 4'b0100;
    							des = rd;
    							ex_unit = 3'b000;
    							u_op = 6'b000000;
    							mem_width = 3'b100;
    						end//addi.d
    		10'b0000001100:begin
    							src1 = rj;
    							src2 = rk;
    							src1_sel = 4'b0001;
    							src2_sel = 4'b0100;
    							des = rd;
    							ex_unit = 3'b000;
    							u_op = 6'b000011;//单独给rd套上掩码，剔除rd中高12位内容
    							//如果后续验证这条指令仅用于加载立即数而不被其他程序混用，可改成000000直接用加法相加
    							mem_width = 3'b100;
    							shamt = 6'd52;
    							//imm_type = 2'b11;
    						end//LU52I.D
    		10'b0000001101:begin
    							src1 = rj;
    							src2 = rk;
    							src1_sel = 4'b0001;
    							src2_sel = 4'b0100;
    							des = rd;
    							ex_unit = 3'b000;
    							u_op = 6'b000111;
    							mem_width = 3'b100;
    							imm_extension_mode = 1'b0;
    						end//ANDI
    		10'b0000001110:begin
    							src1 = rj;
    							src2 = rk;
    							src1_sel = 4'b0001;
    							src2_sel = 4'b0100;
    							des = rd;
    							ex_unit = 3'b000;
    							u_op = 6'b001000;
    							mem_width = 3'b100;
    							imm_extension_mode = 1'b0;
    						end//ORI 
    		10'b0000001111:begin
    							src1 = rj;
    							src2 = rk;
    							src1_sel = 4'b0001;
    							src2_sel = 4'b0100;
    							des = rd;
    							ex_unit = 3'b000;
    							u_op = 6'b001010;
    							mem_width = 3'b100;
    							imm_extension_mode = 1'b0;
    						end//XORI
    		10'b00000100??:;
    		10'b0000011000:;
    		10'b0000011001:;
    		10'b0000100000:;
    		10'b0000100001:;
    		10'b0000100010:;
    		10'b0000100011:;
    		10'b0000110000:;
    		10'b0000110100:;
    		10'b000100????:begin
    							src1 = rj;
    							src2 = rk;
    							src1_sel = 4'b0001;
    							src2_sel = 4'b0100;
    							des = rd;
    							ex_unit = 3'b000;
    							u_op = 6'b000000;
    							mem_width = 3'b100;
    							shamt = 6'd16;
    							imm_type = 2'b10;
    						end//ADDU16I.D
    		10'b0001010???:begin
    							src1 = rj;
    							src2 = rk;
    							src1_sel = 4'b0001;
    							src2_sel = 4'b0100;
    							des = rd;
    							ex_unit = 3'b000;
    							u_op = 6'b000001;
    							mem_width = 3'b011;
    							shamt = 6'd12;
    							imm_type = 2'b11;
    						end//LU12I.W
    		10'b0001011???:begin
    							src1 = rd;
    							src2 = rk;
    							src1_sel = 4'b0001;
    							src2_sel = 4'b0100;
    							des = rd;
    							ex_unit = 3'b000;
    							u_op = 6'b000010;//单独给rd套上掩码，剔除rd中高32位内容
    							//如果后续验证这条指令仅用于加载立即数而不被其他程序混用，可改成000000直接用加法相加
    							mem_width = 3'b100;
    							shamt = 6'd32;
    							imm_type = 2'b11;
    						end//LU32I.D
    		10'b0001100???:begin
    							src1 = rj;
    							src2 = rk;
    							src1_sel = 4'b0011;
    							src2_sel = 4'b0100;
    							des = rd;
    							ex_unit = 3'b000;
    							u_op = 6'b000000;
    							mem_width = 3'b100;
    							shamt = 6'd2;
    							imm_type = 2'b11;
    						end//PCADDI
    		10'b0001101???:begin
    							src1 = rj;
    							src2 = rk;
    							src1_sel = 4'b0011;
    							src2_sel = 4'b0100;
    							des = rd;
    							ex_unit = 3'b000;
    							u_op = 6'b000110;
    							mem_width = 3'b100;
    							shamt = 6'd12;
    							imm_type = 2'b11;
    						end//PCALAU12I 
    		10'b0001110???:begin
    							src1 = rj;
    							src2 = rk;
    							src1_sel = 4'b0011;
    							src2_sel = 4'b0100;
    							des = rd;
    							ex_unit = 3'b000;
    							u_op = 6'b000000;
    							mem_width = 3'b100;
    							shamt = 6'd12;
    							imm_type = 2'b11;
    						end//PCADDU12I
    		10'b0001111???:begin
    							src1 = rj;
    							src2 = rk;
    							src1_sel = 4'b0011;
    							src2_sel = 4'b0100;
    							des = rd;
    							ex_unit = 3'b000;
    							u_op = 6'b000000;
    							mem_width = 3'b100;
    							shamt = 6'd18;
    							imm_type = 2'b11;
    						end//PCADDU18I
    		10'b00100000??:;
    		10'b00100001??:;
    		10'b00100010??:;
    		10'b00100011??:;
    		10'b00100100??:;
    		10'b00100101??:;
    		10'b00100110??:;
    		10'b00100111??:;
    		10'b0010100000:;
    		10'b0010100001:;
    		10'b0010100010:;
    		10'b0010100011:;
    		10'b0010100100:;
    		10'b0010100101:;
    		10'b0010100110:;
    		10'b0010100111:;
    		10'b0010101000:;
    		10'b0010101001:;
    		10'b0010101010:;
    		10'b0010101011:;
    		10'b0010101100:;
    		10'b0010101101:;
    		10'b0010101110:;
    		10'b0010101111:;
    		10'b0011100000:;
    		10'b0011100001:;
    		10'b010000????:is_branch = 1'b1;
    		10'b010001????:is_branch = 1'b1;
    		10'b010010????:begin
    							is_branch = 1'b1;
    							(* parallel_case *)
    							case(branch_op)
    								2'b00:;
    								2'b01:;
    								default:undefined = 1'b1;
    							endcase
    						end//相同opcode有2条指令，根据手册161页，由i[9，8]来对bceqz00，01bcnez做区分
    		10'b010011????:is_branch = 1'b1;
    		10'b010100????:is_branch = 1'b1;
    		10'b010101????:is_branch = 1'b1;
    		10'b010110????:is_branch = 1'b1;
    		10'b010111????:is_branch = 1'b1;
    		10'b011000????:is_branch = 1'b1;
    		10'b011001????:is_branch = 1'b1;
    		10'b011010????:is_branch = 1'b1;
    		10'b011011????:is_branch = 1'b1;
    		
    		default:undefined = 1'b1;//注意要在所有的case语句中添加，防止未定义指令造成异常
    	endcase
    end  
endmodule

