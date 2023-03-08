`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:00:27 10/09/2022
// Design Name:   vote
// Module Name:   /home/co-eda/iseProjects/helloWorld/vote_tb.v
// Project Name:  helloWorld
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: vote
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module vote_tb;

	// Inputs
	reg [31:0] np;
	reg [7:0] vip;
	reg vvip;

	// Outputs
	wire res;
	wire [6:0] cntLook;

	// Instantiate the Unit Under Test (UUT)
	vote uut (
		.np(np), 
		.vip(vip), 
		.vvip(vvip), 
		.res(res),
		.cntLook(cntLook)
	);

	initial begin
		$fsdbDumpvars();
		// Initialize Inputs
		np = 32'hFFFF_FFFF;
		vip = 8'b011111;
		vvip = 0;
        
		// Add stimulus here
		#10
		$finish;
	end
      
endmodule

