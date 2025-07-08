# Advanced Comparative Analysis of Congestion Control Algorithms and QoS Metrics in Heterogeneous Networks

## Overview

This project presents a comparative study of various TCP congestion control algorithms—namely Reno, New Reno, Tahoe, BIC, and CUBIC—under different wireless network interference conditions (no interference, low interference, and high interference). The project further investigates Quality of Service (QoS) parameters such as throughput, delay, and jitter for typical network traffic types like video, audio, and Constant Bit Rate (CBR) data.

## Objectives

- Model and simulate the behavior of multiple TCP congestion control algorithms under varying levels of network interference.
- Measure key QoS metrics: throughput, delay, and jitter.
- Evaluate sensitivity of real-time and non-real-time traffic to congestion and interference.
- Compare algorithm performance to suggest suitable protocol selection for different traffic environments.

## Technologies Used

- **MATLAB (R2021a or later)** for simulation and visualization.
- **Standard statistical models** for simulating jitter, delay, and throughput.
- **No external datasets** were used; all data was synthetically generated.

## Project Modules

1. **Interference-Free Simulation**:
   - Simulates TCP variants without interference.
   - Compares throughput and delay performance.

2. **Low Interference Scenario**:
   - Introduces CBR nodes to simulate mild congestion.
   - Evaluates impact on TCP performance.

3. **High Interference Scenario**:
   - Involves 5 CBR nodes and high channel contention.
   - Tests resilience of TCP algorithms under stress.

4. **QoS Analysis**:
   - Simulates traffic flows for video, audio, and CBR.
   - Measures and plots real-time metrics like jitter and delay.

5. **Topology Visualization**:
   - Visual representations of node positions and access point.
   - Helps understand traffic layout and node relationships.

## Key Findings

- **CUBIC** performs best under low interference due to its aggressive window growth.
- **New Reno** is more resilient under high interference conditions.
- **Tahoe** consistently delivers the lowest throughput due to conservative behavior.
- **QoS analysis** shows that video and audio traffic are highly sensitive to jitter and delay.

## Future Work

- Integrate **machine learning techniques** to enable adaptive congestion control.
- Extend simulation to other platforms like **NS-3** or **OMNeT++**.
- Evaluate newer congestion protocols such as **BBR** and **TCP Prague**.
- Test in **mobile environments** like VANETs for real-world applicability.

## How to Run

1. Open MATLAB R2021a or newer.
2. Load any of the provided `.m` script files corresponding to the simulation type:
   - `no_interference.m`
   - `low_interference.m`
   - `high_interference.m`
   - `qos_simulation.m`
3. Run the script to view graphs and performance output in the Command Window.

## License

This project is licensed under the [MIT License](LICENSE).  
You are free to use, modify, and distribute this code with proper attribution.  
Please retain the license file and mention the original author in derived works.


