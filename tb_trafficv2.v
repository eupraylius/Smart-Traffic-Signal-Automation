// tb_trafficv2_fixed.v
`timescale 1ns/1ps

module tb_trafficv2;
    reg clk;
    reg clear;
    reg X;
    reg B;
    reg [4:0] hours;
    reg [5:0] minutes;
    reg [7:0] char;
    wire [1:0] hwy, country;
    wire is_true1;
    wire is_true;

    // Instantiate DUT
    first DUT (
        .hwy(hwy),
        .country(country),
        .X(X),
        .B(B),
        .clock(clk),
        .clear(clear),
        .hours(hours),
        .minutes(minutes),
        .char(char),
        .is_true(is_true),
        .is_true1(is_true1)
    );

    // clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns period
    end

    initial begin
        $display("Starting TB...");
        $dumpfile("trafficv2.vcd");
        $dumpvars(0, tb_trafficv2);

        // initial stimulus
        clear = 1; X = 0; B = 0; hours = 4; minutes = 59; char = 8'h00;
        #12; clear = 0;

        // test: day time and an 'A' char to trigger detector
        #20; hours = 5; minutes = 0; char = 8'h41; // daytime begins
        #200;

        $display("Ending TB...");
        $finish;
    end
endmodule
