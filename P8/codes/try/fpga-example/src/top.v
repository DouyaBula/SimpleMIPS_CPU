`default_nettype none

`include "uart.vh"

module top (
    // clock and reset
    input wire clk_in,
    input wire sys_rstn,
    // dip switch
    input wire [7:0] dip_switch0,
    input wire [7:0] dip_switch1,
    input wire [7:0] dip_switch2,
    input wire [7:0] dip_switch3,
    input wire [7:0] dip_switch4,
    input wire [7:0] dip_switch5,
    input wire [7:0] dip_switch6,
    input wire [7:0] dip_switch7,
    // key
    input wire [7:0] user_key,
    // led
    output wire [31:0] led_light,
    // digital tube
    output wire [7:0] digital_tube2,
    output wire digital_tube_sel2,
    output wire [7:0] digital_tube1,
    output wire [3:0] digital_tube_sel1,
    output wire [7:0] digital_tube0,
    output wire [3:0] digital_tube_sel0,
    // uart
    input wire uart_rxd,
    output wire uart_txd
);
    /* ------ LED ------ */
    reg [31:0] led_counter;
    localparam LED_PERIOD_SLOW = 32'd25_000_000;
    localparam LED_PERIOD_FAST = 32'd25_000_00;

    reg [31:0] light;

    reg led_speed;
    wire [31:0] led_period = led_speed ? LED_PERIOD_SLOW : LED_PERIOD_FAST;

    always @(posedge clk_in) begin
        if (~sys_rstn) begin
            led_counter <= 0;
            light <= 32'b0;
            led_speed <= 0;
        end
        else begin
            if (led_counter + 1 == led_period) begin
                if (light == 32'hFFFF_FFFF) begin   // complete one cycle
                    led_speed <= ~led_speed;        // change speed
                    light <= 32'b0;
                end
                else begin
                    light <= {light[30:0], 1'b1};
                end
                led_counter <= 0;
            end
            else begin
                led_counter <= led_counter + 1;
            end
        end
    end

    assign led_light = ~light;

    /* ------ Calculator ------ */

    wire [31:0] alu_A = ~({dip_switch3, dip_switch2, dip_switch1, dip_switch0});
    wire [31:0] alu_B = ~({dip_switch7, dip_switch6, dip_switch5, dip_switch4});
    
    wire [6:0] alu_op = ~user_key[6:0];

    function [32:0] alu;    // {valid, result}
        input [31:0] a;
        input [31:0] b;
        input [6:0] op;
        begin
            alu[32] = 1'b1;
            case (op)
            7'b000_0001 : alu[31:0] = a & b;
            7'b000_0010 : alu[31:0] = a | b;
            7'b000_0100 : alu[31:0] = a ^ b;
            7'b000_1000 : alu[31:0] = a + b;
            7'b001_0000 : alu[31:0] = a - b;
            7'b010_0000 : alu[31:0] = $signed(a) >>> b[4:0];
            7'b100_0000 : alu[31:0] = (a << b[4:0]) | (a >> (32 - b[4:0]));
            default     : alu = 0;
            endcase
        end
    endfunction

    wire alu_valid;
    wire [31:0] alu_result;
    wire alu_sign = alu_valid & alu_result[31];
    wire [31:0] alu_abs = alu_result[31] ? -alu_result : alu_result;

    assign {alu_valid, alu_result} = alu(alu_A, alu_B, alu_op);

    /* ------ UART ------ */
    wire uart_en = ~user_key[7];
    wire [1:0] uart_baud_sel;

    wire tx_start, tx_avai;
    wire rx_clear, rx_ready;
    wire [15:0] uart_period;
    wire [7:0] rx_data, tx_data;
    
    wire [23:0] baud_disp;  // 不需要
    reg [7:0] byte_disp;    // number of received byte // 不需要

    uart_tx tx (
        .clk(clk_in), .rstn(sys_rstn), .period(uart_period), .txd(uart_txd), 
        .tx_start(tx_start), .tx_data(tx_data), .tx_avai(tx_avai)
    );

    uart_rx rx (
        .clk(clk_in), .rstn(sys_rstn), .period(uart_period), .rxd(uart_rxd),
        .rx_clear(rx_clear), .rx_data(rx_data), .rx_ready(rx_ready)
    );

    assign tx_data = rx_data;   // echo

    assign tx_start = uart_en & rx_ready;
    assign rx_clear = (tx_start & tx_avai) | (~uart_en);  // clear when data transmitted or uart closed

    assign uart_baud_sel = ~(user_key[1:0]);

    // 不需要
    assign uart_period = uart_baud_sel == 2'b11 ? `PERIOD_BAUD_115200 :
                         uart_baud_sel == 2'b10 ? `PERIOD_BAUD_57600  :
                         uart_baud_sel == 2'b01 ? `PERIOD_BAUD_38400  :
                                                  `PERIOD_BAUD_9600;

    // 不需要
    assign baud_disp = uart_baud_sel == 2'b11 ? 24'h115200 :
                       uart_baud_sel == 2'b10 ? 24'h057600 :
                       uart_baud_sel == 2'b01 ? 24'h038400 :
                                                24'h009600;

    // 不需要
    always @(posedge clk_in) begin
        if (~sys_rstn) begin
            byte_disp <= 0;
        end
        else begin
            if (uart_en & rx_ready) begin
                byte_disp <= byte_disp + 8'b1;
            end
        end
    end

    /* ------ Digital Tube ------ */
    wire [31:0] digital_data;
    wire digital_en;

    assign digital_tube_sel2 = 1'b1;
    assign digital_tube2 = uart_en  ? 8'b1110_0000 :// 'b'
                           alu_sign ? 8'b1111_1110 :// '-'
                                      8'b1111_1111; // all off

    assign digital_data = uart_en ? {byte_disp, baud_disp} : alu_abs;
    assign digital_en = uart_en | alu_valid;

    digital_tube d0 (
        .clk(clk_in),
        .rstn(sys_rstn),
        .en(digital_en),
        .data(digital_data[15:0]),
        .sel(digital_tube_sel0),
        .seg(digital_tube0)
    );

    digital_tube d1 (
        .clk(clk_in),
        .rstn(sys_rstn),
        .en(digital_en),
        .data(digital_data[31:16]),
        .sel(digital_tube_sel1),
        .seg(digital_tube1)
    );
    
endmodule