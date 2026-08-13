import numpy as np
import matplotlib.pyplot as plt

from modulator import modulate_symbol
from lora_config import SAMPLE_RATE_HZ


symbols = [0, 25, 64, 127]

plt.figure(figsize=(10, 8))

for symbol in symbols:

    waveform = modulate_symbol(symbol)

    t = np.arange(len(waveform)) / SAMPLE_RATE_HZ

    plt.plot(
        t * 1000,
        np.real(waveform),
        label=f"Symbol {symbol}"
    )

plt.xlabel("Time (ms)")
plt.ylabel("Amplitude")
plt.title("LoRa Symbol Comparison")

plt.legend()
plt.grid(True)

plt.tight_layout()

plt.savefig(
    "simulation/python_reference/symbol_comparison.png",
    dpi=300,
    bbox_inches="tight"
)

plt.show()
