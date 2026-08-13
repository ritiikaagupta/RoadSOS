import numpy as np

from modulator import generate_upchirp


def detect_preamble_start(
    received_signal,
    threshold=0.5
):

    reference = generate_upchirp()

    correlation = np.correlate(
        received_signal,
        reference,
        mode="valid"
    )

    magnitude = np.abs(correlation)

    peak = np.max(magnitude)

    peak_index = np.argmax(magnitude)

    if peak > threshold:

        return peak_index, peak

    return None, peak
