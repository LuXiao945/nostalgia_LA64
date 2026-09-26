`timescale 1ns / 1ps
//该模块为半成品，没写写入逻辑和读出逻辑，只判断了是否命中，时序可能还有问题
//2026/7/2该模块没写写入逻辑，未仿真
//16行8路组相联stlb+8路全相联mtlb
//2026/9/17将8路mtlb扩展成32路
//判断是否命中时只判断了存在位，没有判断有效位(一时半会不打算修,想看看会发生什么问题)
//指令端不允许写
module TLB(

    input CLK,
	input RST,//用来复位伪LRU和mtlb写指针
    //指令端口-----------------------------------------------------
    input en_i,//使能信号
    input rw_i, //读写控制信号0=r 1=w
	input [63:0] vaddr_i,//pc
	input [9:0] asid_i,
	output reg hit_i,
	output reg [47:0] ppn_i,//pa
	output reg [5:0] ps_i,//页大小
	output reg [1:0] plv_i,// 特权等级（PLV），2比特。该页表项对应的特权等级。当RPLV=0时，该页表项可以被任何特权
	output reg [1:0] mat_i,//存储访问类型
	output reg d_i,//脏位
	output reg v_i,//有效位
	output reg nx_i,//不可执行位
	output reg nr_i,//不可读位
	output reg rplv_i,//受限特权等级使能（RPLV），1比特。页表项是否仅被对应特权等级的程序访问的控制位。请参
	//数据读端口--------------------------------------------------------
	input logic [7:0] TLBWR_index,//TLBWR指令输入的索引，此指令从d端访问
	input logic address_mode,//寻址模式 0为vaddr寻址 1为tlb索引寻址
	input logic we_d,//当写有效时当前节拍读结果不输出
	input [63:0] vaddr_d,
	input [9:0] asid_d,
	output reg hit_d,
	output reg [5:0] ps_d,
	
	output reg [47:0] ppn_d0,
	output reg [1:0] plv_d0,
	output reg [1:0] mat_d0,
	output reg d_d0,
	output reg v_d0,
	output reg nx_d0,
	output reg nr_d0,
	output reg rplv_d0,

	output reg [47:0] ppn_d1,
	output reg [1:0] plv_d1,
	output reg [1:0] mat_d1,
	output reg d_d1,
	output reg v_d1,
	output reg nx_d1,
	output reg nr_d1,
	output reg rplv_d1,
	
	output logic odd_even_sel_d,//tlb奇偶页选择，1为奇数页 0为偶数页
	output logic [7:0] TLB_index,//TLBSRCH指令输出的索引，此指令从d端访问
	//数据写端口
	input logic [5:0] csr_ps,// 将CSR.TLBIDX.PS填入

	input logic [47:0] csr_ppn_d0,
	input logic [1:0] csr_plv_d0,
	input logic [1:0] csr_mat_d0,
	input logic csr_d_d0,
	input logic csr_v_d0,
	input logic csr_nx_d0,
	input logic csr_nr_d0,
	input logic csr_rplv_d0,

	input logic [47:0] csr_ppn_d1,
	input logic [1:0] csr_plv_d1,
	input logic [1:0] csr_mat_d1,
	input logic csr_d_d1,
	input logic csr_v_d1,
	input logic csr_nx_d1,
	input logic csr_nr_d1,
	input logic csr_rplv_d1,
	//写tlb控制信号
	/*
	若此时CSR.TLBRERA.IsTLBR=1，
	即处于TLB重填例外处理过程中，那么TLB中总是填入一个有效项（即TLB项的E位为1）。否则的话，
	就需要看CSR.TLBIDX.NE位的值。此时如果CSR.TLBIDX.NE=1，那么TLB中会被填入一个无效TLB项；
	仅当CSR.TLBIDX.NE=0 时，TLB中才会被填入一个有效TLB项
	*/
	input logic CSR_TLBRERA_IsTLBR,
	input logic CSR_TLBIDX_NE,
	input logic [5:0] CSR_STLBPS,
	/*
	当被填入的页表项的
	页大小与STLB所配置的页大小（CSR.STLBPS）相等时将被填入STLB，否则将被填入MTLB。
	*/
	input logic w_mode,//0为索引写,1为根据lru写

	//0为填0,1为根据CSR.TLBRERA.IsTLBR和CSR.TLBIDX.NE填入有效位
	input logic exists_bit_choose//写数据(不管是写和无效化)时选择填入比较表项中E位的值
    );
	/*
	temp_TLB_index用来存储实际访问tlb表项的索引
	当读取时,此项为tlbwr_index
	当写入时,如果是无效化指令且按索引无效化那么index为tlbwr_index否则需要遍历tlb那么则在提交阶段时将indexcnt清零再递增，直到达到最大索引
	*/
	logic [7:0] indexcnt;
	logic [7:0] temp_TLB_index;
    
	//读tlb d端的地址
	logic [3:0] dtlb_addr;
	assign dtlb_addr = address_mode ? TLBWR_index[6:3] : vaddr_d[16:13];
	//记录命中的页表项，将页表项的数据输出
    reg [4:0] i_hit_way;
    reg i_hit_op;//0说明在stlb中命中，1说明在mtlb中命中
    reg [4:0] d_hit_way;
    reg d_hit_op;//0说明在stlb中命中，1说明在mtlb中命中
    
    //32路全相联mtlb处理大页
    //mtlb比较部分
    reg [52:0] mtlb_c [31:0];
    reg [44:0] mtlb_d0 [31:0];
    reg [44:0] mtlb_d1 [31:0];
    reg [35:0] address_mask;
	//mtlb_LRU
	logic [30:0] LRU_M;
    //stlb比较部分---------------------------------------------------------------------------------
    //实例化8个sram存储stlb比较部分
    //a为指令tlb端口    b为数据tlb端口
    wire [46:0] stlb_c_i [7:0];//接收指令端每个stlb比较部分的数据
    wire [46:0] stlb_c_d [7:0];//接收数据端每个stlb比较部分的数据
	//stlb的lru算法
	logic [6:0] LRU_S [15:0];
    genvar i;
    generate 
		for(i=0;i<8;i=i+1)begin : STLB_C
			STLB_comparison U_STLB_C(
  				.clka(CLK),    // input wire clka
  				.wea(1'b0),// input wire [0 : 0] wea
  				.addra(vaddr_i[16:13]),//用输入地址的低位寻址cache组
  				.dina(53'b0),    // input wire [52 : 0] dina
  				.douta(stlb_c_i[i]),  // output wire [52 : 0] douta
  				.clkb(CLK),    // input wire clkb
  				.web(),      // input wire [0 : 0] web
  				.addrb(dtlb_addr),  // input wire [3 : 0] addrb
  				.dinb(),    // input wire [52 : 0] dinb
  				.doutb(stlb_c_d[i])  // output wire [52 : 0] doutb
				);	
		end
	endgenerate
	
	//-------------------------------------------------------------------------------------------------
	//分别实例化2次[手册92页奇偶相邻页表]8个sram用来存储stlb中的数据部分
	wire [44:0] stlb_d0_i [7:0];//接收指令端每个stlb数据0部分的数据
    wire [44:0] stlb_d0_d [7:0];//接收数据端每个stlb数据0部分的数据
	genvar j;
    generate 
		for(j=0;j<8;j=j+1)begin : STLB_D0
			STLB_DATA U_STLB_D0 (
  			.clka(CLK),    // input wire clka
  			.wea(1'b0),      // input wire [0 : 0] wea
  			.addra(vaddr_i[16:13]),  // input wire [3 : 0] addra
  			.dina(45'b0),    // input wire [44 : 0] dina
 			 .douta(stlb_d0_i[j]),  // output wire [44 : 0] douta
  			.clkb(CLK),    // input wire clkb
  			.web(),      // input wire [0 : 0] web
  			.addrb(dtlb_addr),  // input wire [3 : 0] addrb
  			.dinb(),    // input wire [44 : 0] dinb
  			.doutb(stlb_d0_d[j])  // output wire [44 : 0] doutb
			);
		end
	endgenerate
	//
	wire [44:0] stlb_d1_i [7:0];//接收指令端每个stlb数据1部分的数据
    wire [44:0] stlb_d1_d [7:0];//接收数据端每个stlb数据1部分的数据
	genvar k;
    generate 
		for(k=0;k<8;k=k+1)begin : STLB_D1
			STLB_DATA U_STLB_D1 (
  			.clka(CLK),    // input wire clka
  			.wea(1'b0),      // input wire [0 : 0] wea
  			.addra(vaddr_i[16:13]),  // input wire [3 : 0] addra
  			.dina(45'b0),    // input wire [44 : 0] dina
 			 .douta(stlb_d1_i[k]),  // output wire [44 : 0] douta
  			.clkb(CLK),    // input wire clkb
  			.web(),      // input wire [0 : 0] web
  			.addrb(dtlb_addr),  // input wire [3 : 0] addrb
  			.dinb(),    // input wire [44 : 0] dinb
  			.doutb(stlb_d1_d[k])  // output wire [44 : 0] doutb
			);
		end
	endgenerate
	
	//判断TLB是否命中-------------------------------------------------------------
	reg odd_even_sel_i;//tlb奇偶页选择，1为奇数页 0为偶数页 
    //reg odd_even_sel_d;定义在输出端口
    reg [47:0] temp_ppn_i;//临时储存ppn
    logic [47:0] temp_ppn_d0;
	logic [47:0] temp_ppn_d1;
    reg [5:0] temp_ps_i;//零时存储ps
    reg [5:0] temp_ps_d;
	//判断i端
	integer e;//用于遍历mtlb，判断mtlb是否命中
	//integer a;
	integer b;
	always@(*)begin
		//初始化参数
		hit_i = 1'b0;
		i_hit_way = 5'b0;
    	i_hit_op = 1'b0;
    	//判断stlb i端是否命中
		for(int unsigned a=0;a<8;a=a+1)begin
			if((vaddr_i[47:17]==stlb_c_i[a][46:16])//判断va的tage位与tlb中保存的是否相等
			&&stlb_c_i[a][0]//tlb中0位是有效位
			&&((asid_i==stlb_c_i[a][9:1])//判断asid和tlb中是否相等
			||stlb_c_i[a][11]))//asid相等或者全局标志位tlb[11]其中任意一个为1时tlb命中
			begin
				hit_i = 1'b1;
				i_hit_way = 5'(a);
    			i_hit_op = 1'b0;
    			
    			odd_even_sel_i = vaddr_i[12];
    			break;
			end
			
		end
		//初始化参数
		hit_d = 1'b0;
		d_hit_way = 5'b0;
    	d_hit_op = 1'b0;
    	//判断stlb d端是否命中
		if (address_mode) begin//寻址模式 0为vaddr寻址 1为tlb索引寻址
			//索引寻址

			if (TLBWR_index[7]) begin//TLBWR_index[7]为1表示在mtlb中,0表示在stlb中
				hit_d = stlb_c_d[TLBWR_index[2:0]][0];//TLBWR_index[2:0]指向每路中的way
				d_hit_op = 1'b0;
				d_hit_way = TLBWR_index[4:0];
			end else begin
				hit_d = mtlb_c[TLBWR_index[4:0]][0];
				d_hit_op = 1'b1;//0说明在stlb中命中，1说明在mtlb中命中
				d_hit_way = {2'b0,TLBWR_index[2:0]};
			end
			

		end else begin
			for(b=0;b<8;b=b+1)begin
				if((vaddr_d[47:17]==stlb_c_d[b][46:16])//判断va的tage位与tlb中保存的是否相等
				&&stlb_c_d[b][0]//tlb中0位是有效位
				&&((asid_d==stlb_c_d[b][9:1])//判断asid和tlb中是否相等
				||stlb_c_d[b][11]))//asid相等或者全局标志位tlb[11]其中任意一个为1时tlb命中
				begin
					hit_d = 1'b1;
					d_hit_way = b;
    				d_hit_op = 1'b0;
	
    				odd_even_sel_d = vaddr_d[12];
    				break;
				end
			end
		end
		//判断mtlb是否命中
		for(e=0;e<32;e=e+1)begin
    		//由于mtlb的页大小不唯一，获取ps[17:12]数据，用来生成掩码
    		case(mtlb_c[e][17:12])
    			6'd12:address_mask = 36'b111111111111111111111111111111111111;
    			6'd13:address_mask = 36'b111111111111111111111111111111111110;
    			6'd14:address_mask = 36'b111111111111111111111111111111111100;
    			6'd15:address_mask = 36'b111111111111111111111111111111111000;
    			6'd16:address_mask = 36'b111111111111111111111111111111110000;
    			6'd17:address_mask = 36'b111111111111111111111111111111100000;
    			6'd18:address_mask = 36'b111111111111111111111111111111000000;
    			6'd19:address_mask = 36'b111111111111111111111111111110000000;
    			6'd20:address_mask = 36'b111111111111111111111111111100000000;
    			6'd21:address_mask = 36'b111111111111111111111111111000000000;
    			6'd22:address_mask = 36'b111111111111111111111111110000000000;
    			6'd23:address_mask = 36'b111111111111111111111111100000000000;
    			6'd24:address_mask = 36'b111111111111111111111111000000000000;
    			6'd25:address_mask = 36'b111111111111111111111110000000000000;
    			6'd26:address_mask = 36'b111111111111111111111100000000000000;
    			6'd27:address_mask = 36'b111111111111111111111000000000000000;
    			6'd28:address_mask = 36'b111111111111111111110000000000000000;
    			6'd29:address_mask = 36'b111111111111111111100000000000000000;
    			6'd30:address_mask = 36'b111111111111111111000000000000000000;
    			6'd31:address_mask = 36'b111111111111111110000000000000000000;
    			6'd32:address_mask = 36'b111111111111111100000000000000000000;
    			6'd33:address_mask = 36'b111111111111111000000000000000000000;
    			6'd34:address_mask = 36'b111111111111110000000000000000000000;
    			6'd35:address_mask = 36'b111111111111100000000000000000000000;
    			6'd36:address_mask = 36'b111111111111000000000000000000000000;
    			6'd37:address_mask = 36'b111111111110000000000000000000000000;
    			6'd38:address_mask = 36'b111111111100000000000000000000000000;
    			6'd39:address_mask = 36'b111111111000000000000000000000000000;
    			6'd40:address_mask = 36'b111111110000000000000000000000000000;
    			6'd41:address_mask = 36'b111111100000000000000000000000000000;
    			6'd42:address_mask = 36'b111111000000000000000000000000000000;
    			6'd43:address_mask = 36'b111110000000000000000000000000000000;
    			6'd44:address_mask = 36'b111100000000000000000000000000000000;
    			6'd45:address_mask = 36'b111000000000000000000000000000000000;
    			6'd46:address_mask = 36'b110000000000000000000000000000000000;		
    		endcase
    		//判断mtlb表项的存在位判断是否存在
    		if(mtlb_c[e][0])begin
    			//判断i端
    			if(mtlb_c[e][52:18]==vaddr_i[47:13])begin
    				//判断asid和全局位是否有一个有效
    				if((asid_i==mtlb_c[e][9:1])||(mtlb_c[e][11]))begin
    					hit_i = 1'b1;
						i_hit_way = e;
    					i_hit_op = 1'b1;
    					//判断奇偶页表
    					odd_even_sel_i = vaddr_i[mtlb_c[e][17:12]];
    					//计算ppn
    					case(odd_even_sel_i)
    						1'b0:temp_ppn_i = (mtlb_d0[e][44:9]&address_mask)<<12|(~(address_mask<<12)&vaddr_i[47:0]);
    						1'b1:temp_ppn_i = (mtlb_d1[e][44:9]&address_mask)<<12|(~(address_mask<<12)&vaddr_i[47:0]);
    					endcase
    					//储存ps
    					temp_ps_i = mtlb_c[e][17:12];
    				end
    			end
    			//判断d端                              
				//当addr寻址模式时判断是否命中,索引寻址单独判断
    			if((mtlb_c[e][52:18]==vaddr_d[47:13])&&(!address_mode))begin
    				//判断asid和全局位是否有一个有效
    				if((asid_d==mtlb_c[e][9:1])||(mtlb_c[e][11]))begin
    					hit_d = 1'b1;
						d_hit_way = e;
    					d_hit_op = 1'b1;
    					//判断奇偶页表
    					odd_even_sel_d = vaddr_d[mtlb_c[e][17:12]];
    					//计算ppn
    					case(odd_even_sel_d)
    						1'b0:temp_ppn_d0 = (mtlb_d0[e][44:9]&address_mask)<<12|(~(address_mask<<12)&vaddr_d[47:0]);
    						1'b1:temp_ppn_d1 = (mtlb_d1[e][44:9]&address_mask)<<12|(~(address_mask<<12)&vaddr_d[47:0]);
							default:;
    					endcase
    					//储存ps
    					temp_ps_d = mtlb_c[e][17:12];
    				end
    			end
    		end
    		
    	end
		
	end

	    //读写逻辑

//    assign odd_even_sel_i = vaddr_i[12];//虚拟地址设计为48位 第13位为奇偶页表判断位 指令集手册92页
 //   assign odd_even_sel_d = vaddr_d[12];
	
    always@(*)begin
    	//读出
    	//指令
    	if(hit_i&&!rw_i&&en_i)begin
			case(i_hit_op)
				1'b0:begin//0说明在stlb中命中，1说明在mtlb中命中
						case(odd_even_sel_i)
							1'b0:begin
									ppn_i  = {stlb_d0_i[i_hit_way[2:0]][44:9],vaddr_i[11:0]};
									ps_i   = 6'b001100;//stlb中页大小统一为4kb
									plv_i  = stlb_d0_i[i_hit_way[2:0]][7:6];
									mat_i  = stlb_d0_i[i_hit_way[2:0]][5:4];
									d_i    = stlb_d0_i[i_hit_way[2:0]][1];
									v_i    = stlb_d0_i[i_hit_way[2:0]][0];
									nx_i   = stlb_d0_i[i_hit_way[2:0]][3];
									nr_i   = stlb_d0_i[i_hit_way[2:0]][2];
									rplv_i = stlb_d0_i[i_hit_way[2:0]][8];
								end
							1'b1:begin
									ppn_i  = {stlb_d1_i[i_hit_way[2:0]][44:9],vaddr_i[11:0]};
									ps_i   = 6'b001100;//stlb中页大小统一为4kb
									plv_i  = stlb_d1_i[i_hit_way[2:0]][7:6];
									mat_i  = stlb_d1_i[i_hit_way[2:0]][5:4];
									d_i    = stlb_d1_i[i_hit_way[2:0]][1];
									v_i    = stlb_d1_i[i_hit_way[2:0]][0];
									nx_i   = stlb_d1_i[i_hit_way[2:0]][3];
									nr_i   = stlb_d1_i[i_hit_way[2:0]][2];
									rplv_i = stlb_d1_i[i_hit_way[2:0]][8];
								end 
						endcase
					end
				1'b1:begin
						case(odd_even_sel_i)//指令奇偶页选择，1为奇数页 0为偶数页 
							1'b0:begin
									ppn_i  = temp_ppn_i;
									ps_i   = temp_ps_i;
									plv_i  = mtlb_d0[i_hit_way][7:6];
									mat_i  = mtlb_d0[i_hit_way][5:4];
									d_i    = mtlb_d0[i_hit_way][1];
									v_i    = mtlb_d0[i_hit_way][0];
									nx_i   = mtlb_d0[i_hit_way][3];
									nr_i   = mtlb_d0[i_hit_way][2];
									rplv_i = mtlb_d0[i_hit_way][8];
								end          
							1'b1:begin       
									ppn_i  = temp_ppn_i;
									ps_i   = temp_ps_i;
									plv_i  = mtlb_d1[i_hit_way][7:6];
									mat_i  = mtlb_d1[i_hit_way][5:4];
									d_i    = mtlb_d1[i_hit_way][1];
									v_i    = mtlb_d1[i_hit_way][0];
									nx_i   = mtlb_d1[i_hit_way][3];
									nr_i   = mtlb_d1[i_hit_way][2];
									rplv_i = mtlb_d1[i_hit_way][8];
								end 
						endcase
					end 
			endcase	
    	end
    	//数据-读
		/*
		d端为了支持tlb维护指令,一次读取把奇偶双页全部取出
		并且读写data端口复用
		*/
    	if(hit_d&&(!we_d))begin
			case(d_hit_op)
				1'b0:begin//0说明在stlb中命中，1说明在mtlb中命中
						ps_d   = 6'b001100;//stlb中页大小统一为4kb

						ppn_d0  = {stlb_d0_d[d_hit_way[2:0]][44:9],vaddr_d[11:0]};
						plv_d0  = stlb_d0_d[d_hit_way[2:0]][7:6];
						mat_d0  = stlb_d0_d[d_hit_way[2:0]][5:4];
						d_d0    = stlb_d0_d[d_hit_way[2:0]][1];
						v_d0    = stlb_d0_d[d_hit_way[2:0]][0];
						nx_d0   = stlb_d0_d[d_hit_way[2:0]][3];
						nr_d0   = stlb_d0_d[d_hit_way[2:0]][2];
						rplv_d0 = stlb_d0_d[d_hit_way[2:0]][8];
						//--------------------------------------------
						ppn_d1  = {stlb_d1_d[d_hit_way[2:0]][44:9],vaddr_d[11:0]};
						plv_d1  = stlb_d1_d[d_hit_way[2:0]][7:6];
						mat_d1  = stlb_d1_d[d_hit_way[2:0]][5:4];
						d_d1    = stlb_d1_d[d_hit_way[2:0]][1];
						v_d1    = stlb_d1_d[d_hit_way[2:0]][0];
						nx_d1   = stlb_d1_d[d_hit_way[2:0]][3];
						nr_d1   = stlb_d1_d[d_hit_way[2:0]][2];
						rplv_d1 = stlb_d1_d[d_hit_way[2:0]][8];
					
					end
				1'b1:begin
						ps_d   = temp_ps_d;

						ppn_d0  = temp_ppn_d0;
						plv_d0  = mtlb_d0[d_hit_way][7:6];
						mat_d0  = mtlb_d0[d_hit_way][5:4];
						d_d0    = mtlb_d0[d_hit_way][1];
						v_d0    = mtlb_d0[d_hit_way][0];
						nx_d0   = mtlb_d0[d_hit_way][3];
						nr_d0   = mtlb_d0[d_hit_way][2];
						rplv_d0 = mtlb_d0[d_hit_way][8];
						//---------------------------------------------
						ppn_d1  = temp_ppn_d1;
						plv_d1  = mtlb_d1[d_hit_way][7:6];
						mat_d1  = mtlb_d1[d_hit_way][5:4];
						d_d1    = mtlb_d1[d_hit_way][1];
						v_d1    = mtlb_d1[d_hit_way][0];
						nx_d1   = mtlb_d1[d_hit_way][3];
						nr_d1   = mtlb_d1[d_hit_way][2];
						rplv_d1 = mtlb_d1[d_hit_way][8];
						
					end 
				default:;
			endcase	
    	end
    end
    
	//0说明在stlb中命中，1说明在mtlb中命中   索引号先从stlb分配再mtlb,mtlb从stlb(128项8'b01111111)的基础上加
	assign TLB_index = d_hit_op ? (8'b01111111 + 8'(d_hit_way) + 1'b1) : ({1'b0,vaddr_d[16:13],d_hit_way[2:0]});
	//写入逻辑
	logic TLB_ebit;//写入tlb的存在位
	assign TLB_ebit = exists_bit_choose ? (CSR_TLBRERA_IsTLBR||(!CSR_TLBIDX_NE)) : 1'b0 ;

	always_ff@(posedge CLK)begin
		if(RST)begin//复位mtlb写指针和stlb伪LRU
			LRU_M <= 31'b0;
			for (int unsigned a=0;a<16;a++) begin
				LRU_S[a] <= 7'b0; 
			end
		end else begin
			if (w_mode) begin//0为索引写,1为根据lru写
				
			end else begin
				
			end
			//读取时更新LRU
			/*
			i端和d端分别命中stlb和mtlb不会产生冲突
			如果都在mtlb命中那么产生冲突，如果都命中stlb那么如果命中同一组则产生冲突
			(vaddr_i[16:13]==vaddr_d[16:13])&&(hit_i&&hit_d)&&(i_hit_op==d_hit_op)
			*/
			if ((hit_d && hit_i)&&(i_hit_op==d_hit_op)&&((i_hit_op==1'b1)||(vaddr_i[16:13]==dtlb_addr))) begin//i和d都命中并且命中了同一路,此时根据i端来更新
				if (i_hit_op) begin//mtlb  0说明在stlb中命中，1说明在mtlb中命中
					case(i_hit_way)
						5'd0 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b1; LRU_M[3] <=1'b1; LRU_M[7] <=1'b1; LRU_M[15]<=1'b1;end
						5'd1 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b1; LRU_M[3] <=1'b1; LRU_M[7] <=1'b1; LRU_M[15]<=1'b0;end
						5'd2 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b1; LRU_M[3] <=1'b1; LRU_M[7] <=1'b0; LRU_M[16]<=1'b1;end
						5'd3 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b1; LRU_M[3] <=1'b1; LRU_M[7] <=1'b0; LRU_M[16]<=1'b0;end
						5'd4 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b1; LRU_M[3] <=1'b0; LRU_M[8] <=1'b1; LRU_M[17]<=1'b1;end
						5'd5 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b1; LRU_M[3] <=1'b0; LRU_M[8] <=1'b1; LRU_M[17]<=1'b0;end
						5'd6 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b1; LRU_M[3] <=1'b0; LRU_M[8] <=1'b0; LRU_M[18]<=1'b1;end
						5'd7 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b1; LRU_M[3] <=1'b0; LRU_M[8] <=1'b0; LRU_M[18]<=1'b0;end
						5'd8 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b0; LRU_M[4] <=1'b1; LRU_M[9] <=1'b1; LRU_M[19]<=1'b1;end
						5'd9 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b0; LRU_M[4] <=1'b1; LRU_M[9] <=1'b1; LRU_M[19]<=1'b0;end
						5'd10:begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b0; LRU_M[4] <=1'b1; LRU_M[9] <=1'b0; LRU_M[20]<=1'b1;end
						5'd11:begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b0; LRU_M[4] <=1'b1; LRU_M[9] <=1'b0; LRU_M[20]<=1'b0;end
						5'd12:begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b0; LRU_M[4] <=1'b0; LRU_M[10]<=1'b1; LRU_M[21]<=1'b1;end
						5'd13:begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b0; LRU_M[4] <=1'b0; LRU_M[10]<=1'b1; LRU_M[21]<=1'b0;end
						5'd14:begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b0; LRU_M[4] <=1'b0; LRU_M[10]<=1'b0; LRU_M[22]<=1'b1;end
						5'd15:begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b0; LRU_M[4] <=1'b0; LRU_M[10]<=1'b0; LRU_M[22]<=1'b0;end
						5'd16:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b1; LRU_M[5] <=1'b1; LRU_M[11]<=1'b1; LRU_M[23]<=1'b1;end
						5'd17:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b1; LRU_M[5] <=1'b1; LRU_M[11]<=1'b1; LRU_M[23]<=1'b0;end
						5'd18:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b1; LRU_M[5] <=1'b1; LRU_M[11]<=1'b0; LRU_M[24]<=1'b1;end
						5'd19:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b1; LRU_M[5] <=1'b1; LRU_M[11]<=1'b0; LRU_M[24]<=1'b0;end
						5'd20:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b1; LRU_M[5] <=1'b0; LRU_M[12]<=1'b1; LRU_M[25]<=1'b1;end
						5'd21:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b1; LRU_M[5] <=1'b0; LRU_M[12]<=1'b1; LRU_M[25]<=1'b0;end
						5'd22:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b1; LRU_M[5] <=1'b0; LRU_M[12]<=1'b0; LRU_M[26]<=1'b1;end
						5'd23:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b1; LRU_M[5] <=1'b0; LRU_M[12]<=1'b0; LRU_M[26]<=1'b0;end
						5'd24:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b0; LRU_M[6] <=1'b1; LRU_M[13]<=1'b1; LRU_M[27]<=1'b1;end
						5'd25:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b0; LRU_M[6] <=1'b1; LRU_M[13]<=1'b1; LRU_M[27]<=1'b0;end
						5'd26:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b0; LRU_M[6] <=1'b1; LRU_M[13]<=1'b0; LRU_M[28]<=1'b1;end
						5'd27:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b0; LRU_M[6] <=1'b1; LRU_M[13]<=1'b0; LRU_M[28]<=1'b0;end
						5'd28:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b0; LRU_M[6] <=1'b0; LRU_M[14]<=1'b1; LRU_M[29]<=1'b1;end
						5'd29:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b0; LRU_M[6] <=1'b0; LRU_M[14]<=1'b1; LRU_M[29]<=1'b0;end
						5'd30:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b0; LRU_M[6] <=1'b0; LRU_M[14]<=1'b0; LRU_M[30]<=1'b1;end
						5'd31:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b0; LRU_M[6] <=1'b0; LRU_M[14]<=1'b0; LRU_M[30]<=1'b0;end
						default:;
  					endcase
				end else begin//stlb
					case(i_hit_way[2:0])
  						3'b000:begin LRU_S[vaddr_i[16:13]][0] <= 1;LRU_S[vaddr_i[16:13]][1] <= 1;LRU_S[vaddr_i[16:13]][3] <= 1;end
  						3'b001:begin LRU_S[vaddr_i[16:13]][0] <= 1;LRU_S[vaddr_i[16:13]][1] <= 1;LRU_S[vaddr_i[16:13]][3] <= 0;end
  						3'b010:begin LRU_S[vaddr_i[16:13]][0] <= 1;LRU_S[vaddr_i[16:13]][1] <= 0;LRU_S[vaddr_i[16:13]][4] <= 1;end
  						3'b011:begin LRU_S[vaddr_i[16:13]][0] <= 1;LRU_S[vaddr_i[16:13]][1] <= 0;LRU_S[vaddr_i[16:13]][4] <= 0;end
  						3'b100:begin LRU_S[vaddr_i[16:13]][0] <= 0;LRU_S[vaddr_i[16:13]][2] <= 1;LRU_S[vaddr_i[16:13]][5] <= 1;end
  						3'b101:begin LRU_S[vaddr_i[16:13]][0] <= 0;LRU_S[vaddr_i[16:13]][2] <= 1;LRU_S[vaddr_i[16:13]][5] <= 0;end
  						3'b110:begin LRU_S[vaddr_i[16:13]][0] <= 0;LRU_S[vaddr_i[16:13]][2] <= 0;LRU_S[vaddr_i[16:13]][6] <= 1;end
  						3'b111:begin LRU_S[vaddr_i[16:13]][0] <= 0;LRU_S[vaddr_i[16:13]][2] <= 0;LRU_S[vaddr_i[16:13]][6] <= 0;end
						default:;
  					endcase
				end
			end else begin//不冲突时单独更新
				if (hit_i) begin
					case (i_hit_op)
						1'b0:begin
							case(i_hit_way[2:0])
  								3'b000:begin LRU_S[vaddr_i[16:13]][0] <= 1;LRU_S[vaddr_i[16:13]][1] <= 1;LRU_S[vaddr_i[16:13]][3] <= 1;end
  								3'b001:begin LRU_S[vaddr_i[16:13]][0] <= 1;LRU_S[vaddr_i[16:13]][1] <= 1;LRU_S[vaddr_i[16:13]][3] <= 0;end
  								3'b010:begin LRU_S[vaddr_i[16:13]][0] <= 1;LRU_S[vaddr_i[16:13]][1] <= 0;LRU_S[vaddr_i[16:13]][4] <= 1;end
  								3'b011:begin LRU_S[vaddr_i[16:13]][0] <= 1;LRU_S[vaddr_i[16:13]][1] <= 0;LRU_S[vaddr_i[16:13]][4] <= 0;end
  								3'b100:begin LRU_S[vaddr_i[16:13]][0] <= 0;LRU_S[vaddr_i[16:13]][2] <= 1;LRU_S[vaddr_i[16:13]][5] <= 1;end
  								3'b101:begin LRU_S[vaddr_i[16:13]][0] <= 0;LRU_S[vaddr_i[16:13]][2] <= 1;LRU_S[vaddr_i[16:13]][5] <= 0;end
  								3'b110:begin LRU_S[vaddr_i[16:13]][0] <= 0;LRU_S[vaddr_i[16:13]][2] <= 0;LRU_S[vaddr_i[16:13]][6] <= 1;end
  								3'b111:begin LRU_S[vaddr_i[16:13]][0] <= 0;LRU_S[vaddr_i[16:13]][2] <= 0;LRU_S[vaddr_i[16:13]][6] <= 0;end
								default:;
  							endcase
						end
						1'b1:begin
							case(i_hit_way)
								5'd0 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b1; LRU_M[3] <=1'b1; LRU_M[7] <=1'b1; LRU_M[15]<=1'b1;end
								5'd1 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b1; LRU_M[3] <=1'b1; LRU_M[7] <=1'b1; LRU_M[15]<=1'b0;end
								5'd2 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b1; LRU_M[3] <=1'b1; LRU_M[7] <=1'b0; LRU_M[16]<=1'b1;end
								5'd3 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b1; LRU_M[3] <=1'b1; LRU_M[7] <=1'b0; LRU_M[16]<=1'b0;end
								5'd4 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b1; LRU_M[3] <=1'b0; LRU_M[8] <=1'b1; LRU_M[17]<=1'b1;end
								5'd5 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b1; LRU_M[3] <=1'b0; LRU_M[8] <=1'b1; LRU_M[17]<=1'b0;end
								5'd6 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b1; LRU_M[3] <=1'b0; LRU_M[8] <=1'b0; LRU_M[18]<=1'b1;end
								5'd7 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b1; LRU_M[3] <=1'b0; LRU_M[8] <=1'b0; LRU_M[18]<=1'b0;end
								5'd8 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b0; LRU_M[4] <=1'b1; LRU_M[9] <=1'b1; LRU_M[19]<=1'b1;end
								5'd9 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b0; LRU_M[4] <=1'b1; LRU_M[9] <=1'b1; LRU_M[19]<=1'b0;end
								5'd10:begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b0; LRU_M[4] <=1'b1; LRU_M[9] <=1'b0; LRU_M[20]<=1'b1;end
								5'd11:begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b0; LRU_M[4] <=1'b1; LRU_M[9] <=1'b0; LRU_M[20]<=1'b0;end
								5'd12:begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b0; LRU_M[4] <=1'b0; LRU_M[10]<=1'b1; LRU_M[21]<=1'b1;end
								5'd13:begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b0; LRU_M[4] <=1'b0; LRU_M[10]<=1'b1; LRU_M[21]<=1'b0;end
								5'd14:begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b0; LRU_M[4] <=1'b0; LRU_M[10]<=1'b0; LRU_M[22]<=1'b1;end
								5'd15:begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b0; LRU_M[4] <=1'b0; LRU_M[10]<=1'b0; LRU_M[22]<=1'b0;end
								5'd16:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b1; LRU_M[5] <=1'b1; LRU_M[11]<=1'b1; LRU_M[23]<=1'b1;end
								5'd17:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b1; LRU_M[5] <=1'b1; LRU_M[11]<=1'b1; LRU_M[23]<=1'b0;end
								5'd18:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b1; LRU_M[5] <=1'b1; LRU_M[11]<=1'b0; LRU_M[24]<=1'b1;end
								5'd19:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b1; LRU_M[5] <=1'b1; LRU_M[11]<=1'b0; LRU_M[24]<=1'b0;end
								5'd20:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b1; LRU_M[5] <=1'b0; LRU_M[12]<=1'b1; LRU_M[25]<=1'b1;end
								5'd21:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b1; LRU_M[5] <=1'b0; LRU_M[12]<=1'b1; LRU_M[25]<=1'b0;end
								5'd22:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b1; LRU_M[5] <=1'b0; LRU_M[12]<=1'b0; LRU_M[26]<=1'b1;end
								5'd23:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b1; LRU_M[5] <=1'b0; LRU_M[12]<=1'b0; LRU_M[26]<=1'b0;end
								5'd24:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b0; LRU_M[6] <=1'b1; LRU_M[13]<=1'b1; LRU_M[27]<=1'b1;end
								5'd25:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b0; LRU_M[6] <=1'b1; LRU_M[13]<=1'b1; LRU_M[27]<=1'b0;end
								5'd26:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b0; LRU_M[6] <=1'b1; LRU_M[13]<=1'b0; LRU_M[28]<=1'b1;end
								5'd27:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b0; LRU_M[6] <=1'b1; LRU_M[13]<=1'b0; LRU_M[28]<=1'b0;end
								5'd28:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b0; LRU_M[6] <=1'b0; LRU_M[14]<=1'b1; LRU_M[29]<=1'b1;end
								5'd29:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b0; LRU_M[6] <=1'b0; LRU_M[14]<=1'b1; LRU_M[29]<=1'b0;end
								5'd30:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b0; LRU_M[6] <=1'b0; LRU_M[14]<=1'b0; LRU_M[30]<=1'b1;end
								5'd31:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b0; LRU_M[6] <=1'b0; LRU_M[14]<=1'b0; LRU_M[30]<=1'b0;end
								default:;
  							endcase
						end
						default:;
					endcase
				end
				if (hit_d) begin
					case (d_hit_op)
						1'b0:begin
							case(d_hit_way[2:0])
  								3'b000:begin LRU_S[dtlb_addr][0] <= 1;LRU_S[dtlb_addr][1] <= 1;LRU_S[dtlb_addr][3] <= 1;end
  								3'b001:begin LRU_S[dtlb_addr][0] <= 1;LRU_S[dtlb_addr][1] <= 1;LRU_S[dtlb_addr][3] <= 0;end
  								3'b010:begin LRU_S[dtlb_addr][0] <= 1;LRU_S[dtlb_addr][1] <= 0;LRU_S[dtlb_addr][4] <= 1;end
  								3'b011:begin LRU_S[dtlb_addr][0] <= 1;LRU_S[dtlb_addr][1] <= 0;LRU_S[dtlb_addr][4] <= 0;end
  								3'b100:begin LRU_S[dtlb_addr][0] <= 0;LRU_S[dtlb_addr][2] <= 1;LRU_S[dtlb_addr][5] <= 1;end
  								3'b101:begin LRU_S[dtlb_addr][0] <= 0;LRU_S[dtlb_addr][2] <= 1;LRU_S[dtlb_addr][5] <= 0;end
  								3'b110:begin LRU_S[dtlb_addr][0] <= 0;LRU_S[dtlb_addr][2] <= 0;LRU_S[dtlb_addr][6] <= 1;end
  								3'b111:begin LRU_S[dtlb_addr][0] <= 0;LRU_S[dtlb_addr][2] <= 0;LRU_S[dtlb_addr][6] <= 0;end
								default:;
  							endcase
						end
						1'b1:begin
							case(d_hit_way)
								5'd0 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b1; LRU_M[3] <=1'b1; LRU_M[7] <=1'b1; LRU_M[15]<=1'b1;end
								5'd1 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b1; LRU_M[3] <=1'b1; LRU_M[7] <=1'b1; LRU_M[15]<=1'b0;end
								5'd2 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b1; LRU_M[3] <=1'b1; LRU_M[7] <=1'b0; LRU_M[16]<=1'b1;end
								5'd3 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b1; LRU_M[3] <=1'b1; LRU_M[7] <=1'b0; LRU_M[16]<=1'b0;end
								5'd4 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b1; LRU_M[3] <=1'b0; LRU_M[8] <=1'b1; LRU_M[17]<=1'b1;end
								5'd5 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b1; LRU_M[3] <=1'b0; LRU_M[8] <=1'b1; LRU_M[17]<=1'b0;end
								5'd6 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b1; LRU_M[3] <=1'b0; LRU_M[8] <=1'b0; LRU_M[18]<=1'b1;end
								5'd7 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b1; LRU_M[3] <=1'b0; LRU_M[8] <=1'b0; LRU_M[18]<=1'b0;end
								5'd8 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b0; LRU_M[4] <=1'b1; LRU_M[9] <=1'b1; LRU_M[19]<=1'b1;end
								5'd9 :begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b0; LRU_M[4] <=1'b1; LRU_M[9] <=1'b1; LRU_M[19]<=1'b0;end
								5'd10:begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b0; LRU_M[4] <=1'b1; LRU_M[9] <=1'b0; LRU_M[20]<=1'b1;end
								5'd11:begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b0; LRU_M[4] <=1'b1; LRU_M[9] <=1'b0; LRU_M[20]<=1'b0;end
								5'd12:begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b0; LRU_M[4] <=1'b0; LRU_M[10]<=1'b1; LRU_M[21]<=1'b1;end
								5'd13:begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b0; LRU_M[4] <=1'b0; LRU_M[10]<=1'b1; LRU_M[21]<=1'b0;end
								5'd14:begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b0; LRU_M[4] <=1'b0; LRU_M[10]<=1'b0; LRU_M[22]<=1'b1;end
								5'd15:begin LRU_M[0]<=1'b1; LRU_M[1]<=1'b0; LRU_M[4] <=1'b0; LRU_M[10]<=1'b0; LRU_M[22]<=1'b0;end
								5'd16:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b1; LRU_M[5] <=1'b1; LRU_M[11]<=1'b1; LRU_M[23]<=1'b1;end
								5'd17:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b1; LRU_M[5] <=1'b1; LRU_M[11]<=1'b1; LRU_M[23]<=1'b0;end
								5'd18:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b1; LRU_M[5] <=1'b1; LRU_M[11]<=1'b0; LRU_M[24]<=1'b1;end
								5'd19:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b1; LRU_M[5] <=1'b1; LRU_M[11]<=1'b0; LRU_M[24]<=1'b0;end
								5'd20:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b1; LRU_M[5] <=1'b0; LRU_M[12]<=1'b1; LRU_M[25]<=1'b1;end
								5'd21:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b1; LRU_M[5] <=1'b0; LRU_M[12]<=1'b1; LRU_M[25]<=1'b0;end
								5'd22:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b1; LRU_M[5] <=1'b0; LRU_M[12]<=1'b0; LRU_M[26]<=1'b1;end
								5'd23:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b1; LRU_M[5] <=1'b0; LRU_M[12]<=1'b0; LRU_M[26]<=1'b0;end
								5'd24:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b0; LRU_M[6] <=1'b1; LRU_M[13]<=1'b1; LRU_M[27]<=1'b1;end
								5'd25:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b0; LRU_M[6] <=1'b1; LRU_M[13]<=1'b1; LRU_M[27]<=1'b0;end
								5'd26:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b0; LRU_M[6] <=1'b1; LRU_M[13]<=1'b0; LRU_M[28]<=1'b1;end
								5'd27:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b0; LRU_M[6] <=1'b1; LRU_M[13]<=1'b0; LRU_M[28]<=1'b0;end
								5'd28:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b0; LRU_M[6] <=1'b0; LRU_M[14]<=1'b1; LRU_M[29]<=1'b1;end
								5'd29:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b0; LRU_M[6] <=1'b0; LRU_M[14]<=1'b1; LRU_M[29]<=1'b0;end
								5'd30:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b0; LRU_M[6] <=1'b0; LRU_M[14]<=1'b0; LRU_M[30]<=1'b1;end
								5'd31:begin LRU_M[0]<=1'b0; LRU_M[2]<=1'b0; LRU_M[6] <=1'b0; LRU_M[14]<=1'b0; LRU_M[30]<=1'b0;end
								default:;
  							endcase
						end
						default:; 
					endcase
				end
			end
		end
	end
endmodule
