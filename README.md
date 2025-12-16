## Traffic-Management
---

## Tools & Technology Stack

| Category | Tool / Technology | Purpose |
|--------|------------------|--------|
| Hardware Description | Verilog HDL | FSM-based traffic signal controller design |
| Simulation | Icarus Verilog | Compiling and running Verilog simulations |
| Waveform Analysis | GTKWave | Visualizing FSM states and signal timing |
| Version Control | Git & GitHub | Source code management and collaboration |
| Development Environment | Notepad++ / Any Text Editor | Writing and editing Verilog code |

---

## Simulation & Verification

The traffic signal controller is verified entirely through simulation.

- Dedicated testbench modules generate clock and reset signals.
- FSM behavior is validated through waveform inspection.
- GTKWave is used to analyze timing diagrams and signal correctness.

> Simulation artifacts such as `.vcd` and `.out` files are generated during runtime and are excluded from version control.

---

## Simulation Workflow

### 1. Traffic Light Module (`traffic_light.v`)

- Implements a Finite State Machine (FSM)
- States include:
  - RED
  - GREEN
  - YELLOW
- State duration is controlled using a counter
- Output signals drive the traffic lights

---

### 2. Testbench (`tb_traffic.v`)

The testbench provides:
- A 10 ns clock signal
- A reset pulse for initialization
- Waveform dumping for post-simulation analysis

Generated output:
- `traffic.vcd`

---

### 3. Compile the Design

Run the following command in the project directory:

```bash
iverilog -o traffic.out traffic_light.v tb_traffic.v
```

### 4. Run the Simulation

```bash
vvp traffic.out
```

### 5. Waveform Analysis

Open the waveform viewer:
```bash
gtkwave traffic.vcd
```
Inside GTKWave:
Expand the tb_traffic module
Add the following signals:
```
clk
counter[3:0]
state[1:0]
light[1:0]
red, yellow, green
```
Use Zoom → Zoom to Fit (or press Home) to view the full timing diagram

(Optional) Change signal radix via Right-click → Data Format


### 6. Sample Output

<img width="1920" height="1080" alt="traffic v1" src="https://github.com/user-attachments/assets/0fd51fc1-f5e9-4d5e-995d-19b9da5ecfa0" />

<img width="1920" height="1080" alt="traffic v3" src="https://github.com/user-attachments/assets/c80da8bc-96a0-49c3-87ca-8063a79366fc" />

Explanation:
Each uses a 2-bit code:

Code	Meaning
11	Green
01	Yellow
00	Red
Day Mode (5:00 to 9:00)

During the day, the controller operates based on vehicle arrival detection (X).

If X = 0 → No cars
→ Highway stays Green
→ Country stays Red

If X = 1 → Car arrives
→ The system triggers the full sequence:
Green → Yellow → Red → Switch roads → Yellow → Back to Green

Character-based input is ignored in day mode.

Night Mode (Outside 5:00–9:00)

During the night, the system switches based on character input, through the char_detector module.

char[7:0] is checked

If the character matches (A/B/C etc.), then is_true1 = 1

Night mode uses is_true1 instead of sensor X

This allows transitions based on user-defined character logic.

State Machine

The controller has 6 states:

State	Code	Meaning

| State | Binary Code | Description |
|------|------------|-------------|
| s0 | `000` | Highway Green, Country Red |
| s1 | `001` | Highway Green (pending) |
| s2 | `010` | Highway Yellow |
| s3 | `011` | Highway Red, Country Green |
| s4 | `100` | Country Yellow |
| s5 | `101` | Reserved / unused |


The sequence of transitions depends on day/night mode and sensor/character inputs.

Important Signals Explained
Signal	Purpose
- X	Day-mode sensor input detecting a car
- B	Night-mode auxiliary input (optional)
- clock	Drives the FSM state changes
- clear	Resets the system to state s0
- hours / minutes	Determines day vs night mode
- char[7:0]	Character input sent to the detector
- is_true1	Output of character detector (1 if char is valid)
- state[2:0]	Current FSM state
- next_state[2:0]	Calculated next FSM state
- hwy[1:0]	Highway traffic light
- country[1:0]	Country road traffic light

Waveform Explanation

When simulated in GTKWave:

hwy shows green (11) during idle day-mode

country shows red (00)

state stays around 000/001 because no cars arrive (X = 0)

char_detector still outputs values (is_true1 toggles), but day mode ignores it

The system behaves correctly according to the day-time rules
