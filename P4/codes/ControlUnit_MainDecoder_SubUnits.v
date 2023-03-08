`timescale 1ns / 1ps
module ALUOPDecoder (
    input RType, ORI, LW, SW, BEQ, LUI,
    output [2:0] ALUOP
);
    reg [2:0] ALUOPReg;
    assign ALUOP = ALUOPReg;
    always @(*) begin
        if (RType) begin
            ALUOPReg = 3'b000;
        end else if (ORI) begin
            ALUOPReg = 3'b001;
        end else if (LW) begin
            ALUOPReg = 3'b010;
        end else if (SW) begin
            ALUOPReg = 3'b010;
        end else if (BEQ) begin
            ALUOPReg = 3'b011;
        end else if (LUI) begin
            ALUOPReg = 3'b100;
        end else begin
            ALUOPReg = 3'b000;
        end
    end
endmodule



module RegDataSrcDecoder (
    input LW, JAL,
    output [2:0] RegDataSrc
);
    reg [2:0] RegDataSrcReg;
    assign RegDataSrc = RegDataSrcReg;
    always @(*) begin
        if (LW) begin
            RegDataSrcReg = 3'b001;
        end else if (JAL) begin
            RegDataSrcReg = 3'b010;
        end else begin
            RegDataSrcReg = 3'b000;
        end
    end
endmodule



module PCSrcDecoder (
    input Zero, BEQ, JAL, JR, JAS,
    output [2:0] PCSrc
);
    reg [2:0] PCSrcReg;
    assign PCSrc = PCSrcReg;
    always @(*) begin
        if (Zero && BEQ) begin
            PCSrcReg = 3'b001;
        end else if (JAL || JAS) begin
            PCSrcReg = 3'b010;
        end else if (JR) begin
            PCSrcReg = 3'b011;
        end else begin
            PCSrcReg = 3'b000;
        end
    end
endmodule



module RegDstDecoder (
    input RType, JAL,
    output [2:0] RegDst
);
    reg [2:0] RegDstReg;
    assign RegDst = RegDstReg;
    always @(*) begin
        if (RType) begin
            RegDstReg = 3'b001;
        end else if (JAL) begin
            RegDstReg = 3'b010;
        end else begin
            RegDstReg = 3'b000;
        end
    end
endmodule