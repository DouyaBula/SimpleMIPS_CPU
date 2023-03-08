`timescale 1ns / 1ps
`default_nettype none 
module ALU (
    input wire [31:0] SrcA, SrcB,
    input wire [2:0] ALUControl,

    output wire [31:0] ALUResult
);
    reg [31:0] SUMReg, SUBReg, ANDReg, ORReg, ShiftReg;
    always @(*) begin
        SUMReg = SrcA + SrcB;
        SUBReg = SrcA - SrcB;
        ANDReg = SrcA & SrcB;
        ORReg = SrcA | SrcB;
        ShiftReg = {{SrcB[15:0]}, 16'h0000}; 
    end
    MUX8_1 #(.width(32)) MUXInALU (
        .slt(ALUControl),
        .input0(SUMReg),
        .input1(SUBReg),
        .input2(ANDReg),
        .input3(ORReg),
        .input4(ShiftReg),
        .result(ALUResult)
    );
endmodule