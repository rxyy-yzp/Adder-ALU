`timescale 1ns / 1ps

module alu_top(
    output [15:0] leds,
    input  [31:0] dip_sw
    );
    wire [7:0] operand1, operand2;
    wire [11:0] opcode;
    wire [7:0] result;
    
    assign operand1 = dip_sw [7:0];
    assign operand2 = dip_sw [15:8];
    assign opcode = dip_sw [27:16];
    assign leds[7:0] =  result[7:0];
    assign leds[15:8] = 8'b0;
    alu  #( .DATA_WIDTH(8))
        uut(
        .alu_src1(operand1),
        .alu_src2(operand2),
        .alu_control(opcode),
        .alu_result(result)
    );
endmodule
