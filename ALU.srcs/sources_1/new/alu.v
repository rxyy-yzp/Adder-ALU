`timescale 1ns / 1ps


module alu
    #(
        parameter DATA_WIDTH=32
    )
    (
        input  [11:0] alu_control,  // ALU控制信号
        input  [DATA_WIDTH-1:0] alu_src1,     // ALU操作数1,为补码
        input  [DATA_WIDTH-1:0] alu_src2,     // ALU操作数2，为补码
        output [DATA_WIDTH-1:0] alu_result    // ALU结果
    );
    
    // ALU控制信号，独热码
    wire alu_add;   //加法操作
    wire alu_sub;   //减法操作
    wire alu_slt;   //有符号比较，小于置位，复用加法器做减法 al_src1 > alu_src2 时， 置1
    wire alu_sltu;  //无符号比较，小于置位，复用加法器做减法
    wire alu_and;   //按位与
    wire alu_nor;   //按位或非
    wire alu_or;    //按位或
    wire alu_xor;   //按位异或
    wire alu_sll;   //逻辑左移  // alu_src1 代表偏移量  alu_src2 代表被偏移数   
    wire alu_srl;   //逻辑右移  // alu_src1 代表偏移量  alu_src2 代表被偏移数
    wire alu_sra;   //算术右移  // alu_src1 代表偏移量  alu_src2 代表被偏移数
    wire alu_lui;   //高位加载  //  alu_src2 是立即数
    
    assign alu_add  = alu_control[11];
    assign alu_sub  = alu_control[10];
    assign alu_slt  = alu_control[9];
    assign alu_sltu = alu_control[8];
    assign alu_and  = alu_control[7];
    assign alu_nor  = alu_control[6];
    assign alu_or   = alu_control[5];
    assign alu_xor  = alu_control[4];
    assign alu_sll  = alu_control[3];
    assign alu_srl  = alu_control[2];
    assign alu_sra  = alu_control[1];
    assign alu_lui  = alu_control[0];
    
    wire [DATA_WIDTH-1:0] add_sub_result;
    wire [DATA_WIDTH-1:0] slt_result;
    wire [DATA_WIDTH-1:0] sltu_result;
    wire [DATA_WIDTH-1:0] and_result;
    wire [DATA_WIDTH-1:0] nor_result;
    wire [DATA_WIDTH-1:0] or_result;
    wire [DATA_WIDTH-1:0] xor_result;
    wire [DATA_WIDTH-1:0] sll_result;
    wire [DATA_WIDTH-1:0] srl_result;
    wire [DATA_WIDTH-1:0] sra_result;
    wire [DATA_WIDTH-1:0] lui_result;
    
    
    assign and_result = alu_src1 & alu_src2;   // 与结果为两数按位与
    assign or_result = alu_src1 | alu_src2;    // 或结果为两数按位或
    assign xor_result = alu_src1 ^ alu_src2;      // 异或
    assign nor_result = ~(alu_src1 | alu_src2);   // 或非
    
    wire [DATA_WIDTH-1:0] alu_sub_temp;
    wire [DATA_WIDTH-1:0] alu_sub_temp1;
    assign alu_sub_temp = ~alu_src2 + 1;   //取补码
    assign alu_sub_temp1 = alu_src1 + alu_sub_temp;  //保存有符号数减法结果
    assign add_sub_result = alu_add ? alu_src1 + alu_src2 :      //加法
                                       alu_sub_temp1;    //直接调用减法保存的结果
                                       
    assign slt_result = $signed(alu_src1) < $signed(alu_src2) ? 1 : 0;    //比较有符号数减法结果首位
    assign sltu_result = alu_src1 < alu_src2 ? 1 : 0;   //无符号数比较   
    
    assign sll_result = alu_src2 << alu_src1 % (DATA_WIDTH); //逻辑左移  // alu_src1 代表偏移量  alu_src2 代表被偏移数 
    assign srl_result = alu_src2 >> alu_src1 % (DATA_WIDTH); //逻辑左移  // alu_src1 代表偏移量  alu_src2 代表被偏移数 
    assign sra_result = $signed(alu_src2) >>> alu_src1 % (DATA_WIDTH); //算术右移  // alu_src1 代表偏移量  alu_src2 代表被偏移数
    assign lui_result = {alu_src2[DATA_WIDTH/2 - 1:0],{DATA_WIDTH/2{1'b0}}};
    
    // 选择相应结果输出
    assign alu_result = (alu_add|alu_sub) ? add_sub_result[DATA_WIDTH-1:0] : 
                         alu_slt           ? slt_result[DATA_WIDTH-1:0] :
                         alu_sltu          ? sltu_result[DATA_WIDTH-1:0] :
                         alu_and           ? and_result[DATA_WIDTH-1:0] :
                         alu_or            ? or_result[DATA_WIDTH-1:0] :
                         alu_xor           ? xor_result[DATA_WIDTH-1:0] :
                         alu_nor           ? nor_result[DATA_WIDTH-1:0] :
                         alu_sll           ? sll_result[DATA_WIDTH-1:0] :
                         alu_srl           ? srl_result[DATA_WIDTH-1:0] :
                         alu_sra           ? sra_result[DATA_WIDTH-1:0] :
                         alu_lui           ? lui_result[DATA_WIDTH-1:0] :
                         {DATA_WIDTH{1'b0}};
    
endmodule
