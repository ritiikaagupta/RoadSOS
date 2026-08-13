from packet import SafeLinkPacket


# --------------------------------------------------
# Create original packet
# --------------------------------------------------

original_packet = SafeLinkPacket(

    version=1,

    message_type=1,

    node_id=3,

    sequence_id=27,

    priority=3,

    hop_count=0,

    payload=b"ACCIDENT"
)


# --------------------------------------------------
# Serialize
# --------------------------------------------------

encoded_packet = original_packet.serialize()


print("SAFE-Link Packet Decoder Test")
print("-----------------------------")

print()

print("Original packet:")
print(original_packet)

print()

print("Serialized bytes:")
print(encoded_packet.hex(" "))

print()


# --------------------------------------------------
# Decode
# --------------------------------------------------

decoded_packet = SafeLinkPacket.deserialize(
    encoded_packet
)


print("Decoded packet:")
print(decoded_packet)

print()


# --------------------------------------------------
# Compare
# --------------------------------------------------

if decoded_packet == original_packet:

    print("RESULT: PASS")

else:

    print("RESULT: FAIL")
