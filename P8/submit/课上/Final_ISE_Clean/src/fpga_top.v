`timescale 1ns / 1ps
module fpga_top (
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

    mips __mips(
        .clk(clk_in),
        .reset(~sys_rstn),
        .dip_switch0(dip_switch0),
        .dip_switch1(dip_switch1),
        .dip_switch2(dip_switch2),
        .dip_switch3(dip_switch3),
        .dip_switch4(dip_switch4),
        .dip_switch5(dip_switch5),
        .dip_switch6(dip_switch6),
        .dip_switch7(dip_switch7),
        .user_key(user_key),
        .led_light(led_light),
        .digital_tube2(digital_tube2),
        .digital_tube_sel2(digital_tube_sel2),
        .digital_tube1(digital_tube1),
        .digital_tube_sel1(digital_tube_sel1),
        .digital_tube0(digital_tube0),
        .digital_tube_sel0(digital_tube_sel0),
        .uart_rxd(uart_rxd),
        .uart_txd(uart_txd)        
    );

endmodule