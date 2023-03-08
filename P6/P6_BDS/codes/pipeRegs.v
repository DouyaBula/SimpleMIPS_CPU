`timescale 1ns / 1ps
`default_nettype none 
module pipeRegD (
    input wire clk, rst, en,
    input wire [31:0] InstrF, PCPlus8F, PCForTestF,

    output reg [31:0] InstrD, PCPlus8D, PCForTestD
);
    always @(posedge clk) begin
        if (rst) begin
            InstrD <= 32'd0;
            PCPlus8D <= 32'd0;
            PCForTestD <= 32'd0;
        end else if (en) begin
            InstrD <= InstrF;
            PCPlus8D <= PCPlus8F;
            PCForTestD <= PCForTestF;
        end
    end
endmodule

module pipeRegE (
    input wire clk, rst,

    input wire [2:0] PCSrcD,
    input wire SignImmD,
    input wire [2:0] ByteEnControlD,
    input wire [2:0] MemDataControlD,
    input wire RegWriteD,
    input wire [2:0] RegDataSrcD,
    input wire [2:0]RegDstD,
    input wire [1:0] TuseD,
    input wire [1:0]TnewD,
    input wire [3:0] ALUControlD,
    input wire ALUSrcD,
    input wire StartD,
    input wire [3:0] MDUOPD,
    input wire [1:0] ReadHILOD,
    input wire [3:0] TimeD,

    input wire [31:0] RD1D,
    input wire [31:0] PCPlus8D,
    input wire [31:0] RD2D,
    input wire [31:0] PCForTestD,
    input wire [31:0] Imm32D,
    input wire [4:0] Instr25_21D,
    input wire [4:0] Instr20_16D,
    input wire [4:0] Instr15_11D,


    output reg [2:0] PCSrcE,
    output reg SignImmE,
    output reg [2:0] ByteEnControlE,
    output reg [2:0] MemDataControlE,
    output reg RegWriteE,
    output reg [2:0] RegDataSrcE,
    output reg [2:0] RegDstE,
    output reg [1:0] TuseE,
    output reg [1:0] TnewE,
    output reg [3:0] ALUControlE,
    output reg ALUSrcE,
    output reg StartE,
    output reg [3:0] MDUOPE,
    output reg [1:0] ReadHILOE,
    output reg [3:0] TimeE,

    output reg [31:0] RD1E,
    output reg [31:0] PCPlus8E,
    output reg [31:0] RD2E,
    output reg [31:0] PCForTestE,
    output reg [31:0] Imm32E,
    output reg [4:0] Instr25_21E,
    output reg [4:0] Instr20_16E,
    output reg [4:0] Instr15_11E
);
    always @(posedge clk) begin
        if (rst) begin
            PCSrcE <= 3'd0;
            SignImmE <= 1'd0;
            ByteEnControlE <= 3'd0;
            MemDataControlE <= 3'd0;
            RegWriteE <= 1'd0;
            RegDataSrcE <= 3'd0;
            RegDstE <= 3'd0;
            TuseE <= 2'd0; 
            TnewE <= 2'd0;
            ALUControlE <= 4'd0;
            ALUSrcE <= 1'd0;
            StartE <= 1'd0;
            MDUOPE <= 4'd0;
            ReadHILOE <= 2'd0;
            TimeE <= 4'd0;

            RD1E <= 32'd0;
            PCPlus8E <= 32'd0;
            RD2E <= 32'd0;
            PCForTestE <= 32'd0;
            Imm32E <= 32'd0;
            Instr25_21E <= 5'd0;
            Instr20_16E <= 5'd0;
            Instr15_11E <= 5'd0;
        end else begin
            PCSrcE <= PCSrcD;
            SignImmE <= SignImmD;
            ByteEnControlE <= ByteEnControlD;
            MemDataControlE <= MemDataControlD;
            RegWriteE <= RegWriteD;
            RegDataSrcE <= RegDataSrcD;
            RegDstE <= RegDstD;
            TuseE <= TuseD; 
            TnewE <= (TnewD == 2'd0) ? 2'd0 : (TnewD - 2'd1); 
            ALUControlE <= ALUControlD;
            ALUSrcE <= ALUSrcD;
            StartE <= StartD;
            MDUOPE <= MDUOPD;
            ReadHILOE <= ReadHILOD;
            TimeE <= TimeD;

            RD1E <= RD1D; 
            PCPlus8E <= PCPlus8D; 
            RD2E <= RD2D; 
            PCForTestE <= PCForTestD; 
            Imm32E <= Imm32D;
            Instr25_21E <= Instr25_21D;
            Instr20_16E <= Instr20_16D;
            Instr15_11E <= Instr15_11D;
        end
    end
endmodule

module pipeRegM (
    input wire clk, rst,
    
    input wire [2:0] PCSrcE,
    input wire SignImmE,
    input wire [2:0] ByteEnControlE,
    input wire [2:0] MemDataControlE,
    input wire RegWriteE,
    input wire [2:0] RegDataSrcE,
    input wire [2:0] RegDstE,
    input wire [1:0] TuseE,
    input wire [1:0] TnewE,
    input wire [3:0] ALUControlE,
    input wire ALUSrcE,
    input wire StartE,
    input wire [3:0] MDUOPE,
    input wire [1:0] ReadHILOE,
    input wire [3:0] TimeE,

    input wire [31:0] ALUResultE,
    input wire [31:0] PCPlus8E,
    input wire [31:0] PCForTestE,
    input wire [31:0] RD2ForwardResultE,
    input wire [4:0] WriteRegE,
    input wire [31:0] MDUResultE,


    output reg [2:0] PCSrcM,
    output reg SignImmM,
    output reg [2:0] ByteEnControlM,
    output reg [2:0] MemDataControlM,
    output reg RegWriteM,
    output reg [2:0] RegDataSrcM,
    output reg [2:0] RegDstM,
    output reg [1:0] TuseM,
    output reg [1:0] TnewM,
    output reg [3:0] ALUControlM,
    output reg ALUSrcM,
    output reg StartM,
    output reg [3:0] MDUOPM,
    output reg [1:0] ReadHILOM,
    output reg [3:0] TimeM,

    output reg [31:0] ALUResultM,
    output reg [31:0] PCPlus8M,
    output reg [31:0] PCForTestM,
    output reg [31:0] RD2ForwardResultM,
    output reg [4:0] WriteRegM,
    output reg [31:0] MDUResultM
);
    always @(posedge clk) begin
        if (rst) begin
            PCSrcM <= 3'd0;
            SignImmM <= 1'd0;
            ByteEnControlM <= 3'd0;
            MemDataControlM <= 3'd0;
            RegWriteM <= 1'd0;
            RegDataSrcM <= 3'd0;
            RegDstM <= 3'd0;
            TuseM <= 2'd0; 
            TnewM <= 2'd0;
            ALUControlM <= 4'd0;
            ALUSrcM <= 1'd0;
            StartM <= 1'd0;
            MDUOPM <= 4'd0;
            ReadHILOM <= 2'd0;
            TimeM <= 4'd0;

            ALUResultM <= 32'd0;
            PCPlus8M <= 32'd0;
            PCForTestM <= 32'd0;
            WriteRegM <= 5'd0;
            RD2ForwardResultM <= 32'd0;
            MDUResultM <= 32'd0;
        end else begin
            PCSrcM <= PCSrcE;
            SignImmM <= SignImmE;
            ByteEnControlM <= ByteEnControlE;
            MemDataControlM <= MemDataControlE;
            RegWriteM <= RegWriteE;
            RegDataSrcM <= RegDataSrcE;
            RegDstM <= RegDstE;
            TuseM <= TuseE; 
            TnewM <= (TnewE == 2'd0) ? 2'd0 : (TnewE - 2'd1); 
            ALUControlM <= ALUControlE;
            ALUSrcM <= ALUSrcE;
            StartM <= StartE;
            MDUOPM <= MDUOPE;
            ReadHILOM <= ReadHILOE;
            TimeM <= TimeE;

            ALUResultM <= ALUResultE;
            PCPlus8M <= PCPlus8E;
            PCForTestM <= PCForTestE;
            WriteRegM <= WriteRegE;
            RD2ForwardResultM <= RD2ForwardResultE;
            MDUResultM <= MDUResultE;
        end
    end    
endmodule

module pipeRegW (
    input wire clk, rst,

    input wire [2:0] RegDataSrcM,
    input wire RegWriteM,
    input wire [1:0] TnewM,
    
    input wire [31:0] ALUResultM,
    input wire [31:0] MemoryDataM,
    input wire [31:0] PCPlus8M,
    input wire [4:0] WriteRegM,
    input wire [31:0] PCForTestM,
    input wire [31:0] MDUResultM,


    output reg [2:0] RegDataSrcW,
    output reg RegWriteW,
    output reg [1:0] TnewW,

    output reg [31:0] ALUResultW,
    output reg [31:0] MemoryDataW,
    output reg [31:0] PCPlus8W,
    output reg [4:0] WriteRegW,
    output reg [31:0] PCForTestW,
    output reg [31:0] MDUResultW
);
    always @(posedge clk) begin
        if (rst) begin
            RegDataSrcW <= 3'd0;
            RegWriteW <= 1'd0;
            TnewW <= 2'd0;
            ALUResultW <= 32'd0;
            MemoryDataW <= 32'd0;
            PCPlus8W <= 32'd0;
            WriteRegW <= 5'd0;
            PCForTestW <= 32'd0;
            MDUResultW <= 32'd0;
        end else begin
            RegDataSrcW <= RegDataSrcM;
            RegWriteW <= RegWriteM;
            TnewW <= (TnewM == 2'd0) ? 2'd0 : (TnewM - 2'd1) ;
            ALUResultW <= ALUResultM;
            MemoryDataW <= MemoryDataM;
            PCPlus8W <= PCPlus8M;
            WriteRegW <= WriteRegM;
            PCForTestW <= PCForTestM;
            MDUResultW <= MDUResultM;
        end
    end
endmodule