`timescale 1ns / 1ps
module RAM (
    input [31:0] address,
    input [31:0] storeData,
    input MemWrite, clk, rst,
    output [31:0] loadData,
    input [31:0] PCForTest
);
    reg [7:0] bytes [12*1024-1:0];
    // reg [31:0] loadDataReg;
    // assign loadData = loadDataReg;
    assign loadData = {bytes[address], bytes[address+32'd1], bytes[address+32'd2], bytes[address+32'd3]};

    integer i;
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 12*1024; i = i + 1 ) begin
                bytes[i] <= 8'h00;
            end
        end else begin
            if (MemWrite) begin
                $display("@%h: *%h <= %h", PCForTest, address, storeData);
                bytes[address] <= storeData[31:24];
                bytes[address+32'd1] <= storeData[23:16];
                bytes[address+32'd2] <= storeData[15:8];
                bytes[address+32'd3] <= storeData[7:0];
            end
        end
    end
endmodule