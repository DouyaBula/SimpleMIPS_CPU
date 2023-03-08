`timescale 1ns / 1ps
`default_nettype none 
module MainDecoder (
    input wire [31:0] Instr,
    input wire Zero,
    input wire [5:0] Funct, Opcode,
    output wire [2:0] ALUOP, RegDataSrc,
    output wire MemWrite,
    output wire [2:0] PCSrc,
    output wire ALUSrc,
    output wire [2:0] RegDst,
    output wire RegWrite, SignImm,
    output wire [1:0] TuseD, TnewD
);
    // AND Logic
    reg RType, ORI, LW, SW, BEQ, LUI, JAL, JR, NOP;
    always @(*) begin
        RType = (Opcode == 6'b000000);
        ORI = (Opcode == 6'b001101);
        LW = (Opcode == 6'b100011);
        SW = (Opcode == 6'b101011);
        BEQ = (Opcode == 6'b000100);
        LUI = (Opcode == 6'b001111);
        JAL = (Opcode == 6'b000011);
        JR = (RType & (Funct == 6'b001000));
        NOP = (Instr == 32'd0);
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

    assign MemWrite = SW && !NOP;
    
    PCSrcDecoder PCSrcDecoderInCU (
        .Zero(Zero),
        .BEQ(BEQ),
        .JAL(JAL),
        .JR(JR),
        .PCSrc(PCSrc)
    );

    assign ALUSrc = ORI | LW | SW | LUI;

    RegDstDecoder RegDstDecoderInCU (
        .RType(RType),
        .JAL(JAL),
        .RegDst(RegDst)
    );

    assign RegWrite = (RType | ORI | LW | LUI | JAL) && !JR && !NOP;

    assign SignImm = LW | SW | BEQ;
    
    TimeDecoder TimeDecoderInCU (
        .RType(RType),
        .ORI(ORI),
        .LW(LW),
        .SW(SW),
        .BEQ(BEQ),
        .LUI(LUI),
        .JAL(JAL),
        .JR(JR),
        .TuseD(TuseD),
        .TnewD(TnewD)
    );
endmodule