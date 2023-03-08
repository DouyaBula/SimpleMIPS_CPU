`timescale 1ns / 1ps
`default_nettype none 
module mips (
    input wire clk,                    // 时钟信号
    input wire reset,                  // 同步复位信号

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
    // IM wires
    wire  [31:0] i_inst_rdata;

    // DM wires
    wire  [31:0] m_data_rdata;

    // CPU wires
    wire [31:0] i_inst_addr;
    wire [31:0] CPU_O_m_data_addr;
    wire [31:0] CPU_O_m_data_wdata;
    wire [3:0] CPU_O_m_data_byteen;
    wire [31:0] CPU_O_m_inst_addr;
    
    reg [31:0] R_Addr, R_Instr;
    always @(posedge clk) begin
        R_Addr <= CPU_O_m_data_addr;
        R_Instr <= CPU_O_m_inst_addr;
    end  
    
    // Bridge wires
    wire [31:0] Bridge_O_m_data_wdata;
    wire [31:0] Bridge_O_m_data_addr;
    wire [3:0] Bridge_O_m_data_byteen;
    wire [3:0] Bridge_O_DMWE;
    wire Bridge_O_Timer0WE;
    wire Bridge_O_LEDWE;
    wire Bridge_O_DigitalTubeWE;
    wire Bridge_O_UARTWE;
    wire [31:0] Bridge_O_m_data_rdata;
    
    // Timer0 wires
    wire [31:0] Timer0Data;
    wire IRQ0;

    // GPIO regs
    reg [31:0] W_Reg_DipSwitch0_3, R_Reg_DipSwitch0_3;
    reg [31:0] W_Reg_DipSwitch4_7, R_Reg_DipSwitch4_7;
    reg [31:0] W_Reg_User_Key, R_Reg_User_Key;
    reg [31:0] Reg_LED, R_Reg_LED;

    // UART wires
    wire [7:0] rx_data;
    wire interrupt;

    DM __DM (                                       // TODO: 需要在ISE中使用IP核
        .clka(clk),                                 // input clka
        .wea(Bridge_O_m_data_byteen & Bridge_O_DMWE), // input [3 : 0] wea
        .addra(Bridge_O_m_data_addr >> 2),          // input [11 : 0] addra
        .dina(Bridge_O_m_data_wdata),               // input [31 : 0] dina
        .douta(m_data_rdata)                        // output [31 : 0] douta
    );

    IM __IM (                                       // TODO: 需要在ISE中使用IP核
        .clka(clk),                                 // input clka
        .addra((i_inst_addr - 32'h3000) >> 2),      // input [11 : 0] addra
        .douta(i_inst_rdata)                        // output [31 : 0] douta
    );

    wire [5:0] CPU_I_HWInt;
    assign CPU_I_HWInt = {2'b0, {interrupt}, 2'b0, {IRQ0}};
    CPU CPU_Mips (
        .clk(clk),
        .reset(reset),
        .i_inst_rdata(i_inst_rdata),    //来自IM
        .m_data_rdata(Bridge_O_m_data_rdata),    // 来自Bridge
        .HWInt(CPU_I_HWInt),   // 由Timer0, UART中断信号组合而成

        .i_inst_addr(i_inst_addr),  //直接送出给IM
        .m_data_addr(CPU_O_m_data_addr), //送给Bridge
        .m_data_wdata(CPU_O_m_data_wdata), //送给Bridge
        .m_data_byteen(CPU_O_m_data_byteen), //送给Bridge
        .m_inst_addr(CPU_O_m_inst_addr) //送给Bridge
    );

    Bridge Bridge_Mips (
        .R_Addr(R_Addr),
        .m_data_addr(CPU_O_m_data_addr),  // 来自CPU 
        .m_data_wdata(CPU_O_m_data_wdata), // 来自CPU 
        .m_data_byteen(CPU_O_m_data_byteen), // 来自CPU 
        .m_inst_addr(CPU_O_m_inst_addr),  // 来自CPU 
        .I_DMData(m_data_rdata),     // 来自外设DM(TB)
        .I_Timer0Data(Timer0Data), // 来自外设Timer0
        .I_DipSwitch0_3(R_Reg_DipSwitch0_3),
        .I_DipSwitch4_7(R_Reg_DipSwitch4_7),
        .I_User_Key(R_Reg_User_Key),
        .I_UART(rx_data),
        .I_LED(R_Reg_LED),


        .O_m_data_wdata(Bridge_O_m_data_wdata),   // 送给外设DM, Timer0, LED
        .O_m_data_addr(Bridge_O_m_data_addr),    // 送给外设DM, Timer0, LED
        .O_m_data_byteen(Bridge_O_m_data_byteen),  // 送给外设DM, LED

        .O_DMWE(Bridge_O_DMWE),
        .O_Timer0WE(Bridge_O_Timer0WE),  // 送给外设Timer0
        .O_LEDWE(Bridge_O_LEDWE),
        .O_DigitalTubeWE(Bridge_O_DigitalTubeWE),
        .O_UARTWE(Bridge_O_UARTWE),

        .m_data_rdata(Bridge_O_m_data_rdata)  // 送给CPU
    );

    reg [31:0] Timer0Data_Reg;
    TC Timer0_Mips (
        .clk(clk),
        .reset(reset),
        .Addr(Bridge_O_m_data_addr[31:2]),    // 来自Bridge
        .WE(Bridge_O_Timer0WE),  // 来自Bridge
        .Din(Bridge_O_m_data_wdata), // 来自Bridge
        
        .Dout(Timer0Data),    // 送给Bridge
        .IRQ(IRQ0)  // 送给CPU
    );

    // __GPIO  不封装了
    always @(posedge clk) begin // 同步读写
        if (reset) begin
            W_Reg_DipSwitch0_3 <= 32'd0;
            W_Reg_DipSwitch4_7 <= 32'd0;
            W_Reg_User_Key <= 32'd0;
            Reg_LED <= 32'd0;
        end else begin
            W_Reg_DipSwitch0_3 <= ~({dip_switch3, dip_switch2, dip_switch1, dip_switch0});
            W_Reg_DipSwitch4_7 <= ~({dip_switch7, dip_switch6, dip_switch5, dip_switch4});
            W_Reg_User_Key <= {24'd0, ~user_key};
            if (Bridge_O_LEDWE) begin
                if (Bridge_O_m_data_byteen[3]) Reg_LED[31:24] <= Bridge_O_m_data_wdata[31:24];
                if (Bridge_O_m_data_byteen[2]) Reg_LED[23:16] <= Bridge_O_m_data_wdata[23:16];
                if (Bridge_O_m_data_byteen[1]) Reg_LED[15: 8] <= Bridge_O_m_data_wdata[15: 8];
                if (Bridge_O_m_data_byteen[0]) Reg_LED[7 : 0] <= Bridge_O_m_data_wdata[7 : 0];
            end
        end
        R_Reg_DipSwitch0_3 <= W_Reg_DipSwitch0_3;
        R_Reg_DipSwitch4_7 <= W_Reg_DipSwitch4_7;
        R_Reg_User_Key <= W_Reg_User_Key;
        R_Reg_LED <= Reg_LED;
    end

    DigitalTube __DigitalTube (
        .clk(clk),
        .reset(reset),
        .addr(Bridge_O_m_data_addr[31:2]),
        .en(user_key[1]),                   //按键1直接控制, 但汇编程序仍需通过读取按键1的值选择存取.
        .Wen(Bridge_O_DigitalTubeWE),
        .ByteEn(Bridge_O_m_data_byteen),
        .data(Bridge_O_m_data_wdata),
        
        .sel0(digital_tube_sel0),
        .sel1(digital_tube_sel1),
        .sel2(digital_tube_sel2),
        .seg0(digital_tube0),
        .seg1(digital_tube1),
        .seg2(digital_tube2)
    );

    UART __UART (
        .clk(clk),
        .reset(reset),
        .en(1'b1),      //时刻准备着, 但汇编程序仍需通过读取按键1的值选择存取.
        .Wen(Bridge_O_UARTWE),
        .addr(Bridge_O_m_data_addr[31:2]),
        .data(Bridge_O_m_data_wdata),
        .uart_rxd(uart_rxd),

        .uart_txd(uart_txd),
        .rx_data(rx_data),
        .interrupt(interrupt)
    );

    // 设置输出端口
    assign led_light = ~Reg_LED;
endmodule