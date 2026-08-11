****RoadSoS: Resilient Emergency Communication System****
***🚨 Problem Statement: The "Survival Gap" in Road Emergency Response***
**Context**
In critical road accidents, the "Golden Hour"—the first 60 minutes after an impact—is the most decisive factor in saving lives. Rapid medical intervention depends entirely on the immediate and accurate transmission of the victim's location and medical data to emergency responders.

**The Critical Gap**
Current emergency notification systems (standard SOS buttons or manual phone calls) rely on a "Best-Case Scenario" infrastructure that fails during high-stakes highway accidents due to three primary vulnerabilities:
*Network Volatility:* 
Existing applications rely exclusively on 4G/5G data. In rural highways, tunnels, or mountainous "dead zones," these applications fail to transmit any data.
*Energy Fragility:* 
Smartphones involved in high-impact collisions often suffer from rapid battery drain or OS crashes, rendering software-only SOS solutions useless.
*Communication Latency:* 
Automated systems often lack a robust fail-safe to bypass human intervention in low-signal environments, leading to life-threatening delays in dispatching help.

**The Objective**
To develop RoadSoS, a resilient, multi-layered emergency response system designed to ensure 100% notification delivery regardless of infrastructure limitations.

**Our Solution: The 4-Level Connectivity Stack**
Our engineering approach introduces a Graceful Degradation model that ensures a "Zero-Failure" communication protocol by automatically switching between:
Level 1: High-bandwidth 4G/5G Data (Firebase/Cloud).{Handled by - AADYAA }
Level 2: SMS-Encoded SOS (Compressed data transmission via GSM Signaling Channels). {Handled by - NAMRATA}
Level 3: USSD Gateway (Session-based tower communication as a last resort). {Handled by - SHRADDHA DUBEY]
Level 4: V2V / Mesh Relay (Decentralized Bluetooth/Wi-Fi Direct hopping to passing vehicles).{Handled by - RITIKA GUPTA}

# RoadSoS: Multi-Tiered Emergency Connectivity

This project implements a 4-level fallback system to ensure SOS signals reach emergency services within the **Golden Hour**, regardless of network strength.

### Connectivity Stack:
1. **Standard Data (4G/5G):** Primary channel for rich data transfer.
2. **SMS Fallback:** Uses GSM Signaling Channel for low-signal environments.
3. **USSD Gateway:** Session-based communication for near-zero signal.
4. **V2V Mesh Relay:** BLE-based hopping for total cellular dead zones.
**Impact Goal**
By bridging the "Invisible 40%"—the portion of highway accidents occurring in low-coverage or dead zones—RoadSoS aims to eliminate communication failures and drastically reduce emergency response times.


# SAFE-Link

FPGA-Based LoRa Baseband System for
Intelligent Vehicle-to-Vehicle Emergency Communication

## Status

Project initialization

## Objective

To develop an FPGA-based LoRa digital baseband
for low-latency emergency communication.

## Hardware

Spartan-7 FPGA
External LoRa RF transceiver

## Languages

SystemVerilog
Python
Tcl
Markdown
