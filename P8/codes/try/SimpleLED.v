module SimpleLED (
    input clk_in,
    input sys_rstn,
    output [31:0] led_light
);

    // Counter
    localparam PERIOD = 32'd25_000_000;

    reg [31:0] counter;

    always @(posedge clk_in) begin
        if (~sys_rstn) 
            counter <= 0;
        else begin
            if (counter + 1 == PERIOD)
                counter <= 0;
            else
                counter <= counter + 1;
        end
    end

    // LED
    reg [31:0] led;

    always @(posedge clk_in) begin
        if (~sys_rstn)
            led <= 32'b1;
        else begin
            if (counter + 1 == PERIOD)
                led <= {led[30:0], led[31]};
        end
    end

    assign led_light = ~led;

endmodule