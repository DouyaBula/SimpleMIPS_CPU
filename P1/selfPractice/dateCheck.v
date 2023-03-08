`timescale 1ns/1ps

`define State0 6'b000001
`define State1 6'b000010
`define State2 6'b000100
`define State3 6'b001000
`define State4 6'b010000
`define State5 6'b100000

module date(
    input [7:0] char,
    input reset, clk,
    output result
);
    reg resultReg = 0;
    assign result = resultReg;
    reg [5:0] state = `State0;
    reg [2:0] cnt = 0;
    reg [7:0] month [1:0];
    reg [7:0] day [1:0];
    reg [7:0] typeOp;
    initial begin
        month [1] <= "0";
        month [0] <= "0";
        day [1] <= "0";
        day [0] <= "0";
    end
    always @(posedge clk) begin
        if (reset) begin
            state <= `State0;
        end else begin
            case (state)
                `State0: begin
                    if (char >= "1" && char <= "9") begin
                        state <= `State1;
                        cnt <= 3'b001;
                    end else begin
                        state <= `State5;
                    end
                end
                `State1: begin
                    if (char >= "0" && char <= "9" && cnt <= 3'b100) begin
                        state <= `State1;
                        cnt <= cnt + 3'b001;
                    end else if ((char == "." || char == "-" || char == "/")&& cnt <= 3'b100) begin
                        state <= `State2;
                        typeOp = char;
                    end else begin
                        state <= `State5;
                    end
                end
                `State2: begin
                    if (char >= "1" && char <= "9") begin
                        month[1] <= char - "0";
                        state <= `State3;
                        cnt <= 3'b001;
                    end else begin
                        state <= `State5;
                    end
                end
                `State3: begin
                    if (char >= "0" && char <= "9" && cnt <= 3'b010) begin
                        month[0] <= char - "0";
                        cnt <= cnt + 3'b001;
                        state <= `State3;
                    end else if (char == typeOp && cnt <= 3'b010 && legal(month[1], month[0], cnt, 1'b0)) begin
                        state <= `State4;
                    end else begin
                        state <= `State5;
                    end
                end
                `State4: begin
                    state <= `State4;
                end
                `State5: begin
                    state <= `State5;
                end
                default: begin
                    state <= state;
                end 
            endcase
        end
    end

    always @(*) begin
        resultReg = (state==`State4)?1:0;
    end

    function legal;
        input [7:0] monOrDay1;
        input [7:0] monOrDay0;
        input [2:0] amount;
        input type;
        reg [4:0] value;
        reg [7:0] monOrDay [1:0];
        integer i;
        begin
            value = 5'b00000;
            monOrDay [1] = monOrDay1;
            monOrDay [0] = monOrDay0;
            for (i = amount-1; i >= 0; i = i-1) begin
                value = 10*value;
                value = value + monOrDay[i];
            end
            case (type)
                1'b0: begin
                    if (value <= 5'd12) begin
                        legal = 1'b1;
                    end else begin
                        legal = 1'b0;
                    end
                end 
                1'b1: begin
                    if (value <= 5'd30) begin
                        legal = 1'b1;
                    end else begin
                        legal = 1'b0;
                    end
                end 
            endcase
        end
    endfunction


endmodule