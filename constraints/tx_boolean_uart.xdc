# RoadSOS TX prototype - Real Digital Boolean Board
# XC7S50-CSGA324-1, 100 MHz
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 10.000 -name sys_clk [get_ports clk]
# BTN0 reset, BTN1 emergency trigger
set_property -dict {PACKAGE_PIN T5 IOSTANDARD LVCMOS33} [get_ports rst]
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports emergency_trigger]
# SW0..SW7 = event ID
set_property -dict {PACKAGE_PIN V2 IOSTANDARD LVCMOS33} [get_ports {event_id[0]}]
set_property -dict {PACKAGE_PIN U2 IOSTANDARD LVCMOS33} [get_ports {event_id[1]}]
set_property -dict {PACKAGE_PIN U1 IOSTANDARD LVCMOS33} [get_ports {event_id[2]}]
set_property -dict {PACKAGE_PIN T2 IOSTANDARD LVCMOS33} [get_ports {event_id[3]}]
set_property -dict {PACKAGE_PIN T1 IOSTANDARD LVCMOS33} [get_ports {event_id[4]}]
set_property -dict {PACKAGE_PIN R2 IOSTANDARD LVCMOS33} [get_ports {event_id[5]}]
set_property -dict {PACKAGE_PIN R1 IOSTANDARD LVCMOS33} [get_ports {event_id[6]}]
set_property -dict {PACKAGE_PIN P2 IOSTANDARD LVCMOS33} [get_ports {event_id[7]}]
# USB/UART bridge: FPGA TX -> USB UART RX
set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports uart_tx]
# LEDs: busy, done, event debug bit
set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} [get_ports busy]
set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} [get_ports tx_done]
set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS33} [get_ports {debug_event_id[0]}]
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
