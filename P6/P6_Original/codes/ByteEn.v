`timescale 1ns / 1ps
`default_nettype none 
module ByteEn (
    input wire [2:0] ByteEnControl,
    input wire [31:0] ALUResult,
    input wire [31:0] RD2ForwardResult,

    output wire [3:0] ByteEn,
    output wire [31:0] FixRD2ForwardResult
);
    reg [3:0] ByteEnReg;
    reg [31:0] FixRD2ForwardResultReg;
    assign ByteEn = ByteEnReg;
    assign FixRD2ForwardResult = FixRD2ForwardResultReg;

    always @(*) begin
        case (ByteEnControl)
            3'b001: begin
                case (ALUResult[1:0])
                    2'b00: begin
                        ByteEnReg = 4'b0001;
                        FixRD2ForwardResultReg = {8'd0, 8'd0, 8'd0, RD2ForwardResult[7:0]};
                    end 
                    2'b01: begin
                        ByteEnReg = 4'b0010;
                        FixRD2ForwardResultReg = {8'd0, 8'd0, RD2ForwardResult[7:0], 8'd0};
                    end
                    2'b10 : begin
                        ByteEnReg = 4'b0100;
                        FixRD2ForwardResultReg = {8'd0, RD2ForwardResult[7:0], 8'd0, 8'd0};
                    end
                    2'b11 : begin
                        ByteEnReg = 4'b1000;
                        FixRD2ForwardResultReg = {RD2ForwardResult[7:0], 8'd0, 8'd0, 8'd0};
                    end
                    default: begin
                        ByteEnReg = 4'b1111;
                    end
                endcase
            end 
            3'b010: begin
                case (ALUResult[1])
                    1'b0: begin
                        ByteEnReg = 4'b0011;
                        FixRD2ForwardResultReg = {16'd0, RD2ForwardResult[15:0]};
                    end 
                    1'b1: begin
                        ByteEnReg = 4'b1100;
                        FixRD2ForwardResultReg = {RD2ForwardResult[15:0], 16'd0};
                    end
                    default: begin
                        ByteEnReg = 4'b1111;
                    end
                endcase
            end
            3'b011: begin
                ByteEnReg = 4'b1111;
                FixRD2ForwardResultReg = RD2ForwardResult;
            end
            default: begin
                ByteEnReg = 4'b0000;
                FixRD2ForwardResultReg = RD2ForwardResult;
            end 
        endcase
    end
endmodule