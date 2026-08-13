import numpy as np
import matplotlib.pyplot as plt

from lora_config import (
    SPREADING_FACTOR,
    BANDWIDTH_HZ,
    SAMPLE_RATE_HZ
)


# --------------------------------------------------
# Calculate LoRa symbol duration
# --------------------------------------------------

SYMBOL_TIME = (2 ** SPREADING_FACTOR) / BANDWIDTH_HZ

NUM_SAMPLES = int(SYMBOL_TIME * SAMPLE_RATE_HZ)


# --------------------------------------------------
# Generate a baseband upchirp
# --------------------------------------------------

def generate_upchirp():
    """
    Generate one complex baseband upchirp.

    Returns:
        t : time samples
        chirp : complex I/Q samples
    """

    t = np.arange(NUM_SAMPLES) / SAMPLE_RATE_HZ

    # Chirp rate
    chirp_rate = BANDWIDTH_HZ / SYMBOL_TIME

    # Complex baseband upchirp
    phase = 2 * np.pi * (
        -BANDWIDTH_HZ / 2 * t
        + 0.5 * chirp_rate * t**2
    )

    chirp = np.exp(1j * phase)

    return t, chirp


# --------------------------------------------------
# Main program
# --------------------------------------------------

if __name__ == "__main__":

    t, chirp = generate_upchirp()

    print("SAFE-Link LoRa Chirp Generator")
    print("--------------------------------")
    print(f"Spreading Factor : {SPREADING_FACTOR}")
    print(f"Bandwidth        : {BANDWIDTH_HZ} Hz")
    print(f"Symbol Time      : {SYMBOL_TIME * 1000:.3f} ms")
    print(f"Number of Samples: {NUM_SAMPLES}")

    # I and Q components
    I = np.real(chirp)
    Q = np.imag(chirp)

    # Plot I component
    plt.figure(figsize=(10, 4))
    plt.plot(t * 1000, I)

    plt.xlabel("Time (ms)")
    plt.ylabel("Amplitude")
    plt.title("SAFE-Link LoRa Upchirp - I Component")
    plt.grid(True)

    plt.tight_layout()
        # ----------------------------------------------
    # Estimate instantaneous frequency
    # ----------------------------------------------

    phase_unwrapped = np.unwrap(np.angle(chirp))

    instantaneous_frequency = (
        np.diff(phase_unwrapped)
        * SAMPLE_RATE_HZ
        / (2 * np.pi)
    )

    time_frequency = t[:-1] * 1000

    plt.figure(figsize=(10, 4))
    plt.plot(time_frequency, instantaneous_frequency / 1000)

    plt.xlabel("Time (ms)")
    plt.ylabel("Frequency (kHz)")
    plt.title("SAFE-Link LoRa Upchirp - Instantaneous Frequency")
    plt.grid(True)

    plt.tight_layout()
    plt.savefig("simulation/python_reference/upchirp_frequency.png",
            dpi=300,
            bbox_inches="tight")

plt.show()
