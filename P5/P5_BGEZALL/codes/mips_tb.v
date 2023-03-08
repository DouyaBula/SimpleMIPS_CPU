`timescale 1ns / 1ps
`default_nettype none 
module mips_tb (
);
    reg clk, reset;
    mips uut(
        .clk(clk),
        .reset(reset)
    );

    always begin
        #5
        clk = ~clk;
    end

    initial begin
        $fsdbDumpvars();
        clk = 1'd0;
        reset = 1'd1;
        #10
        reset = 1'd0;

        #1000
        $finish;
    end
endmodule