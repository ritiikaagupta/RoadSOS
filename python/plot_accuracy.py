import numpy as np
import matplotlib.pyplot as plt

from modulator import modulate_symbol
from demodulator import detect_symbol
from channel import add_awgn


NUM_TRIALS = 200

SNR_VALUES = [
    20,
    15,
    10,
    5,
    0,
    -5
]


accuracies = []


for snr_db in SNR_VALUES:

    correct = 0

    for _ in range(NUM_TRIALS):

        transmitted_symbol = np.random.randint(
            0,
            128
        )

        tx_signal = modulate_symbol(
            transmitted_symbol
        )

        rx_signal = add_awgn(
            tx_signal,
            snr_db
        )

        detected_symbol, _ = (
            detect_symbol(rx_signal)
        )

        if detected_symbol == transmitted_symbol:

            correct += 1

    accuracy = (
        correct / NUM_TRIALS * 100
    )

    accuracies.append(accuracy)


# --------------------------------------------------
# Plot
# --------------------------------------------------

plt.figure(figsize=(8, 5))

plt.plot(
    SNR_VALUES,
    accuracies,
    marker="o"
)

plt.xlabel("SNR (dB)")
plt.ylabel("Symbol Detection Accuracy (%)")

plt.title(
    "SAFE-Link LoRa Symbol Detection Accuracy"
)

plt.grid(True)

plt.tight_layout()

plt.savefig(
    "simulation/python_reference/"
    "symbol_detection_accuracy.png",
    dpi=300,
    bbox_inches="tight"
)

plt.show()
