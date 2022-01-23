`timescale 1ns / 1ps

module tracecompare( );
    integer i;
    integer j;
    integer in;
    integer statusI;
    reg [7:0] operand1;
    reg [7:0] operand2;
    reg [11:0] opcode;
    wire [7:0] myResult;
    reg [7:0] rightResult;
    
    alu  #( .DATA_WIDTH(8))
        uut (
        .alu_src1(operand1),
          .alu_src2(operand2) ,
          .alu_control(opcode),
          .alu_result(myResult)
    );
    initial begin
        in = $fopen("trace8bits.txt", "r");

        opcode = 12'b1;
        operand1 = 0;
        operand2 = 0;
        #10;
    
    while ( ! $feof(in)) begin
        statusI = $fscanf(in,"%h %h %h %h\n",operand1,operand2, opcode, rightResult);
        #5
        if( rightResult !== myResult) begin
            $display ("alu_src1: %h, alu_src2: %h, alu_control: %h, \nRightResult: %h, YourResult: %h \n", operand1, operand2, opcode, rightResult, myResult);
            $stop;
        end
        #10;
    end
    $fclose(in);
    #100  $finish;
    end
endmodule
