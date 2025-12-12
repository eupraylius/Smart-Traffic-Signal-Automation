module traffic_light(
    input clk,
    input reset,
    output reg [1:0] light
);
    // Encode states
    localparam RED    = 2'b00;
    localparam GREEN  = 2'b01;
    localparam YELLOW = 2'b10;

    reg [1:0] state;
    reg [3:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= RED;
            counter <= 0;
        end else begin
            counter <= counter + 1;

            case (state)
                RED: begin
                    if (counter == 4) begin
                        state <= GREEN;
                        counter <= 0;
                    end
                end

                GREEN: begin
                    if (counter == 3) begin
                        state <= YELLOW;
                        counter <= 0;
                    end
                end

                YELLOW: begin
                    if (counter == 2) begin
                        state <= RED;
                        counter <= 0;
                    end
                end
            endcase
        end
    end

    // Output light = state
    always @(*) begin
        light = state;
    end
endmodule
