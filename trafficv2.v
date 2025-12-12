
`timescale 1ns/1ps 
`define Red 2'b00
`define Green 2'b11
`define Yellow 2'b01 
`define s0  3'b000//highway on gg country off
`define s1  3'b001//highway on 
`define s2  3'b010
`define s3  3'b011
`define s4  3'b100
`define s5  3'b101

////////////////////////Delays
`define YellowtoRed  7
`define RedtoGreen   7
`define s0tos1   9
`define s1tos2   7
`define s3tos4   9
/////////////////////////true and false

`define TRUE 1'b1
`define FALSE 1'b0

// small stub for char_detector so file compiles
module char_detector(
    input  wire [7:0] char,
    output wire       is_true1
);
    assign is_true1 = (char == 8'h41) ? 1'b1 : 1'b0; // 'A' example
endmodule


module first(hwy, country, X, B, clock, clear, hours, minutes, char, is_true, is_true1);

    // Port declarations (kept in your original order)
    output reg [1:0] hwy, country; // green yellow red
    input X; // for the traffic in day 
    input B; // for the a b c in night
    input clock, clear;
    input [4:0] hours;   
    input [5:0] minutes; 
    input [7:0] char;  

    // fixed: specify type for is_true and terminate is_true1 declaration with semicolon
    output reg is_true;  
    output wire is_true1;

    // internal regs
    reg [2:0] state;
    reg [2:0] next_state;

    initial begin
        state = `s0;
        next_state = `s0;
        hwy = `Green;
        country = `Red;
        is_true = `FALSE;
    end

    // synchronous state update
    always @(posedge clock) begin
        state <= next_state;
    end

    // outputs based on state
    always @(state) begin
        case (state)
            `s0: begin hwy=`Green;  country=`Red;   end
            `s1: begin hwy=`Green;  country=`Red;   end
            `s2: begin hwy=`Yellow; country=`Red;   end
            `s3: begin hwy=`Red;    country=`Green; end
            `s4: begin hwy=`Red;    country=`Yellow;end
            default: begin hwy=`Green; country=`Red; end
        endcase
    end

    // instantiate char_detector (single instance)
    char_detector char_det_inst (
        .char(char),
        .is_true1(is_true1)
    );

    // NOTE: original code used repeat(@posedge clock) inside combinational always.
    // That is illegal. To keep your logic structure and make the file syntactically
    // valid I left immediate transitions where timing was requested. Replace with
    // counters/timers on posedge clock when you want real delays.
    always @(state or clear or X or is_true1 or hours or minutes) begin
        if ((hours >= 5 && hours < 9) || (hours == 9 && minutes == 0)) begin
            if (clear) next_state = `s0;
            else begin
                case (state)
                    `s0: if (X) next_state = `s1; else if (is_true1) next_state = `s2; else next_state = `s0;
                    `s1: next_state = `s2;
                    `s2: next_state = `s3;
                    `s3: next_state = `s4;
                    `s4: next_state = `s0;
                    default: next_state = `s0;
                endcase
            end
        end else begin
            if (clear) next_state = `s0;
            else begin
                case (state)
                    `s0: if (is_true1) next_state = `s2; else next_state = `s0;
                    `s2: next_state = `s4;
                    `s4: next_state = `s0;
                    default: next_state = `s0;
                endcase
            end
        end
    end

endmodule
