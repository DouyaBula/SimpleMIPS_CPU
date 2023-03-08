`timescale 1ns / 1ps
module ALUDecoder (
    input [5:0] Funct,
    input [2:0] ALUOP,
    output [2:0] ALUControl
);
    reg [2:0] FunctTypeReg;
    always @(*) begin
        if (ALUOP == 3'b000) begin
            case (Funct)
                6'b100000: begin
                    FunctTypeReg = 3'b000;
                end 
                6'b100010: begin
                    FunctTypeReg = 3'b001;
                end
                6'b001111: begin
                    FunctTypeReg = 3'b101;
                end
                default: begin
                    FunctTypeReg = 3'b000;
                end
            endcase
        end
    end

    MUX8_1 #(.width(3)) MUXInALUDecoder (
        .slt(ALUOP),
        .input0(FunctTypeReg),
        .input1(3'b011),
        .input2(3'b000),
        .input3(3'b001),
        .input4(3'b100),
        .result(ALUControl)
    );

endmodule