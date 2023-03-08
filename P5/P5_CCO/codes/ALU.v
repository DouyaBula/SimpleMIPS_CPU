`timescale 1ns / 1ps
`default_nettype none 
module ALU (
    input wire [31:0] SrcA, SrcB,
    input wire [3:0] ALUControl,

    output wire [31:0] ALUResult
);
    reg [31:0] SUMReg, SUBReg, ORReg, LUIReg;
    
    reg [31:0] CCOResult;

    integer i;
    always @(*) begin
        SUMReg = SrcA + SrcB;
        SUBReg = SrcA - SrcB;
        ORReg = SrcA | SrcB;
        LUIReg = {{SrcB[15:0]}, 16'h0000}; 

        CCOResult = 32'd0;
        for (i = 0; i < 32; i = i + 1) begin
            if(SrcA[i] & SrcB[i]) CCOResult = CCOResult + 32'd1;
        end
    end


    assign ALUResult =  (ALUControl == 4'b0000) ? SUMReg :
                        (ALUControl == 4'b0001) ? SUBReg :
                        (ALUControl == 4'b0011) ? ORReg :
                        (ALUControl == 4'b0110) ? LUIReg :
                        (ALUControl == 4'b1010) ? CCOResult : 32'haaaa;

endmodule