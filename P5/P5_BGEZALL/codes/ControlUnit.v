`timescale 1ns / 1ps
`default_nettype none 
module ControlUnit (
    input wire [31:0] Instr,
    input wire [5:0] Opcode, Funct,
    input wire BranchCondition,
    
    output wire [2:0] PCSrc, CMP,
    output wire SignImm,
    output wire [2:0] ByteEnControl, MemDataControl,
    output wire RegWrite,
    output wire [2:0] RegDataSrc, RegDst,
    output wire [1:0] Tuse, TnewD,
    output wire [3:0] ALUControl,
    output wire ALUSrc
);

    wire RRCalType, ADD, SUB;
    wire RICalType, ORI, LUI;
    wire LMType, LW;
    wire SMType, SW;
    wire BType, BEQ;
    wire JType, JAL, JR;
    wire NOP;
    wire BGEZALL;
    TypeDecoder TypeDecoderCU (
        .Instr(Instr),
        .Opcode(Opcode),
        .Funct(Funct),

        .RRCalType(RRCalType),
        .ADD(ADD),
        .SUB(SUB),
        .RICalType(RICalType),
        .ORI(ORI),
        .LUI(LUI),
        .LMType(LMType),
        .LW(LW),
        .SMType(SMType),
        .SW(SW),
        .BType(BType),
        .BEQ(BEQ),
        .JType(JType),
        .JAL(JAL),
        .JR(JR),
        .NOP(NOP),
        .BGEZALL(BGEZALL)
    );

    SignalDecoder SignalDecoderCU (
        .RRCalType(RRCalType),
        .ADD(ADD),
        .SUB(SUB),
        .RICalType(RICalType),
        .ORI(ORI),
        .LUI(LUI),
        .LMType(LMType),
        .LW(LW),
        .SMType(SMType),
        .SW(SW),
        .BType(BType),
        .BEQ(BEQ),
        .JType(JType),
        .JAL(JAL),
        .JR(JR),
        .NOP(NOP),
        .BGEZALL(BGEZALL),
        .BranchCondition(BranchCondition),

        .PCSrc(PCSrc),
        .CMP(CMP),
        .SignImm(SignImm),
        .ByteEnControl(ByteEnControl),
        .MemDataControl(MemDataControl),
        .RegWrite(RegWrite),
        .RegDataSrc(RegDataSrc),
        .RegDst(RegDst),
        .Tuse(Tuse),
        .TnewD(TnewD),
        .ALUControl(ALUControl),
        .ALUSrc(ALUSrc)
    );
endmodule