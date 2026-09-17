`timescale 1ns / 1ps
//源寄存器有效信号暂定,理论上就算基于无效信号取出的数据也是不使用的,不过为了鲁棒性暂且加上

module RAT(
	input clk,
	input rst,//复位信号，高电平有效
	
	input [4:0] src00,
	input [4:0] src01,
	input [4:0] des0,
	input src00_valid,
	input src01_valid,
	input des0_valid,
	output reg [6:0] psrc00,
	output reg [6:0] psrc01,
	output reg [6:0] pdes0,
	output reg [6:0] old_des0,
	
	input [4:0] src10,
	input [4:0] src11,
	input [4:0] des1,
	input src10_valid,
	input src11_valid,
	input des1_valid,
	output reg [6:0] psrc10,
	output reg [6:0] psrc11,
	output reg [6:0] pdes1,
	output reg [6:0] old_des1,
	
	input [4:0] src20,
	input [4:0] src21,
	input [4:0] des2,
	input src20_valid,
	input src21_valid,
	input des2_valid,
	output reg [6:0] psrc20,
	output reg [6:0] psrc21,
	output reg [6:0] pdes2,
	output reg [6:0] old_des2,
	
	input [4:0] src30,
	input [4:0] src31,
	input [4:0] des3,
	input src30_valid,
	input src31_valid,
	input des3_valid,
	output reg  [6:0] psrc30,
	output reg  [6:0] psrc31,
	output reg  [6:0] pdes3,
	output reg [6:0] old_des3,
	
	input [4:0] src40,
	input [4:0] src41,
	input [4:0] des4,
	input src40_valid,
	input src41_valid,
	input des4_valid,
	output reg [6:0] psrc40,
	output reg [6:0] psrc41,
	output reg [6:0] pdes4,
	output reg [6:0] old_des4,
	
	input [4:0] src50,
	input [4:0] src51,
	input [4:0] des5,
	input src50_valid,
	input src51_valid,
	input des5_valid,
	output reg [6:0] psrc50,
	output reg [6:0] psrc51,
	output reg [6:0] pdes5,
	output reg [6:0] old_des5,
	
	input [6:0] free_reg_id [5:0],
	input [5:0] free_reg_valid,
	
	output reg [2:0] use_num,
	output reg stop_rat
    );
    reg [6:0] rat [31:0];//0恒为0不允许更改
    
    //新的映射关系写入
    //先判断空闲id是否够用,不够用时暂停id分配
    //将空闲id分配给des,先分配空闲id的第0位
    wire [2:0] need_id_cnt;//需要空闲id数量
    assign need_id_cnt = des0_valid + des1_valid + des2_valid + des3_valid + des4_valid + des5_valid ;
    //输入的空闲id计数
    wire [2:0] free_id_cnt;
    assign free_id_cnt =
    					 free_reg_valid[0] + 
    					 free_reg_valid[1] + 
    					 free_reg_valid[2] + 
    					 free_reg_valid[3] + 
    					 free_reg_valid[4] + 
    					 free_reg_valid[5] ; 
    //将des有效信号放在一个寄存器堆中
    wire [5:0] des_valid;
    assign des_valid[0] = des0_valid;
    assign des_valid[1] = des1_valid;
    assign des_valid[2] = des2_valid;
    assign des_valid[3] = des3_valid;
    assign des_valid[4] = des4_valid;
    assign des_valid[5] = des5_valid;
    
    //创建循环变量
    integer i;
    integer j;
    //temp_pdes向量用来零时接受分配的空闲id,等时钟的下降沿再输出给pdes0，1，2.....
    reg [6:0] temp_pdes [5:0];
    //reg temp_stop_rat;
    //给des分配空闲id
    always@(*)begin
    	//创建已分配id计数器
    	automatic reg [2:0] assignid_cnt;
    	
    	stop_rat = 1'b0;
    	//初始化temp_pdes
    	for(j=0;j<6;j=j+1)begin
    		temp_pdes[j] = 7'b0;
    	end
    	//初始化已分配id计数器
    	assignid_cnt = 6'b0;
    	if(need_id_cnt <= free_id_cnt )begin
    		
    		//如果需要的id小于空闲列表输出的id数量
    		//依次分配,优先分配第0位
    		for(i=0;i<6;i=i+1)begin
    			//判断des是否需要分配空闲id
    			//如果是则依次从0-1-2分配,如果不是则判断下一个des
    			temp_pdes[i] = des_valid[i] ? free_reg_id[assignid_cnt] : 7'b0;
    			assignid_cnt = des_valid[i] ? (assignid_cnt + 1'b1) : assignid_cnt;
    		end
    		use_num = need_id_cnt;
    	end else begin
    		//如果不符合分配空闲id的条件则
    		stop_rat = 1'b1;
    		use_num = 3'b0;
    	end
    end
    //空闲id使用数量输出
   /* always@(*)begin
    	if(stop_rat == 1'b1)begin
    		use_num = 3'b0;
    	end else begin
    		use_num = need_id_cnt;
    	end
    end
    */
    
    //psrc读出并处理写后读(raw)
    always@(negedge clk)begin
    	//src0因为是最先取出的指令不受后取出指令的影响所以直接用rat中的值即可
    	psrc00 <= src00_valid ? rat[src00] : 7'b0;
    	psrc01 <= src01_valid ? rat[src01] : 7'b0;
    	
    	psrc10 <= src10_valid ? ((src10==des0) ? temp_pdes[0] : rat[src10]) : 7'b0;
    	psrc11 <= src11_valid ? ((src11==des0) ? temp_pdes[0] : rat[src11]) : 7'b0;
    	
    	psrc20 <= src20_valid ? ((src20==des1) ? temp_pdes[1] : ((src20==des0) ? temp_pdes[0] : rat[src20])) : 7'b0;
    	psrc21 <= src21_valid ? ((src21==des1) ? temp_pdes[1] : ((src21==des0) ? temp_pdes[0] : rat[src21])) : 7'b0;
    	
    	psrc30 <= src30_valid ? ((src30==des2) ? temp_pdes[2] : ((src30==des1) ? temp_pdes[1] : ((src30==des0) ? temp_pdes[0] : rat[src30]))) : 7'b0;
    	psrc31 <= src31_valid ? ((src31==des2) ? temp_pdes[2] : ((src31==des1) ? temp_pdes[1] : ((src31==des0) ? temp_pdes[0] : rat[src31]))) : 7'b0;
    	
    	psrc40 <= src40_valid ? ((src40==des3) ? temp_pdes[3] : ((src40==des2) ? temp_pdes[2] : ((src40==des1) ? temp_pdes[1] : ((src40==des0) ? temp_pdes[0] : rat[src40])))) : 7'b0;
    	psrc41 <= src41_valid ? ((src41==des3) ? temp_pdes[3] : ((src41==des2) ? temp_pdes[2] : ((src41==des1) ? temp_pdes[1] : ((src41==des0) ? temp_pdes[0] : rat[src41])))) : 7'b0;
    	
    	psrc50 <= src50_valid ? ((src50==des4) ? temp_pdes[4] : ((src50==des3) ? temp_pdes[3] : ((src50==des2) ? temp_pdes[2] : ((src50==des1) ? temp_pdes[1] : ((src50==des0) ? temp_pdes[0] : rat[src50]))))) : 7'b0;
    	psrc51 <= src51_valid ? ((src51==des4) ? temp_pdes[4] : ((src51==des3) ? temp_pdes[3] : ((src51==des2) ? temp_pdes[2] : ((src51==des1) ? temp_pdes[1] : ((src51==des0) ? temp_pdes[0] : rat[src51]))))) : 7'b0;
    end
    //如果遇到一条有目的寄存器的指令，那么将这条指令之前对应的old_pdes读出
    always@(negedge clk)begin
    	//第一条指令的old_pdes就是rat中读出的
    	old_des0 <= des0_valid ? rat[des0] : 7'b0;
    	
    	old_des1 <= des1_valid ? ((des1==des0) ? temp_pdes[0] : rat[des1]) : 7'b0;
    	
    	old_des2 <= des2_valid ? ((des2==des1) ? temp_pdes[1] : ((des2==des0) ? temp_pdes[0] : rat[des2])) : 7'b0;
    	
    	old_des3 <= des3_valid ? ((des3==des2) ? temp_pdes[2] : ((des3==des1) ? temp_pdes[1] : ((des3==des0) ? temp_pdes[0] : rat[des3]))) : 7'b0;
    	
    	old_des4 <= des4_valid ? ((des4==des3) ? temp_pdes[3] : ((des4==des2) ? temp_pdes[2] : ((des4==des1) ? temp_pdes[1] : ((des4==des0) ? temp_pdes[0] : rat[des4])))) : 7'b0;
    	
    	old_des5 <= des5_valid ? ((des5==des4) ? temp_pdes[4] : ((des5==des3) ? temp_pdes[3] : ((des5==des2) ? temp_pdes[2] : ((des5==des1) ? temp_pdes[1] : ((des5==des0) ? temp_pdes[0] : rat[des5]))))) : 7'b0;
    	
    end
    //时钟下降沿写入映射关系(并解决waw问题)
    integer k;
    always@(negedge clk)begin
    	if(rst==1'b1)begin
    		for(k=0;k<32;k=k+1)begin
    			rat[k] <= 7'b0;//对rat复位
    		end
    	end else begin
    		//将映射关系写入
    		rat[des5] <= ((des5!=5'b0) && des5_valid) ? temp_pdes[5] : rat[des5];
    		rat[des4] <= ((des4!=5'b0) && des4_valid && (des4!=des5) ) ? temp_pdes[4] : rat[des4];
    		rat[des3] <= ((des3!=5'b0) && des3_valid && (des3!=des5) && (des3!=des4) ) ? temp_pdes[3] : rat[des3];
    		rat[des2] <= ((des2!=5'b0) && des2_valid && (des2!=des5) && (des2!=des4) && (des2!=des3) ) ? temp_pdes[2] : rat[des2];
    		rat[des1] <= ((des1!=5'b0) && des1_valid && (des1!=des5) && (des1!=des4) && (des1!=des3) && (des1!=des2) ) ? temp_pdes[1] : rat[des1];
    		rat[des0] <= ((des0!=5'b0) && des0_valid && (des0!=des5) && (des0!=des4) && (des0!=des3) && (des0!=des2) && (des0!=des1) ) ? temp_pdes[0] : rat[des0];
    	end
    end
    //将temp_pdes输出
    always@(negedge clk)begin
    	pdes0 <= temp_pdes[0];
    	pdes1 <= temp_pdes[1];
    	pdes2 <= temp_pdes[2];
    	pdes3 <= temp_pdes[3];
    	pdes4 <= temp_pdes[4];
    	pdes5 <= temp_pdes[5];
    end
endmodule
