`timescale 1ns / 1ps

module tb_I_cache(

    );
    
    reg clk;
    
    reg [63:0] pc;
        reg re; //读使能
    reg [35:0] TLB_ppn;
    
    //写入cache-未命中返回
    reg [511:0] write_data ;//返回未命中的数据
    reg missback;
    // 最高位有效位由取指单元产生,[95:32为pc] 
     reg [96:0] insn_final [7:0] ;//指令执行顺序先后为0到7，先执行0
     reg hit;//是否命中
    //output reg fifo_we//当未命中时置0暂停写fifo处理缺失
    
    initial begin
    	clk = 1'b0;
    	TLB_ppn = 36'b0;
    	missback = 1'b0;
    	write_data = 512'b0;
    	pc = 64'b0;
    end
    
    always #10 clk = ~clk;
    
    I_cache u_I_cache(
    .CLK         (clk),
	.PC          (pc),
	.re          (re),
    .TLB_ppn     (TLB_ppn),
    .write_data  (write_data),
    .missback    (missback),
    .insn_final  (insn_final),
    .hit         (hit)
    
    );
    
    always@(posedge clk) begin
    	if(hit == 1'b1)begin
    		//pc = pc + 9'b111111111;
    		//TLB_ppn = TLB_ppn + 1'b1;
    		missback = 1'b0;
    	end 
    	else begin
    		write_data = write_data + 8'b11111111;
    		missback = 1'b1;
    	end
    end
    
    
endmodule
