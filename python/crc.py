def crc16_ccitt(data):
    crc = 0xFFFF
    polynomial = 0x1021

    for byte in data:
        crc ^= byte << 8

        for _ in range(8):
            if crc & 0x8000:
                crc = ((crc << 1) ^ polynomial) & 0xFFFF
            else:
                crc = (crc << 1) & 0xFFFF

    return crc


# Test vector
message = b"123456789"

crc = crc16_ccitt(message)

print("Message :", message)
print("CRC     : 0x{:04X}".format(crc))
