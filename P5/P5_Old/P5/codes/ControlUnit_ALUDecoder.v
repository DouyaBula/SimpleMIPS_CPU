`timescale 1ns / 1ps
`default_nettype none 
module ALUDecoder (
    input wire [5:0] Funct,
    input wire [2:0] ALUOP,
    
    output wire [2:0] ALUControl
);
    reg [2:0] FunctType;
    always @(*) begin
        if (ALUOP == 3'b000) begin
            case (Funct)
                6'b100000: begin
                    FunctType = 3'b000;
                end 
                6'b100010: begin
                    FunctType = 3'b001;
                end
                default: begin
                    FunctType = 3'b000;
                end
            endcase
        end
    end

    MUX8_1 #(.width(3)) MUXInALUDecoder (
        .slt(ALUOP),
        .input0(FunctType),
        .input1(3'b011),
        .input2(3'b000),
        .input3(3'b001),
        .input4(3'b100),

        .result(ALUControl)
    );

endmodule