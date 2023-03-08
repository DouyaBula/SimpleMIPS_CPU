`define State1 4'b0001
`define State2 4'b0010
`define State3 4'b0100
`define State4 4'b1000

`timescale 1ns/1ps
module string(
    input clk, clr,
    input [7:0] in,
    output out
);
    reg outReg = 0;
    assign out = outReg;
    reg [3:0] state = `State1;
    
    always @(posedge clk, posedge clr) begin
        if (clr) begin
            state <= `State1;
        end else begin
            case (state)
                `State1: begin
                    if (in >= "0" && in <= "9") begin
                        state <= `State2;
                    end else begin
                        state <= `State4;
                    end
                end
                `State2: begin
                    if (in == "+" || in == "*") begin
                        state <= `State3;
                    end else begin
                        state <= `State4;
                    end
                end 
                `State3: begin
                    if (in >= "0" && in <= "9") begin
                        state <= `State2;
                    end else begin
                        state <= `State4;
                    end
                end 
                `State4: begin
                    state <= state;
                end 
                default: begin
                    state <= state;
                end
            endcase
        end
    end

    always @(*) begin
        outReg = (state == `State2)? 1 : 0;
    end
endmodule