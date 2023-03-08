`timescale 1ns / 1ps
`default_nettype none 
module MUX8_1 #(
    parameter width = 32
) (
    input wire [2:0] slt,
    input wire [width-1:0] input0, input1, input2, input3, input4, input5, input6, input7,
    output wire [width-1:0] result
);
    reg [width-1:0] resultReg;
    assign result = resultReg;
    always @(*) begin
        case (slt)
            3'b000: begin
                resultReg = input0;
            end 
            3'b001: begin
                resultReg = input1;
            end 
            3'b010: begin
                resultReg = input2;
            end 
            3'b011: begin
                resultReg = input3;
            end 
            3'b100: begin
                resultReg = input4;
            end 
            3'b101: begin
                resultReg = input5;
            end 
            3'b110: begin
                resultReg = input6;
            end 
            3'b111: begin
                resultReg = input7;
            end 
            default: begin
                resultReg = input0;
            end
        endcase
    end
endmodule