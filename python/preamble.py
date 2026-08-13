import numpy as np

from modulator import generate_upchirp
from dechirper import dechirp


# --------------------------------------------------
# Configuration
# --------------------------------------------------

NUM_UPCHIRPS = 4
NUM_DOWNCHIRPS = 2


# --------------------------------------------------
# Generate preamble
# --------------------------------------------------

def generate_preamble():

    upchirp = generate_upchirp()

    downchirp = np.conjugate(upchirp)

    preamble = np.concatenate(
        [
            np.tile(upchirp, NUM_UPCHIRPS),
            np.tile(downchirp, NUM_DOWNCHIRPS)
        ]
    )

    return preamble
