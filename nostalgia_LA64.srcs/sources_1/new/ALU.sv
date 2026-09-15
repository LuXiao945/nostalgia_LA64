`timescale 1ns / 1ps
module ALU(
	
	input CLK,
	input RST,
	//input is_32bit,//1为32 0为64
	input [63:0] PC ,
	input [3:0] src1_sel,//源操作数选择
	input [3:0] src2_sel,//0000保留0001src1 0010src2 0011pc 0100imm 0101src3
						 //1001 src1取反 1010src2取反
	input [63:0] src1,
	input [63:0] src2,
	//input [63:0] src3,//只在浮点指令被使用
	//input [4:0] des,//目的寄存器地址 一般为rd
	input [63:0] imm,//立即数解码时符号扩展后全部使用imm存储
	input [5:0] u_op,//在alu中 000000为加 
	input [2:0] mem_width,//数据类型	000比特（bit，简记b）	001字节（Byte，简记B，长度8b）
							  //010半字（Halfword，简记H，长度16b）	011字（Word，简记W，长度32b）		
							  //100双字（Doubleword，简记D，长度64b）
	input [5:0] shamt, //一般情况把imm放入opnum2并且移位只对opnum2操作
	input ExtensionMode,//扩展模式,0为0扩展,1为符号扩展,默认为1
	input is_unsign,//1表示当前的操作数视为无符号,用于乘除单元和符号扩展单元
	input need_ext,//表示是否需要扩展-----详情见解码单元
	input shift_mode,//最低为表示左右,0左1右,高位表示模式,00逻辑,01算术,10循环64bit,11循环32bit//默认为000
	input shamt_choose,//0为shamt，1为rk中[4:0]数据，默认为0
	input LT_mode,
	input [2:0] sa,
	input [5:0] msb,
	input [5:0] lsb,
	output reg [63:0] ALU_out
    );
    
    //根据src_sel和src2_sel选择操作数，根据shamt完成对操作数的移位
    reg [63:0] opnum1;
    reg [63:0] opnum2;
    reg [63:0] temp_opnum2;//因为opnum2要移位，所以用一个临时变量接收然后送入移位器
    always@(*)begin
    	//如果是32bit(w类型)就对操作数进行位截断
    	if(mem_width==3'b011)begin
    		case(src1_sel)
    			//4'b0000:;
    			4'b0001:opnum1 = {32'd0,src1[31:0]};
    			4'b0010:opnum1 = {32'd0,src2[31:0]};
    			4'b0011:opnum1 = {32'd0,PC[31:0]};
    			4'b0100:opnum1 = {32'd0,imm[31:0]};
    			4'b1001:opnum1 = ~{32'd0,src1[31:0]};
    			4'b1010:opnum1 = ~{32'd0,src2[31:0]};
    			default:;
    		endcase
    		case(src2_sel)
    			//4'b0000:;
    			4'b0001:temp_opnum2 = {32'd0,src1[31:0]};
    			4'b0010:temp_opnum2 = {32'd0,src2[31:0]};
    			4'b0011:temp_opnum2 = {32'd0,PC[31:0]};
    			4'b0100:temp_opnum2 = {32'd0,imm[31:0]};
    			4'b1001:temp_opnum2 = ~{32'd0,src1[31:0]};
    			4'b1010:temp_opnum2 = ~{32'd0,src2[31:0]};
    			default:;
    		endcase
    	end else begin
    		case(src1_sel)
    			//4'b0000:;
    			4'b0001:opnum1 = src1;
    			4'b0010:opnum1 = src2;
    			4'b0011:opnum1 = PC;
    			4'b0100:opnum1 = imm;
    			4'b1001:opnum1 = ~src1;
    			4'b1010:opnum1 = ~src2;
    			default:;
    		endcase
    		case(src2_sel)
    			//4'b0000:;
    			4'b0001:temp_opnum2 = src1;
    			4'b0010:temp_opnum2 = src2;
    			4'b0011:temp_opnum2 = PC;
    			4'b0100:temp_opnum2 = imm;
    			4'b1001:temp_opnum2 = ~src1;
    			4'b1010:temp_opnum2 = ~src2;
    			default:;
    		endcase
    	end
    end
    //当遇到移位指令时充当移位指令的移位器
    //其他时刻辅助操作第二个操作数移位
    reg [5:0] BS_shamt;
    assign BS_shamt = shamt_choose ? {1'b0,opnum1[4:0]} : shamt;
    Barrel_Shifter_64bit U0_Barrel_Shifter_64bit(
    	.in(temp_opnum2),
    	.shamt(BS_shamt),
    	.mode(shift_mode),//以后再填输入,目前工作在逻辑左移模式
    	.out(opnum2)
    	);
    //实例化减法单元
    reg [63:0] diff;//差
    reg ZF;
    reg SF;
    reg OF;
    reg CF;
    SUB_Unit U_SUB_Unit(
    .src1(opnum1),
	.src2(opnum2),
	.out(diff),
	.ZF(ZF),//0标志位
	.SF(SF),//符号标准位
	.OF(OF),//溢出标志位
	.CF(CF)//进位借位标志
    );
    //根据减法单元的输出标志位判断大小
    reg equal;
    reg LT;
    reg RT;
    Compare_Unit U_Compare_Unit(
    .ZF(ZF),//0标志位 
	.SF(SF),//符号标准位
	.OF(OF),//溢出标志位
	.CF(CF),//进位借位标
	.is_unsign(is_unsign),//1为无符号数      
	.equal(equal),//等于
	.LT(LT),//小于
	.RT(RT)//大于
    );
    //用妙妙工具对操作数释放一些妙妙魔法
    reg [63:0] fuck;//用来接受操作数的运算结果
    reg [63:0] SUM;//加法结果的和
    reg [63:0] AAND;
    reg [63:0] OOR;
    //reg [63:0] NNOR;
    reg [63:0] XXOR;
    assign SUM = opnum1 + opnum2;
    assign AAND = opnum1 & opnum2;
    assign OOR = opnum1 | opnum2;
    assign XXOR = opnum1 ^ opnum2;
    //乘除 001011乘法[31:0] 001100乘法[63:32] 001101乘法[63:0] 001110乘法[127:64]
    reg [127:0] product;
    MUL_UNIT U_MUL_UNIT(
    .opnum1(opnum1),
	.opnum2(opnum2),
	.is_unsign(is_unsign),
	.mem_width(mem_width),
	.product(product)
    );
    //位操作-----------------------------------------------------
    wire [63:0] cnt;
    CLO U_CLO(//统计前导或尾随0、1的数量
    .in(opnum1),
	.mem_width(mem_width),
	.LT_mode(LT_mode),//0为计算前导，1为计算尾随
	.cnt(cnt)//输出连续1的数量
    );
    //BYTEPICK---------------
    wire [31:0] bytepick32;
    wire [63:0] bytepick64;
    wire [63:0] concat64;
    wire [127:0] concat128;
    assign concat64 = {opnum2[31:0],opnum1[31:0]};
    assign concat128 = {opnum2,opnum1};
    assign bytepick32 = concat64[(63-(sa<<3))-:32];
    assign bytepick64 = concat128[(127-(sa<<3))-:64];
    //-----------------------------------------------------------
    //计算掩码，将rd寄存器的msbw：lsbw替换成rj寄存器的msbw-lsbw：0
    //其中rj寄存器的值为opnum1，rd寄存器的值为opnum2
    wire [63:0] mask;
    wire [6:0] bstr_width;
    assign bstr_width = msb-lsb+1'b1;
    assign mask = (65'b1<<bstr_width)-1'b1;
    wire [63:0] bstr ; 
    assign bstr= (opnum2 & (~(mask<<lsb)))|((opnum1&mask)<<lsb);
    //提取rj的msb：lsb位
    wire [63:0] mask1;
    wire [6:0] bstr_width1;
    assign bstr_width1 = msb + 1'b1;
    assign mask1 = (65'b1<<bstr_width1)-1'b1;
    wire [63:0] bstrpink ;
    assign bstrpink = (opnum1&mask)>>lsb;
    //-------------------------------------------------------
    //判断rk是否为0
    wire rk_is_zero;//当值为1时rk为0，反之rk不为0
    assign rk_is_zero = ~(|opnum2);
    //-------------------------------------------------------
    always@(*)begin
    	case(u_op)
    		6'b000000:fuck = SUM;//加法
    		6'b000001:fuck = opnum2;
    		6'b000010:fuck = opnum1[31:0] + opnum2;
    		6'b000011:fuck = opnum1[51:0] + opnum2;
    		6'b000100:fuck = diff;
    		6'b000101:fuck = LT ? 64'd1 : 64'd0;
    		6'b000110:fuck = {SUM[63:12],12'b0};
    		6'b000111:fuck = AAND;
    		6'b001000:fuck = OOR;
    		6'b001001:fuck = ~OOR;
    		6'b001010:fuck = XXOR;
    		6'b001011:fuck = {32'd0,product[31:0]};
    		6'b001100:fuck = {32'd0,product[63:32]};
    		6'b001101:fuck = product[63:0];
    		6'b001110:fuck = product[127:64];
    		6'b001111:fuck = opnum1;
    		6'b010000:fuck = cnt;
    		6'b010001:fuck = {32'd0,bytepick32};
    		6'b010010:fuck = bytepick64;
    		6'b010011:fuck = {32'd0,opnum1[23:16],opnum1[31:24],opnum1[7:0],opnum1[15:8]};
    		6'b010100:fuck = {opnum1[55:48],opnum1[63:56],opnum1[39:32],opnum1[47:40],opnum1[23:16],opnum1[31:24],opnum1[7:0],opnum1[15:8]};
    		6'b010101:fuck = {{<<8{opnum1[63:32]}},{<<8{opnum1[31:0]}}};
    		6'b010110:fuck = {{<<8{opnum1}}};
    		6'b010111:fuck = {{<<16{opnum1[63:32]}},{<<16{opnum1[31:0]}}};
    		6'b011000:fuck = {<<16{opnum1}};
    		6'b011001:fuck = {32'b0,{<<{opnum1[31:24]}},{<<{opnum1[23:16]}},{<<{opnum1[15:8]}},{<<{opnum1[7:0]}}};
    		6'b011010:fuck = {{<<{opnum1[63:56]}},{<<{opnum1[55:48]}},{<<{opnum1[47:40]}},{<<{opnum1[39:32]}},{<<{opnum1[31:24]}},{<<{opnum1[23:16]}},{<<{opnum1[15:8]}},{<<{opnum1[7:0]}}};
    		6'b011011:fuck = {32'b0,{<<{opnum1[31:0]}}};
    		6'b011100:fuck = {<<{opnum1}};
    		6'b011101:fuck = bstr;
    		6'b011110:fuck = bstrpink;
    		6'b011111:fuck = rk_is_zero ? 64'b0 : opnum1;
    		6'b100000:fuck = (~rk_is_zero) ? 64'b0 : opnum1;
    		default:;
    	endcase
    end
    //判断是否需要符号扩展后输出
    reg [63:0] Sign_Extension_out;
    General_Sign_Extension U0_General_Sign_Extension(
    .mem_width(mem_width),
    .in(fuck),
    .out(Sign_Extension_out)
    );
    always@(*)begin//根据数据类型选择符号扩展输出还是非符号扩展输出
    	
    	if(need_ext == 1'b1)begin
    		if(mem_width == 3'b100)begin
    			ALU_out = fuck;
    		end else begin//选择扩展输出
    			case(ExtensionMode)
    				1'b0:ALU_out = {32'b0,fuck[31:0]};//零扩展
    				1'b1:ALU_out = Sign_Extension_out;//符号扩展
    			endcase
    		end
    	end else begin
    		ALU_out = fuck;
    	end
    end
endmodule
