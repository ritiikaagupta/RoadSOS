import numpy as np

from modulator import modulate_symbol
from channel import add_awgn
from demodulator import detect_symbol

from byte_symbol import (
    bytes_to_symbols,
    symbols_to_bytes
)


# --------------------------------------------------
# SAFE-Link LoRa PHY
# --------------------------------------------------

class LoRaPHY:

    def __init__(
        self,
        snr_db=20
    ):

        self.snr_db = snr_db


    # --------------------------------------------------
    # Transmitter
    # --------------------------------------------------

    def transmit(
        self,
        data
    ):

        # ----------------------------------------------
        # Convert complete byte stream into symbols
        # ----------------------------------------------

        transmitted_symbols = (
            bytes_to_symbols(
                data
            )
        )


        transmitted_waveforms = []


        # ----------------------------------------------
        # Modulate every symbol
        # ----------------------------------------------

        for symbol in transmitted_symbols:

            waveform = (
                modulate_symbol(
                    symbol
                )
            )

            transmitted_waveforms.append(
                waveform
            )


        # ----------------------------------------------
        # Combine waveforms
        # ----------------------------------------------

        if not transmitted_waveforms:

            return (
                np.array(
                    [],
                    dtype=complex
                ),
                transmitted_symbols
            )


        signal = np.concatenate(
            transmitted_waveforms
        )


        # ----------------------------------------------
        # Channel
        # ----------------------------------------------

        received_signal = (
            add_awgn(
                signal,
                self.snr_db
            )
        )


        return (
            received_signal,
            transmitted_symbols
        )


    # --------------------------------------------------
    # Receiver
    # --------------------------------------------------

    def receive(
        self,
        received_signal,
        number_of_symbols
    ):

        from modulator import NUM_SAMPLES


        detected_symbols = []


        # ----------------------------------------------
        # Process each symbol
        # ----------------------------------------------

        for index in range(
            number_of_symbols
        ):

            start = (
                index * NUM_SAMPLES
            )

            end = (
                start + NUM_SAMPLES
            )


            symbol_waveform = (
                received_signal[
                    start:end
                ]
            )


            # ------------------------------------------
            # Check complete symbol
            # ------------------------------------------

            if (
                len(symbol_waveform)
                != NUM_SAMPLES
            ):

                raise ValueError(
                    "Incomplete LoRa symbol received"
                )


            # ------------------------------------------
            # Detect symbol
            # ------------------------------------------

            detected_symbol, _ = (
                detect_symbol(
                    symbol_waveform
                )
            )


            detected_symbols.append(
                detected_symbol
            )


        return detected_symbols


    # --------------------------------------------------
    # Symbols -> Bytes
    # --------------------------------------------------

    def symbols_to_bytes(
        self,
        symbols,
        number_of_bytes
    ):

        return symbols_to_bytes(
            symbols,
            number_of_bytes
        )
