`timescale 1ns / 1ps
module ControlUnit (
    input Zero,
    input [5:0] Opcode, Funct,
    output [2:0] RegDataSrc,
    output MemWrite,
    output [2:0] PCSrc,
    output ALUSrc,
    output [2:0] RegDst,
    output RegWrite, SignImm,
    output [2:0] ALUControl,
    output MemDataSrc
);
    wire [2:0] ALUOP;

    MainDecoder MainDecoderInCU (
        .Zero(Zero),
        .Funct(Funct),
        .Opcode(Opcode),
        .RegDataSrc(RegDataSrc),
        .MemWrite(MemWrite),
        .PCSrc(PCSrc),
        .ALUSrc(ALUSrc),
        .RegDst(RegDst),
        .RegWrite(RegWrite),
        .SignImm(SignImm),
        .ALUOP(ALUOP),
        .MemDataSrc(MemDataSrc)
    );

    ALUDecoder ALUDecoderInCU (
        .Funct(Funct),
        .ALUOP(ALUOP),
        .ALUControl(ALUControl)
    );
    
endmodule