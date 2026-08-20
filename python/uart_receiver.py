# PC-side test program for the FPGA UART.
# Install once:
#   pip install pyserial
#
# Change COM_PORT to the port shown by Windows Device Manager.

import serial

COM_PORT = "COM7"       # <-- change this
BAUD_RATE = 115200

with serial.Serial(COM_PORT, BAUD_RATE, timeout=1) as ser:
    print(f"Listening on {COM_PORT} at {BAUD_RATE} baud...")
    while True:
        line = ser.readline()
        if line:
            print(line.decode("ascii", errors="replace").rstrip())
