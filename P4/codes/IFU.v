`timescale 1ns / 1ps
module IFU (
    input clk, rst,
    input [31:0] Imm32,
    input [25:0] Instr25_0,
    input [31:0] RD1,
    input [2:0] PCSrc,
    output [31:0] Instr, PCPlus4,
    output [31:0] PCForTest
);
    reg [31:0] PC;
    assign PCForTest = PC;
    reg [31:0] PCPlus4Reg, PCBranchReg, PCJumpReg, PCRegReg;
    wire [31:0] muxResult;
    assign PCPlus4 = PCPlus4Reg;

    always @(*) begin
        PCPlus4Reg = PC + 32'd4;
        PCBranchReg = {{Imm32[29:0]}, 2'b00} + PCPlus4Reg;
        PCJumpReg = {{PC[31:28]}, {Instr25_0}, 2'b00};
        PCRegReg = RD1;
    end

    MUX8_1 #(.width(32)) MUXInIFU (
        .slt(PCSrc),
        .input0(PCPlus4Reg),
        .input1(PCBranchReg),
        .input2(PCJumpReg), 
        .input3(PCRegReg),
        .result(muxResult)
    );

    ROM instrMem (
        .address(PC),
        .data(Instr)
    );
    
    always @(posedge clk) begin
        if (rst) begin
            PC <= 32'h00003000;
        end else begin
            PC <= muxResult;
        end
    end
    
endmodule