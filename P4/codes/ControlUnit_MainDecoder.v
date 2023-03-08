`timescale 1ns / 1ps
module MainDecoder (
    input Zero,
    input [5:0] Funct, Opcode,
    output [2:0] ALUOP, RegDataSrc,
    output MemWrite,
    output [2:0] PCSrc,
    output ALUSrc,
    output [2:0] RegDst,
    output RegWrite, SignImm, MemDataSrc
);
    // AND Logic
    reg RType, ORI, LW, SW, BEQ, LUI, JAL, JR, JAS;
    always @(*) begin
        RType = (Opcode == 6'b000000);
        ORI = (Opcode == 6'b001101);
        LW = (Opcode == 6'b100011);
        SW = (Opcode == 6'b101011);
        BEQ = (Opcode == 6'b000100);
        LUI = (Opcode == 6'b001111);
        JAL = (Opcode == 6'b000011);
        JR = (RType & (Funct == 6'b001000));
        JAS = (Opcode == 6'b011011);
    end

    // OR Logic
    ALUOPDecoder ALUOPDecoderInCU (
        .RType(RType),
        .ORI(ORI),
        .LW(LW),
        .SW(SW),
        .BEQ(BEQ),
        .LUI(LUI),
        .ALUOP(ALUOP)
    );

    RegDataSrcDecoder RegDataSrcDecoderInCU (
        .LW(LW),
        .JAL(JAL),
        .RegDataSrc(RegDataSrc)
    );

    assign MemWrite = SW | JAS;
    
    PCSrcDecoder PCSrcDecoderInCU (
        .Zero(Zero),
        .BEQ(BEQ),
        .JAL(JAL),
        .JR(JR),
        .PCSrc(PCSrc),
        .JAS(JAS)
    );

    assign ALUSrc = ORI | LW | SW | LUI;

    RegDstDecoder RegDstDecoderInCU (
        .RType(RType),
        .JAL(JAL),
        .RegDst(RegDst)
    );

    assign RegWrite = RType | ORI | LW | LUI | JAL;

    assign SignImm = LW | SW | BEQ;

    assign MemDataSrc = JAS;
    
endmodule