`timescale 1ns / 1ps
`default_nettype none
`define ALUType 3'b000
`define MemType 3'b001
`define MDUType 3'b010
`define PC8Type 3'b011
module HazardUnit (
    input wire [1:0] TuseD,
    input wire [4:0] Instr25_21D,
    input wire [4:0] Instr20_16D,

    input wire [1:0] TnewE,
    input wire [4:0] Instr25_21E,
    input wire [4:0] Instr20_16E,
    input wire [4:0] WriteRegE,
    input wire [2:0] RegDataSrcE,

    input wire [1:0] TnewM,
    input wire [4:0] WriteRegM,
    input wire [2:0] RegDataSrcM,

    input wire [1:0] TnewW,
    input wire [4:0] WriteRegW,

    input wire BusyE,
    input wire [3:0] MDUOPD,

    output wire [2:0] RD1ForwardD, RD2ForwardD, RD1ForwardE, RD2ForwardE,
    output wire Stall
);
    reg [2:0] RD1ForwardDReg, RD2ForwardDReg, RD1ForwardEReg, RD2ForwardEReg;
    reg StallReg;
    assign RD1ForwardD = RD1ForwardDReg;
    assign RD2ForwardD = RD2ForwardDReg;
    assign RD1ForwardE = RD1ForwardEReg;
    assign RD2ForwardE = RD2ForwardEReg;
    assign Stall = StallReg || (BusyE && MDUOPD == 4'b1111);
    always @(*) begin
        // GPR Stall
        StallReg = 1'd0;
        if ((TuseD < TnewE) &&
            ((Instr25_21D != 5'd0 && Instr25_21D == WriteRegE) || (Instr20_16D != 5'd0 && Instr20_16D == WriteRegE))) begin
                StallReg = 1'b1;
        end else if ((TuseD < TnewM) &&
            ((Instr25_21D != 5'd0 && Instr25_21D == WriteRegM) || (Instr20_16D != 5'd0 && Instr20_16D == WriteRegM))) begin
                StallReg = 1'b1;
        end 

        // TODO: MD Stall

        // Forward In D
        RD1ForwardDReg = 3'd0;
        if ((TnewE == 2'd0) && (Instr25_21D != 5'd0 && Instr25_21D == WriteRegE)) begin
            case (RegDataSrcE)
                `PC8Type: RD1ForwardDReg = 3'd1; 
            endcase
        end else if ((TnewM == 2'd0) && (Instr25_21D != 5'd0 && Instr25_21D == WriteRegM)) begin
                case (RegDataSrcM)
                    `ALUType: RD1ForwardDReg = 3'd2;
                    `PC8Type: RD1ForwardDReg = 3'd3; 
                    `MDUType: RD1ForwardDReg = 3'd4;
                endcase
        end

        RD2ForwardDReg = 3'd0;
        if ((TnewE == 2'd0) && (Instr20_16D != 5'd0 && Instr20_16D == WriteRegE)) begin
            case (RegDataSrcE)
                `PC8Type: RD2ForwardDReg = 3'd1;
            endcase
        end else if ((TnewM == 2'd0) && (Instr20_16D != 5'd0 && Instr20_16D == WriteRegM)) begin
                case (RegDataSrcM)
                    `ALUType: RD2ForwardDReg = 3'd2;
                    `PC8Type: RD2ForwardDReg = 3'd3;
                    `MDUType: RD2ForwardDReg = 3'd4;
                endcase
        end // else if TnewW == 2'd0 GRF内部转发

        // Forward In E
        RD1ForwardEReg = 3'd0;
        if ((TnewM == 2'd0) && (Instr25_21E != 5'd0 && Instr25_21E == WriteRegM)) begin
            case (RegDataSrcM)
                `ALUType: RD1ForwardEReg = 3'd1;
                `PC8Type: RD1ForwardEReg = 3'd2; 
                `MDUType: RD1ForwardEReg = 3'd3; 
            endcase
        end else if ((TnewW == 2'd0) && (Instr25_21E != 5'd0 && Instr25_21E == WriteRegW)) begin
            RD1ForwardEReg = 3'd4;
        end

        RD2ForwardEReg = 3'd0;
        if ((TnewM == 2'd0) && (Instr20_16E != 5'd0 && Instr20_16E == WriteRegM)) begin
            case (RegDataSrcM)
                `ALUType: RD2ForwardEReg = 3'd1;
                `PC8Type: RD2ForwardEReg = 3'd2; 
                `MDUType: RD2ForwardEReg = 3'd3; 
            endcase
        end else if ((TnewW == 2'd0) && (Instr20_16E != 5'd0 && Instr20_16E == WriteRegW)) begin
            RD2ForwardEReg = 3'd4;
        end
    end
endmodule