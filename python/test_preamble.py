import numpy as np
import matplotlib.pyplot as plt

from preamble import generate_preamble
from lora_config import SAMPLE_RATE_HZ


preamble = generate_preamble()

time = (
    np.arange(len(preamble))
    / SAMPLE_RATE_HZ
)


print("SAFE-Link LoRa Preamble Test")
print("----------------------------")

print(
    f"Total samples: {len(preamble)}"
)

print(
    f"Duration: "
    f"{len(preamble) / SAMPLE_RATE_HZ * 1000:.3f} ms"
)


plt.figure(figsize=(12, 4))

plt.plot(
    time * 1000,
    np.real(preamble)
)

plt.xlabel("Time (ms)")
plt.ylabel("Amplitude")

plt.title(
    "SAFE-Link LoRa Reference Preamble"
)

plt.grid(True)

plt.tight_layout()

plt.savefig(
    "simulation/python_reference/"
    "preamble.png",
    dpi=300,
    bbox_inches="tight"
)

plt.show()
