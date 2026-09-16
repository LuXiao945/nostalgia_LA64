`timescale 1ns / 1ps
//两位饱和预测器

module Bimodal_Predictor(
    input CLK,
    input RST,
    input [63:0] PC0,//最先需要预测的pc
    input [63:0] PC1,
    //-----------------------------------------------
    input [63:0] commit_PC0,//每周期支持提交两条分支指令
    input [63:0] commit_PC1,//将分支指令结果返回预测器
    input commit_valid0,//返回的是否为分支指令
    input commit_valid1,
    input branch_direction0,
    input branch_direction1,
    //-----------------------------------------------
    output reg is_taken0,//是否跳转,0为不跳转,1为跳转
    output reg is_taken1
    );
    
    /*
    由于指令四字对其,所以pc的0-1位用不到
    2k的pht可以提供93%以上的预测正确率
    2*1024 1024=2^10 -->需要10位pc寻址
    */

    reg [1:0] pht [1023:0];//00:强不跳转 01:弱不跳转 10:弱跳转 11:强跳转
    wire [9:0] pht_address0 = PC0[11:2];//用来寻址pht
    wire [9:0] pht_address1 = PC1[11:2];

    

    //读出跳转预测情况
    assign is_taken0 = pht [pht_address0] [1];
    assign is_taken1 = pht [pht_address1] [1];
    //pht写入及复位
    always@(posedge CLK)begin//2位状态机明天再写
        if(RST)begin//复位信号高电平有效
            //pht复位
            for(int unsigned a=0;a<1024;a=a+1)begin
                pht[a] <= 2'b00; 
            end
        end else begin
            if (commit_valid0 && (pht[commit_PC0[11:2]][1]==branch_direction0)) begin
                pht[commit_PC0[11:2]] <= ;
            end else begin
                
            end
            
        end
    end
endmodule
