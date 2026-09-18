`timescale 1ns / 1ps


module D_cache(
    
    input CLK,
	input [63:0] PC,
	//input we,//写使能
    input re, //读使能----暂时没用
    input [35:0] TLB_ppn,
    
    //写入cache-未命中返回
    input [511:0] write_data ,//返回未命中的数据
    input missback,
    // 最高位有效位由取指单元产生,[95:32为pc] 
    output reg [96:0] insn_final [7:0] ,//指令执行顺序先后为0到7，先执行0
    output reg hit//是否命中
    //output reg fifo_we//当未命中时置0暂停写fifo处理缺失
    );
    wire [1:0] which_bank = TLB_ppn[1:0];//根据ppn最低2位选择bank
    wire [5:0] offset_hi = PC[11:6];
    wire [5:0] offset_lo = PC[5:0];
    //ram访问地址，暂时不完善，写数据时将hi和lo更新为写地址-----此功能仅在d_cache写入时有用
    wire [5:0] address_hi = offset_hi;//
    wire [5:0] address_lo = offset_lo;//cacheline内偏移
    
    //cache写入
    reg [40:0] write_tag [7:0];
    reg [3:0] we_bank;//标准写使能信号对哪个bank有效,bank和tag 0，1，2，3写有效，bank0和tag0对应最低位
    														//bank3和tag3对应最高位
    reg [2:0] fuck_choose_cacheline;//根据lru选择一个cacheline
    //实例化8个cachelineip核以构成8路组相联cache
    genvar i;
    //创建零时变量接受cacheline读出的文件
    wire [511:0] bank0 [7:0];
    wire [511:0] bank1 [7:0];
    wire [511:0] bank2 [7:0];
    wire [511:0] bank3 [7:0];
    //实例化4个bank结构以处理同义问题
    //用address_hi选择一个cacheline
    /*
    
    根据ppn低2位选择一个bank，由于cacheline寻址地址位数大于页大小会产生同义问题，所以扩展cache大小通过ppn来增加bank，让同一个物理地址只能映射到一个虚拟地址																
    address_hi2^6(64)选择一个cacheset，读出这个cacheset的所有cacheline（8行）
    将8行cacheline的tag位进行比较判断是否命中
    最后根据address——lo选择cacheline内的偏移
    */
    generate 
    	for(i=0;i<8;i=i+1)begin : I_Cache0
CacheLine U0_CacheLine (
  .clka(CLK),    // input wire clka
  .wea(~hit&&missback&&we_bank[0]&&(fuck_choose_cacheline==i)),      // input wire [0 : 0] wea
  .addra(address_hi),  // input wire [5 : 0] addra
  .dina(write_data),    // input wire [511 : 0] dina
  .douta(bank0[i])  // output wire [511 : 0] douta
);			
    	end
    endgenerate 
        generate 
    	for(i=0;i<8;i=i+1)begin : I_Cache1
CacheLine U1_CacheLine (
  .clka(CLK),    // input wire clka
  .wea(~hit&&missback&&we_bank[1]&&(fuck_choose_cacheline==i)),      // input wire [0 : 0] wea
  .addra(address_hi),  // input wire [5 : 0] addra
  .dina(write_data),    // input wire [511 : 0] dina
  .douta(bank1[i])  // output wire [511 : 0] douta
);			
    	end
    endgenerate 
        generate 
    	for(i=0;i<8;i=i+1)begin : I_Cache2
CacheLine U2_CacheLine (
  .clka(CLK),    // input wire clka
  .wea(~hit&&missback&&we_bank[2]&&(fuck_choose_cacheline==i)),      // input wire [0 : 0] wea
  .addra(address_hi),  // input wire [5 : 0] addra
  .dina(write_data),    // input wire [511 : 0] dina
  .douta(bank2[i])  // output wire [511 : 0] douta
);			
    	end
    endgenerate 
        generate 
    	for(i=0;i<8;i=i+1)begin : I_Cache3
CacheLine U3_CacheLine (
  .clka(CLK),    // input wire clka
  .wea(~hit&&missback&&we_bank[3]&&(fuck_choose_cacheline==i)),      // input wire [0 : 0] wea
  .addra(address_hi),  // input wire [5 : 0] addra
  .dina(write_data),    // input wire [511 : 0] dina
  .douta(bank3[i])  // output wire [511 : 0] douta
);			
    	end
    endgenerate 
    //-----------------------------------------------------------
        //创建零时变量接受cacheline读出的文件
        //tag结构
        //ppn/脏位/有效位/lru
        //36/1/1/3
    wire [40:0] tag0 [7:0];
    wire [40:0] tag1 [7:0];
    wire [40:0] tag2 [7:0];
    wire [40:0] tag3 [7:0];
  //实例化8个组相联cache的tag位
  genvar j;
  generate
	for(j=0;j<8;j=j+1)begin : CacheTag0
CacheTag U0_CacheTag (
  .clka(CLK),    // input wire clka
  .wea((hit||missback)&&we_bank[0]),      // input wire [0 : 0] wea
  .addra(address_hi),  // input wire [5 : 0] addra
  .dina(write_tag[j]),    // input wire [40 : 0] dina
  .douta(tag0[j])  // output wire [40 : 0] douta
);
	end
  endgenerate
    generate
	for(j=0;j<8;j=j+1)begin : CacheTag1
CacheTag U1_CacheTag (
  .clka(CLK),    // input wire clka
  .wea((hit||missback)&&we_bank[1]),      // input wire [0 : 0] wea
  .addra(address_hi),  // input wire [5 : 0] addra
  .dina(write_tag[j]),    // input wire [40 : 0] dina
  .douta(tag1[j])  // output wire [40 : 0] douta
);
	end
  endgenerate
    generate
	for(j=0;j<8;j=j+1)begin : CacheTag2
CacheTag U2_CacheTag (
  .clka(CLK),    // input wire clka
  .wea((hit||missback)&&we_bank[2]),      // input wire [0 : 0] wea
  .addra(address_hi),  // input wire [5 : 0] addra
  .dina(write_tag[j]),    // input wire [40 : 0] dina
  .douta(tag2[j])  // output wire [40 : 0] douta
);
	end
  endgenerate
    generate
	for(j=0;j<8;j=j+1)begin : CacheTag3
CacheTag U3_CacheTag (
  .clka(CLK),    // input wire clka
  .wea((hit||missback)&&we_bank[3]),      // input wire [0 : 0] wea
  .addra(address_hi),  // input wire [5 : 0] addra
  .dina(write_tag[j]),    // input wire [40 : 0] dina
  .douta(tag3[j])  // output wire [40 : 0] douta
);
	end
  endgenerate
  //cache命中逻辑
  //创建零时变量按ppn后2位存储对应的bank值以解决同义问题
  reg [511:0] temp_bank [7:0];
  reg [40:0] temp_tag [7:0];
  //insn临时接收命中的指令
  reg [31:0] insn [15:0];
  //指令有效位
  reg vaild;
  //命中哪一路
  reg [2:0] hit_way;
  always@(*)begin
  	hit = 1'b0;
  	//根据which_bank选择对应的bank
  	case(which_bank)
  		2'b00:begin  
  				we_bank = 4'b0001;
  				temp_bank = bank0;
  				temp_tag = tag0; 
  			end
  		2'b01:begin
  				we_bank = 4'b0010;
  		  		temp_bank = bank1;
  				temp_tag = tag1; 
  		end
  		2'b10:begin
  		  		we_bank = 4'b0100;
  				temp_bank = bank2;
  				temp_tag = tag2; 
  			end
  		2'b11:begin
  				we_bank = 4'b1000;
  		  		temp_bank = bank3;
  				temp_tag = tag3; 
  			end
		default:;
  	endcase
  	//判断是否命中
  	for(int unsigned a=0;a<8;a=a+1)begin//遍历8路组相连并判断命中哪一路
  		if((temp_tag[a][40:5]==TLB_ppn)&&temp_tag[a][3])begin
  			hit_way = 3'(a);
  			//取出8条或更少的指令，当第一或二次取指或者第一或二次分支预测后取值
  			//由于cacheline有16条指令，当首指令不是第1条或者第9条时，
  			//在前半个cacheline第一次能取满8条，第二次无法取满8条，
  			//在后半个cacheline第一次无法取满8条，由于cacheline的16条指令是8的倍数，所以之后都能取满8条指令
  		 	hit = 1'b1;
  		 	//将命中的cacheline提取出来
  		 	for(int unsigned b=0;b<16;b=b+1)begin//提取cacheline中16个指令 b为第n条指令
  		 		//+：左侧为基地址，右侧为宽度，基地址向高位取32bit
  		 		insn[b] = temp_bank[a][(b<<5) +: 32];// b<<5是b*32的优化写法,表示取命中的bank中的第b条指令
  		 	end
  		 	//根据address_lo选择第一条指令并连续读取最多8条
  		 	for(int unsigned c=0;c<8;c=c+1)begin
  		 		//判断寻址指令是否越界，越界就将有效位置0，
  		 		//一共0-15，16条指令，超过15就越界
  		 		if(((address_lo>>2)+6'(c))>15)begin//由于是字节寻址，每个指令4字节，所以将lo右移2位就能直接寻址到具体指令(address_lo>>2)
				//+c是因为连续取8条指令，每取一条偏移+1,括号中表示的是当前取的是第几条指令
  		 			vaild = 1'b0;
  		 			insn_final[c] = {vaild,96'b0};
  		 		end 
  		 		else begin
  		 			vaild = 1'b1;
  		 			insn_final[c] = {vaild,PC+64'(c<<5),insn[(address_lo>>2)+6'(c)]};//c<<5是c*32，每两条指令的pc相差4字节所以pc+(c<<5)
  		 		end             						//insn[(address_lo>>2)+c]为取指令，括号内表征当前取第几条指令
  		 		
  		 	end	
  		 	//当命中时将年龄位更改(以后再做吧)
  		 	break;
  		end
  		
  	end
  end 
  
  //cacheline缺失后写入逻辑
  //当未命中返回信号就绪时准备写入的数据
  always@(*)begin
  	write_tag = temp_tag;
  	//当命中时将年龄位更改
  	  //实现树型lru替换算法
  //用tag的lru最低位当作lru年龄位  
  /*tag/0第一年龄位      0表示way0-way3最近未使用 1表示way4-way7最近未使用
  	第二年龄位{\1        0表示way0-way1最近未使用 1表示way2-way3最近未使用
  		\\2				0表示way4-way5最近未使用 1表示way6-way7最近未使用
  	第3年龄位	\3			0表示way0最近未使用 1表示way1最近未使用
  		\4				0表示way2最近未使用 1表示way3最近未使用
  		\5				0表示way4最近未使用 1表示way5最近未使用
  		\6				0表示way6最近未使用 1表示way7最近未使用
  		\7无意义
  */

  //命中时更新lru年龄
  //在未命中写入新数据时lru不更新,因为未命中返回时还是会读取这个cacheline,此时是命中状态,命中之后 会刷新lru
	if(hit==1'b1)begin
		case(hit_way)
  			3'b000:begin write_tag[0][0] = 1;write_tag[1][0] = 1;write_tag[3][0] = 1;end
  			3'b001:begin write_tag[0][0] = 1;write_tag[1][0] = 1;write_tag[3][0] = 0;end
  			3'b010:begin write_tag[0][0] = 1;write_tag[1][0] = 0;write_tag[4][0] = 1;end
  			3'b011:begin write_tag[0][0] = 1;write_tag[1][0] = 0;write_tag[4][0] = 0;end
  			3'b100:begin write_tag[0][0] = 0;write_tag[2][0] = 1;write_tag[5][0] = 1;end
  			3'b101:begin write_tag[0][0] = 0;write_tag[2][0] = 1;write_tag[5][0] = 0;end
  			3'b110:begin write_tag[0][0] = 0;write_tag[2][0] = 0;write_tag[6][0] = 1;end
  			3'b111:begin write_tag[0][0] = 0;write_tag[2][0] = 0;write_tag[6][0] = 0;end
			default:;
  		endcase
	end
	//未命中写入
  	//根据lru选择一个cacheline
  	case(temp_tag[0][0])
  		1'b0:begin
  			case(temp_tag[1][0])
  				1'b0:begin
  					case(temp_tag[3][0])
  						1'b0:fuck_choose_cacheline = 3'd0;
  						1'b1:fuck_choose_cacheline = 3'd1;
						default:;
  					endcase
  				end
  				1'b1:begin
  					case(temp_tag[4][0])
  						1'b0:fuck_choose_cacheline = 3'd2;
  						1'b1:fuck_choose_cacheline = 3'd3;
						default:;
  					endcase
  				end
				default:;
  			endcase
  		end
  		1'b1:begin
  			case(temp_tag[2][0])
  				1'b0:begin
  					case(temp_tag[5][0])
  						1'b0:fuck_choose_cacheline = 3'd4;
  						1'b1:fuck_choose_cacheline = 3'd5;
						default:;
  					endcase
  				end
  				1'b1:begin
  					case(temp_tag[6][0])
  						1'b0:fuck_choose_cacheline = 3'd6;
  						1'b1:fuck_choose_cacheline = 3'd7;
						default:;
  					endcase
  				end
				default:;
  			endcase
  		end
		default:;
  	endcase
  	        //ppn/脏位/有效位/lru
        //36/1/1/3
        
  	write_tag[fuck_choose_cacheline][40:5] = TLB_ppn;
  	write_tag[fuck_choose_cacheline][3] = 1'b1;//写入tag有效位置1
	write_tag[fuck_choose_cacheline][4] = 1'b0;//写入时将脏位复位
  	
  end  

endmodule
