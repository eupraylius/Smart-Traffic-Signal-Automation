module smart_traffic_controller (
    input wire clk,
    input wire reset,

    // Control inputs
    input wire car_sensor,
    input wire pedestrian_req,
    input wire emergency,

    // Parking system
    input wire car_enter,
    input wire car_exit,

    // Outputs
    output reg [1:0] traffic_light,     // 00=RED, 01=YELLOW, 10=GREEN
    output reg pedestrian_green,
    output reg emergency_active,
    output reg [3:0] parking_slots
);

    // State encoding
    localparam s0_IDLE        = 3'b000;
    localparam s1_GREEN       = 3'b001;
    localparam s2_YELLOW      = 3'b010;
    localparam s3_RED         = 3'b011;
    localparam s4_EMERGENCY   = 3'b100;
    localparam s5_PEDESTRIAN  = 3'b101;

    reg [2:0] state, next_state;
    reg [3:0] timer;

    // -------------------- State Register --------------------
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= s0_IDLE;
            timer <= 0;
            parking_slots <= 4'd10;
        end else begin
            state <= next_state;

            // Reset timer whenever state changes
            if (state != next_state)
                timer <= 0;
            else
                timer <= timer + 1;
        end
    end

    // -------------------- Parking Slot Management --------------------
    always @(posedge clk) begin
        if (!reset) begin
            if (car_enter && parking_slots > 0)
                parking_slots <= parking_slots - 1;
            else if (car_exit && parking_slots < 10)
                parking_slots <= parking_slots + 1;
        end
    end

    // -------------------- Next State Logic --------------------
    always @(*) begin
        next_state = state;

        case (state)

            s0_IDLE:
                if (emergency)         next_state = s4_EMERGENCY;
                else if (pedestrian_req) next_state = s5_PEDESTRIAN;
                else if (car_sensor)     next_state = s1_GREEN;

            s1_GREEN:
                if (emergency)         next_state = s4_EMERGENCY;
                else if (timer == 4)   next_state = s2_YELLOW;

            s2_YELLOW:
                if (timer == 2)        next_state = s3_RED;

            s3_RED:
                if (timer == 3)        next_state = s0_IDLE;

            s5_PEDESTRIAN:
                if (timer == 3)        next_state = s0_IDLE;

            s4_EMERGENCY:
                if (!emergency)        next_state = s0_IDLE;

            default: next_state = s0_IDLE;
        endcase
    end

    // -------------------- Output Logic --------------------
    always @(*) begin
        traffic_light = 2'b00;
        pedestrian_green = 0;
        emergency_active = 0;

        case (state)
            s1_GREEN:    traffic_light = 2'b10;
            s2_YELLOW:   traffic_light = 2'b01;
            s3_RED:      traffic_light = 2'b00;

            s5_PEDESTRIAN: begin
                traffic_light = 2'b00;
                pedestrian_green = 1;
            end

            s4_EMERGENCY: begin
                traffic_light = 2'b10; // force GREEN
                emergency_active = 1;
            end
        endcase
    end

endmodule
