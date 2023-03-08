`timescale 1ns / 1ps
`default_nettype none 
module IFU (
    input wire clk, rst, en,
    input wire [31:0] Imm32,
    input wire [25:0] Instr25_0,
    input wire [31:0] RD1,
    input wire [2:0] PCSrc,
    input wire DelayInstr,
    input wire Req,
    input wire [31:0] EPC,

    output wire [31:0] PCPlus8,
    output wire [31:0] PCForTest,
    output wire DelaySlot
);
    reg [31:0] PC;
    assign PCForTest = (PCSrc == 3'b100) ? EPC : PC;    // ERET: 采用积极取消延迟槽的方法, 而非插入nop
    reg [31:0] PCPlus4Reg, PCPlus8Reg, PCBranchReg, PCJumpReg, PCRegReg;
    wire [31:0] muxResult;
    assign PCPlus8 = PCPlus8Reg;

    assign DelaySlot = DelayInstr;

    always @(*) begin
        PCPlus4Reg = PCForTest + 32'd4; // TODO: 草, 万万没想到这里寄了, 这里也要因为ERET改
        PCPlus8Reg = PCForTest + 32'd8;
        PCBranchReg = {{Imm32[29:0]}, 2'b00} + PCForTest;
        PCJumpReg = {{PCForTest[31:28]}, {Instr25_0}, 2'b00};
        PCRegReg = RD1;
    end

    assign muxResult =  (PCSrc == 3'b000) ? PCPlus4Reg :
                        (PCSrc == 3'b001) ? PCBranchReg :
                        (PCSrc == 3'b010) ? PCJumpReg :
                        (PCSrc == 3'b011) ? PCRegReg : 
                        (PCSrc == 3'b100) ? (EPC + 32'd4) : 32'hdddd;   // ERET: 采用积极取消延迟槽的方法, 而非插入nop
    
    always @(posedge clk) begin
        if (rst) begin
            PC <= 32'h0000_3000;
        end else if (Req) begin
            PC <= 32'h0000_4180;
        end else if (en) begin
            PC <= muxResult;
        end
    end
    
endmodule