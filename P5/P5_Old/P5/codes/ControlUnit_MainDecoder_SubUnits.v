`timescale 1ns / 1ps
`default_nettype none 
module ALUOPDecoder (
    input wire RType, ORI, LW, SW, BEQ, LUI,
    output wire [2:0] ALUOP
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
    input wire LW, JAL,
    output wire [2:0] RegDataSrc
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
    input wire Zero, BEQ, JAL, JR,
    output wire [2:0] PCSrc
);
    reg [2:0] PCSrcReg;
    assign PCSrc = PCSrcReg;
    always @(*) begin
        if (BEQ) begin
            PCSrcReg = 3'b001;
        end else if (JAL) begin
            PCSrcReg = 3'b010;
        end else if (JR) begin
            PCSrcReg = 3'b011;
        end else begin
            PCSrcReg = 3'b000;
        end
    end
endmodule



module RegDstDecoder (
    input wire RType, JAL,
    output wire [2:0] RegDst
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

module TimeDecoder (
    input wire RType, ORI, LW, SW, BEQ, LUI, JAL, JR,
    output wire [1:0] TuseD, TnewD
);
    reg [1:0] TuseDReg, TnewDReg;
    assign TuseD = TuseDReg;
    assign TnewD = TnewDReg;
    always @(*) begin
        if (RType) begin
            TuseDReg = JR ? 2'd0 : 2'd1;
        end else if (BEQ) begin
            TuseDReg = 2'd0;
        end else if (ORI || LW || SW || LUI) begin
            TuseDReg = 2'd1;
        end else if (JAL) begin
            TuseDReg = 2'd3;
        end

        if (RType) begin
            TnewDReg = JR ? 2'd0 : 2'd2;
        end else if (SW || BEQ || JAL) begin
            TnewDReg = 2'd0;
        end else if (ORI || LUI) begin
            TnewDReg = 2'd2;
        end else if (LW) begin
            TnewDReg = 2'd3;
        end
    end
endmodule