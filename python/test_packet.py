from packet import SafeLinkPacket

from protocol import (
    MESSAGE_ACCIDENT,
    PRIORITY_CRITICAL
)


# --------------------------------------------------
# Create SAFE-Link packet
# --------------------------------------------------

packet = SafeLinkPacket(

    version=1,

    message_type=MESSAGE_ACCIDENT,

    node_id=3,

    sequence_id=27,

    priority=PRIORITY_CRITICAL,

    hop_count=0,

    payload=b"ACCIDENT"
)


# --------------------------------------------------
# Serialize packet
# --------------------------------------------------

encoded = packet.serialize()


print("SAFE-Link Packet + CRC Test")
print("---------------------------")

print()

print("Payload:")
print(packet.payload)

print()

print("Serialized packet:")
print(encoded)

print()

print("Hex representation:")
print(encoded.hex(" "))


# --------------------------------------------------
# Extract received CRC
# --------------------------------------------------

received_crc = (
    (encoded[-2] << 8)
    | encoded[-1]
)


# --------------------------------------------------
# Calculate CRC again
# --------------------------------------------------

packet_without_crc = encoded[:-2]

calculated_crc = packet_crc = None

from packet import crc16_ccitt

calculated_crc = crc16_ccitt(
    packet_without_crc
)


# --------------------------------------------------
# Display CRC values
# --------------------------------------------------

print()

print(
    f"Received CRC  : "
    f"0x{received_crc:04X}"
)

print(
    f"Calculated CRC: "
    f"0x{calculated_crc:04X}"
)


# --------------------------------------------------
# CRC verification
# --------------------------------------------------

if received_crc == calculated_crc:

    print("CRC RESULT    : PASS")

else:

    print("CRC RESULT    : FAIL")
