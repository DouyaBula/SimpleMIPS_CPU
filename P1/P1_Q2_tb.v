`timescale 1ns/1ps
module tb;
reg [31:0] A, B;
reg [2:0] ALUOp;
wire [31:0] C;
alu dut(.A(A), .B(B), .ALUOp(ALUOp), .C(C));
initial begin
    $fsdbDumpvars();
    A = 32'b11110000_00000000_10101010_00000000;
    B = 32'd5;
    ALUOp = 3'b101;
    #10
    ALUOp = 3'b100;
    #10


    #20
    $finish;
end
endmodule