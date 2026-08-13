# --------------------------------------------------
# SAFE-Link Byte <-> LoRa Symbol Conversion
# --------------------------------------------------

from lora_config import SPREADING_FACTOR


BITS_PER_SYMBOL = SPREADING_FACTOR
SYMBOL_MASK = (1 << BITS_PER_SYMBOL) - 1


# ==================================================
# BYTES -> SYMBOLS
# ==================================================

def bytes_to_symbols(data):
    """
    Convert a byte stream into a continuous stream
    of LoRa symbols.

    Bits are packed LSB-first.
    """

    if not isinstance(data, bytes):

        raise TypeError(
            "Input data must be bytes"
        )

    symbols = []

    bit_buffer = 0
    bit_count = 0

    for byte in data:

        # Add 8 new bits to buffer
        bit_buffer |= (
            byte << bit_count
        )

        bit_count += 8

        # Extract complete LoRa symbols
        while bit_count >= BITS_PER_SYMBOL:

            symbol = (
                bit_buffer
                & SYMBOL_MASK
            )

            symbols.append(
                symbol
            )

            bit_buffer >>= BITS_PER_SYMBOL

            bit_count -= BITS_PER_SYMBOL

    # Handle remaining bits
    if bit_count > 0:

        symbols.append(
            bit_buffer
            & SYMBOL_MASK
        )

    return symbols


# ==================================================
# SYMBOLS -> BYTES
# ==================================================

def symbols_to_bytes(
    symbols,
    number_of_bytes
):
    """
    Reconstruct exactly number_of_bytes from
    the LoRa symbol stream.
    """

    if number_of_bytes < 0:

        raise ValueError(
            "number_of_bytes must be >= 0"
        )

    output = bytearray()

    bit_buffer = 0
    bit_count = 0

    for symbol in symbols:

        # ------------------------------------------
        # Validate symbol
        # ------------------------------------------

        if (
            symbol < 0
            or symbol > SYMBOL_MASK
        ):

            raise ValueError(
                f"Invalid LoRa symbol: {symbol}"
            )

        # ------------------------------------------
        # Add symbol bits
        # ------------------------------------------

        bit_buffer |= (
            symbol << bit_count
        )

        bit_count += BITS_PER_SYMBOL

        # ------------------------------------------
        # Extract bytes
        # ------------------------------------------

        while bit_count >= 8:

            byte = (
                bit_buffer
                & 0xFF
            )

            output.append(
                byte
            )

            bit_buffer >>= 8

            bit_count -= 8

            # --------------------------------------
            # IMPORTANT
            # --------------------------------------

            if len(output) == number_of_bytes:

                return bytes(output)

    return bytes(output)


# ==================================================
# SINGLE BYTE TEST HELPERS
# ==================================================

def byte_to_symbols(
    byte_value
):

    if (
        byte_value < 0
        or byte_value > 255
    ):

        raise ValueError(
            "Byte must be between 0 and 255"
        )

    return bytes_to_symbols(
        bytes([byte_value])
    )


def symbols_to_byte(
    symbols
):

    result = symbols_to_bytes(
        symbols,
        1
    )

    if len(result) != 1:

        raise ValueError(
            "Could not reconstruct one byte"
        )

    return result[0]
