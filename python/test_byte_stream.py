from packet import SafeLinkPacket

from byte_symbol import (
    bytes_to_symbols,
    symbols_to_bytes
)


# ==================================================
# Create SAFE-Link packet
# ==================================================

packet = SafeLinkPacket(

    version=1,

    message_type=1,

    node_id=1,

    sequence_id=55,

    priority=3,

    hop_count=0,

    payload=b"ACCIDENT"
)


# ==================================================
# Serialize
# ==================================================

original_bytes = packet.serialize()


print()
print("==========================================")
print(" SAFE-Link BYTE <-> SYMBOL STREAM TEST")
print("==========================================")
print()

print(
    "Original bytes:"
)

print(
    original_bytes.hex(" ")
)

print()

print(
    "Original byte count:",
    len(original_bytes)
)


# ==================================================
# Bytes -> Symbols
# ==================================================

symbols = bytes_to_symbols(
    original_bytes
)


print()

print(
    "Number of symbols:",
    len(symbols)
)

print(
    "Symbols:"
)

print(
    symbols
)


# ==================================================
# Symbols -> Bytes
# ==================================================

recovered_bytes = symbols_to_bytes(

    symbols,

    len(original_bytes)
)


print()

print(
    "Recovered bytes:"
)

print(
    recovered_bytes.hex(" ")
)

print()

print(
    "Recovered byte count:",
    len(recovered_bytes)
)


# ==================================================
# Compare
# ==================================================

print()

if recovered_bytes == original_bytes:

    print(
        "BYTE STREAM RESULT: PASS"
    )

else:

    print(
        "BYTE STREAM RESULT: FAIL"
    )
