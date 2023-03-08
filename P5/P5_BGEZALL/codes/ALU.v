`timescale 1ns / 1ps
`default_nettype none 
module ALU (
    input wire [31:0] SrcA, SrcB,
    input wire [3:0] ALUControl,

    output wire [31:0] ALUResult
);
    reg [31:0] SUMReg, SUBReg, ORReg, LUIReg;
    always @(*) begin
        SUMReg = SrcA + SrcB;
        SUBReg = SrcA - SrcB;
        ORReg = SrcA | SrcB;
        LUIReg = {{SrcB[15:0]}, 16'h0000}; 
    end

    assign ALUResult =  (ALUControl == 4'b0000) ? SUMReg :
                        (ALUControl == 4'b0001) ? SUBReg :
                        (ALUControl == 4'b0011) ? ORReg :
                        (ALUControl == 4'b0110) ? LUIReg : 32'haaaa;

endmodule