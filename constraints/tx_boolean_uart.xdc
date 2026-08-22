# ============================================================
# ROAD SOS - TX MODULE
# Real Digital Boolean Board
# FPGA: XC7S50-CSGA324-1
# ============================================================


# ============================================================
# CLOCK
# Boolean Board 100 MHz oscillator
# FPGA pin F14
# ============================================================

set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports clk]

create_clock -period 10.000 -name sys_clk [get_ports clk]


# ============================================================
# RESET
# BTN0
# FPGA pin J2
# ============================================================

set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports rst]


# ============================================================
# EMERGENCY TRIGGER
# BTN1
# FPGA pin J5
# ============================================================

set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports emergency_trigger]


# ============================================================
# EVENT ID
# SW0 - SW7
#
# event_id[0] -> SW0
# event_id[1] -> SW1
# ...
# event_id[7] -> SW7
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
# FPGA pin V12
# ============================================================

set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports uart_tx]


# ============================================================
# STATUS RGB LEDS
#
# RGB0_RED   -> Emergency detected
# RGB0_GREEN -> Packet generated
#
# RGB1_RED   -> UART transmission active
# RGB1_GREEN -> Transmission completed
# ============================================================

# RGB0 RED
set_property -dict {PACKAGE_PIN V6 IOSTANDARD LVCMOS33} [get_ports led_emergency]

# RGB0 GREEN
set_property -dict {PACKAGE_PIN V4 IOSTANDARD LVCMOS33} [get_ports led_packet]

# RGB1 RED
set_property -dict {PACKAGE_PIN U3 IOSTANDARD LVCMOS33} [get_ports led_tx]

# RGB1 GREEN
set_property -dict {PACKAGE_PIN V3 IOSTANDARD LVCMOS33} [get_ports led_done]


# ============================================================
# DEBUG STATUS
#
# These use the BLUE channels of the RGB LEDs.
#
# busy    -> RGB0_BLUE
# tx_done -> RGB1_BLUE
# ============================================================

set_property -dict {PACKAGE_PIN U6 IOSTANDARD LVCMOS33} [get_ports busy]

set_property -dict {PACKAGE_PIN V5 IOSTANDARD LVCMOS33} [get_ports tx_done]


# ============================================================
# DEBUG VEHICLE ID [15:0]
# Boolean Board LEDs LD0-LD15
#
# debug_vehicle_id[0]  -> LD0
# debug_vehicle_id[1]  -> LD1
# ...
# debug_vehicle_id[15] -> LD15
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
# DEBUG EVENT ID [7:0]
# RIGHT 4-DIGIT SEVEN-SEGMENT DISPLAY
#
# debug_event_id[0] -> CA
# debug_event_id[1] -> CB
# debug_event_id[2] -> CC
# debug_event_id[3] -> CD
# debug_event_id[4] -> CE
# debug_event_id[5] -> CF
# debug_event_id[6] -> CG
# debug_event_id[7] -> DP
#
# Boolean Board SSEG1 / RIGHT DISPLAY
#
# IMPORTANT:
# Seven-segment signals are ACTIVE-LOW.
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
# ASYNCHRONOUS INPUTS
# ============================================================
#
# Reset, emergency button and switches are not synchronous
# to the 100 MHz system clock.
#
# The emergency_input module should synchronize/debounce
# emergency_trigger as required by the design.
# ============================================================

set_false_path -from [get_ports rst]

set_false_path -from [get_ports emergency_trigger]

set_false_path -from [get_ports {event_id[*]}]


# ============================================================
# UART OUTPUT
#
# UART TX is a serial asynchronous interface, not a
# synchronous external timing interface.
# ============================================================

set_false_path -to [get_ports uart_tx]


# ============================================================
# PHYSICAL STATUS OUTPUTS
#
# These are human-visible indicators, not synchronous
# external timing interfaces.
# ============================================================

set_false_path -to [get_ports led_emergency]
set_false_path -to [get_ports led_packet]
set_false_path -to [get_ports led_tx]
set_false_path -to [get_ports led_done]

set_false_path -to [get_ports busy]
set_false_path -to [get_ports tx_done]


# ============================================================
# DEBUG OUTPUTS
# ============================================================

set_false_path -to [get_ports {debug_event_id[*]}]

set_false_path -to [get_ports {debug_vehicle_id[*]}]


# ============================================================
# FPGA CONFIGURATION
# ============================================================

set_property CFGBVS VCCO [current_design]

set_property CONFIG_VOLTAGE 3.3 [current_design]
