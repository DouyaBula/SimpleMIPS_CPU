`timescale 1ns / 1ps
module ALU (
    input [31:0] SrcA, SrcB,
    input [2:0] ALUControl,
    output Zero,
    output [31:0] ALUResult
);
    reg [31:0] SUMReg, SUBReg, ANDReg, ORReg, ShiftReg;
    wire [31:0] SSZEReg;
    reg flag = 1'b1;
    always @(*) begin
        SUMReg = SrcA + SrcB;
        SUBReg = SrcA - SrcB;
        ANDReg = SrcA & SrcB;
        ORReg = SrcA | SrcB;
        ShiftReg = {{SrcB[15:0]}, 16'h0000};
    end
    
    test Test(.SrcA(SrcA), .SrcB(SrcB), .result(SSZEReg));

    MUX8_1 #(.width(32)) MUXInALU (
        .slt(ALUControl),
        .input0(SUMReg),
        .input1(SUBReg),
        .input2(ANDReg),
        .input3(ORReg),
        .input4(ShiftReg),
        .input5(SSZEReg),
        .result(ALUResult)
    );
    assign Zero = ALUResult == 0 ? 32'd1 : 32'd0;
endmodule

module test (
    input [31:0] SrcA, SrcB,
    output [31:0] result
);
    reg [31:0] resultReg;
    reg flag;
    assign result = resultReg;
    integer i;
    always @(*) begin
        flag = 1'b1;
        resultReg = 32'd1;
        for (i = 0; flag && (i < 32); i = i + 1) begin
            if (((SrcA[i] == 1'b1) || (SrcB[i] == 1'b1))) begin
                resultReg = (SrcA[i] == SrcB[i]) ? 32'd1 : 32'd0;
                flag = 1'b0;
            end
        end 
    end
endmodule