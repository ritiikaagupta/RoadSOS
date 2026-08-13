import numpy as np
import matplotlib.pyplot as plt

from lora_config import (
    SPREADING_FACTOR,
    BANDWIDTH_HZ,
    SAMPLE_RATE_HZ
)


# --------------------------------------------------
# LoRa parameters
# --------------------------------------------------

SYMBOLS = 2 ** SPREADING_FACTOR

SYMBOL_TIME = SYMBOLS / BANDWIDTH_HZ

NUM_SAMPLES = int(SYMBOL_TIME * SAMPLE_RATE_HZ)


# --------------------------------------------------
# Generate baseband upchirp
# --------------------------------------------------

def generate_upchirp():

    t = np.arange(NUM_SAMPLES) / SAMPLE_RATE_HZ

    chirp_rate = BANDWIDTH_HZ / SYMBOL_TIME

    phase = 2 * np.pi * (
        -BANDWIDTH_HZ / 2 * t
        + 0.5 * chirp_rate * t**2
    )

    chirp = np.exp(1j * phase)

    return chirp


# --------------------------------------------------
# Generate a LoRa symbol
# --------------------------------------------------

def modulate_symbol(symbol):

    """
    Generate a simplified mathematical LoRa
    CSS symbol for the Python reference model.

    symbol:
        Integer from 0 to 2^SF - 1
    """

    if symbol < 0 or symbol >= SYMBOLS:
        raise ValueError(
            f"Symbol must be between 0 and {SYMBOLS - 1}"
        )

    t = np.arange(NUM_SAMPLES) / SAMPLE_RATE_HZ

    base_chirp = generate_upchirp()

    # Symbol-dependent frequency offset
    symbol_frequency = (
        symbol * BANDWIDTH_HZ / SYMBOLS
    )

    symbol_phase = (
        2 * np.pi * symbol_frequency * t
    )

    waveform = (
        base_chirp *
        np.exp(1j * symbol_phase)
    )

    return waveform


# --------------------------------------------------
# Main
# --------------------------------------------------

if __name__ == "__main__":

    symbol = 25

    waveform = modulate_symbol(symbol)

    t = np.arange(NUM_SAMPLES) / SAMPLE_RATE_HZ

    print("SAFE-Link LoRa Symbol Modulator")
    print("--------------------------------")
    print(f"Spreading Factor : {SPREADING_FACTOR}")
    print(f"Bandwidth        : {BANDWIDTH_HZ} Hz")
    print(f"Symbol           : {symbol}")
    print(f"Number of Samples: {NUM_SAMPLES}")

    plt.figure(figsize=(10, 4))

    plt.plot(
        t * 1000,
        np.real(waveform)
    )

    plt.xlabel("Time (ms)")
    plt.ylabel("Amplitude")

    plt.title(
        f"LoRa Symbol {symbol} - I Component"
    )

    plt.grid(True)
    plt.tight_layout()

    plt.savefig(
        "simulation/python_reference/symbol_25.png",
        dpi=300,
        bbox_inches="tight"
    )

    plt.show()
