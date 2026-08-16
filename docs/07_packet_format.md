# Packet Format — Version 1

The initial application-layer emergency packet is designed as a
48-bit packet for FPGA development and verification.

| Field | Size | Description |
|---|---:|---|
| Header | 8 bits | Packet identification |
| Event ID | 8 bits | Type of emergency event |
| Vehicle ID | 16 bits | Identifier of transmitting vehicle |
| CRC | 16 bits | CRC-16-CCITT error detection |

## Total Packet Size

48 bits = 6 bytes

## Header

0xA5

## Event IDs

| Event ID | Event |
|---|---|
| 0x01 | Sudden braking |
| 0x02 | Accident |
| 0x03 | Vehicle breakdown |
| 0x04 | Road hazard |

## CRC

CRC-16-CCITT is calculated over:

Header + Event ID + Vehicle ID

The CRC is appended at the end of the packet.

## Example

Header = A5
Event ID = 01
Vehicle ID = 0017

CRC = 8715

Complete packet:

A5 01 00 17 87 15
