`timescale 1ns / 1ps
`default_nettype none 
module MDU (
    input wire clk, reset,
    input wire [31:0] SrcA, SrcB,
    input wire Start,
    input wire [3:0] MDUOP,
    input wire [1:0] ReadHILO,
    input wire [3:0] Time,
    input wire Req,

    output wire Busy,
    output wire [31:0] MDUResult
);
    reg [31:0] SrcASave, SrcBSave;
    reg [3:0] MDUOPSave;
    reg [3:0] TimeLeftHI, TimeLeftLO;
    reg [31:0] HI, LO;
    reg [31:0] HITemp, LOTemp;
    assign MDUResult =  (ReadHILO == 2'b01) ? LO :
                        (ReadHILO == 2'b10) ? HI : 32'd0;

    assign Busy = |TimeLeftHI || |TimeLeftLO  || Start;

    

    always @(*) begin
        if (!Req) begin // TODO: 可能会寄, 寄了再看看 
            case (MDUOP)
                4'b0101: begin
                    TimeLeftHI = 4'd0;
                    HI = SrcA;
                    LO = LO;
                end
                4'b0110: begin
                    TimeLeftLO = 4'd0;
                    HI = HI;
                    LO = SrcA;
                end
            endcase
        end
    end // 中断相应寄存器进程

    always @(posedge clk) begin
        if (reset) begin
            SrcASave <= 32'd0;
            SrcBSave <= 32'd0;
            MDUOPSave <= 4'd0;
            TimeLeftHI <= 4'd0;
            TimeLeftLO <= 4'd0;
            HI <= 32'd0;
            LO <= 32'd0;
            HITemp <= 32'd0;
            LOTemp <= 32'd0;
        end else begin
            if (Start && !Req) begin    // TODO: 可能会寄, 寄了再看看 
                SrcASave <= SrcA;       // "在进入中断或异常状态时，如果受害指令及其后续指令已经改变了 MDU 的状态，则无需恢复。"
                SrcBSave <= SrcB;       
                MDUOPSave <= MDUOP;
                TimeLeftHI <= Time; 
                TimeLeftLO <= Time;
            end else begin
                TimeLeftHI <= (TimeLeftHI == 4'd0) ? 4'd0 : TimeLeftHI - 4'd1;
                TimeLeftLO <= (TimeLeftLO == 4'd0) ? 4'd0 : TimeLeftLO - 4'd1;
                if (TimeLeftHI == 4'd2) begin
                    case (MDUOPSave)
                        4'b0001: begin
                            {HI, LOTemp} <= $signed(SrcASave) * $signed(SrcBSave);
                        end
                        4'b0010: begin
                            {HI, LOTemp} <= SrcASave * SrcBSave;
                        end
                        4'b0011: begin
                            HI <= $signed(SrcASave) % $signed(SrcBSave);
                        end
                        4'b0100: begin
                            HI <= SrcASave % SrcBSave;
                        end
                        default: begin
                            HI <= HI;
                        end
                    endcase
                end
                if (TimeLeftLO == 4'd2) begin
                    case (MDUOPSave)
                        4'b0001: begin
                            {HITemp, LO} <= $signed(SrcASave) * $signed(SrcBSave);
                        end
                        4'b0010: begin
                            {HITemp, LO} <= SrcASave * SrcBSave;
                        end
                        4'b0011: begin
                            LO <= $signed(SrcASave) / $signed(SrcBSave);
                        end
                        4'b0100: begin
                            LO <= SrcASave / SrcBSave;
                        end
                        default: begin
                            LO <= LO;
                        end
                    endcase
                end
            end
        end
    end
endmodule