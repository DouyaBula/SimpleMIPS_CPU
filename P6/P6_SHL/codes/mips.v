`timescale 1ns / 1ps
`default_nettype none 
module mips(
    input wire clk,
    input wire reset,
    input wire [31:0] i_inst_rdata,
    input wire [31:0] m_data_rdata,

    output wire [31:0] i_inst_addr,
    output wire [31:0] m_data_addr,
    output wire [31:0] m_data_wdata,
    output wire [3 :0] m_data_byteen,
    output wire [31:0] m_inst_addr,
    output wire w_grf_we,
    output wire [4:0] w_grf_addr,
    output wire [31:0] w_grf_wdata,
    output wire [31:0] w_inst_addr
);
    //##### Hazard Unit wires #####//
    wire [2:0] RD1ForwardD, RD2ForwardD, RD1ForwardE, RD2ForwardE;
    wire Stall;

    //##### F wires #####//
    // Imm32ToIFUMUX wires
    wire [31:0] Imm32toIFUF;
    // IFU wires
    wire [31:0] PCPlus8F;
    wire [31:0] PCForTestF;
        assign i_inst_addr = PCForTestF;
    wire [31:0] InstrF;
        assign InstrF = i_inst_rdata;
    
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
    wire [2:0] PCSrcD;
    wire [2:0] CMPD;
    wire SignImmD;
    wire [2:0] ByteEnControlD;
    wire [2:0] MemDataControlD;
    wire RegWriteD;
    wire [2:0] RegDataSrcD;
    wire [2:0] RegDstD;
    wire [1:0] TuseD;
    wire [1:0] TnewD;
    wire [3:0] ALUControlD;
    wire ALUSrcD;
    wire StartD;
    wire [3:0] MDUOPD;
    wire [1:0] ReadHILOD;
    wire [3:0] TimeD;
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
    wire [2:0] PCSrcE;
    wire SignImmE;
    wire [2:0] ByteEnControlE;
    wire [2:0] MemDataControlE;
    wire RegWriteE;
    wire [2:0] RegDataSrcE;
    wire [2:0] RegDstE;
    wire [1:0] TuseE;
    wire [1:0] TnewE;
    wire [3:0] ALUControlE;
    wire ALUSrcE;
    wire StartE;
    wire [3:0] MDUOPE;
    wire [1:0] ReadHILOE;
    wire [3:0] TimeE;

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
    // MDU wires
    wire BusyE;
    wire [31:0] MDUResultE;

    //##### M wires #####//
    // pipeRegM wires
    wire [2:0] PCSrcM;
    wire SignImmM;
    wire [2:0] ByteEnControlM;
    wire [2:0] MemDataControlM;
    wire RegWriteM;
    wire [2:0] RegDataSrcM;
    wire [2:0] RegDstM;
    wire [1:0] TuseM;
    wire [1:0] TnewM;
    wire [3:0] ALUControlM;
    wire ALUSrcM;
    wire StartM;
    wire [3:0] MDUOPM;
    wire [1:0] ReadHILOM;
    wire [3:0] TimeM;

    wire [31:0] ALUResultM;
    wire [31:0] PCPlus8M;
    wire [31:0] PCForTestM;
    wire [4:0] WriteRegM;
    wire [31:0] RD2ForwardResultM;
    wire [31:0] MDUResultM;
    // ByteEn wires
    wire [3:0] ByteEnM;
    wire [31:0] FixRD2ForwardResultM;
        assign m_data_addr = ALUResultM;
        assign m_data_wdata = FixRD2ForwardResultM;
        assign m_data_byteen = ByteEnM;
        assign m_inst_addr = PCForTestM;
    // MemDataFix wires
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
    wire [31:0] MDUResultW;
    // RegDataMUX wires
    wire [31:0] RegDataW;
        assign w_grf_we = RegWriteW;
        assign w_grf_addr = WriteRegW;
        assign w_grf_wdata = RegDataW;
        assign w_inst_addr = PCForTestW;



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
        .BusyE(BusyE),
        .MDUOPD(MDUOPD),

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
        .Opcode(Instr31_26D), 
        .Funct(Instr5_0D), 
        
        .PCSrc(PCSrcD),
        .CMP(CMPD),
        .SignImm(SignImmD),
        .ByteEnControl(ByteEnControlD),
        .MemDataControl(MemDataControlD),
        .RegWrite(RegWriteD),
        .RegDataSrc(RegDataSrcD),
        .RegDst(RegDstD),
        .Tuse(TuseD),
        .TnewD(TnewD),
        .ALUControl(ALUControlD),
        .ALUSrc(ALUSrcD),
        .Start(StartD),
        .MDUOP(MDUOPD),
        .ReadHILO(ReadHILOD),
        .Time(TimeD)
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

    assign RD1ForwardResultD =  (RD1ForwardD == 3'd0) ? RD1D :
                                (RD1ForwardD == 3'd1) ? PCPlus8E :
                                (RD1ForwardD == 3'd2) ? ALUResultM :
                                (RD1ForwardD == 3'd3) ? PCPlus8M :
                                (RD1ForwardD == 3'd4) ? MDUResultM : 32'h1234;
    
    assign RD2ForwardResultD =  (RD2ForwardD == 3'd0) ? RD2D :
                                (RD2ForwardD == 3'd1) ? PCPlus8E :
                                (RD2ForwardD == 3'd2) ? ALUResultM :
                                (RD2ForwardD == 3'd3) ? PCPlus8M :
                                (RD2ForwardD == 3'd4) ? MDUResultM : 32'h2345;

    assign BranchConditionD =   (CMPD == 3'b000)? (RD1ForwardResultD == RD2ForwardResultD) :
                                (CMPD == 3'b001)? (RD1ForwardResultD != RD2ForwardResultD) : 1'b0;

    ////////////// EEEEE //////////////
    pipeRegE pipeRegE_TOP (
        .clk(clk),
        .rst(reset || Stall),

        .PCSrcD(PCSrcD),
        .SignImmD(SignImmD),
        .ByteEnControlD(ByteEnControlD),
        .MemDataControlD(MemDataControlD),
        .RegWriteD(RegWriteD),
        .RegDataSrcD(RegDataSrcD),
        .RegDstD(RegDstD),
        .TuseD(TuseD), 
        .TnewD(TnewD),
        .ALUControlD(ALUControlD),
        .ALUSrcD(ALUSrcD),
        .StartD(StartD),
        .MDUOPD(MDUOPD),
        .ReadHILOD(ReadHILOD),
        .TimeD(TimeD),
        
        .RD1D(RD1D),
        .PCPlus8D(PCPlus8D),
        .RD2D(RD2D),
        .PCForTestD(PCForTestD),
        .Imm32D(Imm32D),
        .Instr25_21D(Instr25_21D),
        .Instr20_16D(Instr20_16D),
        .Instr15_11D(Instr15_11D),


        .PCSrcE(PCSrcE),
        .SignImmE(SignImmE),
        .ByteEnControlE(ByteEnControlE),
        .MemDataControlE(MemDataControlE),
        .RegWriteE(RegWriteE),
        .RegDataSrcE(RegDataSrcE),
        .RegDstE(RegDstE),
        .TuseE(TuseE), 
        .TnewE(TnewE),
        .ALUControlE(ALUControlE),
        .ALUSrcE(ALUSrcE),
        .StartE(StartE),
        .MDUOPE(MDUOPE),
        .ReadHILOE(ReadHILOE),
        .TimeE(TimeE),

        .RD1E(RD1E),
        .PCPlus8E(PCPlus8E),
        .RD2E(RD2E),
        .PCForTestE(PCForTestE),
        .Imm32E(Imm32E),
        .Instr25_21E(Instr25_21E),
        .Instr20_16E(Instr20_16E),
        .Instr15_11E(Instr15_11E)
    );

    assign RD1ForwardResultE =  (RD1ForwardE == 3'd0) ? RD1E :
                                (RD1ForwardE == 3'd1) ? ALUResultM :
                                (RD1ForwardE == 3'd2) ? PCPlus8M :
                                (RD1ForwardE == 3'd3) ? MDUResultM : 
                                (RD1ForwardE == 3'd4) ? RegDataW : 32'h3456;
    
    assign RD2ForwardResultE =  (RD2ForwardE == 3'd0) ? RD2E :
                                (RD2ForwardE == 3'd1) ? ALUResultM :
                                (RD2ForwardE == 3'd2) ? PCPlus8M :
                                (RD2ForwardE == 3'd3) ? MDUResultM : 
                                (RD2ForwardE == 3'd4) ? RegDataW : 32'h789a;

    assign RegAddrE =   (RegDstE == 3'b000) ? Instr20_16E :
                        (RegDstE == 3'b001) ? Instr15_11E :
                        (RegDstE == 3'b010) ? 5'd31 : 5'bxxxxx; 

    assign SrcBE = ALUSrcE ? Imm32E : RD2ForwardResultE;

    assign WriteRegE = RegWriteE ? RegAddrE : 5'd0;

    ALU ALU_TOP (
        .SrcA(RD1ForwardResultE), 
        .SrcB(SrcBE), 
        .ALUControl(ALUControlE), 
        
        .ALUResult(ALUResultE)
    );

    MDU MDU_TOP (
        .clk(clk),
        .reset(reset),
        .SrcA(RD1ForwardResultE),
        .SrcB(RD2ForwardResultE),
        .Start(StartE),
        .MDUOP(MDUOPE),
        .ReadHILO(ReadHILOE),
        .Time(TimeE),

        .Busy(BusyE),
        .MDUResult(MDUResultE)
    );

    ////////////// MMMMM //////////////
    pipeRegM pipeRegM_TOP (
        .clk(clk),
        .rst(reset),

        .PCSrcE(PCSrcE),
        .SignImmE(SignImmE),
        .ByteEnControlE(ByteEnControlE),
        .MemDataControlE(MemDataControlE),
        .RegWriteE(RegWriteE),
        .RegDataSrcE(RegDataSrcE),
        .RegDstE(RegDstE),
        .TuseE(TuseE), 
        .TnewE(TnewE),
        .ALUControlE(ALUControlE),
        .ALUSrcE(ALUSrcE),
        .StartE(StartE),
        .MDUOPE(MDUOPE),
        .ReadHILOE(ReadHILOE),
        .TimeE(TimeE),
        
        .ALUResultE(ALUResultE),
        .PCPlus8E(PCPlus8E),
        .PCForTestE(PCForTestE),
        .RD2ForwardResultE(RD2ForwardResultE),
        .WriteRegE(WriteRegE),
        .MDUResultE(MDUResultE),


        .PCSrcM(PCSrcM),
        .SignImmM(SignImmM),
        .ByteEnControlM(ByteEnControlM),
        .MemDataControlM(MemDataControlM),
        .RegWriteM(RegWriteM),
        .RegDataSrcM(RegDataSrcM),
        .RegDstM(RegDstM),
        .TuseM(TuseM), 
        .TnewM(TnewM),
        .ALUControlM(ALUControlM),
        .ALUSrcM(ALUSrcM),
        .StartM(StartM),
        .MDUOPM(MDUOPM),
        .ReadHILOM(ReadHILOM),
        .TimeM(TimeM),

        .ALUResultM(ALUResultM),
        .PCPlus8M(PCPlus8M),
        .PCForTestM(PCForTestM),
        .RD2ForwardResultM(RD2ForwardResultM),
        .WriteRegM(WriteRegM),
        .MDUResultM(MDUResultM)
    );

    ByteEn ByteEn_TOP (
        .ByteEnControl(ByteEnControlM),
        .ALUResult(ALUResultM),
        .RD2ForwardResult(RD2ForwardResultM),

        .ByteEn(ByteEnM),
        .FixRD2ForwardResult(FixRD2ForwardResultM)
    );

    MemDataFix MemDataFix_TOP (
        .ALUResult(ALUResultM),
        .MemDataControl(MemDataControlM),
        .RawMemoryData(m_data_rdata),

        .MemoryData(MemoryDataM)
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
        .MDUResultM(MDUResultM),

        .RegDataSrcW(RegDataSrcW),
        .RegWriteW(RegWriteW),
        .TnewW(TnewW),
        .ALUResultW(ALUResultW),
        .MemoryDataW(MemoryDataW),
        .PCPlus8W(PCPlus8W),
        .WriteRegW(WriteRegW),
        .PCForTestW(PCForTestW),
        .MDUResultW(MDUResultW)
    );

    assign RegDataW =   (RegDataSrcW == 3'b000) ? ALUResultW :
                        (RegDataSrcW == 3'b001) ? MemoryDataW :
                        (RegDataSrcW == 3'b010) ? MDUResultW :
                        (RegDataSrcW == 3'b011) ? PCPlus8W : 32'h0000;

endmodule