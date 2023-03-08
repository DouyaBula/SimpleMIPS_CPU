`timescale 1ns / 1ps
`default_nettype none
module SignalDecoder (
    input wire RRCalType, ADD, SUB,
    input wire RICalType, ORI, LUI,
    input wire LMType, LW,
    input wire SMType, SW,
    input wire BType, BEQ,
    input wire JType, JAL, JR,
    input wire NOP,
    
    output wire [2:0] PCSrc, CMP,
    output wire SignImm,
    output wire [2:0] ByteEnControl, MemDataControl,
    output wire RegWrite,
    output wire [2:0] RegDataSrc, RegDst,
    output wire [1:0] Tuse, TnewD,
    output wire [3:0] ALUControl,
    output wire ALUSrc
);
    assign PCSrc =  BType ? 3'b001 :
                    JAL ? 3'b010 :
                    JR ? 3'b011 : 3'b000;

    assign CMP =    BEQ ? 3'b000 : 3'b111;

    assign SignImm = LUI | LMType | SMType | BType;

    assign ByteEnControl =  SW ? 3'b011 : 3'b000;

    assign MemDataControl = LW ? 3'b011 : 3'b000;

    assign RegWrite = RRCalType | RICalType | LMType | JAL;

    assign RegDataSrc = RRCalType ? 3'b000 :
                        RICalType ? 3'b000 :
                        LMType ? 3'b001 :
                        JAL ? 3'b011 : 3'b111;

    assign RegDst = RRCalType ? 3'b001 :
                    RICalType ? 3'b000 :
                    LMType ? 3'b000 :
                    JAL ? 3'b010 : 3'b111;

    assign Tuse =   (BType || JR) ? 2'd0 :
                    (RRCalType || RICalType || LMType || SMType) ? 2'd1 : 2'b11;

    assign TnewD =  (SMType || BType || JType || NOP) ? 2'd0 :
                    (RRCalType || RICalType) ? 2'd2 :
                    LMType ? 2'd3 : 2'b11;

    assign ALUControl = (ADD | LMType | SMType) ? 4'b0000 :
                        SUB ? 4'b0001 :
                        ORI ? 4'b0011 :
                        LUI ? 4'b0110 : 4'b1111;

    assign ALUSrc =     (RRCalType) ? 1'b0 :
                        (RICalType || LMType || SMType) ? 1'b1 : 1'b1;
endmodule