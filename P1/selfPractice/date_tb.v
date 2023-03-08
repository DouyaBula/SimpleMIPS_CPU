`timescale 1ns/1ps
module tb;

// module date(
//     input [7:0] char,
//     input reset, clk,
//     output result
// );    
    reg [7:0] char;
    reg reset, clk;
    wire result;
    date uut(.char(char), .clk(clk), .reset(reset),.result(result));
    always begin
        #10
        clk =  ~clk;
    end

    initial begin
        $fsdbDumpvars();
        clk = 0;
        reset = 1;
        #20
        reset = 0;
        char = "2";
        #20
        char = "0";
        #20
        char = "2";
        #20
        char = "1";
        #20
        char = "-";
        #20
        char = "1";
        #20
        char = "0";
        #20
        char = "-";
        #100
        $finish;
    end

endmodule