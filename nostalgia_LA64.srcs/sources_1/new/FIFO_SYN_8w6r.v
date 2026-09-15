`timescale 1ns / 1ps

module FIFO_SYN_8w6r(
	input [96:0] i [7:0] ,//每周期8条指令输入6条指令输出 o为最新一条指令以此类推
	// 最高位有效位由取指单元产生,[95:32为pc] 
	
	output reg [96:0] o [5:0],
	
	
	input CLK,
	input RST,
	
	output reg full,//写满信号有效时要暂停取指并保留pc不能更改
	output reg empty,//读空信号
	
	input en_read,//当发射队列已经被撑爆时停止读指令和解码指令，并且保持解码指令存在解码单元中，
				//当发送队列可以一次性输入6条指令时再继续运行取值和解码
	input we//写有效信号，当icache缺缺失时暂停写指令由cache hit信号提供
    );
    reg [7:0]rd_ptr;
    reg [7:0]wr_ptr;
    reg [96:0] FIFO [7:0][31:0];//每个数据单元4字节，2^3列，2^9行 [32:0]最高位为有效信号其余为指令
    reg [8:0] wr_cnt;
    //复位
    always@(posedge CLK)begin
    	if(RST==1)begin
    		empty <= 1'b1;//读空信号开始时为1
    		rd_ptr <= 8'd0;//复位读写指针
    		wr_ptr <= 8'd0;
    		
    		full <= 1'b0;
    		//有效位置零
    		for(integer i=0;i<8;i=i+1)begin
    			for(integer j=0;j<32;j=j+1)begin
    				FIFO[i][j][96] <= 1'b0;
    			end
    		end
    	end
    end
	//预计算读取和写入数据量
	// 计算有效写入数量（组合逻辑）
    wire [3:0] wr_valid_cnt;
    assign wr_valid_cnt = i[0][96] && we + i[1][96] && we + i[2][96] && we + i[3][96] && we +
                          i[4][96] && we + i[5][96] && we + i[6][96] && we + i[7][96] && we;
    // 读取地址预计算
    wire [7:0] rd_addr [0:5];
    assign rd_addr[0] = rd_ptr;
    assign rd_addr[1] = rd_ptr + 1;
    assign rd_addr[2] = rd_ptr + 2;
    assign rd_addr[3] = rd_ptr + 3;
    assign rd_addr[4] = rd_ptr + 4;
    assign rd_addr[5] = rd_ptr + 5;
    
    // 读取有效计数（组合逻辑）
    reg [3:0] rd_valid_cnt;
    always @(*) begin
        rd_valid_cnt = 0;
        for (integer l = 0; l < 6; l = l + 1) begin
            if (FIFO[rd_addr[l][2:0]][rd_addr[l][7:3]][96]&& en_read) begin
                rd_valid_cnt = rd_valid_cnt + 1;
            end
        end
    end
    //写入
    always@(posedge CLK)begin
    	if(RST!=1)begin
    		for(integer k=0;k<8;k=k+1)begin//8w有8个bank复制8个
    			if(i[k][96]==1 && !full && we)begin//判断有效位是否为1，不把无效数据存入FIFO
    				FIFO[wr_ptr[2:0]][wr_ptr[7:3]] <= i[k];
    				//wr_cnt <= wr_cnt +1'b1;
    				//empty <= 1'b0;//当写入一个数据后，读空信号应变更为0
    			end
    		end
    		wr_ptr <= wr_ptr + wr_valid_cnt;
    	end
    end
    //读取
    always@(posedge CLK)begin
    	if(RST!=1)begin
    		for(integer l=0;l<6;l=l+1)begin
    			if(FIFO[rd_addr[l][2:0]][rd_addr[l][7:3]][96]&&en_read)begin//判断有效位是否为1，不把无效数据存入FIFO
    				o[l] <= FIFO[rd_addr[l][2:0]][rd_addr[l][7:3]];
    			end
    			else begin
    				o[l][96] <= 1'b0;//如果读使能信号为0或者有效位为0就将输出有效位置为0 
    			end
    		end
    		rd_ptr <= rd_ptr + rd_valid_cnt;
    	end
    end
    //再一次性无法写入8条指令时输出写快满信号和读空信号
    always@(posedge CLK)begin
    	if(RST!=1)begin
    		
    		if(wr_cnt>=9'd248)begin//如果计数值大于于248说明一次性不可以写入8条指令，则写快满信号为1
    			full <= 1'b1;
    		end	
    		else begin
    			full <= 1'b0;
    		end	
    		if(wr_cnt==8'b0)begin
    			empty <= 1'b1;
    			
    		end
    		else begin
    			empty <= 1'b0;
    		end 
    	end
    	
    end	
    always @(posedge CLK) begin
    	if (RST) begin
        	wr_cnt <= 9'd0;//复位写计数器
    	end 
    	else begin
        	wr_cnt <= wr_cnt + wr_valid_cnt - rd_valid_cnt;//更新写计数器
    	end
	end
endmodule
