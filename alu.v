`timescale 1ns / 1ps


module alu
    #(
        parameter DATA_WIDTH=32
    )
    (
        input  [11:0] alu_control,  // ALU�����ź�
        input  [DATA_WIDTH-1:0] alu_src1,     // ALU������1,Ϊ����
        input  [DATA_WIDTH-1:0] alu_src2,     // ALU������2��Ϊ����
        output [DATA_WIDTH-1:0] alu_result    // ALU���
    );
    
    // ALU�����źţ�������
    wire alu_add;   //�ӷ�����
    wire alu_sub;   //��������
    wire alu_slt;   //�з��űȽϣ�С����λ�����üӷ��������� al_src1 > alu_src2 ʱ�� ��1
    wire alu_sltu;  //�޷��űȽϣ�С����λ�����üӷ���������
    wire alu_and;   //��λ��
    wire alu_nor;   //��λ���
    wire alu_or;    //��λ��
    wire alu_xor;   //��λ���
    wire alu_sll;   //�߼�����  // alu_src1 ����ƫ����  alu_src2 ������ƫ����   
    wire alu_srl;   //�߼�����  // alu_src1 ����ƫ����  alu_src2 ������ƫ����
    wire alu_sra;   //��������  // alu_src1 ����ƫ����  alu_src2 ������ƫ����
    wire alu_lui;   //��λ����  //  alu_src2 ��������
    
    assign alu_add  = alu_control[11];
    assign alu_sub  = alu_control[10];
    assign alu_slt  = alu_control[ 9];
    assign alu_sltu = alu_control[ 8];
    assign alu_and  = alu_control[ 7];
    assign alu_nor  = alu_control[ 6];
    assign alu_or   = alu_control[ 5];
    assign alu_xor  = alu_control[ 4];
    assign alu_sll  = alu_control[ 3];
    assign alu_srl  = alu_control[ 2];
    assign alu_sra  = alu_control[ 1];
    assign alu_lui  = alu_control[ 0];
    
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
    
    
    assign and_result = alu_src1 & alu_src2;      // ����Ϊ������λ��
    assign or_result  = alu_src1 | alu_src2;      // ����Ϊ������λ��
    
    // ѡ����Ӧ������
    assign alu_result = (alu_add|alu_sub) ? add_sub_result[DATA_WIDTH-1:0] : 
                         alu_slt           ? slt_result :
                         alu_and           ? and_result :
                         alu_or            ? or_result :
                         {DATA_WIDTH{1'b0}};
    
endmodule