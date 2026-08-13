from packet import (
    SafeLinkPacket,
    crc16_ccitt
)


# --------------------------------------------------
# Create original packet
# --------------------------------------------------

packet = SafeLinkPacket(

    version=1,

    message_type=1,

    node_id=3,

    sequence_id=27,

    priority=3,

    hop_count=0,

    payload=b"ACCIDENT"
)


encoded = bytearray(
    packet.serialize()
)


# --------------------------------------------------
# Verify original packet
# --------------------------------------------------

received_crc = (
    (encoded[-2] << 8)
    | encoded[-1]
)

calculated_crc = crc16_ccitt(
    encoded[:-2]
)


print("SAFE-Link CRC Error Test")
print("------------------------")

print("Original packet:")

print(
    "CRC check:",
    "PASS"
    if received_crc == calculated_crc
    else "FAIL"
)


# --------------------------------------------------
# Introduce artificial corruption
# --------------------------------------------------

print()
print("Introducing one-bit error...")


encoded[7] ^= 0x01


# --------------------------------------------------
# Check corrupted packet
# --------------------------------------------------

received_crc = (
    (encoded[-2] << 8)
    | encoded[-1]
)

calculated_crc = crc16_ccitt(
    encoded[:-2]
)


print(
    "Corrupted CRC check:",
    "PASS"
    if received_crc == calculated_crc
    else "FAIL"
)
