`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:25:39 10/09/2022 
// Design Name: 
// Module Name:    vote 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module vote(
    input [31:0] np,
    input [7:0] vip,
    input vvip,
    output res,
	 output [6:0] cntLook
);
    reg [6:0] cnt = 0;
    reg resReg = 0;
    assign res = (cnt >= 7'd32)? 1 : 0;
	assign cntLook = cnt;
	 
	integer i;
	always @(*) begin
        for (i = 31; i >= 0; i = i-1) begin
            if (np[i]) begin
                cnt = cnt + 1;
            end
        end
	end
    
    
endmodule
