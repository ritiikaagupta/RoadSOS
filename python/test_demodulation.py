import numpy as np
import matplotlib.pyplot as plt

from modulator import modulate_symbol
from dechirper import dechirp
from demodulator import detect_symbol

from lora_config import (
    SAMPLE_RATE_HZ,
    BANDWIDTH_HZ,
    SPREADING_FACTOR
)


# --------------------------------------------------
# Test symbol
# --------------------------------------------------

TRANSMITTED_SYMBOL = 100


# --------------------------------------------------
# Generate transmitted LoRa symbol
# --------------------------------------------------

tx_signal = modulate_symbol(
    TRANSMITTED_SYMBOL
)


# --------------------------------------------------
# Dechirp and detect
# --------------------------------------------------

detected_symbol, spectrum = detect_symbol(
    tx_signal
)


# --------------------------------------------------
# Print results
# --------------------------------------------------

print("SAFE-Link LoRa Demodulation Test")
print("---------------------------------")

print(
    f"Transmitted Symbol : {TRANSMITTED_SYMBOL}"
)

print(
    f"Detected FFT Bin   : {detected_symbol}"
)

if detected_symbol == TRANSMITTED_SYMBOL:

    print("Result             : PASS")

else:

    print("Result             : CHECK MODEL")


# --------------------------------------------------
# Plot FFT spectrum
# --------------------------------------------------

frequency = np.fft.fftfreq(
    len(tx_signal),
    1 / SAMPLE_RATE_HZ
)

magnitude_db = 20 * np.log10(
    spectrum + 1e-12
)


plt.figure(figsize=(10, 4))

plt.plot(
    frequency / 1000,
    magnitude_db
)

plt.xlabel("Frequency (kHz)")
plt.ylabel("Magnitude (dB)")

plt.title(
    f"Dechirped Spectrum - Symbol {TRANSMITTED_SYMBOL}"
)

plt.grid(True)

plt.tight_layout()

plt.savefig(
    "simulation/python_reference/"
    "demodulation_symbol_25.png",
    dpi=300,
    bbox_inches="tight"
)

plt.show()
