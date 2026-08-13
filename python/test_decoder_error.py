from packet import SafeLinkPacket


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


# --------------------------------------------------
# Serialize packet
# --------------------------------------------------

encoded = bytearray(
    packet.serialize()
)


print("SAFE-Link Decoder Error Test")
print("-----------------------------")


# --------------------------------------------------
# Introduce corruption
# --------------------------------------------------

print("Introducing packet corruption...")

encoded[6] ^= 0x01


# --------------------------------------------------
# Try to decode corrupted packet
# --------------------------------------------------

try:

    decoded = SafeLinkPacket.deserialize(
        bytes(encoded)
    )

    print("RESULT: FAIL")
    print("Corrupted packet was accepted.")

except ValueError as error:

    print("RESULT: PASS")
    print("Corrupted packet was rejected.")

    print(f"Reason: {error}")
