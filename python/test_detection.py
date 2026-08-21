
import numpy as np

from modulator import modulate_symbol
from demodulator import detect_symbol
from channel import add_awgn


# --------------------------------------------------
# Configuration
# --------------------------------------------------

NUM_TRIALS = 100

SNR_VALUES = [
    20,
    10,
    5,
    0,
    -5
]


# --------------------------------------------------
# Run experiment
# --------------------------------------------------

print("SAFE-Link Symbol Detection Accuracy")
print("-------------------------------------")

for snr_db in SNR_VALUES:

    errors = 0

    for _ in range(NUM_TRIALS):

        # Random LoRa symbol
        transmitted_symbol = np.random.randint(
            0,
            128
        )

        # Generate symbol
        tx_signal = modulate_symbol(
            transmitted_symbol
        )

        # Add noise
        rx_signal = add_awgn(
            tx_signal,
            snr_db
        )

        # Detect
        detected_symbol, _ = detect_symbol(
            rx_signal
        )

        # Compare
        if detected_symbol != transmitted_symbol:

            errors += 1

    accuracy = (
        (NUM_TRIALS - errors)
        / NUM_TRIALS
        * 100
    )

    print(
        f"SNR = {snr_db:>4} dB"
        f" | Errors = {errors:>3}/{NUM_TRIALS}"
        f" | Accuracy = {accuracy:6.2f}%"
    )
test_det ... uracy.py
Displaying test_detection_accuracy.py.
