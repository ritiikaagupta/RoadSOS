# ============================================================
# Real Digital Boolean Board
# FPGA: Xilinx/AMD Spartan-7 XC7S50-CSGA324-1
# Project: FPGA-Based V2V Emergency Communication
# ============================================================

# ============================================================
# 100 MHz onboard clock
# ============================================================

set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports {clk}]

create_clock -period 10.000 -name sys_clk [get_ports {clk}]


# ============================================================
# PUSH BUTTONS
# ============================================================
#
# btn[0] -> Accident / Emergency
# btn[1] -> Road Hazard
# btn[2] -> Obstacle
# btn[3] -> Send / Test
#
# ============================================================

set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports {btn[0]}]
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports {btn[1]}]
set_property -dict {PACKAGE_PIN H2 IOSTANDARD LVCMOS33} [get_ports {btn[2]}]
set_property -dict {PACKAGE_PIN J1 IOSTANDARD LVCMOS33} [get_ports {btn[3]}]


# ============================================================
# STATUS LEDs
# ============================================================
#
# led[0] -> Accident selected
# led[1] -> Road Hazard selected
# led[2] -> Obstacle selected
# led[3] -> TX active
# led[4] -> RX detected
# led[5] -> CRC PASS
# led[6] -> CRC FAIL
# led[7] -> Synchronization detected
#
# ============================================================

set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} [get_ports {led[0]}]
set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} [get_ports {led[1]}]
set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS33} [get_ports {led[2]}]
set_property -dict {PACKAGE_PIN F2 IOSTANDARD LVCMOS33} [get_ports {led[3]}]
set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS33} [get_ports {led[4]}]
set_property -dict {PACKAGE_PIN E2 IOSTANDARD LVCMOS33} [get_ports {led[5]}]
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports {led[6]}]
set_property -dict {PACKAGE_PIN E5 IOSTANDARD LVCMOS33} [get_ports {led[7]}]


# ============================================================
# OPTIONAL SLIDE SWITCHES
# ============================================================
#
# We can use these later for debug/configuration.
#
# sw[0] -> Debug mode
# sw[1] -> Loopback mode
# sw[2] -> Test mode
# sw[3] -> Reserved
#
# ============================================================

set_property -dict {PACKAGE_PIN V2 IOSTANDARD LVCMOS33} [get_ports {sw[0]}]
set_property -dict {PACKAGE_PIN U2 IOSTANDARD LVCMOS33} [get_ports {sw[1]}]
set_property -dict {PACKAGE_PIN U1 IOSTANDARD LVCMOS33} [get_ports {sw[2]}]
set_property -dict {PACKAGE_PIN T2 IOSTANDARD LVCMOS33} [get_ports {sw[3]}]
