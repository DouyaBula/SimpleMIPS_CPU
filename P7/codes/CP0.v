`timescale 1ns / 1ps
`default_nettype none 
`include "macros.v"
`define SR_IM SR[15:10]
`define SR_EXL SR[1]
`define SR_IE SR[0]
`define Cause_BD Cause[31]
`define Cause_IP Cause[15:10]
`define Cause_ExcCode Cause[6:2]
module CP0 (
    input wire clk,
    input wire reset,
    input wire en,
    input wire [4:0] CP0Add,
    input wire [31:0] CP0In,
    input wire [31:0] VPC,
    input wire BDIn,
    input wire [4:0] ExcCodeIn,
    input wire [5:0] HWInt,
    input wire EXLClr,
    
    output wire [31:0] CP0Out,
    output wire [31:0] EPCOut,
    output wire Req,
    output wire tbReq
);
    reg [31:0] SR, Cause, EPC;
    wire EXC;
    wire INT;
    assign EXC = !`SR_EXL && (ExcCodeIn != `None);
    assign INT = !`SR_EXL && `SR_IE && (|(`SR_IM & HWInt));


    assign CP0Out = (CP0Add == 5'd12) ? SR :
                    (CP0Add == 5'd13) ? Cause :
                    (CP0Add == 5'd14) ? EPC : 32'd0;
    assign EPCOut = EPC;
    assign Req = EXC | INT; 
    assign tbReq = !`SR_EXL && `SR_IE && (|(SR[12] & HWInt[2]));


    always @(posedge clk) begin
        if (reset) begin    // TODO: 要异步?
            SR <= 32'd0;
            Cause <= 32'd0;
            EPC <= 32'd0;
        end else begin
            if (!Req & en) begin
                case (CP0Add)
                    5'd12: begin
                        SR <= CP0In;
                    end
                    // 5'd13: begin
                    //     Cause <= CP0In;
                    // end
                    // 教程"P7提交要求"小节: 测试程序保证不会写入Cause
                    5'd14: begin
                        EPC <= CP0In;
                    end 
                endcase
            end else begin
                EPC <=  (Req) ? ((BDIn) ? (VPC - 32'd4) : VPC) : EPC;
            end
            `SR_EXL <=  (EXLClr) ? 1'd0 : 
                        (Req) ? 1'd1 : `SR_EXL;
            `Cause_BD <= (Req) ? BDIn : `Cause_BD;
            `Cause_IP <= HWInt;
            `Cause_ExcCode <=   (INT) ? 5'd0 :
                                (EXC) ? ExcCodeIn :
                                 `Cause_ExcCode;  // TODO: 可能会寄
                                                  // 草, 还真寄在这了. 
                                                  // "中断优先级高于异常优先级" 是要在写EXCODE的时候特殊处理
        end
    end

endmodule