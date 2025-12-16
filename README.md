## Traffic-Management

---

## Tools & Technology Stack

| Category | Tool / Technology | Purpose |
|--------|------------------|--------|
| Hardware Description | Verilog HDL | FSM-based traffic signal controller design |
| Simulation | Icarus Verilog | Compiling and running Verilog simulations |
| Waveform Analysis | GTKWave | Visualizing FSM states and signal timing |
| Version Control | Git & GitHub | Source code management and collaboration |
| Development Environment | VS Code / Any Text Editor | Writing and editing HDL code |

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

