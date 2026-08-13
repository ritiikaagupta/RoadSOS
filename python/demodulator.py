import numpy as np

from dechirper import dechirp
from lora_config import SAMPLE_RATE_HZ


def detect_symbol(received_signal):

    # ----------------------------------------------
    # Step 1: Dechirp
    # ----------------------------------------------

    dechirped = dechirp(received_signal)

    # ----------------------------------------------
    # Step 2: FFT
    # ----------------------------------------------

    spectrum = np.fft.fft(dechirped)

    magnitude = np.abs(spectrum)

    # ----------------------------------------------
    # Step 3: Find strongest frequency bin
    # ----------------------------------------------

    peak_bin = np.argmax(magnitude)

    return peak_bin, magnitude
