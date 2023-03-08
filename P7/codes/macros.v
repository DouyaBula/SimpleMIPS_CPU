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

`define Timer1Start 32'h0000_7F10
`define Timer1End 32'h0000_7F1B

`define IGStart 32'h0000_7F20
`define IGEnd 32'h0000_7F23
