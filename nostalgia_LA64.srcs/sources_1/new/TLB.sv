`timescale 1ns / 1ps
//该模块为半成品，没写写入逻辑和读出逻辑，只判断了是否命中，时序可能还有问题
//2026/7/2该模块没写写入逻辑，未仿真
//16行8路组相联stlb+8路全相联mtlb
//2026/9/17将8路mtlb扩展成32路
module TLB(

    input CLK,
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
	//数据端口--------------------------------------------------------
	input address_mode,//寻址模式 0为vaddr寻址 1为tlb索引寻址
	input en_d,//使能信号
    input rw_d, //读写控制信号0=r 1=w
	input [63:0] vaddr_d,
	input [9:0] asid_d,
	output reg hit_d,
	output reg [47:0] ppn_d,
	output reg [5:0] ps_d,
	output reg [1:0] plv_d,
	output reg [1:0] mat_d,
	output reg d_d,
	output reg v_d,
	output reg nx_d,
	output reg nr_d,
	output reg rplv_d,
	
	output logic [7:0] TLB_index//TLBSRCH指令输出的索引，此指令从d端访问
	
    );

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
    //stlb比较部分---------------------------------------------------------------------------------
    //实例化8个sram存储stlb比较部分
    //a为指令tlb端口    b为数据tlb端口
    wire [46:0] stlb_c_i [7:0];//接收指令端每个stlb比较部分的数据
    wire [46:0] stlb_c_d [7:0];//接收数据端每个stlb比较部分的数据
    genvar i;
    generate 
		for(i=0;i<8;i=i+1)begin : STLB_C
			STLB_comparison U_STLB_C(
  				.clka(CLK),    // input wire clka
  				.wea(),// input wire [0 : 0] wea
  				.addra(vaddr_i[16:13]),//用输入地址的低位寻址cache组
  				.dina(),    // input wire [52 : 0] dina
  				.douta(stlb_c_i[i]),  // output wire [52 : 0] douta
  				.clkb(CLK),    // input wire clkb
  				.web(),      // input wire [0 : 0] web
  				.addrb(vaddr_d[16:13]),  // input wire [3 : 0] addrb
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
  			.wea(),      // input wire [0 : 0] wea
  			.addra(vaddr_i[16:13]),  // input wire [3 : 0] addra
  			.dina(),    // input wire [44 : 0] dina
 			 .douta(stlb_d0_i[j]),  // output wire [44 : 0] douta
  			.clkb(CLK),    // input wire clkb
  			.web(),      // input wire [0 : 0] web
  			.addrb(vaddr_d[16:13]),  // input wire [3 : 0] addrb
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
  			.wea(),      // input wire [0 : 0] wea
  			.addra(vaddr_i[16:13]),  // input wire [3 : 0] addra
  			.dina(),    // input wire [44 : 0] dina
 			 .douta(stlb_d1_i[k]),  // output wire [44 : 0] douta
  			.clkb(CLK),    // input wire clkb
  			.web(),      // input wire [0 : 0] web
  			.addrb(vaddr_d[16:13]),  // input wire [3 : 0] addrb
  			.dinb(),    // input wire [44 : 0] dinb
  			.doutb(stlb_d1_d[k])  // output wire [44 : 0] doutb
			);
		end
	endgenerate
	
	//判断L1 TLB是否命中-------------------------------------------------------------
	reg odd_even_sel_i;//tlb奇偶页选择，1为奇数页 0为偶数页 
    reg odd_even_sel_d;
    reg [47:0] temp_ppn_i;//临时储存ppn
    reg [47:0] temp_ppn_d;
    reg [5:0] temp_ps_i;//零时存储ps
    reg [5:0] temp_ps_d;
	//判断i端
	integer e;//用于遍历mtlb，判断mtlb是否命中
	integer a;
	integer b;
	always@(*)begin
		//初始化参数
		hit_i = 1'b0;
		i_hit_way = 5'b0;
    	i_hit_op = 1'b0;
    	//判断stlb i端是否命中
		for(a=0;a<8;a=a+1)begin
			if((vaddr_i[47:17]==stlb_c_i[a][46:16])//判断va的tage位与tlb中保存的是否相等
			&&stlb_c_i[a][0]//tlb中0位是有效位
			&&((asid_i==stlb_c_i[a][9:1])//判断asid和tlb中是否相等
			||stlb_c_i[a][11]))//asid相等或者全局标志位tlb[11]其中任意一个为1时tlb命中
			begin
				hit_i = 1'b1;
				i_hit_way = a;
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
    			if(mtlb_c[e][52:18]==vaddr_d[47:13])begin
    				//判断asid和全局位是否有一个有效
    				if((asid_d==mtlb_c[e][9:1])||(mtlb_c[e][11]))begin
    					hit_d = 1'b1;
						d_hit_way = e;
    					d_hit_op = 1'b1;
    					//判断奇偶页表
    					odd_even_sel_d = vaddr_d[mtlb_c[e][17:12]];
    					//计算ppn
    					case(odd_even_sel_d)
    						1'b0:temp_ppn_d = (mtlb_d0[e][44:9]&address_mask)<<12|(~(address_mask<<12)&vaddr_d[47:0]);
    						1'b1:temp_ppn_d = (mtlb_d1[e][44:9]&address_mask)<<12|(~(address_mask<<12)&vaddr_d[47:0]);
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
    	if(hit_d&&!rw_d&&en_d)begin
			case(d_hit_op)
				1'b0:begin//0说明在stlb中命中，1说明在mtlb中命中
						TLB_index = {1'b0,vaddr_d[16:13],d_hit_way[2:0]};
						case(odd_even_sel_d)
							1'b0:begin
									ppn_d  = {stlb_d0_d[d_hit_way[2:0]][44:9],vaddr_d[11:0]};
									ps_d   = 6'b001100;//stlb中页大小统一为4kb
									plv_d  = stlb_d0_d[d_hit_way[2:0]][7:6];
									mat_d  = stlb_d0_d[d_hit_way[2:0]][5:4];
									d_d    = stlb_d0_d[d_hit_way[2:0]][1];
									v_d    = stlb_d0_d[d_hit_way[2:0]][0];
									nx_d   = stlb_d0_d[d_hit_way[2:0]][3];
									nr_d   = stlb_d0_d[d_hit_way[2:0]][2];
									rplv_d = stlb_d0_d[d_hit_way[2:0]][8];
								end
							1'b1:begin
									ppn_d  = {stlb_d1_d[d_hit_way[2:0]][44:9],vaddr_d[11:0]};
									ps_d   = 6'b001100;//stlb中页大小统一为4kb
									plv_d  = stlb_d1_d[d_hit_way[2:0]][7:6];
									mat_d  = stlb_d1_d[d_hit_way[2:0]][5:4];
									d_d    = stlb_d1_d[d_hit_way[2:0]][1];
									v_d    = stlb_d1_d[d_hit_way[2:0]][0];
									nx_d   = stlb_d1_d[d_hit_way[2:0]][3];
									nr_d   = stlb_d1_d[d_hit_way[2:0]][2];
									rplv_d = stlb_d1_d[d_hit_way[2:0]][8];
								end 
						endcase
					end
				1'b1:begin
						TLB_index = 8'b01111111 + 8'(d_hit_way) + 1'b1;
						case(odd_even_sel_d)//指令奇偶页选择，1为奇数页 0为偶数页 
							1'b0:begin
									ppn_d  = temp_ppn_d;
									ps_d   = temp_ps_d;
									plv_d  = mtlb_d0[d_hit_way][7:6];
									mat_d  = mtlb_d0[d_hit_way][5:4];
									d_d    = mtlb_d0[d_hit_way][1];
									v_d    = mtlb_d0[d_hit_way][0];
									nx_d   = mtlb_d0[d_hit_way][3];
									nr_d   = mtlb_d0[d_hit_way][2];
									rplv_d = mtlb_d0[d_hit_way][8];
								end          
							1'b1:begin       
									ppn_d  = temp_ppn_d;
									ps_d   = temp_ps_d;
									plv_d  = mtlb_d1[d_hit_way][7:6];
									mat_d  = mtlb_d1[d_hit_way][5:4];
									d_d    = mtlb_d1[d_hit_way][1];
									v_d    = mtlb_d1[d_hit_way][0];
									nx_d   = mtlb_d1[d_hit_way][3];
									nr_d   = mtlb_d1[d_hit_way][2];
									rplv_d = mtlb_d1[d_hit_way][8];
								end 
						endcase
					end 
			endcase	
    	end
    end
    
	
endmodule
