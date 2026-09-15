`timescale 1ns / 1ps

/*
如果空闲列表取出的id不够消耗，则停止这一节拍的寄存器重命名，直到输出的空闲id足够


*/
module FreeList(
	input CLK,
	input RST,
	input [6:0] deallocation_reg_id [5:0],//释放的寄存器id
	input [5:0] deallocation_valid,//释放的id有效位
	input [2:0] use_num,//rat使用的id数量
	output reg [6:0] free_reg_id [5:0],//输出的空闲寄存器id
	output reg [5:0] valid//空闲寄存器使能,用来告诉rat输出的哪些id有效
    );
    reg [6:0] freelist [127:0];//2^7一共127个物理寄存器
    reg [6:0] top;//栈顶指针
    integer i;
    integer j;
    integer k;
    integer l;
    integer m;
    //将释放的寄存器id压缩
    reg [2:0] write_cnt;
    reg [6:0] id [5:0];
    always@(*)begin
    	automatic reg [2:0] temp_write_cnt = 3'b000;
    	//将id清零
    	for(m=0;m<6;m=m+1)begin
    		id[m] = 7'b0;
    	end
    	for(l=0;l<6;l=l+1)begin
    		if(deallocation_valid[l] == 1'b1)begin
    			id[temp_write_cnt] = deallocation_reg_id[l];
    			temp_write_cnt = temp_write_cnt + 1'b1;
    		end
    	end
    	write_cnt = temp_write_cnt;
    end
    //当时钟上升沿读取寄存器id，下降沿写入释放的寄存器id
    always@(negedge CLK)begin//写入和复位
    	if(RST != 1'b1)begin
    		for(k=0;k<6;k=k+1)begin
    			if(k<write_cnt)begin
    				freelist[top-use_num+k+1'b1] <= id[k];
    			end
    		end
    		//重新计算top
    		top <= top-use_num+write_cnt;
    	end else begin//复位逻辑
    		top <= 7'd127;
    		for(i=0;i<128;i=i+1)begin
    			freelist[i] <= i; //初始化freelist时把列表的项号写进表里，读取时不把第0项读出(r0永远映射到p0)
    			
    		end
    	end
    end
    always@(posedge CLK)begin//读出
    	for(j=0;j<6;j=j+1)begin
    			if(top > j)begin
    				free_reg_id[j] <= freelist[(top-j)];//free_reg_id的第0位为栈顶数据。
    				valid[j] <= 1'b1;                   //rat消耗空闲id时先消耗第0位
    			end else begin
    				valid[j] <= 1'b0;
    			end
    		end
    end
endmodule
