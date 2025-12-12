`timescale 1ns/1ps

module tb_traffic;
    reg clk;
    reg reset;
    wire [1:0] light;

    // Instantiate DUT
    traffic_light TL (
        .clk(clk),
        .reset(reset),
        .light(light)
    );

    // Clock - 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Simulation + Waveform dump
    initial begin
        $display("Simulation started...");

        // VCD dump
        $dumpfile("traffic.vcd");
        $dumpvars(0, tb_traffic);  // Dump EVERYTHING in tb_traffic
        $dumpvars(0, TL);          // Dump DUT internals explicitly

        reset = 1;
        #20 reset = 0;

        #200;  // Run long enough to generate wave activity
        $display("Simulation ending...");
        $finish;
    end
endmodule
