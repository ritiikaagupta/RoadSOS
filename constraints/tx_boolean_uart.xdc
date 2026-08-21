# ============================================================
# ROAD SOS - TX MODULE
# Real Digital Boolean Board
# FPGA: XC7S50-CSGA324-1
# ============================================================


# ============================================================
# CLOCK
# Boolean Board 100 MHz oscillator
# ============================================================

set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports clk]

create_clock -period 10.000 -name sys_clk [get_ports clk]


# ============================================================
# RESET
# ============================================================

set_property -dict {PACKAGE_PIN T5 IOSTANDARD LVCMOS33} [get_ports rst]


# ============================================================
# EMERGENCY INPUT
# BTN1 on Boolean Board
# ============================================================

set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports emergency_trigger]


# ============================================================
# EVENT ID INPUT
# SW0 - SW7
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
# Boolean Board USB-UART interface
# ============================================================

set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports uart_tx]


# ============================================================
# 16 DISCRETE LEDs
#
# debug_vehicle_id[15:0]
#
# LED0  -> debug_vehicle_id[0]
# LED1  -> debug_vehicle_id[1]
# ...
# LED15 -> debug_vehicle_id[15]
#
# IMPORTANT:
# These pins are ONLY used for debug_vehicle_id.
# ============================================================

set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} [get_ports {debug_vehicle_id[0]}]
set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} [get_ports {debug_vehicle_id[1]}]
set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS33} [get_ports {debug_vehicle_id[2]}]
set_property -dict {PACKAGE_PIN F2 IOSTANDARD LVCMOS33} [get_ports {debug_vehicle_id[3]}]

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
set_property -dict {PACKAGE_PIN A4 IOSTANDARD LVCMOS33} [get_ports {debug_vehicle_id[15]}]


# ============================================================
# DEBUG EVENT ID
# Seven Segment Display 1 - segment pins
#
# debug_event_id[0] -> CA
# debug_event_id[1] -> CB
# debug_event_id[2] -> CC
# debug_event_id[3] -> CD
# debug_event_id[4] -> CE
# debug_event_id[5] -> CF
# debug_event_id[6] -> CG
# debug_event_id[7] -> DP
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
# STATUS INDICATORS
#
# We use RGB LEDs for status so that the 16 discrete LEDs
# remain completely free for debug_vehicle_id.
#
# RGB0_RED   -> Emergency detected
# RGB0_GREEN -> Packet generated
# RGB1_RED   -> UART TX active
# RGB1_GREEN -> Transmission complete
# ============================================================

set_property -dict {PACKAGE_PIN V6 IOSTANDARD LVCMOS33} [get_ports led_emergency]
set_property -dict {PACKAGE_PIN V4 IOSTANDARD LVCMOS33} [get_ports led_packet]

set_property -dict {PACKAGE_PIN U3 IOSTANDARD LVCMOS33} [get_ports led_tx]
set_property -dict {PACKAGE_PIN V3 IOSTANDARD LVCMOS33} [get_ports led_done]


# ============================================================
# BUSY / TX_DONE
#
# RGB blue channels
#
# RGB0_BLUE -> busy
# RGB1_BLUE -> tx_done
# ============================================================

set_property -dict {PACKAGE_PIN U6 IOSTANDARD LVCMOS33} [get_ports busy]
set_property -dict {PACKAGE_PIN V5 IOSTANDARD LVCMOS33} [get_ports tx_done]


# ============================================================
# INPUT TIMING CONSTRAINTS
# ============================================================

set_input_delay -clock sys_clk 0 [get_ports rst]
set_input_delay -clock sys_clk 0 [get_ports emergency_trigger]
set_input_delay -clock sys_clk 0 [get_ports {event_id[*]}]


# ============================================================
# OUTPUT TIMING CONSTRAINTS
# ============================================================

set_output_delay -clock sys_clk 0 [get_ports uart_tx]

set_output_delay -clock sys_clk 0 [get_ports busy]
set_output_delay -clock sys_clk 0 [get_ports tx_done]

set_output_delay -clock sys_clk 0 [get_ports {debug_event_id[*]}]
set_output_delay -clock sys_clk 0 [get_ports {debug_vehicle_id[*]}]

set_output_delay -clock sys_clk 0 [get_ports led_emergency]
set_output_delay -clock sys_clk 0 [get_ports led_packet]
set_output_delay -clock sys_clk 0 [get_ports led_tx]
set_output_delay -clock sys_clk 0 [get_ports led_done]


# ============================================================
# ASYNCHRONOUS INPUTS
# ============================================================

set_false_path -from [get_ports rst]
set_false_path -from [get_ports emergency_trigger]
set_false_path -from [get_ports {event_id[*]}]


# ============================================================
# DEBUG / STATUS OUTPUTS
# ============================================================

set_false_path -to [get_ports busy]
set_false_path -to [get_ports tx_done]

set_false_path -to [get_ports {debug_event_id[*]}]
set_false_path -to [get_ports {debug_vehicle_id[*]}]


# ============================================================
# STATUS LEDs
# ============================================================

set_false_path -to [get_ports led_emergency]
set_false_path -to [get_ports led_packet]
set_false_path -to [get_ports led_tx]
set_false_path -to [get_ports led_done]


# ============================================================
# UART
# ============================================================

set_false_path -to [get_ports uart_tx]


# ============================================================
# FPGA CONFIGURATION
# ============================================================

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
