# ============================================================
# ROAD SOS - RX MODULE
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

set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports rst]


# ============================================================
# UART RX
#
# FPGA receives serial data from the Boolean Board
# USB-UART interface.
# ============================================================

set_property -dict {PACKAGE_PIN U11 IOSTANDARD LVCMOS33} [get_ports uart_rx]


# ============================================================
# ORIGINAL FUNCTIONAL STATUS OUTPUTS
#
# These are physical LED outputs.
# ============================================================

set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} [get_ports packet_valid]

set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} [get_ports crc_pass]

set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS33} [get_ports emergency_alert]

set_property -dict {PACKAGE_PIN F2 IOSTANDARD LVCMOS33} [get_ports crc_done]


# ============================================================
# RX STATUS LEDs
#
# LED0 / LED1 / LED2 / LED3
#
# led_packet     -> complete packet received
# led_crc_pass   -> CRC passed
# led_crc_fail   -> CRC failed
# led_emergency  -> valid emergency packet
#
# ============================================================

set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS33} [get_ports led_packet]

set_property -dict {PACKAGE_PIN E2 IOSTANDARD LVCMOS33} [get_ports led_crc_pass]

set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports led_crc_fail]

set_property -dict {PACKAGE_PIN E5 IOSTANDARD LVCMOS33} [get_ports led_emergency]


# ============================================================
# INPUT TIMING
# ============================================================

set_input_delay -clock sys_clk 0 [get_ports uart_rx]


# ============================================================
# DEBUG / STATUS OUTPUT TIMING
# ============================================================

set_output_delay -clock sys_clk 0 [get_ports packet_valid]

set_output_delay -clock sys_clk 0 [get_ports crc_pass]

set_output_delay -clock sys_clk 0 [get_ports crc_done]

set_output_delay -clock sys_clk 0 [get_ports emergency_alert]

set_output_delay -clock sys_clk 0 [get_ports led_packet]

set_output_delay -clock sys_clk 0 [get_ports led_crc_pass]

set_output_delay -clock sys_clk 0 [get_ports led_crc_fail]

set_output_delay -clock sys_clk 0 [get_ports led_emergency]


# ============================================================
# UART IS ASYNCHRONOUS TO SYSTEM CLOCK
# ============================================================

set_false_path -from [get_ports uart_rx]


# ============================================================
# PHYSICAL STATUS OUTPUTS
# ============================================================

set_false_path -to [get_ports packet_valid]

set_false_path -to [get_ports crc_pass]

set_false_path -to [get_ports crc_done]

set_false_path -to [get_ports emergency_alert]

set_false_path -to [get_ports led_packet]

set_false_path -to [get_ports led_crc_pass]

set_false_path -to [get_ports led_crc_fail]

set_false_path -to [get_ports led_emergency]


# ============================================================
# FPGA CONFIGURATION
# ============================================================

set_property CFGBVS VCCO [current_design]

set_property CONFIG_VOLTAGE 3.3 [current_design]
