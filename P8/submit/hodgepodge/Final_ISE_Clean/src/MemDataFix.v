`timescale 1ns / 1ps
`default_nettype none 
module MemDataFix (
    input wire [31:0] ALUResult,
    input wire [2:0] MemDataControl,
    input wire [31:0] RawMemoryData,

    output wire [31:0] MemoryData
);
    reg [31:0] MemoryDataReg;
    assign MemoryData = MemoryDataReg;

    always @(*) begin
        case (MemDataControl)
            3'b001: begin
                case (ALUResult[1:0])
                    2'b00: begin
                        MemoryDataReg = $signed(RawMemoryData[7:0]);
                    end 
                    2'b01: begin
                        MemoryDataReg = $signed(RawMemoryData[15:8]);
                    end
                    2'b10 : begin
                        MemoryDataReg = $signed(RawMemoryData[23:16]);
                    end
                    2'b11 : begin
                        MemoryDataReg = $signed(RawMemoryData[31:24]);
                    end
                    default: begin
                        MemoryDataReg = 32'heeee;
                    end
                endcase
            end 
            3'b010: begin
                case (ALUResult[1])
                    1'b0: begin
                        MemoryDataReg = $signed(RawMemoryData[15:0]);
                    end 
                    1'b1: begin
                        MemoryDataReg = $signed(RawMemoryData[31:16]);
                    end
                    default: begin
                        MemoryDataReg = 32'hffff;
                    end
                endcase
            end
            3'b011: begin
                MemoryDataReg = RawMemoryData;
            end
            default: begin
                MemoryDataReg = 32'haabb;
            end 
        endcase
    end
endmodule