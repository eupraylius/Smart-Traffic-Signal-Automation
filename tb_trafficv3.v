`timescale 1ns/1ps

module tb_smart_traffic_controller;

    reg clk;
    reg reset;
    reg car_sensor;
    reg pedestrian_req;
    reg emergency;
    reg car_enter;
    reg car_exit;

    wire [1:0] traffic_light;
    wire pedestrian_green;
    wire emergency_active;
    wire [3:0] parking_slots;

    // DUT
    smart_traffic_controller dut (
        .clk(clk),
        .reset(reset),
        .car_sensor(car_sensor),
        .pedestrian_req(pedestrian_req),
        .emergency(emergency),
        .car_enter(car_enter),
        .car_exit(car_exit),
        .traffic_light(traffic_light),
        .pedestrian_green(pedestrian_green),
        .emergency_active(emergency_active),
        .parking_slots(parking_slots)
    );

    // Clock: 10 ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("smart_traffic.vcd");
        $dumpvars(0, tb_smart_traffic_controller);

        reset = 1;
        car_sensor = 0;
        pedestrian_req = 0;
        emergency = 0;
        car_enter = 0;
        car_exit = 0;

        #20 reset = 0;

        // Normal car request
        #20 car_sensor = 1;
        #10 car_sensor = 0;

        // Pedestrian request
        #60 pedestrian_req = 1;
        #10 pedestrian_req = 0;

        // Emergency override
        #80 emergency = 1;
        #40 emergency = 0;

        // Parking activity
        #20 car_enter = 1;
        #10 car_enter = 0;

        #20 car_exit = 1;
        #10 car_exit = 0;

        #200 $finish;
    end

endmodule
