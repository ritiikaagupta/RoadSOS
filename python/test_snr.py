import numpy as np

from packet import SafeLinkPacket

from protocol import (
    MESSAGE_ACCIDENT,
    PRIORITY_CRITICAL
)

from phy_link import LoRaPHY


# ==================================================
# Configuration
# ==================================================

SNR_VALUES = [
    20,
    15,
    10,
    5,
    0
]

TRIALS_PER_SNR = 20


# ==================================================
# Create original packet
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


original_bytes = (
    original_packet.serialize()
)


# ==================================================
# Print header
# ==================================================

print()
print("==============================================")
print("        SAFE-Link SNR RELIABILITY TEST")
print("==============================================")
print()

print(
    f"Trials per SNR: {TRIALS_PER_SNR}"
)

print()


# ==================================================
# Results storage
# ==================================================

results = []


# ==================================================
# Test each SNR
# ==================================================

for snr in SNR_VALUES:

    successful_packets = 0

    total_symbol_accuracy = 0.0


    print("----------------------------------------------")

    print(
        f"SNR = {snr} dB"
    )

    print("----------------------------------------------")


    # --------------------------------------------------
    # Multiple trials
    # --------------------------------------------------

    for trial in range(
        TRIALS_PER_SNR
    ):

        # ----------------------------------------------
        # Create PHY
        # ----------------------------------------------

        phy = LoRaPHY(
            snr_db=snr
        )


        # ----------------------------------------------
        # Transmit
        # ----------------------------------------------

        received_signal, transmitted_symbols = (
            phy.transmit(
                original_bytes
            )
        )


        # ----------------------------------------------
        # Receive
        # ----------------------------------------------

        try:

            detected_symbols = (
                phy.receive(
                    received_signal,
                    len(transmitted_symbols)
                )
            )

        except ValueError:

            continue


        # ----------------------------------------------
        # Symbol accuracy
        # ----------------------------------------------

        correct_symbols = 0


        for transmitted, detected in zip(
            transmitted_symbols,
            detected_symbols
        ):

            if transmitted == detected:

                correct_symbols += 1


        if len(transmitted_symbols) > 0:

            accuracy = (
                correct_symbols
                / len(transmitted_symbols)
                * 100
            )

        else:

            accuracy = 0


        total_symbol_accuracy += accuracy


        # ----------------------------------------------
        # Convert symbols to bytes
        # ----------------------------------------------

        recovered_bytes = (
            phy.symbols_to_bytes(
                detected_symbols,
                len(original_bytes)
            )
        )


        # ----------------------------------------------
        # Packet / CRC verification
        # ----------------------------------------------

        try:

            decoded_packet = (
                SafeLinkPacket.deserialize(
                    recovered_bytes
                )
            )


            if decoded_packet == original_packet:

                successful_packets += 1


        except ValueError:

            pass


    # --------------------------------------------------
    # Calculate final statistics
    # --------------------------------------------------

    packet_success_rate = (

        successful_packets
        / TRIALS_PER_SNR
        * 100
    )


    average_symbol_accuracy = (

        total_symbol_accuracy
        / TRIALS_PER_SNR
    )


    results.append(
        (
            snr,
            average_symbol_accuracy,
            packet_success_rate
        )
    )


    print(
        f"Average symbol accuracy : "
        f"{average_symbol_accuracy:.2f}%"
    )

    print(
        f"Packet success rate     : "
        f"{packet_success_rate:.2f}%"
    )

    print()


# ==================================================
# Final summary
# ==================================================

print()
print("==============================================")
print("                  SUMMARY")
print("==============================================")

print()

print(
    " SNR(dB) | Symbol Accuracy | Packet Success"
)

print(
    "---------|------------------|---------------"
)


for snr, accuracy, success in results:

    print(
        f" {snr:>6} | "
        f"{accuracy:>15.2f}% | "
        f"{success:>13.2f}%"
    )


print()

print("SNR TEST COMPLETE")
