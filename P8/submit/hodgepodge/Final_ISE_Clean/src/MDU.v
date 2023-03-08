`timescale 1ns / 1ps
`default_nettype none 

`define MULT 4'b0001
`define MULTU 4'b0010
`define DIV 4'b0011
`define DIVU 4'b0100

module MDU (
    input wire clk, reset,
    input wire [31:0] SrcA, SrcB,
    input wire Start,
    input wire [3:0] MDUOP,
    input wire [1:0] ReadHILO,
    input wire Req,

    output wire Busy,
    output wire [31:0] MDUResult
);
    reg [31:0] HI, LO;

    wire [31:0] in_src0, in_src1;
    wire [1:0] in_op;
    wire in_sign, in_ready, in_valid, out_ready, out_valid;
    wire [31:0] out_res0, out_res1;


    assign in_src0 = SrcA;
    assign in_src1 = SrcB;
    // Ω‚Œˆ÷¡in_op, in_sign, in_valid
    assign in_op =  ((MDUOP == `MULT) || (MDUOP == `MULTU)) ? 2'b01 :
                    ((MDUOP == `DIV) || (MDUOP == `DIVU)) ? 2'b10 : 2'b00;
    assign in_sign =    (MDUOP == `MULTU) || (MDUOP == `DIVU) ? 1'b0 :
                        (MDUOP == `MULT) || (MDUOP == `DIV) ? 1'b1 : 1'b0;
    assign in_valid = Start & !Req;

    assign out_ready = 1'b1;

    MulDivUnit __MulDivUnit (
        .clk(clk),
        .reset(reset),
        .in_src0(in_src0),
        .in_src1(in_src1),
        .in_op(in_op),
        .in_sign(in_sign),
        .in_valid(in_valid),
        .out_ready(out_ready),

        .in_ready(in_ready),
        .out_valid(out_valid),
        .out_res0(out_res0),
        .out_res1(out_res1)
    );

    assign Busy = !in_ready | Start;
    always @(posedge clk) begin
        if (reset) begin
            HI <= 32'd0;
            LO <= 32'd0;
        end else if (out_valid) begin
            HI <= out_res1;
            LO <= out_res0;
        end
    end
    assign MDUResult =  (!Req && (ReadHILO == 2'b10)) ? HI :
                        (!Req && (ReadHILO == 2'b01)) ? LO : 32'd0;
endmodule