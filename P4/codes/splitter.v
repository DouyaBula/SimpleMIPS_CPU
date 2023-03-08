`timescale 1ns/1ps
module splitter (
    input [31:0] Instr,
    output [31:26] Instr31_26,
    output [5:0] Instr5_0,
    output [25:21] Instr25_21,
    output [20:16] Instr20_16,
    output [15:11] Instr15_11,
    output [15:0] Instr15_0,
    output [25:0] Instr25_0
);
    assign Instr31_26 = Instr[31:26];
    assign Instr5_0 = Instr[5:0];
    assign Instr25_21 = Instr[25:21];
    assign Instr20_16 = Instr[20:16];
    assign Instr15_11 = Instr[15:11];
    assign Instr15_0 = Instr[15:0];
    assign Instr25_0 = Instr[25:0];
endmodule