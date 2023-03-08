`timescale 1ns / 1ps
`default_nettype none 
`include "macros.v"
module Bridge (
    input wire [31:0] m_data_addr,  // 来自CPU 
    input wire [31:0] m_data_wdata, // 来自CPU 
    input wire [3:0] m_data_byteen, // 来自CPU 
    input wire [31:0] m_inst_addr,  // 来自CPU 
    input wire [31:0] I_DMData,     // 来自外设DM
    input wire [31:0] I_Timer0Data, // 来自外设Timer0
    input wire [31:0] I_Timer1Data, // 来自外设Timer1

    output wire [31:0] m_int_addr,   // 送给外设IG
    output wire [3:0] m_int_byteen,  // 送给外设IG

    output wire [31:0] O_m_data_wdata,   // 送给外设DM, Timer0, Timer1 
    output wire [31:0] O_m_data_addr,    // 送给外设DM, Timer0, Timer1
    output wire [31:0] O_m_data_byteen,  // 送给外设DM
    output wire [31:0] O_m_inst_addr,    // 送给外设DM

    output wire O_Timer0WE,  // 送给外设Timer0

    output wire O_Timer1WE, // 送给外设Timer1

    output wire [31:0] m_data_rdata  // 送给CPU
);

    assign m_int_addr = m_data_addr;    // 在CPU内部使用tbReq信号实现对IG中断的响应
    assign m_int_byteen = m_data_byteen;

    assign O_m_data_wdata = m_data_wdata;
    assign O_m_data_addr = m_data_addr;
    assign O_m_data_byteen = m_data_byteen;
    assign O_m_inst_addr = m_inst_addr;

    assign O_Timer0WE = ((m_data_addr >= `Timer0Start) && (m_data_addr <= `Timer0End)) && (|m_data_byteen);

    assign O_Timer1WE = ((m_data_addr >= `Timer1Start) && (m_data_addr <= `Timer1End)) && (|m_data_byteen);

    assign m_data_rdata =   ((m_data_addr >= `DataMemStart) && (m_data_addr <= `DataMemEnd)) ? I_DMData :
                            ((m_data_addr >= `Timer0Start) && (m_data_addr <= `Timer0End)) ? I_Timer0Data :
                            ((m_data_addr >= `Timer1Start) && (m_data_addr <= `Timer1End)) ? I_Timer1Data : 32'd0;
                            // 对于中断发生器, 教程规定: "由于其内部并没有真正的存储单元，我们规定读出的数据始终保持 0"
endmodule