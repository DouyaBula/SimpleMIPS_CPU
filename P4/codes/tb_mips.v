`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:33:30 10/28/2022
// Design Name:   mips
// Module Name:   /home/co-eda/iseProjects/SingleCycle/tb_mips.v
// Project Name:  SingleCycle
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mips
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_mips;

	// Inputs
	reg clk;
	reg reset;

	// Instantiate the Unit Under Test (UUT)
	mips uut (
		.clk(clk), 
		.reset(reset)
	);
    always begin
        #5
        clk = ~clk;
    end
	initial begin
        $fsdbDumpvars();
		// Initialize Inputs
		clk = 0;
		reset = 1;
        #10
        reset = 0;

		#1000;
        $finish;
	end
      
endmodule

