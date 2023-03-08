`timescale 1ns / 1ps
`default_nettype none 
module ALU (
    input wire [31:0] SrcA, SrcB,
    input wire [3:0] ALUControl,

    output wire [31:0] ALUResult
);
    reg [31:0] SUMReg, SUBReg, ANDReg, ORReg, ShiftReg, LTReg, LTUReg, LUIReg;
    always @(*) begin
        SUMReg = SrcA + SrcB;
        SUBReg = SrcA - SrcB;
        ANDReg = SrcA & SrcB;
        ORReg = SrcA | SrcB;
        LTReg = $signed(SrcA) < $signed(SrcB);
        LTUReg = $unsigned(SrcA) < $unsigned(SrcB);
        LUIReg = {{SrcB[15:0]}, 16'h0000}; 
    end

    assign ALUResult =  (ALUControl == 4'b0000) ? SUMReg :
                        (ALUControl == 4'b0001) ? SUBReg :
                        (ALUControl == 4'b0010) ? ANDReg :
                        (ALUControl == 4'b0011) ? ORReg :
                        (ALUControl == 4'b0100) ? LTReg :
                        (ALUControl == 4'b0101) ? LTUReg :
                        (ALUControl == 4'b0110) ? LUIReg : 32'haaaa;

endmodule