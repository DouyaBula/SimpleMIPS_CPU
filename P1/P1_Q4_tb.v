`timescale 1ns/1ps
module tb;
    reg Clk, Reset, En;
    wire [2:0] Output;
    wire Overflow;
    gray dut(
        .Clk(Clk), .Reset(Reset), .En(En),
        .Output(Output), .Overflow(Overflow)
    );
    always begin
        #10
        Clk = ~Clk;
    end

    initial begin
        $fsdbDumpvars();
        Clk = 0;
        Reset = 0;
        En = 0;
        #20
        En = 1;
        #500

        #20
        $finish;
    end
endmodule