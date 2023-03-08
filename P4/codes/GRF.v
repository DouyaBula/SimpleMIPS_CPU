`timescale 1ns/1ps
module GRF (
    input clk, rst, WE,
    input [4:0] A1, A2, A3,
    input [31:0] WD,
    output [31:0] RD1, RD2,
    input [31:0] PCForTest,
    output [31:0] GPR29
);
    reg [31:0] registers [31:0];
    reg [31:0] RD1Reg, RD2Reg;
    assign RD1 = RD1Reg;
    assign RD2 = RD2Reg;
    assign GPR29 = registers[29];
    integer i;
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i<32; i = i + 1) begin
                registers[i] <= 32'h0000_0000;
            end
        end else if(WE) begin
            $display("@%h: $%d <= %h", PCForTest, A3, WD);
            registers[A3] <= WD;
        end
    end

    always @(*) begin
        RD1Reg = (A1==5'd0) ? 32'h0000_0000 : registers[A1];
        RD2Reg = (A2==5'd0) ? 32'h0000_0000 : registers[A2];
    end
    
endmodule