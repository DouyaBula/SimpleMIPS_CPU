`timescale 1ns / 1ps
`default_nettype none
module SignalDecoder (
    input wire RRCalType, ADD, SUB, AND, OR, SLT, SLTU,
    input wire RICalType, ADDI, ANDI, ORI, LUI,
    input wire LMType, LB, LH, LW,
    input wire SMType, SB, SH, SW,
    input wire MDType, MULT, MULTU, DIV, DIVU, MFHI, MFLO, MTHI, MTLO,
    input wire BType, BEQ, BNE,
    input wire JType, JAL, JR,
    input wire NOP,
    input wire MFC0, MTC0, ERET, SYSCALL,
    
    output wire [2:0] PCSrc, CMP,
    output wire SignImm,
    output wire [2:0] ByteEnControl, MemDataControl,
    output wire RegWrite,
    output wire [2:0] RegDataSrc, RegDst,
    output wire [1:0] Tuse, TnewD,
    output wire [3:0] ALUControl,
    output wire ALUSrc,
    output wire Start,
    output wire [3:0] MDUOP,
    output wire [1:0] ReadHILO,
    output wire [3:0] Time,
    output wire CP0Write
);
    assign PCSrc =  BType ? 3'b001 :
                    JAL ? 3'b010 :
                    JR ? 3'b011 : 
                    ERET ? 3'b100 : 3'b000;

    assign CMP =    BEQ ? 3'b000 :
                    BNE ? 3'b001 : 3'b111;

    assign SignImm = ADDI | LUI | LMType | SMType | BType;

    assign ByteEnControl =  SB ? 3'b001 :
                            SH ? 3'b010 :
                            SW ? 3'b011 : 3'b000;

    assign MemDataControl = LB ? 3'b001 :
                            LH ? 3'b010 :
                            LW ? 3'b011 : 3'b000;

    assign RegWrite = RRCalType | RICalType | LMType | MFHI | MFLO | JAL | MFC0;

    assign RegDataSrc = RRCalType ? 3'b000 :
                        RICalType ? 3'b000 :
                        LMType ? 3'b001 :
                        (MFHI || MFLO) ? 3'b010 :
                        JAL ? 3'b011 : 
                        MFC0 ? 3'b100 : 3'b111;

    assign RegDst = (RRCalType || MFHI || MFLO) ? 3'b001 :
                    RICalType ? 3'b000 :
                    LMType ? 3'b000 :
                    JAL ? 3'b010 :
                    MFC0 ? 3'b000 : 3'b111;

    assign Tuse =   (BType || JR) ? 2'd0 :
                    (RRCalType || RICalType || LMType || SMType
                     || (MDType && !MFHI && !MFLO) || MTC0) ? 2'd1 :
                    (MFHI || MFLO || JAL || NOP || MFC0 || ERET || SYSCALL) ? 2'd3 : 2'd3;

    assign TnewD =  (SMType || (MDType && !MFHI && !MFLO) 
                     || BType || JType || NOP || MTC0 || ERET || SYSCALL) ? 2'd0 :
                    (RRCalType || RICalType || MFHI || MFLO) ? 2'd2 :
                    (LMType || MFC0) ? 2'd3 : 2'b11;

    assign ALUControl = (ADD | ADDI | LMType | SMType) ? 4'b0000 :
                        SUB ? 4'b0001 :
                        (AND | ANDI) ? 4'b0010 :
                        (OR | ORI) ? 4'b0011 :
                        SLT ? 4'b0100 :
                        SLTU ? 4'b0101 :
                        LUI ? 4'b0110 : 4'b1111;

    assign ALUSrc =     (RRCalType) ? 1'b0 :
                        (RICalType || LMType || SMType) ? 1'b1 : 1'b1;

    assign Start = MULT | MULTU | DIV | DIVU;

    assign MDUOP =  MULT ? 4'b0001 :
                    MULTU ? 4'b0010 :
                    DIV ? 4'b0011 :
                    DIVU ? 4'b0100 :
                    (MFHI || MFLO) ? 4'b1111 :
                    MTHI ? 4'b0101 :
                    MTLO ? 4'b0110 : 4'b0000;

    assign ReadHILO =   MFHI ? 2'b10 :
                        MFLO ? 2'b01 : 2'b00;

    assign Time =   (MULT || MULTU) ? 4'd5 :
                    (DIV || DIVU) ? 4'd10 : 4'd0;

    assign CP0Write = MTC0;
endmodule