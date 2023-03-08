`timescale 1ns/1ps
module tb;
  // Dump waveform to file (it would be impossible to view wavefrom without
  // this task)
  initial begin
    $fsdbDumpvars();
  end

  // Generate clock
  reg clk;
  initial clk = 0;
  always #10 clk = ~clk;

  // Input registers
  reg [31:0] a, b;
  wire [31:0] c;

  initial begin
    a = 0;
    b = 0;
    @(posedge clk);
    a = 32'h631;
    b = 341;
    @(posedge clk);
    $display("%d + %d = %d\n", a, b, c);
    a = 32'o1461;
    b = 0;
    @(posedge clk);
    $display("%d + %d = %d\n", a, b, c);

    #20;
    // Exit the simulation
    $finish;
  end

  // Device under test (our adder)
  adder dut(.clk(clk), .in1(a), .in2(b), .out(c));

endmodule
