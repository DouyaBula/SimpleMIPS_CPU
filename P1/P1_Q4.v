`timescale 1ns/1ps
module gray(
    input Clk, Reset, En,
    output [2:0] Output,
    output Overflow
);
    reg [2:0] OutputReg = 0;
    reg OverflowReg = 0;
    assign Overflow = OverflowReg;
    assign Output = OutputReg;
    reg [2:0] cnt = 0;
    always @(posedge Clk ) begin
        if (Reset) begin
            cnt <= 0;
            OverflowReg <= 0;
        end else begin
            if (En) begin
                if (cnt == 3'b111) begin
                    OverflowReg <= 1'b1;
                end
                cnt <= cnt + 3'b001;                
            end
        end
    end

    always @(*) begin
        OutputReg = cnt ^ (cnt>>1);
    end
endmodule