`timescale 1ns/1ps
module alu (
    input [31:0] A, B,
    input [2:0] ALUOp,
    output [31:0] C
);
    reg [31:0] out;
    assign C = out;

    always @(*) begin
        case (ALUOp)
            3'b000: begin
                out = A + B;
            end
            3'b001: begin
                out = A - B;
            end
            3'b010: begin
                out = A & B;
            end
            3'b011: begin
                out = A | B;
            end
            3'b100: begin
                out = A >> B;
            end
            3'b101: begin
                out = $signed(A) >>> B;
            end
            default: begin
                out = out;
            end
        endcase
    end
endmodule