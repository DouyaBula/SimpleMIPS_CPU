`timescale 1ns / 1ps
`default_nettype none
module ROM (
	input wire [31:0] address,
	output wire [31:0] data
);
	reg [31:0] words [0:4096-1];
	wire [31:0] addressOffset = address - 32'h0000_3000;
	integer i;
    initial begin
		for (i = 0; i < 4096; i = i + 1) begin
			words[i] = 32'h0;
		end
		$readmemh("code.txt", words);
    end
	assign data = words[addressOffset[31:2]];
endmodule