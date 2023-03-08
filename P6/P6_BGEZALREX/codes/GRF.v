`timescale 1ns/1ps
`default_nettype none 
module GRF (
    input wire clk, rst, WE,
    input wire [4:0] A1, A2, A3,
    input wire [31:0] WD,
    input wire [31:0] PCForTest,

    output wire [31:0] RD1, RD2
);
    reg [31:0] registers [31:0];
    assign RD1 = (A1 == 5'd0) ? 32'd0 : 
                 (WE && A1 == A3) ? WD : registers[A1];
    assign RD2 = (A2 == 5'd0) ? 32'd0 :
                 (WE && A2 == A3) ? WD : registers[A2];

    integer i;
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i<32; i = i + 1) begin
                registers[i] <= 32'h0000_0000;
            end
        end else if(WE) begin
            registers[A3] <= WD;
        end
    end
endmodule