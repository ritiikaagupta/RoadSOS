# ============================================================
# SAFE-Link / RoadSOS
# Real Digital Boolean Board
# FPGA: XC7S50-CSGA324
# ============================================================


# ============================================================
# 100 MHz SYSTEM CLOCK
# ============================================================

set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports clk]

create_clock -add -name sys_clk_pin -period 10.00 \
    -waveform {0 5} [get_ports clk]


# ============================================================
# PUSH BUTTONS
# Boolean Board buttons are ACTIVE HIGH
#
# BTN0 = T5
# BTN1 = J5
# BTN2 = V7
# BTN3 = R7
# ============================================================

set_property -dict {PACKAGE_PIN T5 IOSTANDARD LVCMOS33} [get_ports {btn[0]}]

set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports {btn[1]}]

set_property -dict {PACKAGE_PIN V7 IOSTANDARD LVCMOS33} [get_ports {btn[2]}]

set_property -dict {PACKAGE_PIN R7 IOSTANDARD LVCMOS33} [get_ports {btn[3]}]


# ============================================================
# 16 DISCRETE LEDs
# LEDs are ACTIVE HIGH
#
# LD0  = G1
# LD1  = R5
# LD2  = F1
# LD3  = F2
# LD4  = T2
# LD5  = U2
# LD6  = U3
# LD7  = M4
# LD8  = L6
# LD9  = M2
# LD10 = P2
# LD11 = N5
# LD12 = M1
# LD13 = N2
# LD14 = M3
# LD15 = N3
# ============================================================

set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} [get_ports {led[0]}]

set_property -dict {PACKAGE_PIN R5 IOSTANDARD LVCMOS33} [get_ports {led[1]}]

set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS33} [get_ports {led[2]}]

set_property -dict {PACKAGE_PIN F2 IOSTANDARD LVCMOS33} [get_ports {led[3]}]

set_property -dict {PACKAGE_PIN T2 IOSTANDARD LVCMOS33} [get_ports {led[4]}]

set_property -dict {PACKAGE_PIN U2 IOSTANDARD LVCMOS33} [get_ports {led[5]}]

set_property -dict {PACKAGE_PIN U3 IOSTANDARD LVCMOS33} [get_ports {led[6]}]

set_property -dict {PACKAGE_PIN M4 IOSTANDARD LVCMOS33} [get_ports {led[7]}]

set_property -dict {PACKAGE_PIN L6 IOSTANDARD LVCMOS33} [get_ports {led[8]}]

set_property -dict {PACKAGE_PIN M2 IOSTANDARD LVCMOS33} [get_ports {led[9]}]

set_property -dict {PACKAGE_PIN P2 IOSTANDARD LVCMOS33} [get_ports {led[10]}]

set_property -dict {PACKAGE_PIN N5 IOSTANDARD LVCMOS33} [get_ports {led[11]}]

set_property -dict {PACKAGE_PIN M1 IOSTANDARD LVCMOS33} [get_ports {led[12]}]

set_property -dict {PACKAGE_PIN N2 IOSTANDARD LVCMOS33} [get_ports {led[13]}]

set_property -dict {PACKAGE_PIN M3 IOSTANDARD LVCMOS33} [get_ports {led[14]}]

set_property -dict {PACKAGE_PIN N3 IOSTANDARD LVCMOS33} [get_ports {led[15]}]
