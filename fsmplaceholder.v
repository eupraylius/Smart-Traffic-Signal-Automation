// Module definition for a Moore FSM Sequence Detector (detects "101")
module Sequence_Detector_Moore_FSM (
    input wire clk,         // Clock signal
    input wire reset,       // Asynchronous reset
    input wire data_in,     // Input bit
    output reg detected     // Output when "101" is detected
);

// --- State Definitions ---
parameter S0 = 2'b00; // Initial/No Match State
parameter S1 = 2'b01; // Seen '1'
parameter S2 = 2'b10; // Seen '10'
parameter S3 = 2'b11; // Seen '101' (Detected)

reg [1:0] current_state, next_state; // State registers

// --- State Register (Sequential Logic) ---
// Updates current_state with next_state on positive clock edge
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= S0; // Reset to S0
    end else begin
        current_state <= next_state; // Move to next state
    end
end

// --- Next State Logic (Combinational) ---
// Determines next_state based on current_state and data_in
always @(*) begin
    next_state = current_state; // Default to staying in the same state
    case (current_state)
        S0: begin
            if (data_in) next_state = S1; // If '1', go to S1
            else next_state = S0;         // If '0', stay in S0
        end
        S1: begin
            if (data_in == 0) next_state = S2; // If '0', go to S2 (seen '10')
            else next_state = S1;             // If '1', stay in S1 (seen '11')
        end
        S2: begin
            if (data_in) next_state = S3; // If '1', go to S3 (seen '101')
            else next_state = S0;         // If '0', go back to S0 (seen '100')
        end
        S3: begin // Detected state
            if (data_in) next_state = S1; // If '1', go to S1 (new '1' starts sequence)
            else next_state = S0;         // If '0', reset to S0
        end
        default: next_state = S0; // Safety default
    endcase
end

// --- Output Logic (Moore: Output depends only on current_state) ---
always @(*) begin
    detected = 1'b0; // Default output
    case (current_state)
        S3: detected = 1'b1; // Output '1' only in S3
        default: detected = 1'b0;
    endcase
end


endmodule
