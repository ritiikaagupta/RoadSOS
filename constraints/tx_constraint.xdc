## ============================================================
## RoadSOS TX - Boolean Board Constraints
## Board  : Real Digital Boolean Board
## FPGA   : Xilinx/AMD Spartan-7 XC7S50-CSGA324
## Top    : tx_top_module
## ============================================================


## ============================================================
## CLOCK
## Boolean Board 100 MHz oscillator
## FPGA pin: F14
## ============================================================

set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports {clk}]

create_clock -period 10.000 -name sys_clk -waveform {0.000 5.000} [get_ports {clk}]


## ============================================================
## RESET
## BTN0 -> J2
##
## Pushbutton is normally 0 and becomes 1 when pressed.
## Your RTL uses active-high reset.
## ============================================================

set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports {rst}]


## ============================================================
## EMERGENCY TRIGGER
## BTN1 -> J5
##
## Press BTN1 to generate emergency_trigger = 1
## ============================================================

set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports {emergency_trigger}]


## ============================================================
## EVENT ID
## SW0-SW7
##
## SW0 -> event_id[0]
## SW1 -> event_id[1]
## ...
## SW7 -> event_id[7]
## ============================================================

set_property -dict {PACKAGE_PIN V2 IOSTANDARD LVCMOS33} [get_ports {event_id[0]}]
set_property -dict {PACKAGE_PIN U2 IOSTANDARD LVCMOS33} [get_ports {event_id[1]}]
set_property -dict {PACKAGE_PIN U1 IOSTANDARD LVCMOS33} [get_ports {event_id[2]}]
set_property -dict {PACKAGE_PIN T2 IOSTANDARD LVCMOS33} [get_ports {event_id[3]}]
set_property -dict {PACKAGE_PIN T1 IOSTANDARD LVCMOS33} [get_ports {event_id[4]}]
set_property -dict {PACKAGE_PIN R2 IOSTANDARD LVCMOS33} [get_ports {event_id[5]}]
set_property -dict {PACKAGE_PIN R1 IOSTANDARD LVCMOS33} [get_ports {event_id[6]}]
set_property -dict {PACKAGE_PIN P2 IOSTANDARD LVCMOS33} [get_ports {event_id[7]}]


## ============================================================
## STATUS LEDs
##
## LD0 -> busy
## LD1 -> tx_done
## LD2 -> tx_valid
## ============================================================

set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} [get_ports {busy}]
set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} [get_ports {tx_done}]
set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS33} [get_ports {tx_valid}]


## ============================================================
## I OUTPUT DEBUG
##
## Display the lowest 5 bits of I on LD3-LD7.
##
## LD3 -> i_out[0]
## LD4 -> i_out[1]
## LD5 -> i_out[2]
## LD6 -> i_out[3]
## LD7 -> i_out[4]
## ============================================================

set_property -dict {PACKAGE_PIN F2 IOSTANDARD LVCMOS33} [get_ports {i_out[0]}]
set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS33} [get_ports {i_out[1]}]
set_property -dict {PACKAGE_PIN E2 IOSTANDARD LVCMOS33} [get_ports {i_out[2]}]
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports {i_out[3]}]
set_property -dict {PACKAGE_PIN E5 IOSTANDARD LVCMOS33} [get_ports {i_out[4]}]


## ============================================================
## UNCONNECTED DIGITAL I/Q OUTPUTS
##
## i_out[15:5]
## q_out[15:0]
##
## These are intentionally NOT assigned to FPGA package pins
## yet. They should later be routed to expansion/Pmod pins
## or another digital interface.
## ============================================================


## ============================================================
## OPTIONAL CONFIGURATION SETTINGS
## ============================================================

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
