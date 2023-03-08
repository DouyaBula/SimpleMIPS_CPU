`timescale 1ns / 1ps
`default_nettype none 
module MDUtb;
// module MDU (
//     input wire clk, reset,
//     input wire [31:0] SrcA, SrcB,
//     input wire Start,
//     input wire [3:0] MDUOP,
//     input wire [1:0] ReadHILO,
//     input wire [3:0] Time,
//     input wire Req,

//     output wire Busy,
//     output wire [31:0] MDUResult
// );
    reg clk, reset;
    reg [31:0] SrcA, SrcB;
    reg Start;
    reg [3:0] MDUOP;
    reg [1:0] ReadHILO;
    reg [3:0] Time;
    reg Req;

    wire Busy_Old, Busy_New;
    wire [31:0] MDUResult;
    
    always begin
        #5
        clk = ~clk;
    end
    initial begin
        $fsdbDumpvars();
        clk = 0;
        reset = 1;
        SrcA = 32'h7e2;
        SrcB = 32'h1c7;
        Start = 1;
        MDUOP = 4'b0011;
        ReadHILO = 2'b00;
        Time = 4'd5;
        Req = 0;
        #10
        reset = 0;
        #10
        Start = 0;
        #10000

        $finish;
    end
    MDU New_MDU (
        .clk(clk),
        .reset(reset),
        .SrcA(SrcA),
        .SrcB(SrcB),
        .Start(Start),
        .MDUOP(MDUOP),
        .ReadHILO(ReadHILO),
        .Req(Req),

        .Busy(Busy_New),
        .MDUResult(MDUResult)
    );

    MDU_copy Old_MDU (
        .clk(clk),
        .reset(reset),
        .SrcA(SrcA),
        .SrcB(SrcB),
        .Start(Start),
        .MDUOP(MDUOP),
        .ReadHILO(ReadHILO),
        .Time(Time),
        .Req(Req),

        .Busy(Busy_Old),
        .MDUResult(MDUResult)
    );

endmodule