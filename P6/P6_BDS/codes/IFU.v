`timescale 1ns / 1ps
`default_nettype none 
module IFU (
    input wire clk, rst, en,
    input wire [31:0] Imm32,
    input wire [25:0] Instr25_0,
    input wire [31:0] RD1,
    input wire [2:0] PCSrc,
    output wire [31:0] PCPlus8,
    output wire [31:0] PCForTest
);
    reg [31:0] PC;
    assign PCForTest = PC;
    reg [31:0] PCPlus4Reg, PCPlus8Reg, PCBranchReg, PCJumpReg, PCRegReg;
    wire [31:0] muxResult;
    assign PCPlus8 = PCPlus8Reg;

    always @(*) begin
        PCPlus4Reg = PC + 32'd4;
        PCPlus8Reg = PC + 32'd8;
        PCBranchReg = {{Imm32[29:0]}, 2'b00} + PC;
        PCJumpReg = {{PC[31:28]}, {Instr25_0}, 2'b00};
        PCRegReg = RD1;
    end

    assign muxResult =  (PCSrc == 3'b000) ? PCPlus4Reg :
                        (PCSrc == 3'b001) ? PCBranchReg :
                        (PCSrc == 3'b010) ? PCJumpReg :
                        (PCSrc == 3'b011) ? PCRegReg : 32'hdddd;
    
    always @(posedge clk) begin
        if (rst) begin
            PC <= 32'h00003000;
        end else if (en) begin
            PC <= muxResult;
        end
    end
    
endmodule