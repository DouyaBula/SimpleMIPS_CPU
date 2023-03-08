`timescale 1ns/1ps
module P1_Q1_tb;
reg [31:0] A;
wire [7:0] O1;
wire [7:0] O2;
wire [7:0] O3;
wire [7:0] O4;
splitter dut(.A(A), .O1(O1), .O2(O2), .O3(O3), .O4(O4));
initial begin
    $fsdbDumpvars();
    A = 32'b11001111_11111111_00000000_10101010;

    #20
    $finish;
end
endmodule