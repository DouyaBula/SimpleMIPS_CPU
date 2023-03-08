`timescale 1ns / 1ps
`default_nettype none 
module mips (
    input wire clk,                    // 时钟信号
    input wire reset,                  // 同步复位信号
    input wire interrupt,              // 外部中断信号
    output wire [31:0] macroscopic_pc, // 宏观 PC

    output wire [31:0] i_inst_addr,    // IM 读取地址（取指 PC）
    input wire  [31:0] i_inst_rdata,   // IM 读取数据

    output wire [31:0] m_data_addr,    // DM 读写地址
    input wire  [31:0] m_data_rdata,   // DM 读取数据
    output wire [31:0] m_data_wdata,   // DM 待写入数据
    output wire [3 :0] m_data_byteen,  // DM 字节使能信号

    output wire [31:0] m_int_addr,     // 中断发生器待写入地址
    output wire [3 :0] m_int_byteen,   // 中断发生器字节使能信号

    output wire [31:0] m_inst_addr,    // M 级 PC

    output wire w_grf_we,              // GRF 写使能信号
    output wire [4 :0] w_grf_addr,     // GRF 待写入寄存器编号
    output wire [31:0] w_grf_wdata,    // GRF 待写入数据

    output wire [31:0] w_inst_addr     // W 级 PC
);
    // CPU wires
    wire [31:0] CPU_O_m_data_addr;
    wire [31:0] CPU_O_m_data_wdata;
    wire [3:0] CPU_O_m_data_byteen;
    wire [31:0] CPU_O_m_inst_addr;
    
    // Bridge wires
    wire [31:0] Bridge_O_m_int_addr;
    wire [3:0] Bridge_O_m_int_byteen;
    wire [31:0] Bridge_O_m_data_wdata;
    wire [31:0] Bridge_O_m_data_addr;
    wire [31:0] Bridge_O_m_data_byteen;
    wire [31:0] Bridge_O_m_inst_addr;
    wire Bridge_O_Timer0WE;
    wire Bridge_O_Timer1WE;
    wire [31:0] Bridge_O_m_data_rdata;

    // Timer0 wires
    wire [31:0] Timer0Data;
    wire IRQ0;

    // Timer1 wires
    wire [31:0] Timer1Data;
    wire IRQ1;


    wire [5:0] CPU_I_HWInt;
    assign CPU_I_HWInt = {3'b0, {interrupt}, {IRQ1}, {IRQ0}};
    CPU CPU_Mips (
        .clk(clk),
        .reset(reset),
        .i_inst_rdata(i_inst_rdata),    //来自IM(TB)
        .m_data_rdata(Bridge_O_m_data_rdata),    // 来自Bridge
        .HWInt(CPU_I_HWInt),   // 来自IG(TB), Timer0, Timer1, 三者组合而成

        .i_inst_addr(i_inst_addr),  //直接送出给IM(TB)
        .m_data_addr(CPU_O_m_data_addr), //送给Bridge
        .m_data_wdata(CPU_O_m_data_wdata), //送给Bridge
        .m_data_byteen(CPU_O_m_data_byteen), //送给Bridge
        .m_inst_addr(CPU_O_m_inst_addr), //送给Bridge
        .w_grf_we(w_grf_we), //直接送出给TB
        .w_grf_addr(w_grf_addr), //直接送出给TB
        .w_grf_wdata(w_grf_wdata), //直接送出给TB
        .w_inst_addr(w_inst_addr) //直接送出给TB
    );

    Bridge Bridge_Mips (
        .m_data_addr(CPU_O_m_data_addr),  // 来自CPU 
        .m_data_wdata(CPU_O_m_data_wdata), // 来自CPU 
        .m_data_byteen(CPU_O_m_data_byteen), // 来自CPU 
        .m_inst_addr(CPU_O_m_inst_addr),  // 来自CPU 
        .I_DMData(m_data_rdata),     // 来自外设DM(TB)
        .I_Timer0Data(Timer0Data), // 来自外设Timer0
        .I_Timer1Data(Timer1Data), // 来自外设Timer1

        .m_int_addr(Bridge_O_m_int_addr),   // 送给外设IG(TB)
        .m_int_byteen(Bridge_O_m_int_byteen),  // 送给外设IG(TB)

        .O_m_data_wdata(Bridge_O_m_data_wdata),   // 送给外设DM(TB), Timer0, Timer1 
        .O_m_data_addr(Bridge_O_m_data_addr),    // 送给外设DM(TB), Timer0, Timer1 (连线时Timer记得要截取字对齐地址)
        .O_m_data_byteen(Bridge_O_m_data_byteen),  // 送给外设DM(TB)
        .O_m_inst_addr(Bridge_O_m_inst_addr),    // 送给外设DM(TB)

        .O_Timer0WE(Bridge_O_Timer0WE),  // 送给外设Timer0

        .O_Timer1WE(Bridge_O_Timer1WE), // 送给外设Timer1

        .m_data_rdata(Bridge_O_m_data_rdata)  // 送给CPU
    );

    TC Timer0_Mips (
        .clk(clk),
        .reset(reset),
        .Addr(Bridge_O_m_data_addr[31:2]),    // 来自Bridge
        .WE(Bridge_O_Timer0WE),  // 来自Bridge
        .Din(Bridge_O_m_data_wdata), // 来自Bridge
        
        .Dout(Timer0Data),    // 送给Bridge
        .IRQ(IRQ0)  // 送给CPU
    );

    TC Timer1_Mips (
        .clk(clk),
        .reset(reset),
        .Addr(Bridge_O_m_data_addr[31:2]),    // 来自Bridge
        .WE(Bridge_O_Timer1WE),  // 来自Bridge
        .Din(Bridge_O_m_data_wdata), // 来自Bridge
        
        .Dout(Timer1Data),    // 送给Bridge
        .IRQ(IRQ1)  // 送给CPU
    );
    
    // 设置未直接输出的接口
    assign macroscopic_pc = CPU_O_m_inst_addr;
    assign m_data_addr = Bridge_O_m_data_addr;
    assign m_data_wdata = Bridge_O_m_data_wdata;
    assign m_data_byteen = Bridge_O_m_data_byteen;
    assign m_int_addr = Bridge_O_m_int_addr;
    assign m_int_byteen = Bridge_O_m_int_byteen;
    assign m_inst_addr = CPU_O_m_inst_addr;
endmodule
// 踏马的这混乱的命名我自己都受不了了, 看着想似