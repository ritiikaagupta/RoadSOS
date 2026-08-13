import numpy as np

from modulator import modulate_symbol
from demodulator import detect_symbol
from channel import add_awgn


# --------------------------------------------------
# Configuration
# --------------------------------------------------

TRANSMITTED_SYMBOL = 25

SNR_VALUES = [
    20,
    10,
    5,
    0,
    -5
]


# --------------------------------------------------
# Generate LoRa symbol
# --------------------------------------------------

tx_signal = modulate_symbol(
    TRANSMITTED_SYMBOL
)


print("SAFE-Link LoRa Noise Test")
print("--------------------------")

print(
    f"Transmitted Symbol : "
    f"{TRANSMITTED_SYMBOL}"
)

print()


# --------------------------------------------------
# Test different SNR values
# --------------------------------------------------

for snr_db in SNR_VALUES:

    noisy_signal = add_awgn(
        tx_signal,
        snr_db
    )

    detected_symbol, spectrum = (
        detect_symbol(noisy_signal)
    )

    if detected_symbol == TRANSMITTED_SYMBOL:
        result = "PASS"
    else:
        result = "FAIL"

    print(
        f"SNR = {snr_db:>4} dB"
        f" | Detected = {detected_symbol:>3}"
        f" | {result}"
    )
