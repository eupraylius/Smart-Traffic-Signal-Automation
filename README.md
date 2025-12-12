# Traffic-Management

STEPS:

1. Write the Traffic Light Module (traffic_light.v)

This module cycles through three states:
RED
GREEN
YELLOW
[A counter determines how long each state lasts.]

2. Write the Testbench (tb_traffic.v)

This testbench generates:
A 10 ns clock
A reset pulse
Waveform output (traffic.vcd) for GTKWave

3. Compile the Verilog Code (Icarus Verilog)

Open a terminal in the project folder and run: iverilog -o traffic.out traffic_light.v tb_traffic.v

4. Run the Simulation: vvp traffic.out
[This generates traffic.vcd, which contains all recorded waveform data.]

5. Open the waveform in GTKWave: gtkwave traffic.vcd

Inside GTKWave:
Expand the tb_traffic module
Double-click signals to add them to the waveform
clk
counter[3:0]
light[1:0]
state[1:0]
red, yellow, green

Press Home or Zoom → Zoom to Fit to view the full timing diagram

[Optional: Right-click → Radix → change to binary or unsigned]

<img width="1919" height="1009" alt="image" src="https://github.com/user-attachments/assets/162533ae-6622-4fbf-bb55-5d4801367134" />
Media: FSM traffic light output on gtkwave

<img width="1920" height="1080" alt="Screenshot 2025-12-12 195128" src="https://github.com/user-attachments/assets/4f2c94fa-d312-4ad4-8d05-6a8d279eb9de" />
Media: FSM Colour coded traffic light output on gtkwave

