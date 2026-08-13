from packet import SafeLinkPacket

from protocol import (
    MESSAGE_ACCIDENT,
    PRIORITY_CRITICAL
)

from phy_link import LoRaPHY


# ==================================================
# Create SAFE-Link packet
# ==================================================

original_packet = SafeLinkPacket(

    version=1,

    message_type=MESSAGE_ACCIDENT,

    node_id=1,

    sequence_id=55,

    priority=PRIORITY_CRITICAL,

    hop_count=0,

    payload=b"ACCIDENT"
)


print()
print("==========================================")
print("       SAFE-Link LoRa PHY TEST")
print("==========================================")
print()


# ==================================================
# Serialize SAFE-Link packet
# ==================================================

original_bytes = (
    original_packet.serialize()
)


print("Original SAFE-Link packet:")
print(original_packet)

print()

print("Original bytes:")
print(original_bytes.hex(" "))

print()


# ==================================================
# Create PHY
# ==================================================

phy = LoRaPHY(
    snr_db=20
)


# ==================================================
# TRANSMITTER
# ==================================================

print("------------------------------------------")
print("TRANSMITTER")
print("------------------------------------------")

print()


received_signal, transmitted_symbols = (
    phy.transmit(
        original_bytes
    )
)


print(
    "Number of transmitted symbols:",
    len(transmitted_symbols)
)

print(
    "Generated waveform samples:",
    len(received_signal)
)

print()


# ==================================================
# RECEIVER
# ==================================================

print("------------------------------------------")
print("RECEIVER")
print("------------------------------------------")

print()


detected_symbols = phy.receive(

    received_signal,

    len(transmitted_symbols)
)


print(
    "Number of detected symbols:",
    len(detected_symbols)
)

print()


# ==================================================
# SYMBOL COMPARISON
# ==================================================

correct_symbols = 0


for transmitted, detected in zip(
    transmitted_symbols,
    detected_symbols
):

    if transmitted == detected:

        correct_symbols += 1


symbol_accuracy = (
    correct_symbols
    / len(transmitted_symbols)
    * 100
)


print(
    f"Symbol accuracy: "
    f"{symbol_accuracy:.2f}%"
)

print()


# ==================================================
# SYMBOL → BYTE
# ==================================================

recovered_bytes = (
    phy.symbols_to_bytes(
        detected_symbols,
        len(original_bytes)
    )
)


print("Recovered bytes:")

print(
    recovered_bytes.hex(" ")
)

print()


# ==================================================
# PACKET DECODING
# ==================================================

try:

    decoded_packet = (
        SafeLinkPacket.deserialize(
            recovered_bytes
        )
    )


    print(
        "Decoded SAFE-Link packet:"
    )

    print(
        decoded_packet
    )

    print()


    # ----------------------------------------------
    # Compare packets
    # ----------------------------------------------

    if decoded_packet == original_packet:

        print(
            "PACKET RESULT: PASS"
        )

    else:

        print(
            "PACKET RESULT: FAIL"
        )


except ValueError as error:

    print(
        "PACKET RESULT: FAIL"
    )

    print(
        "Decoder error:",
        error
    )


print()


# ==================================================
# Final result
# ==================================================

if (

    len(transmitted_symbols)
    == len(detected_symbols)

    and symbol_accuracy == 100.0

    and recovered_bytes
    == original_bytes

):

    print(
        "FULL PHY RESULT: PASS"
    )

else:

    print(
        "FULL PHY RESULT: FAIL"
    )
