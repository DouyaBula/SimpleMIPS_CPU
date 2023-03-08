`timescale 1ns / 1ps
`default_nettype none 
module ALU (
    input wire [31:0] SrcA, SrcB,
    input wire [3:0] ALUControl,
    input wire Store, Load,

    output wire [31:0] ALUResult,
    output wire AdEL, AdES, Ov
);
    reg [32:0] SUMReg, SUBReg;
    reg [31:0] ANDReg, ORReg, ShiftReg, LTReg, LTUReg, LUIReg;
    wire ADDOv, SUBOv;
    always @(*) begin
        SUMReg = {SrcA[31], SrcA} + {SrcB[31], SrcB};
        SUBReg = {SrcA[31], SrcA} - {SrcB[31], SrcB};
        ANDReg = SrcA & SrcB;
        ORReg = SrcA | SrcB;
        LTReg = $signed(SrcA) < $signed(SrcB);
        LTUReg = $unsigned(SrcA) < $unsigned(SrcB);
        LUIReg = {{SrcB[15:0]}, 16'h0000};
    end

    assign ALUResult =  (ALUControl == 4'b0000) ? SUMReg[31:0] :
                        (ALUControl == 4'b0001) ? SUBReg[31:0] :
                        (ALUControl == 4'b0010) ? ANDReg :
                        (ALUControl == 4'b0011) ? ORReg :
                        (ALUControl == 4'b0100) ? LTReg :
                        (ALUControl == 4'b0101) ? LTUReg :
                        (ALUControl == 4'b0110) ? LUIReg : 32'haaaa;

    assign ADDOv = (ALUControl == 4'b0000) && (SUMReg[32] != SUMReg[31]);
    assign SUBOv = (ALUControl == 4'b0001) && (SUBReg[32] != SUBReg[31]);
    assign AdEL = (Load && ADDOv);
    assign AdES = (Store && ADDOv);
    assign Ov = (!Load && !Store && (ADDOv || SUBOv));

endmodule