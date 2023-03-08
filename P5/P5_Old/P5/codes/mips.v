`timescale 1ns / 1ps
`default_nettype none 
module mips (
    input wire clk, reset
);
    //##### Hazard Unit wires #####//
    wire [2:0] RD1ForwardD, RD2ForwardD, RD1ForwardE, RD2ForwardE;
    wire Stall;

    //##### F wires #####//
    // Imm32ToIFUMUX wires
    wire [31:0] Imm32toIFUF;
    // IFU wires
    wire [31:0] InstrF;
    wire [31:0] PCPlus8F;
    wire [31:0] PCForTestF;

    //##### D wires #####//
    // pipeRegD wires
    wire [31:0] InstrD;
    wire [31:0] PCPlus8D;
    wire [31:0] PCForTestD;
    // splitter wires
    wire [5:0] Instr31_26D;
    wire [5:0] Instr5_0D;
    wire [4:0] Instr25_21D;
    wire [4:0] Instr20_16D;
    wire [4:0] Instr15_11D;
    wire [15:0] Instr15_0D;
    wire [25:0] Instr25_0D;
    // Imm32MUX wires
    wire [31:0] Imm32D;
    // ControUnit wires
    wire [2:0] RegDataSrcD;
    wire MemWriteD;
    wire [2:0] PCSrcD;
    wire ALUSrcD;
    wire [2:0] RegDstD;
    wire RegWriteD;
    wire [2:0] ALUControlD;
    wire SignImmD;
    wire [1:0] TuseD;
    wire [1:0] TnewD;
    // GRF wires
    wire [31:0] RD1D;
    wire [31:0] RD2D;
    // RD1ForwardDMUX wires
    wire [31:0] RD1ForwardResultD;
    // RD2ForwardDMUX wires
    wire [31:0] RD2ForwardResultD;
    // Comparator wires
    wire BranchConditionD;

    //##### E wires #####//
    // pipeRegE wires
    wire [2:0] RegDataSrcE;
    wire MemWriteE;
    wire ALUSrcE;
    wire [2:0] RegDstE;
    wire RegWriteE;
    wire [2:0] ALUControlE;
    wire [1:0] TnewE;
    wire [31:0] RD1E;
    wire [31:0] PCPlus8E;
    wire [31:0] RD2E;
    wire [31:0] PCForTestE;
    wire [31:0] Imm32E;
    wire [4:0] Instr25_21E;
    wire [4:0] Instr20_16E;
    wire [4:0] Instr15_11E;
    // RD1ForwardEMUX wires
    wire [31:0] RD1ForwardResultE;
    // RD2ForwardEMUX wires
    wire [31:0] RD2ForwardResultE;
    // RegAddrMUX wires
    wire [4:0] RegAddrE;
    // ALUSrcBMUX wires
    wire [31:0] SrcBE;
    // WriteRegEMUX wires
    wire [4:0] WriteRegE;
    // ALU wires
    wire [31:0] ALUResultE;

    //##### M wires #####//
    // pipeRegM wires
    wire [2:0] RegDataSrcM;
    wire MemWriteM;
    wire RegWriteM;
    wire [1:0] TnewM;
    wire [31:0] ALUResultM;
    wire [31:0] PCPlus8M;
    wire [31:0] PCForTestM;
    wire [4:0] WriteRegM;
    wire [31:0] RD2ForwardResultM;
    // DataMem wires
    wire [31:0] MemoryDataM;

    //##### W wires #####//
    // pipeRegW wires
    wire [2:0] RegDataSrcW;
    wire RegWriteW;
    wire [1:0] TnewW;
    wire [31:0] ALUResultW;
    wire [31:0] MemoryDataW;
    wire [31:0] PCPlus8W;
    wire [4:0] WriteRegW;
    wire [31:0] PCForTestW;
    // RegDataMUX wires
    wire [31:0] RegDataW;



    /////////// Hazard Unit ///////////
    HazardUnit HazardUnit_TOP(
        .TuseD(TuseD),
        .Instr25_21D(Instr25_21D),
        .Instr20_16D(Instr20_16D),
        .TnewE(TnewE),
        .Instr25_21E(Instr25_21E),
        .Instr20_16E(Instr20_16E),
        .WriteRegE(WriteRegE),
        .RegDataSrcE(RegDataSrcE),
        .TnewM(TnewM),
        .WriteRegM(WriteRegM),
        .RegDataSrcM(RegDataSrcM),
        .TnewW(TnewW),
        .WriteRegW(WriteRegW),

        .RD1ForwardD(RD1ForwardD),
        .RD2ForwardD(RD2ForwardD),
        .RD1ForwardE(RD1ForwardE),
        .RD2ForwardE(RD2ForwardE),
        .Stall(Stall)
    );

    ////////////// FFFFF //////////////
    assign Imm32toIFUF = BranchConditionD ? Imm32D : 32'd1;

    IFU IFU_TOP(
        .clk(clk), 
        .rst(reset), 
        .en(!Stall),
        .Imm32(Imm32toIFUF), 
        .Instr25_0(Instr25_0D), 
        .RD1(RD1ForwardResultD), 
        .PCSrc(PCSrcD),

        .Instr(InstrF), 
        .PCPlus8(PCPlus8F),
        .PCForTest(PCForTestF)
    );

    ////////////// DDDDD //////////////
    pipeRegD pipeRegD_TOP (
        .clk(clk),
        .rst(reset),
        .en(!Stall),
        .InstrF(InstrF),
        .PCPlus8F(PCPlus8F),
        .PCForTestF(PCForTestF),

        .InstrD(InstrD),
        .PCPlus8D(PCPlus8D),
        .PCForTestD(PCForTestD)
    );

    splitter splitter_TOP (
        .Instr(InstrD), 

        .Instr31_26(Instr31_26D), 
        .Instr5_0(Instr5_0D), 
        .Instr25_21(Instr25_21D), 
        .Instr20_16(Instr20_16D), 
        .Instr15_11(Instr15_11D), 
        .Instr15_0(Instr15_0D), 
        .Instr25_0(Instr25_0D)
    );

    assign Imm32D = SignImmD ? {{16{Instr15_0D[15]}}, {Instr15_0D}} : {16'h0000, {Instr15_0D}}; 
    
    ControlUnit ControlUnit_TOP (
        .Instr(InstrD),
        .Zero(BranchConditionD), 
        .Opcode(Instr31_26D), 
        .Funct(Instr5_0D), 
        
        .RegDataSrc(RegDataSrcD), 
        .MemWrite(MemWriteD), 
        .PCSrc(PCSrcD), 
        .ALUSrc(ALUSrcD), 
        .RegDst(RegDstD), 
        .RegWrite(RegWriteD), 
        .ALUControl(ALUControlD),
        .SignImm(SignImmD),
        .TuseD(TuseD),
        .TnewD(TnewD)
    );    

    GRF GRF_TOP (
        .clk(clk), 
        .rst(reset), 
        .WE(RegWriteW), 
        .A1(Instr25_21D), 
        .A2(Instr20_16D), 
        .A3(WriteRegW), 
        .WD(RegDataW), 
        .PCForTest(PCForTestW),

        .RD1(RD1D), 
        .RD2(RD2D)
    );


    MUX8_1 #(.width(32)) RD1ForwardDMUX (
        .slt(RD1ForwardD),
        .input0(RD1D),
        .input1(PCPlus8E),
        .input2(ALUResultM),
        .input3(PCPlus8M),

        .result(RD1ForwardResultD)
    );

    MUX8_1 #(.width(32)) RD2ForwardDMUX (
        .slt(RD2ForwardD),
        .input0(RD2D),
        .input1(PCPlus8E),
        .input2(ALUResultM),
        .input3(PCPlus8M),

        .result(RD2ForwardResultD)
    );

    assign BranchConditionD = (RD1ForwardResultD == RD2ForwardResultD);

    ////////////// EEEEE //////////////
    pipeRegE pipeRegE_TOP (
        .clk(clk),
        .rst(reset || Stall),
        .RegDataSrcD(RegDataSrcD),
        .MemWriteD(MemWriteD),
        .ALUSrcD(ALUSrcD),
        .RegDstD(RegDstD),
        .RegWriteD(RegWriteD),
        .ALUControlD(ALUControlD),
        .TnewD(TnewD),
        .RD1D(RD1D),
        .PCPlus8D(PCPlus8D),
        .RD2D(RD2D),
        .PCForTestD(PCForTestD),
        .Imm32D(Imm32D),
        .Instr25_21D(Instr25_21D),
        .Instr20_16D(Instr20_16D),
        .Instr15_11D(Instr15_11D),

        .RegDataSrcE(RegDataSrcE),
        .MemWriteE(MemWriteE),
        .ALUSrcE(ALUSrcE),
        .RegDstE(RegDstE),
        .RegWriteE(RegWriteE),
        .ALUControlE(ALUControlE),
        .TnewE(TnewE),
        .RD1E(RD1E),
        .PCPlus8E(PCPlus8E),
        .RD2E(RD2E),
        .PCForTestE(PCForTestE),
        .Imm32E(Imm32E),
        .Instr25_21E(Instr25_21E),
        .Instr20_16E(Instr20_16E),
        .Instr15_11E(Instr15_11E)
    );

    MUX8_1 #(.width(32)) RD1ForwardEMUX (
        .slt(RD1ForwardE),
        .input0(RD1E),
        .input1(ALUResultM),
        .input2(PCPlus8M),
        .input7(RegDataW),
        
        .result(RD1ForwardResultE)
    );

    MUX8_1 #(.width(32)) RD2ForwardEMUX (
        .slt(RD2ForwardE),
        .input0(RD2E),
        .input1(ALUResultM),
        .input2(PCPlus8M),
        .input7(RegDataW),

        .result(RD2ForwardResultE)
    );

    MUX8_1 #(.width(5)) RegAddrEMUX (
        .slt(RegDstE),
        .input0(Instr20_16E),
        .input1(Instr15_11E),
        .input2(5'h1f),

        .result(RegAddrE)
    );

    assign SrcBE = ALUSrcE ? Imm32E : RD2ForwardResultE;

    assign WriteRegE = RegWriteE ? RegAddrE : 5'd0;

    ALU ALU_TOP (
        .SrcA(RD1ForwardResultE), 
        .SrcB(SrcBE), 
        .ALUControl(ALUControlE), 
        
        .ALUResult(ALUResultE)
    );

    ////////////// MMMMM //////////////
    pipeRegM pipeRegM_TOP (
        .clk(clk),
        .rst(reset),
        .RegDataSrcE(RegDataSrcE),
        .MemWriteE(MemWriteE),
        .RegWriteE(RegWriteE),
        .TnewE(TnewE),
        .ALUResultE(ALUResultE),
        .PCPlus8E(PCPlus8E),
        .PCForTestE(PCForTestE),
        .RD2ForwardResultE(RD2ForwardResultE),
        .WriteRegE(WriteRegE),

        .RegDataSrcM(RegDataSrcM),
        .MemWriteM(MemWriteM),
        .RegWriteM(RegWriteM),
        .TnewM(TnewM),
        .ALUResultM(ALUResultM),
        .PCPlus8M(PCPlus8M),
        .PCForTestM(PCForTestM),
        .RD2ForwardResultM(RD2ForwardResultM),
        .WriteRegM(WriteRegM)      
    );

    RAM DataMem (
        .clk(clk), 
        .rst(reset), 
        .MemWrite(MemWriteM), 
        .address(ALUResultM), 
        .storeData(RD2ForwardResultM), 
        .PCForTest(PCForTestM),

        .loadData(MemoryDataM)
    );

    ////////////// WWWWW //////////////
    pipeRegW pipeRegW_TOP (
        .clk(clk),
        .rst(reset),
        .RegDataSrcM(RegDataSrcM),
        .RegWriteM(RegWriteM),
        .TnewM(TnewM),
        .ALUResultM(ALUResultM),
        .MemoryDataM(MemoryDataM),
        .PCPlus8M(PCPlus8M),
        .WriteRegM(WriteRegM),
        .PCForTestM(PCForTestM),

        .RegDataSrcW(RegDataSrcW),
        .RegWriteW(RegWriteW),
        .TnewW(TnewW),
        .ALUResultW(ALUResultW),
        .MemoryDataW(MemoryDataW),
        .PCPlus8W(PCPlus8W),
        .WriteRegW(WriteRegW),
        .PCForTestW(PCForTestW)
    );

    MUX8_1 #(.width(32)) RegDataMUX (
        .slt(RegDataSrcW),
        .input0(ALUResultW),
        .input1(MemoryDataW),
        .input2(PCPlus8W),

        .result(RegDataW)
    );

endmodule