from duplicate_filter import DuplicateFilter

from protocol import (
    MAX_HOPS,
    PRIORITY_LOW,
    PRIORITY_MEDIUM,
    PRIORITY_HIGH,
    PRIORITY_CRITICAL
)


# --------------------------------------------------
# SAFE-Link Router
# --------------------------------------------------

class SafeLinkRouter:

    def __init__(self):

        self.duplicate_filter = DuplicateFilter()


    # --------------------------------------------------
    # Get priority name
    # --------------------------------------------------

    def get_priority_name(self, priority):

        if priority == PRIORITY_LOW:

            return "LOW"

        elif priority == PRIORITY_MEDIUM:

            return "MEDIUM"

        elif priority == PRIORITY_HIGH:

            return "HIGH"

        elif priority == PRIORITY_CRITICAL:

            return "CRITICAL"

        else:

            return "UNKNOWN"


    # --------------------------------------------------
    # Process received packet
    # --------------------------------------------------

    def process_packet(self, packet):

        # ----------------------------------------------
        # Step 1: Duplicate check
        # ----------------------------------------------

        duplicate = self.duplicate_filter.is_duplicate(

            node_id=packet.node_id,

            sequence_id=packet.sequence_id
        )


        if duplicate:

            return (
                "DROP_DUPLICATE",
                packet
            )


        # ----------------------------------------------
        # Step 2: Hop-count check
        # ----------------------------------------------

        if packet.hop_count >= MAX_HOPS:

            return (
                "DROP_HOP_LIMIT",
                packet
            )


        # ----------------------------------------------
        # Step 3: Priority classification
        # ----------------------------------------------

        priority_name = self.get_priority_name(
            packet.priority
        )

        print(
            f"Packet priority: {priority_name}"
        )


        # ----------------------------------------------
        # Step 4: Increment hop count
        # ----------------------------------------------

        packet.hop_count += 1


        # ----------------------------------------------
        # Step 5: Forward packet
        # ----------------------------------------------

        return (
            "FORWARD",
            packet
        )
