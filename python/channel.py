import numpy as np


def add_awgn(signal, snr_db):
    """
    Add complex Additive White Gaussian Noise (AWGN)
    to a complex baseband signal.

    Parameters
    ----------
    signal : numpy array
        Complex transmitted signal.

    snr_db : float
        Desired signal-to-noise ratio in dB.

    Returns
    -------
    noisy_signal : numpy array
        Signal after AWGN is added.
    """

    signal_power = np.mean(
        np.abs(signal) ** 2
    )

    snr_linear = 10 ** (snr_db / 10)

    noise_power = (
        signal_power / snr_linear
    )

    noise = np.sqrt(
        noise_power / 2
    ) * (
        np.random.randn(len(signal))
        + 1j * np.random.randn(len(signal))
    )

    noisy_signal = signal + noise

    return noisy_signal
