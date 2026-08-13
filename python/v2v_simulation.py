from packet import SafeLinkPacket

from protocol import (
    MESSAGE_ACCIDENT,
    PRIORITY_CRITICAL
)

from router import SafeLinkRouter


# ==================================================
# Vehicle
# ==================================================

class Vehicle:

    def __init__(self, node_id):

        self.node_id = node_id

        self.router = SafeLinkRouter()


    # --------------------------------------------------
    # Create emergency packet
    # --------------------------------------------------

    def create_accident_packet(
        self,
        sequence_id,
        message=b"ACCIDENT"
    ):

        packet = SafeLinkPacket(

            version=1,

            message_type=MESSAGE_ACCIDENT,

            node_id=self.node_id,

            sequence_id=sequence_id,

            priority=PRIORITY_CRITICAL,

            hop_count=0,

            payload=message
        )

        return packet


    # --------------------------------------------------
    # Receive packet
    # --------------------------------------------------

    def receive_packet(self, encoded_data):

        # ----------------------------------------------
        # Decode received packet
        # ----------------------------------------------

        try:

            packet = SafeLinkPacket.deserialize(
                encoded_data
            )

        except ValueError as error:

            print(
                f"Vehicle {self.node_id}: "
                f"PACKET REJECTED"
            )

            print(
                f"Reason: {error}"
            )

            return None


        # ----------------------------------------------
        # Process through router
        # ----------------------------------------------

        action, packet = (
            self.router.process_packet(packet)
        )


        print(
            f"Vehicle {self.node_id}: "
            f"{action}"
        )

        print(
            f"  Source Node : {packet.node_id}"
        )

        print(
            f"  Sequence ID : {packet.sequence_id}"
        )

        print(
            f"  Priority    : "
            f"{self.router.get_priority_name(packet.priority)}"
        )

        print(
            f"  Hop Count   : {packet.hop_count}"
        )

        print()

        # ----------------------------------------------
        # Forward if allowed
        # ----------------------------------------------

        if action == "FORWARD":

            return packet.serialize()

        return None


# ==================================================
# SAFE-Link V2V Simulation
# ==================================================

print()
print("==========================================")
print("       SAFE-Link V2V SIMULATION")
print("==========================================")
print()


# ==================================================
# Create three vehicles
# ==================================================

vehicle_a = Vehicle(node_id=1)

vehicle_b = Vehicle(node_id=2)

vehicle_c = Vehicle(node_id=3)


print("Vehicles created:")
print("  Vehicle A -> Node 1")
print("  Vehicle B -> Node 2")
print("  Vehicle C -> Node 3")
print()


# ==================================================
# VEHICLE A
# ==================================================

print("------------------------------------------")
print("STEP 1: VEHICLE A GENERATES ACCIDENT ALERT")
print("------------------------------------------")
print()


packet_a = vehicle_a.create_accident_packet(
    sequence_id=100
)


print("Vehicle A created packet:")
print(packet_a)

print()


# ==================================================
# A -> B
# ==================================================

print("------------------------------------------")
print("STEP 2: VEHICLE A -> VEHICLE B")
print("------------------------------------------")
print()


encoded_a = packet_a.serialize()


encoded_b = vehicle_b.receive_packet(
    encoded_a
)


# ==================================================
# B -> C
# ==================================================

print("------------------------------------------")
print("STEP 3: VEHICLE B -> VEHICLE C")
print("------------------------------------------")
print()


if encoded_b is not None:

    encoded_c = vehicle_c.receive_packet(
        encoded_b
    )

else:

    encoded_c = None


# ==================================================
# DUPLICATE TEST
# ==================================================

print("------------------------------------------")
print("STEP 4: DUPLICATE PACKET TEST")
print("------------------------------------------")
print()


duplicate_result = vehicle_b.receive_packet(
    encoded_a
)


# ==================================================
# FINAL RESULT
# ==================================================

print("------------------------------------------")
print("FINAL RESULT")
print("------------------------------------------")


if (

    encoded_b is not None

    and encoded_c is not None

    and duplicate_result is None

):

    print()
    print("V2V SIMULATION RESULT: PASS")
    print()
    print("Vehicle A -> Vehicle B -> Vehicle C")
    print("Emergency packet successfully forwarded.")
    print("Duplicate packet successfully suppressed.")

else:

    print()
    print("V2V SIMULATION RESULT: FAIL")
