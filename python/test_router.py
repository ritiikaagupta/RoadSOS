from packet import SafeLinkPacket

from protocol import (
    MESSAGE_ACCIDENT,
    PRIORITY_LOW,
    PRIORITY_HIGH,
    PRIORITY_CRITICAL,
    MAX_HOPS
)

from router import SafeLinkRouter


# --------------------------------------------------
# Create router
# --------------------------------------------------

router = SafeLinkRouter()


print("SAFE-Link Router Test")
print("---------------------")

print()


# ==================================================
# TEST 1: Critical emergency packet
# ==================================================

packet_1 = SafeLinkPacket(

    version=1,

    message_type=MESSAGE_ACCIDENT,

    node_id=3,

    sequence_id=27,

    priority=PRIORITY_CRITICAL,

    hop_count=0,

    payload=b"ACCIDENT"
)


action_1, processed_packet_1 = (
    router.process_packet(packet_1)
)


print()
print("TEST 1: Critical emergency packet")

print(
    "Priority:",
    router.get_priority_name(
        processed_packet_1.priority
    )
)

print(
    "Action:",
    action_1
)

print(
    "Hop count:",
    processed_packet_1.hop_count
)

print()


# ==================================================
# TEST 2: Duplicate packet
# ==================================================

packet_2 = SafeLinkPacket(

    version=1,

    message_type=MESSAGE_ACCIDENT,

    node_id=3,

    sequence_id=27,

    priority=PRIORITY_CRITICAL,

    hop_count=0,

    payload=b"ACCIDENT"
)


action_2, processed_packet_2 = (
    router.process_packet(packet_2)
)


print("TEST 2: Duplicate packet")

print(
    "Action:",
    action_2
)

print()


# ==================================================
# TEST 3: Hop limit reached
# ==================================================

packet_3 = SafeLinkPacket(

    version=1,

    message_type=MESSAGE_ACCIDENT,

    node_id=5,

    sequence_id=100,

    priority=PRIORITY_HIGH,

    hop_count=MAX_HOPS,

    payload=b"ACCIDENT"
)


action_3, processed_packet_3 = (
    router.process_packet(packet_3)
)


print("TEST 3: Hop limit reached")

print(
    "Action:",
    action_3
)

print()


# ==================================================
# TEST 4: Low-priority packet
# ==================================================

packet_4 = SafeLinkPacket(

    version=1,

    message_type=MESSAGE_ACCIDENT,

    node_id=7,

    sequence_id=50,

    priority=PRIORITY_LOW,

    hop_count=0,

    payload=b"TEST"
)


action_4, processed_packet_4 = (
    router.process_packet(packet_4)
)


print("TEST 4: Low-priority packet")

print(
    "Priority:",
    router.get_priority_name(
        processed_packet_4.priority
    )
)

print(
    "Action:",
    action_4
)

print()


# ==================================================
# FINAL RESULT
# ==================================================

if (

    action_1 == "FORWARD"

    and processed_packet_1.hop_count == 1

    and action_2 == "DROP_DUPLICATE"

    and action_3 == "DROP_HOP_LIMIT"

    and action_4 == "FORWARD"

):

    print("RESULT: PASS")

else:

    print("RESULT: FAIL")
