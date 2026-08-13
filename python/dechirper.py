import numpy as np

from modulator import generate_upchirp


def dechirp(received_signal):

    """
    Dechirp a received LoRa signal using
    the conjugate of the reference upchirp.
    """

    reference_chirp = generate_upchirp()

    downchirp = np.conjugate(reference_chirp)

    dechirped_signal = (
        received_signal * downchirp
    )

    return dechirped_signal
