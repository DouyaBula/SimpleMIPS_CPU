`timescale 1ns / 1ps
`default_nettype none
module TypeDecoder (
    input wire [31:0] Instr,
    input wire [5:0] Opcode, Funct,

    output wire RRCalType, ADD, SUB, AND, OR, SLT, SLTU,
    output wire RICalType, ADDI, ANDI, ORI, LUI,
    output wire LMType, LB, LH, LW,
    output wire SMType, SB, SH, SW,
    output wire MDType, MULT, MULTU, DIV, DIVU, MFHI, MFLO, MTHI, MTLO,
    output wire BType, BEQ, BNE,
    output wire JType, JAL, JR,
    output wire NOP
);
    assign RRCalType = ADD | SUB | AND | OR | SLT | SLTU;
    assign ADD = (Opcode == 6'b000000) && (Funct == 6'b100000);
    assign SUB = (Opcode == 6'b000000) && (Funct == 6'b100010);
    assign AND = (Opcode == 6'b000000) && (Funct == 6'b100100);
    assign OR = (Opcode == 6'b000000) && (Funct == 6'b100101);
    assign SLT = (Opcode == 6'b000000) && (Funct == 6'b101010);
    assign SLTU = (Opcode == 6'b000000) && (Funct == 6'b101011);

    assign RICalType = ADDI | ANDI | ORI | LUI; 
    assign ADDI = (Opcode == 6'b001000);
    assign ANDI = (Opcode == 6'b001100);
    assign ORI = (Opcode == 6'b001101);
    assign LUI = (Opcode == 6'b001111);

    assign LMType = LB | LH | LW;
    assign LB = (Opcode == 6'b100000);
    assign LH = (Opcode == 6'b100001);
    assign LW = (Opcode == 6'b100011);

    assign SMType = SB | SH | SW;
    assign SB = (Opcode == 6'b101000);
    assign SH = (Opcode == 6'b101001);
    assign SW = (Opcode == 6'b101011);

    assign MDType = MULT | MULTU | DIV | DIVU | MFHI | MFLO | MTHI | MTLO;
    assign MULT = (Opcode == 6'b000000) && (Funct == 6'b011000);
    assign MULTU = (Opcode == 6'b000000) && (Funct == 6'b011001);
    assign DIV = (Opcode == 6'b000000) && (Funct == 6'b011010);
    assign DIVU = (Opcode == 6'b000000) && (Funct == 6'b011011);
    assign MFHI = (Opcode == 6'b000000) && (Funct == 6'b010000);
    assign MFLO = (Opcode == 6'b000000) && (Funct == 6'b010010);
    assign MTHI = (Opcode == 6'b000000) && (Funct == 6'b010001);
    assign MTLO = (Opcode == 6'b000000) && (Funct == 6'b010011);

    assign BType = BEQ | BNE;
    assign BEQ = (Opcode == 6'b000100);
    assign BNE = (Opcode == 6'b000101);

    assign JType = JAL | JR;
    assign JAL = (Opcode == 6'b000011);
    assign JR = (Opcode == 6'b000000) && (Funct == 6'b001000);

    assign NOP = (Instr == 32'd0);
endmodule