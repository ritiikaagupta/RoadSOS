###############################################################################
# RoadSOS - RX Constraints
# Board: Real Digital Boolean Board
# FPGA:  XC7S50-CSGA324-1
# Clock: 100 MHz
###############################################################################


###############################################################################
# 1. 100 MHz BOARD CLOCK
#
# Boolean Board oscillator is connected to FPGA pin F14.
###############################################################################

set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports clk]

create_clock -period 10.000 -name sys_clk [get_ports clk]


###############################################################################
# 2. RESET
#
# Use pushbutton 0 as active-high reset.
#
# Boolean pushbuttons are normally 0 and become 1 when pressed.
###############################################################################

set_property -dict {PACKAGE_PIN W2 IOSTANDARD LVCMOS33} [get_ports rst]


###############################################################################
# 3. RX VALID INPUT
#
# For the first hardware demonstration, use SW0 as a manual valid input.
#
# IMPORTANT:
# This is only for demonstration/testing.
# In the final RF/digital-IQ system, valid_in should come from the
# external digital baseband interface.
###############################################################################

set_property -dict {PACKAGE_PIN V2 IOSTANDARD LVCMOS33} [get_ports valid_in]


###############################################################################
# 4. I/Q INPUTS
#
# DO NOT assign arbitrary FPGA pins to these.
#
# i_in[15:0] and q_in[15:0] require an external digital I/Q source.
#
# Once the team decides which expansion/Pmod pins are being used,
# add the corresponding PACKAGE_PIN assignments here.
#
# Example format:
#
# set_property -dict {PACKAGE_PIN <PIN> IOSTANDARD LVCMOS33} \
#     [get_ports {i_in[0]}]
#
# set_property -dict {PACKAGE_PIN <PIN> IOSTANDARD LVCMOS33} \
#     [get_ports {q_in[0]}]
#
###############################################################################


###############################################################################
# 5. RX STATUS LEDS
#
# These are optional demonstration outputs.
#
# LED0 -> preamble detected
# LED1 -> synchronized
# LED2 -> packet valid
# LED3 -> CRC pass
# LED4 -> CRC done
# LED5 -> emergency alert
###############################################################################

set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} \
    [get_ports preamble_detected]

set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} \
    [get_ports synchronized]

set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS33} \
    [get_ports packet_valid]

set_property -dict {PACKAGE_PIN F2 IOSTANDARD LVCMOS33} \
    [get_ports crc_pass]

set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS33} \
    [get_ports crc_done]

set_property -dict {PACKAGE_PIN E2 IOSTANDARD LVCMOS33} \
    [get_ports emergency_alert]


###############################################################################
# END OF RX CONSTRAINTS
###############################################################################
