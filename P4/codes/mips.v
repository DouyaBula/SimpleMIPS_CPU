`timescale 1ns / 1ps
module mips (
    input clk, reset
);
    // ControUnit wires
    wire [2:0] RegDataSrc;
    wire MemWrite;
    wire [2:0] PCSrc;
    wire ALUSrc;
    wire [2:0] RegDst;
    wire RegWrite;
    wire [2:0] ALUControl;
    wire SignImm;
    wire MemDataSrc;
    // IFU wires
    wire [31:0] Instr;
    wire [31:0] PCPlus4;
    wire [31:0] PCForTest;
    // splitter wires
    wire [5:0] Instr31_26;
    wire [5:0] Instr5_0;
    wire [4:0] Instr25_21;
    wire [4:0] Instr20_16;
    wire [4:0] Instr15_11;
    wire [15:0] Instr15_0;
    wire [25:0] Instr25_0;
    // RegAddrMUX wires
    wire [4:0] RegAddr;
    // GRF wires
    wire [31:0] RD1;
    wire [31:0] RD2;
    wire [31:0] GPR29;
    // Imm32MUX wires
    wire [31:0] Imm32;
    // ALU wires
    wire Zero;
    wire [31:0] ALUResult;
    // MemDataSrcMUX
    wire [31:0] Data;
    // DataMem wires
    wire [31:0] MemoryData;
    // RegDataMUX wires
    wire [31:0] RegData;
    ControlUnit ControlUnit_TOP (
        .Zero(Zero), 
        .Opcode(Instr31_26), 
        .Funct(Instr5_0), 
        .RegDataSrc(RegDataSrc), 
        .MemWrite(MemWrite), 
        .PCSrc(PCSrc), 
        .ALUSrc(ALUSrc), 
        .RegDst(RegDst), 
        .RegWrite(RegWrite), 
        .SignImm(SignImm), 
        .ALUControl(ALUControl),
        .MemDataSrc(MemDataSrc)
    );

    
    IFU IFU_TOP(
        .clk(clk), 
        .rst(reset), 
        .Imm32(Imm32), 
        .Instr25_0(Instr25_0), 
        .RD1(RD1), 
        .PCSrc(PCSrc), 
        .Instr(Instr), 
        .PCPlus4(PCPlus4),
        .PCForTest(PCForTest)
    );

    
    splitter splitter_TOP (
        .Instr(Instr), 
        .Instr31_26(Instr31_26), 
        .Instr5_0(Instr5_0), 
        .Instr25_21(Instr25_21), 
        .Instr20_16(Instr20_16), 
        .Instr15_11(Instr15_11), 
        .Instr15_0(Instr15_0), 
        .Instr25_0(Instr25_0)
    );

    MUX8_1 #(.width(5)) RegAddrMUX (
        .slt(RegDst),
        .input0(Instr20_16),
        .input1(Instr15_11),
        .input2(5'h1f),
        .result(RegAddr)
    );

    GRF GRF_TOP (
        .clk(clk), 
        .rst(reset), 
        .WE(RegWrite), 
        .A1(Instr25_21), 
        .A2(Instr20_16), 
        .A3(RegAddr), 
        .WD(RegData), 
        .RD1(RD1), 
        .RD2(RD2),
        .PCForTest(PCForTest),
        .GPR29(GPR29)
    );

    assign Imm32 = SignImm ? {{16{Instr15_0[15]}}, {Instr15_0}} : {16'h0000, {Instr15_0}}; 

    wire [31:0] SrcB;
    assign SrcB = ALUSrc ? Imm32 : RD2;
    ALU ALU_TOP (
        .SrcA(RD1), 
        .SrcB(SrcB), 
        .ALUControl(ALUControl), 
        .Zero(Zero), 
        .ALUResult(ALUResult)
    );

    wire [31:0] addr;
    
    assign addr = MemDataSrc ? GPR29 : ALUResult;

    assign Data = MemDataSrc ? PCPlus4 : RD2;

    RAM DataMem (
        .address(ALUResult), 
        .storeData(Data), 
        .MemWrite(MemWrite), 
        .clk(clk), 
        .rst(reset), 
        .loadData(MemoryData),
        .PCForTest(PCForTest)
    );

    MUX8_1 #(.width(32)) RegDataMUX (
        .slt(RegDataSrc),
        .input0(ALUResult),
        .input1(MemoryData),
        .input2(PCPlus4),
        .result(RegData)
    );
endmodule