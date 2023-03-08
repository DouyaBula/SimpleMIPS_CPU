`timescale 1ns / 1ps
`default_nettype none 
module ControlUnit (
    input wire [31:0] Instr,
    input wire Zero,
    input wire [5:0] Opcode, Funct,
    
    output wire [2:0] RegDataSrc,
    output wire MemWrite,
    output wire [2:0] PCSrc,
    output wire ALUSrc,
    output wire [2:0] RegDst,
    output wire RegWrite, SignImm,
    output wire [2:0] ALUControl,
    output wire [1:0] TuseD, TnewD
);
    wire [2:0] ALUOP;

    MainDecoder MainDecoderInCU (
        .Instr(Instr),
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
        .TuseD(TuseD),
        .TnewD(TnewD)
    );

    ALUDecoder ALUDecoderInCU (
        .Funct(Funct),
        .ALUOP(ALUOP),
        .ALUControl(ALUControl)
    );
    
endmodule