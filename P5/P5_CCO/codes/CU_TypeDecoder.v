`timescale 1ns / 1ps
`default_nettype none
module TypeDecoder (
    input wire [31:0] Instr,
    input wire [5:0] Opcode, Funct,

    output wire RRCalType, ADD, SUB, CCO,
    output wire RICalType, ORI, LUI,
    output wire LMType, LW,
    output wire SMType, SW,
    output wire BType, BEQ,
    output wire JType, JAL, JR,
    output wire NOP
);
    assign RRCalType = ADD | SUB | CCO;
    assign ADD = (Opcode == 6'b000000) && (Funct == 6'b100000);
    assign SUB = (Opcode == 6'b000000) && (Funct == 6'b100010);
    assign CCO = (Opcode == 6'b000000) && (Funct == 6'b110110);

    assign RICalType = ORI | LUI; 
    assign ORI = (Opcode == 6'b001101);
    assign LUI = (Opcode == 6'b001111);

    assign LMType = LW;
    assign LW = (Opcode == 6'b100011);

    assign SMType = SW;
    assign SW = (Opcode == 6'b101011);

    assign BType = BEQ;
    assign BEQ = (Opcode == 6'b000100);

    assign JType = JAL | JR;
    assign JAL = (Opcode == 6'b000011);
    assign JR = (Opcode == 6'b000000) && (Funct == 6'b001000);

    assign NOP = (Instr == 32'd0);
endmodule