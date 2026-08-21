# RoadSOS RX prototype - Real Digital Boolean Board
# XC7S50-CSGA324-1, 100 MHz
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 10.000 -name sys_clk [get_ports clk]
# BTN0 reset
set_property -dict {PACKAGE_PIN T5 IOSTANDARD LVCMOS33} [get_ports rst]
# USB/UART bridge: USB UART TX -> FPGA RX
set_property -dict {PACKAGE_PIN U11 IOSTANDARD LVCMOS33} [get_ports uart_rx]
# Status LEDs
set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} [get_ports packet_valid]
set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} [get_ports crc_pass]
set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS33} [get_ports emergency_alert]
set_property -dict {PACKAGE_PIN F2 IOSTANDARD LVCMOS33} [get_ports crc_done]
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
