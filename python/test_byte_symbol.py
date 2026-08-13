from byte_symbol import (
    byte_to_symbols,
    symbols_to_byte
)


print("SAFE-Link Byte <-> Symbol Test")
print("--------------------------------")


# --------------------------------------------------
# Test bytes
# --------------------------------------------------

test_bytes = [
    0,
    1,
    25,
    65,
    100,
    255
]


all_passed = True


# --------------------------------------------------
# Test conversion
# --------------------------------------------------

for value in test_bytes:

    symbols = byte_to_symbols(
        value
    )

    reconstructed = symbols_to_byte(
        symbols
    )

    print()

    print(
        f"Byte        : {value}"
    )

    print(
        f"Symbols     : {symbols}"
    )

    print(
        f"Reconstructed: {reconstructed}"
    )


    if reconstructed == value:

        print("Result      : PASS")

    else:

        print("Result      : FAIL")

        all_passed = False


# --------------------------------------------------
# Final result
# --------------------------------------------------

print()

if all_passed:

    print("RESULT: PASS")

else:

    print("RESULT: FAIL")
