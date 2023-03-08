`timescale 1ns / 1ps
`default_nettype none
/*
    ----a----
    |       |
    f       b
    |       |
    ----g----
    |       |
    e       c
    |       |
    ----d----  .dp

    seg[7:0] = {dp, a, b, c, d, e, f, g}
*/
module DigitalTube(
    input wire clk,
    input wire reset,
    input wire [31:2] addr,
    input wire en,
    input wire Wen,
    input wire [3:0] ByteEn,
    input wire [31:0] data,
    output wire [3:0] sel0,
    output wire [3:0] sel1,
    output wire [7:0] seg0,
    output wire [7:0] seg1,
    output wire sel2,
    output wire [7:0] seg2
);
    // save registers
    reg [31:0] Regs[0:1];
    wire [31:0] debug0 = Regs[0];
    wire [31:0] debug1 = Regs[1];
    always @(posedge clk) begin
        if (reset) begin
            Regs[0] <= 32'd0;
            Regs[1] <= 32'd0;
        end else if (Wen) begin
            if (ByteEn[3]) Regs[addr[2]][31:24] <= data[31:24];
            if (ByteEn[2]) Regs[addr[2]][23:16] <= data[23:16];
            if (ByteEn[1]) Regs[addr[2]][15: 8] <= data[15: 8];
            if (ByteEn[0]) Regs[addr[2]][7 : 0] <= data[7 : 0];
        end
    end

    localparam PERIOD = 32'd25_000;

    // div counter
    reg [31:0] counter;
    always @(posedge clk) begin
        if (reset) begin
            counter <= 0;
        end
        else begin
            if (counter + 1 == PERIOD) 
                counter <= 0;
            else
                counter <= counter + 1;
        end
    end

    // select
    reg [1:0] select;
    always @(posedge clk) begin
        if (reset) begin
            select <= 0;
        end
        else begin
            if (counter + 1 == PERIOD) 
                select <= select + 1'b1;
        end
    end

    assign sel0 = (4'b1 << select);
    assign sel1 = (4'b1 << select);
    assign sel2 = 1'b1;

    // data output
    function [7:0] hex2dig;   // dp = 1
        input [3:0] hex;
        begin
            case (hex)
            4'h0    : hex2dig = 8'b1000_0001;   // not g
            4'h1    : hex2dig = 8'b1100_1111;   // b, c
            4'h2    : hex2dig = 8'b1001_0010;   // not c, f
            4'h3    : hex2dig = 8'b1000_0110;   // not e, f
            4'h4    : hex2dig = 8'b1100_1100;   // not a, d, e
            4'h5    : hex2dig = 8'b1010_0100;   // not b, e
            4'h6    : hex2dig = 8'b1010_0000;   // not b
            4'h7    : hex2dig = 8'b1000_1111;   // a, b, c
            4'h8    : hex2dig = 8'b1000_0000;   // all
            4'h9    : hex2dig = 8'b1000_0100;   // not e
            4'hA    : hex2dig = 8'b1000_1000;   // not d
            4'hB    : hex2dig = 8'b1110_0000;   // not a, b
            4'hC    : hex2dig = 8'b1011_0001;   // a, d, e, f
            4'hD    : hex2dig = 8'b1100_0010;   // not a, f
            4'hE    : hex2dig = 8'b1011_0000;   // not b, c
            4'hF    : hex2dig = 8'b1011_1000;   // a, e, f, g
            default : hex2dig = 8'b1111_1111;
            endcase
        end
    endfunction

    assign seg0 = en ? hex2dig(Regs[0][select * 4 +: 4]) : 8'b1111_1110; // '-'
    assign seg1 = en ? hex2dig(Regs[0][(select + 32'd4) * 4 +: 4]) : 8'b1111_1110; //TODO: 可能寄
    assign seg2 = en ? hex2dig(Regs[1][3:0]) : 8'b1111_1110;
endmodule
