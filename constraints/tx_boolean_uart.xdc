# ============================================================
# ROAD SOS - TX MODULE
# Real Digital Boolean Board
# FPGA: XC7S50-CSGA324-1
# ============================================================

# ============================================================
# CLOCK
# On-board 100 MHz oscillator
# ============================================================
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 10.000 -name sys_clk [get_ports clk]


# ============================================================
# RESET / EMERGENCY INPUT
# ============================================================
set_property -dict {PACKAGE_PIN T5 IOSTANDARD LVCMOS33} [get_ports rst]
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports emergency_trigger]


# ============================================================
# EVENT ID INPUT
# Boolean Board SW0-SW7
# ============================================================
set_property -dict {PACKAGE_PIN V2 IOSTANDARD LVCMOS33} [get_ports {event_id[0]}]
set_property -dict {PACKAGE_PIN U2 IOSTANDARD LVCMOS33} [get_ports {event_id[1]}]
set_property -dict {PACKAGE_PIN U1 IOSTANDARD LVCMOS33} [get_ports {event_id[2]}]
set_property -dict {PACKAGE_PIN T2 IOSTANDARD LVCMOS33} [get_ports {event_id[3]}]
set_property -dict {PACKAGE_PIN T1 IOSTANDARD LVCMOS33} [get_ports {event_id[4]}]
set_property -dict {PACKAGE_PIN R2 IOSTANDARD LVCMOS33} [get_ports {event_id[5]}]
set_property -dict {PACKAGE_PIN R1 IOSTANDARD LVCMOS33} [get_ports {event_id[6]}]
set_property -dict {PACKAGE_PIN P2 IOSTANDARD LVCMOS33} [get_ports {event_id[7]}]


# ============================================================
# UART TX
# Boolean Board USB-UART TX pin
# ============================================================
set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports uart_tx]


# ============================================================
# STATUS OUTPUTS
# Use RGB LED pins for BUSY and TX_DONE
# ============================================================
set_property -dict {PACKAGE_PIN V6 IOSTANDARD LVCMOS33} [get_ports busy]
set_property -dict {PACKAGE_PIN V4 IOSTANDARD LVCMOS33} [get_ports tx_done]


# ============================================================
# DEBUG VEHICLE ID [15:0]
# Mapped to Boolean Board LEDs LD0-LD15
#
# debug_vehicle_id[0]  -> LD0
# debug_vehicle_id[1]  -> LD1
# ...
# debug_vehicle_id[15] -> LD15
# ============================================================

set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} [get_ports {debug_vehicle_id[0]}]
set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} [get_ports {debug_vehicle_id[1]}]
set_property -dict {PACKAGE_PIN F2 IOSTANDARD LVCMOS33} [get_ports {debug_vehicle_id[2]}]
set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS33} [get_ports {debug_vehicle_id[3]}]
set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS33} [get_ports {debug_vehicle_id[4]}]
set_property -dict {PACKAGE_PIN E2 IOSTANDARD LVCMOS33} [get_ports {debug_vehicle_id[5]}]
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports {debug_vehicle_id[6]}]
set_property -dict {PACKAGE_PIN E5 IOSTANDARD LVCMOS33} [get_ports {debug_vehicle_id[7]}]
set_property -dict {PACKAGE_PIN E6 IOSTANDARD LVCMOS33} [get_ports {debug_vehicle_id[8]}]
set_property -dict {PACKAGE_PIN C3 IOSTANDARD LVCMOS33} [get_ports {debug_vehicle_id[9]}]
set_property -dict {PACKAGE_PIN B2 IOSTANDARD LVCMOS33} [get_ports {debug_vehicle_id[10]}]
set_property -dict {PACKAGE_PIN A2 IOSTANDARD LVCMOS33} [get_ports {debug_vehicle_id[11]}]
set_property -dict {PACKAGE_PIN B3 IOSTANDARD LVCMOS33} [get_ports {debug_vehicle_id[12]}]
set_property -dict {PACKAGE_PIN A3 IOSTANDARD LVCMOS33} [get_ports {debug_vehicle_id[13]}]
set_property -dict {PACKAGE_PIN B4 IOSTANDARD LVCMOS33} [get_ports {debug_vehicle_id[14]}]
set_property -dict {PACKAGE_PIN A5 IOSTANDARD LVCMOS33} [get_ports {debug_vehicle_id[15]}]


# ============================================================
# DEBUG EVENT ID [7:0]
# Mapped to Seven Segment Display 1 segment pins
#
# debug_event_id[0] -> SSEG1_CA
# debug_event_id[1] -> SSEG1_CB
# debug_event_id[2] -> SSEG1_CC
# debug_event_id[3] -> SSEG1_CD
# debug_event_id[4] -> SSEG1_CE
# debug_event_id[5] -> SSEG1_CF
# debug_event_id[6] -> SSEG1_CG
# debug_event_id[7] -> SSEG1_DP
# ============================================================

set_property -dict {PACKAGE_PIN F4 IOSTANDARD LVCMOS33} [get_ports {debug_event_id[0]}]
set_property -dict {PACKAGE_PIN J3 IOSTANDARD LVCMOS33} [get_ports {debug_event_id[1]}]
set_property -dict {PACKAGE_PIN D2 IOSTANDARD LVCMOS33} [get_ports {debug_event_id[2]}]
set_property -dict {PACKAGE_PIN C2 IOSTANDARD LVCMOS33} [get_ports {debug_event_id[3]}]
set_property -dict {PACKAGE_PIN B1 IOSTANDARD LVCMOS33} [get_ports {debug_event_id[4]}]
set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVCMOS33} [get_ports {debug_event_id[5]}]
set_property -dict {PACKAGE_PIN D1 IOSTANDARD LVCMOS33} [get_ports {debug_event_id[6]}]
set_property -dict {PACKAGE_PIN C1 IOSTANDARD LVCMOS33} [get_ports {debug_event_id[7]}]


# ============================================================
# FPGA CONFIGURATION
# ============================================================
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
