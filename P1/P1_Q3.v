`timescale 1ns/1ps
module ext(
    input [15:0] imm,
    input [1:0] EOp,
    output [31:0] ext
);
    reg [31:0] result;
    reg sign;
    assign ext = result;
    always @(*) begin
        sign = imm[15];
    end
    always @(*) begin
        case (EOp)
            2'b00: begin
                result = {{16{sign}}, imm};
            end 
            2'b01: begin
                result = {{16{1'b0}}, imm};
            end 
            2'b10: begin
                result = {imm, {16{1'b0}}};
            end 
            2'b11: begin
                result = {{14{sign}}, imm, {2{1'b0}}};
            end 
            default: begin
                result = result;
            end
        endcase
    end
endmodule