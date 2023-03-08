`timescale 1ns / 1ps
`default_nettype none 
`include "macros.v"

`define DATA Regs[0]        // 仅[7:0]一字节可用, rxtx共用地址(但不共用寄存器).
`define LSR Regs[1]         // [0]表示接收状态, [5]表示发送状态
`define DIVR Regs[2]
`define DIVT Regs[3]

module UART (
    input wire clk,
    input wire reset,
    input wire en,
    input wire Wen,
    input wire [31:2] addr,
    input wire [31:0] data,
    input wire uart_rxd,             // 外部rx输入

    output wire uart_txd,       // 发到外部
    output reg [7:0] rx_data,  // 发到CPU  
    output wire interrupt       // 发到CPU
);
    wire [7:0] __rx_data;
    // tx wires
    wire tx_avai;
    // rx wires
    wire rx_ready;
    
    reg R_Wen;
    always @(posedge clk) begin
        R_Wen <= Wen;
    end
    reg [31:0] Regs[0:3];
    always @(posedge clk) begin
        rx_data <= Regs[addr[3:2]][7:0];        
    end
    always @(posedge clk) begin
        if (reset) begin
            `DATA <= 32'd0;
            `LSR <= 32'b100001;
            `DIVR <= `PERIOD_BAUD_9600;
            `DIVT <= `PERIOD_BAUD_9600;
        end else if (Wen) begin
            Regs[addr[3:2]] <= data;
        end else if (rx_ready) begin
            Regs[0] <= __rx_data;
        end
        if (~reset) begin       // TODO: 可能会寄
            `LSR[0] <= rx_ready;
            `LSR[5] <= tx_avai;
        end
    end

    wire tx_start = en & R_Wen;
    uart_tx __uart_tx (
        .clk(clk),
        .reset(reset),
        .period(`DIVT[15:0]),
        .tx_start(tx_start),
        .tx_data(`DATA[7:0]),

        .txd(uart_txd),
        .tx_avai(tx_avai)
    );

    uart_rx __uart_rx (
        .clk(clk),
        .reset(reset),
        .period(`DIVR[15:0]),
        .rxd(uart_rxd),
        .rx_clear((tx_start & tx_avai) | (~en)),

        .rx_data(__rx_data),
        .rx_ready(rx_ready)
    );

    // 设置输出端口
    assign interrupt = rx_ready;

endmodule

module uart_count (
    input wire clk,
    input wire reset,
    input wire en,
    input wire [15:0] period,
    input wire [15:0] preset,   // preset value
    output wire q
);

    reg [15:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
        end
        else begin
            if (en) begin
                if (count + 16'd1 == period) begin
                    count <= 16'd0;
                end
                else begin
                    count <= count + 16'd1;
                end
            end
            else begin
                count <= preset;
            end
        end
    end

    assign q = count + 16'd1 == period;

endmodule

module uart_tx (
    input wire clk,
    input wire reset,
    input wire [15:0] period,
    input wire tx_start,        // 1 if outside wants to send data
    input wire [7:0] tx_data,   // data to be sent
    output wire txd,
    output wire tx_avai         // 1 if uart can send data
);
    localparam IDLE = 0, START = 1, WORK = 2, STOP = 3;

    reg [1:0] state;
    reg [7:0] data;         // a copy of 'tx_data', modified(right shift) at each sample point
    reg [2:0] bit_count;    // number of bits which is not sent

    wire count_en = state != IDLE;
    wire count_q;

    uart_count count (
        .clk(clk), .reset(reset), .period(period), .en(count_en), .q(count_q),
        .preset(16'b0) // no offset
    );

    // transmit
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            data <= 0;
            bit_count <= 0;
        end
        else begin
            case (state)
                IDLE: begin
                    if (tx_start) begin
                        state <= START;
                        data <= tx_data;
                    end
                end
                START: begin
                    if (count_q) begin
                        state <= WORK;
                        bit_count <= 3'd7;
                    end
                end
                WORK: begin
                    if (count_q) begin
                        data <= {1'b0, data[7:1]}; // right shift
                        if (bit_count == 0) begin
                            state <= STOP;
                        end
                        else begin
                            bit_count <= bit_count - 3'd1;
                        end
                    end
                end
                STOP: begin
                    if (count_q) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    assign tx_avai = state == IDLE;
    assign txd = (state == IDLE || state == STOP) ? 1'b1 :
                 (state == START) ? 1'b0 : data[0];

endmodule

module uart_rx (
    input wire clk,
    input wire reset,
    input wire [15:0] period,
    input wire rxd,
    input wire rx_clear,        // 1 if outside took or discarded the received data
    output reg [7:0] rx_data,   // data has been read
    output reg rx_ready         // 1 if 'uart_rx' has read complete data(a byte)
);
    localparam IDLE = 0, START = 1, WORK = 2, STOP = 3;

    reg [1:0] state;
    reg [7:0] buffer;       // buffer for received bits
    reg [2:0] bit_count;    // number of bits which need to receive

    wire count_en = state != IDLE;
    wire count_q;

    uart_count count (
        .clk(clk), .reset(reset), .period(period + 15'b1), .en(count_en), 
        .q(count_q), .preset(period >> 1) // half sample cycle offset
    );

    
    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
            buffer <= 0;
            bit_count <= 0;
        end
        else begin
            case (state)
                IDLE: begin
                    if (~rxd) begin
                        state <= START;
                        buffer <= 0;
                    end
                end
                START: begin
                    if (count_q) begin
                        state <= WORK;
                        bit_count <= 3'd7;
                    end
                end
                WORK: begin
                    if (count_q) begin
                        if (bit_count == 0) begin
                            state <= STOP;
                        end
                        else begin
                            bit_count <= bit_count - 3'd1;
                        end
                        buffer <= {rxd, buffer[7:1]};   // take received bit
                    end
                end
                STOP: begin
                    if (count_q) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            rx_data <= 0;
            rx_ready <= 0;
        end
        else begin
            if (rx_clear) begin
                rx_data <= 0;
                rx_ready <= 0;
            end
            else if (state == STOP && count_q) begin    // complete receiving
                rx_data <= buffer;
                rx_ready <= 1;
            end
        end
    end

endmodule