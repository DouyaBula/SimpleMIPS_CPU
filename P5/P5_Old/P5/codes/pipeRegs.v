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
    input wire [2:0] RegDataSrcD,
    input wire MemWriteD,
    input wire ALUSrcD,
    input wire [2:0] RegDstD,
    input wire RegWriteD,
    input wire [2:0] ALUControlD,
    input wire [1:0] TnewD,
    input wire [31:0] RD1D,
    input wire [31:0] PCPlus8D,
    input wire [31:0] RD2D,
    input wire [31:0] PCForTestD,
    input wire [31:0] Imm32D,
    input wire [4:0] Instr25_21D,
    input wire [4:0] Instr20_16D,
    input wire [4:0] Instr15_11D,

    output reg [2:0] RegDataSrcE,
    output reg MemWriteE,
    output reg ALUSrcE,
    output reg [2:0] RegDstE,
    output reg RegWriteE,
    output reg [2:0] ALUControlE,
    output reg [1:0] TnewE,
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
            RegDataSrcE <= 3'd0;
            MemWriteE <= 1'd0;
            ALUSrcE <= 1'd0;
            RegDstE <= 3'd0;
            RegWriteE <= 1'd0;
            ALUControlE <= 3'd0;
            TnewE <= 2'd0;
            RD1E <= 32'd0;
            PCPlus8E <= 32'd0;
            RD2E <= 32'd0;
            PCForTestE <= 32'd0;
            Imm32E <= 32'd0;
            Instr25_21E <= 5'd0;
            Instr20_16E <= 5'd0;
            Instr15_11E <= 5'd0;
        end else begin
            RegDataSrcE <= RegDataSrcD;
            MemWriteE <= MemWriteD; 
            ALUSrcE <= ALUSrcD; 
            RegDstE <= RegDstD; 
            RegWriteE <= RegWriteD; 
            ALUControlE <= ALUControlD; 
            TnewE <= (TnewD == 2'd0) ? 2'd0 : (TnewD - 2'd1); 
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
    input wire [2:0] RegDataSrcE,
    input wire MemWriteE,
    input wire RegWriteE,
    input wire [1:0] TnewE,
    input wire [31:0] ALUResultE,
    input wire [31:0] PCPlus8E,
    input wire [31:0] PCForTestE,
    input wire [31:0] RD2ForwardResultE,
    input wire [4:0] WriteRegE,

    output reg [2:0] RegDataSrcM,
    output reg MemWriteM,
    output reg RegWriteM,
    output reg [1:0] TnewM,
    output reg [31:0] ALUResultM,
    output reg [31:0] PCPlus8M,
    output reg [31:0] PCForTestM,
    output reg [31:0] RD2ForwardResultM,
    output reg [4:0] WriteRegM
);
    always @(posedge clk) begin
        if (rst) begin
            RegDataSrcM <= 3'd0;
            MemWriteM <= 1'd0;
            RegWriteM <= 1'd0;
            TnewM <= 2'd0;
            ALUResultM <= 32'd0;
            PCPlus8M <= 32'd0;
            PCForTestM <= 32'd0;
            WriteRegM <= 5'd0;
            RD2ForwardResultM <= 32'd0;
        end else begin
            RegDataSrcM <= RegDataSrcE;
            MemWriteM <= MemWriteE;
            RegWriteM <= RegWriteE;
            TnewM <= (TnewE == 2'd0) ? 2'd0 : (TnewE - 2'd1);
            ALUResultM <= ALUResultE;
            PCPlus8M <= PCPlus8E;
            PCForTestM <= PCForTestE;
            WriteRegM <= WriteRegE;
            RD2ForwardResultM <= RD2ForwardResultE;
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

    output reg [2:0] RegDataSrcW,
    output reg RegWriteW,
    output reg [1:0] TnewW,
    output reg [31:0] ALUResultW,
    output reg [31:0] MemoryDataW,
    output reg [31:0] PCPlus8W,
    output reg [4:0] WriteRegW,
    output reg [31:0] PCForTestW
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
        end else begin
            RegDataSrcW <= RegDataSrcM;
            RegWriteW <= RegWriteM;
            TnewW <= (TnewM == 2'd0) ? 2'd0 : (TnewM - 2'd1) ;
            ALUResultW <= ALUResultM;
            MemoryDataW <= MemoryDataM;
            PCPlus8W <= PCPlus8M;
            WriteRegW <= WriteRegM;
            PCForTestW <= PCForTestM;
        end
    end
endmodule