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
    input branch_direction0,//分支指令实际方向,0:not token 1:token
    input branch_direction1,
    //-----------------------------------------------
    output logic is_taken0,//是否跳转,0为不跳转,1为跳转
    output logic is_taken1
    );
    
    /*
    由于指令四字对其,所以pc的0-1位用不到
    2k的pht可以提供93%以上的预测正确率
    2*1024 1024=2^10 -->需要10位pc寻址
    */

    logic [1:0] pht [1023:0];//00:强不跳转 01:弱不跳转 10:弱跳转 11:强跳转
    logic [9:0] pht_address0 ;//用来寻址pht
    logic [9:0] pht_address1 ;
    assign pht_address0 = PC0[11:2];
    assign pht_address1 = PC1[11:2];
    logic [9:0] commit_address0 ;//提交时的地址
    logic [9:0] commit_address1 ;
    assign commit_address0 = commit_PC0[11:2];
    assign commit_address1 = commit_PC1[11:2];
    //读出跳转预测情况
    assign is_taken0 = pht [pht_address0] [1];
    assign is_taken1 = pht [pht_address1] [1];

    logic conflict ;//对同一个地址写入则饱和计数器的值重新计算
    assign conflict = ((commit_address0 == commit_address1) && commit_valid0 && commit_valid1) ? 1'b1 : 1'b0 ;
    logic mispredict0 ; //预测失败信号
    logic mispredict1 ; //1为失败 0为正确
    assign mispredict0 = (pht[commit_address0][1]==branch_direction0) ? 1'b0 : 1'b1 ;
    assign mispredict1 = (pht[commit_address1][1]==branch_direction1) ? 1'b0 : 1'b1 ;
    //pht写入及复位
    always@(posedge CLK)begin
        if(RST)begin//复位信号高电平有效
            //pht复位
            for(int unsigned a=0;a<1024;a=a+1)begin
                pht[a] <= 2'b01; //初始化为弱不跳转
            end
        end else begin
            if(!conflict)begin
                if(commit_valid0)begin//预测成功
                    if(!mispredict0)begin
                        case(pht[commit_address0])
                            2'b00:pht[commit_address0] <= 2'b00;
                            2'b01:pht[commit_address0] <= 2'b00;
                            2'b10:pht[commit_address0] <= 2'b11;
                            2'b11:pht[commit_address0] <= 2'b11;
                            default:;
                        endcase
                    end else begin//预测失败
                        case(pht[commit_address0])
                            2'b00:pht[commit_address0] <= 2'b01;
                            2'b01:pht[commit_address0] <= 2'b10;
                            2'b10:pht[commit_address0] <= 2'b01;
                            2'b11:pht[commit_address0] <= 2'b10;
                            default:;
                        endcase
                    end
                end
                if(commit_valid1)begin
                    if(!mispredict1)begin
                        case(pht[commit_address1])
                            2'b00:pht[commit_address1] <= 2'b00;
                            2'b01:pht[commit_address1] <= 2'b00;
                            2'b10:pht[commit_address1] <= 2'b11;
                            2'b11:pht[commit_address1] <= 2'b11;
                            default:;
                        endcase
                    end else begin//预测失败
                        case(pht[commit_address1])
                            2'b00:pht[commit_address1] <= 2'b01;
                            2'b01:pht[commit_address1] <= 2'b10;
                            2'b10:pht[commit_address1] <= 2'b01;
                            2'b11:pht[commit_address1] <= 2'b10;
                            default:;
                        endcase
                    end
                end
            end else begin//当两个写地址相同时单独计算饱和计数器的值
                if (mispredict0==mispredict1) begin//如果都预测成功或都预测失败则往同一个方向更新2次状态
                    case (mispredict0)
                        1'b0:case(pht[commit_address0])
                                2'b00:pht[commit_address0] <= 2'b00;
                                2'b01:pht[commit_address0] <= 2'b00;
                                2'b10:pht[commit_address0] <= 2'b11;
                                2'b11:pht[commit_address0] <= 2'b11;
                                default:;
                            endcase
                        1'b1:case(pht[commit_address0])
                                2'b00:pht[commit_address0] <= 2'b10;
                                2'b01:pht[commit_address0] <= 2'b11;
                                2'b10:pht[commit_address0] <= 2'b00;
                                2'b11:pht[commit_address0] <= 2'b01;
                                default:;
                            endcase
                        default:;
                    endcase
                end//如果一次成功一次失败则不更改状态       
            end
        end
    end
endmodule
