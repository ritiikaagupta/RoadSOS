from duplicate_filter import DuplicateFilter


filter = DuplicateFilter()


print("SAFE-Link Duplicate Filter Test")
print("--------------------------------")


# --------------------------------------------------
# First message
# --------------------------------------------------

result_1 = filter.is_duplicate(
    node_id=3,
    sequence_id=27
)


print(
    "First reception:",
    "DUPLICATE"
    if result_1
    else "NEW"
)


# --------------------------------------------------
# Same message again
# --------------------------------------------------

result_2 = filter.is_duplicate(
    node_id=3,
    sequence_id=27
)


print(
    "Second reception:",
    "DUPLICATE"
    if result_2
    else "NEW"
)


# --------------------------------------------------
# Different message
# --------------------------------------------------

result_3 = filter.is_duplicate(
    node_id=3,
    sequence_id=28
)


print(
    "New sequence:",
    "DUPLICATE"
    if result_3
    else "NEW"
)


# --------------------------------------------------
# Final result
# --------------------------------------------------

if (
    result_1 is False
    and result_2 is True
    and result_3 is False
):

    print("RESULT: PASS")

else:

    print("RESULT: FAIL")
