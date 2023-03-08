`default_nettype none
`timescale 1ns/1ps
module DM (
    input wire clka, 
    input wire [3:0] wea,
    input wire [31:0] addra,
    input wire [31:0] dina,
    output reg [31:0] douta
);
    reg [31:0] data[0:4095];
    reg [31:0] fixed_wdata;
    always @(posedge clka) begin
        douta = data[addra];
    end
    always @(*) begin
		fixed_wdata = data[addra & 4095];
		if (wea) fixed_wdata[31:24] = dina[31:24];
		if (wea) fixed_wdata[23:16] = dina[23:16];
		if (wea) fixed_wdata[15: 8] = dina[15: 8];
		if (wea) fixed_wdata[7 : 0] = dina[7 : 0];
	end
    integer i;
    initial begin
        for (i = 0; i < 4096; i = i + 1) data[i] <= 0;
    end
	always @(posedge clka) begin
        if (|wea && addra < 4096) begin
			data[addra] <= fixed_wdata;
		end
	end
endmodule


module IM (
    input wire clka, 
    input wire [31:0] addra,
    output reg [31:0] douta
);
    reg [31:0] data[0:4095];
    wire [31:0] test;
    assign test = data[addra];
    always @(posedge clka) begin
        douta = data[addra];
    end
    initial begin
       $readmemh("code.txt", data); 
    end
endmodule