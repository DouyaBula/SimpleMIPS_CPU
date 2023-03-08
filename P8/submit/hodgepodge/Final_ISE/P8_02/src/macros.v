// 异常与中断编码
`define None 5'd31          //无异常
`define Int 5'd0            //外部中断
`define AdEL 5'd4           //取指异常 或 取数异常
`define AdES 5'd5           //存数异常
`define Syscall 5'd8        //系统调用
`define RI 5'd10            //未知指令
`define Ov 5'd12            //溢出异常

// 地址空间编码 
`define DataMemStart 32'h0000_0000
`define DataMemEnd 32'h0000_2FFF

`define IMStart 32'h0000_3000
`define IMEnd 32'h0000_6FFF

`define Timer0Start 32'h0000_7F00
`define Timer0End 32'h0000_7F0B

`define UARTStart 32'h0000_7F30
`define UARTEnd 32'h0000_7F4B

`define DigitalTubeStart 32'h0000_7F50
`define DigitalTubeEnd 32'h0000_7F57

`define DipSwitch0_3Start 32'h0000_7F60
`define DipSwitch0_3End 32'h0000_7F63

`define DipSwitch4_7Start 32'h0000_7F64
`define DipSwitch4_7End 32'h0000_7F67

`define UserKeyStart 32'h0000_7F68
`define UserKeyEnd 32'h0000_7F6B
// 是32位寄存器, 但只用到低8位, 即第一个字节.

`define LEDStart 32'h0000_7F70
`define LEDEnd 32'h0000_7F73

// 除数因子
// baud = clk_freq / num_cycles
`define PERIOD_BAUD_9600    32'd2604    // 10^9ns / 9600baud / 40ns(25MHz)  
`define PERIOD_BAUD_38400   32'd651
`define PERIOD_BAUD_57600   32'd434
`define PERIOD_BAUD_115200  32'd217

