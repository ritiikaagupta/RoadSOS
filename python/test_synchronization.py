import numpy as np

from preamble import generate_preamble
from preamble_detector import detect_preamble_start


# --------------------------------------------------
# Generate preamble
# --------------------------------------------------

preamble = generate_preamble()


# --------------------------------------------------
# Add noise before packet
# --------------------------------------------------

prefix_noise = (
    0.2
    * (
        np.random.randn(500)
        + 1j * np.random.randn(500)
    )
)


received_signal = np.concatenate(
    [
        prefix_noise,
        preamble
    ]
)


# --------------------------------------------------
# Detect preamble
# --------------------------------------------------

index, peak = detect_preamble_start(
    received_signal,
    threshold=0.5
)


print("SAFE-Link Synchronization Test")
print("--------------------------------")

print(
    f"Actual packet start : 500"
)

print(
    f"Detected start      : {index}"
)

print(
    f"Correlation peak    : {peak:.3f}"
)
