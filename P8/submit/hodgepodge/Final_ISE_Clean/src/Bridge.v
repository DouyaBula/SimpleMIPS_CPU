`timescale 1ns / 1ps
`default_nettype none 
`include "macros.v"
module Bridge (
    input wire [31:0] R_Addr,
    input wire [31:0] m_data_addr,  // 来自CPU 
    input wire [31:0] m_data_wdata, // 来自CPU 
    input wire [3:0] m_data_byteen, // 来自CPU 
    input wire [31:0] m_inst_addr,  // 来自CPU 
    input wire [31:0] I_DMData,     // 来自外设DM
    input wire [31:0] I_Timer0Data, // 来自外设Timer0
    input wire [31:0] I_DipSwitch0_3, // 来自外设DipSwitch0_3
    input wire [31:0] I_DipSwitch4_7, // 来自外设DipSwitch4_7
    input wire [31:0] I_User_Key,     // 来自外设User_Key
    input wire [7:0] I_UART,          // 来自外设UART 
    input wire [31:0] I_LED,

    output wire [31:0] O_m_data_wdata,   // 送给外设DM, Timer0, LED
    output wire [31:0] O_m_data_addr,    // 送给外设DM, Timer0, LED
    output wire [3:0] O_m_data_byteen,  // 送给外设DM, LED

    output wire [3:0] O_DMWE,  // 送给外设DM
    output wire O_Timer0WE,  // 送给外设Timer0
    output wire O_LEDWE,  // 送给外设LED
    output wire O_DigitalTubeWE,
    output wire O_UARTWE,

    output wire [31:0] m_data_rdata  // 送给CPU
);
    assign O_m_data_wdata = m_data_wdata;
    assign O_m_data_addr = m_data_addr;
    assign O_m_data_byteen = m_data_byteen;

    assign O_DMWE = (((m_data_addr >= `DataMemStart) && (m_data_addr <= `DataMemEnd)) && (|m_data_byteen)) ? 4'b1111 : 4'b0000;
    assign O_Timer0WE = ((m_data_addr >= `Timer0Start) && (m_data_addr <= `Timer0End)) && (|m_data_byteen);
    assign O_LEDWE = ((m_data_addr >= `LEDStart) && (m_data_addr <= `LEDEnd)) && (|m_data_byteen);
    assign O_DigitalTubeWE = ((m_data_addr >= `DigitalTubeStart) && (m_data_addr <= `DigitalTubeEnd)) && (|m_data_byteen);
    assign O_UARTWE = ((m_data_addr >= `UARTStart) && (m_data_addr <= `UARTEnd)) && (|m_data_byteen);

    assign m_data_rdata =   ((R_Addr >= `DataMemStart) && (R_Addr <= `DataMemEnd)) ? I_DMData :
                            ((R_Addr >= `Timer0Start) && (R_Addr <= `Timer0End)) ? I_Timer0Data :
                            ((R_Addr >= `DipSwitch0_3Start) && (R_Addr <= `DipSwitch0_3End)) ? I_DipSwitch0_3 :
                            ((R_Addr >= `DipSwitch4_7Start) && (R_Addr <= `DipSwitch4_7End)) ? I_DipSwitch4_7 : 
                            ((R_Addr >= `UserKeyStart) && (R_Addr <= `UserKeyEnd)) ? I_User_Key :
                            ((R_Addr >= `UARTStart) && (R_Addr <= `UARTEnd)) ? {24'd0, I_UART} : 
                            ((R_Addr >= `LEDStart) && (R_Addr <= `LEDEnd)) ? I_LED :32'd0;
endmodule