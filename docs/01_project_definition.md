# SAFE-Link Project Definition

## Project Title

An FPGA-Based LoRa Baseband System for Intelligent
Vehicle-to-Vehicle Emergency Communication

## Problem
Road accidents, sudden braking, vehicle breakdowns, and road hazards require emergency information to reach nearby vehicles within a very short time. However, conventional vehicle-to-vehicle communication solutions often depend on cellular networks, internet connectivity, or centralized infrastructure, which may be unreliable or unavailable in **remote areas such as rural highways, forest routes, desert roads, and mountainous regions**, where network coverage is weak or completely absent.
There is therefore a need for an **infrastructure-independent vehicle-to-vehicle emergency communication system** capable of transmitting compact safety messages directly between nearby vehicles over long distances with reliable packet delivery and predictable processing delay.
The challenge is to design a communication architecture that can detect an emergency event, generate a prioritized safety packet, transmit it wirelessly, recover and validate the packet at the receiving vehicle, and generate an alert with minimum processing delay. The system must also operate with low power and remain functional when conventional cellular or internet connectivity is unavailable, especially in **remote and network-limited environments**.


## Proposed Solution
An FPGA will implement the digital LoRa baseband processing required for emergency-message communication. Emergency events will be generated through sensors or a manual emergency input and converted into compact, priority-based packets containing essential safety information such as event type and vehicle-related status.
At the transmitting side, the FPGA will perform packet generation, framing, error-detection coding, synchronization-related processing, and LoRa baseband modulation. An external LoRa transceiver and antenna will provide the RF wireless link between vehicles.
At the receiving side, the FPGA will perform synchronization, demodulation-related baseband processing, packet recovery, CRC validation, and emergency-alert generation. Hardware parallelism, pipelining, and dedicated processing blocks will be explored to reduce and make the baseband processing delay more deterministic.
The resulting system will enable direct vehicle-to-vehicle emergency communication without requiring cellular networks, internet connectivity, or roadside infrastructure.


## Main Objective
To design and experimentally validate a low-latency, low-power, infrastructure-independent LoRa-based V2V emergency communication system using FPGA hardware, capable of reliably detecting, transmitting, receiving, and processing emergency messages between vehicles in network-limited environments.
Specific Objectives: 
To design a modular LoRa digital baseband architecture suitable for implementation on a Spartan-7 FPGA.
To develop hardware blocks for emergency packet generation, framing, synchronization, modulation, demodulation, packet recovery, and CRC-based error detection.
To investigate FPGA parallelism and pipelining techniques for reducing deterministic baseband processing latency.
To develop priority-based emergency packets for rapid dissemination of critical safety information.
To integrate the FPGA baseband with an external LoRa RF transceiver for wireless V2V communication.
To experimentally evaluate end-to-end latency, packet delivery reliability, communication range, and power consumption.
To determine the suitability of the proposed architecture for emergency communication in areas with limited or unavailable cellular connectivity.


## Expected Output
The project is expected to produce:
1. **FPGA-based LoRa digital baseband IP** implemented on a Spartan-7 FPGA.
2. A functional **emergency packet-generation and priority-handling module**.
3. FPGA hardware modules for **framing, synchronization, modulation, demodulation, packet recovery, and CRC validation**.
4. A working interface between the FPGA baseband and an **external LoRa RF transceiver**.
5. A prototype demonstrating **direct V2V emergency-message transmission without cellular or internet infrastructure**.
6. A receiver-side emergency alert mechanism that generates an alert after successful packet validation.
7. Experimental measurements of:

   * End-to-end emergency-message latency
   * FPGA baseband processing latency
   * Packet delivery reliability
   * Communication range
   * Power consumption
8. A comparison of different FPGA implementation techniques, particularly **parallelism and pipelining**, to determine their effect on processing latency and hardware utilization.
9. A validated prototype demonstrating the feasibility of LoRa-based FPGA communication for **remote and network-limited transportation environments**.


## Research Focus
The research focuses on designing and implementing a **low-latency FPGA-based V2X emergency communication system** for infrastructure-independent safety messaging in intelligent transportation systems.
The major research areas include:
* **FPGA-based V2X architecture:** Design of a real-time V2V/V2I communication system on FPGA for emergency and safety messages without relying on cellular or cloud infrastructure.
* **Custom FPGA baseband design:** Development of a lightweight, application-specific digital communication pipeline (modulation, framing, and packet processing) optimized for low latency.
* **Low-latency processing pipeline:** Minimization of end-to-end delay from emergency detection to transmission and reception using pipelined and parallel FPGA design.
* **FPGA parallelism and optimization:** Use of parallel and pipelined architectures to speed up packet generation, encoding, modulation, and decoding.
* **Emergency message prioritization:** Design of high-priority safety packets for critical events like collision warnings and sudden braking alerts.
* **Reliable communication techniques:** Implementation of synchronization, packet alignment, and CRC-based error detection for robust performance in vehicular environments.
* **Latency and resource trade-off analysis:** Evaluation of FPGA resource usage, power consumption, and latency to optimize system performance.
* **Infrastructure-independent operation:** Ensuring communication works in remote or network-denied environments without external connectivity.
* **End-to-end latency evaluation:** Measurement of total system delay from event generation to alert reception, including FPGA and wireless delays.
