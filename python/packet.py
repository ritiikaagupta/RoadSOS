from dataclasses import dataclass


# --------------------------------------------------
# CRC-16-CCITT
# --------------------------------------------------

def crc16_ccitt(data):

    crc = 0xFFFF

    for byte in data:

        crc ^= byte << 8

        for _ in range(8):

            if crc & 0x8000:

                crc = (
                    (crc << 1)
                    ^ 0x1021
                )

            else:

                crc <<= 1

            crc &= 0xFFFF

    return crc


# --------------------------------------------------
# SAFE-Link Packet
# --------------------------------------------------

@dataclass
class SafeLinkPacket:

    version: int

    message_type: int

    node_id: int

    sequence_id: int

    priority: int

    hop_count: int

    payload: bytes

    # --------------------------------------------------
    # Serialize packet
    # --------------------------------------------------

    def serialize(self):

        packet = bytearray()

        packet.append(self.version)

        packet.append(self.message_type)

        packet.append(self.node_id)

        packet.append(self.sequence_id)

        packet.append(self.priority)

        packet.append(self.hop_count)

        packet.extend(self.payload)

        # Calculate CRC
        crc = crc16_ccitt(packet)

        # Add CRC high byte
        packet.append(
            (crc >> 8) & 0xFF
        )

        # Add CRC low byte
        packet.append(
            crc & 0xFF
        )

        return bytes(packet)

    # --------------------------------------------------
    # Deserialize packet
    # --------------------------------------------------

    @classmethod
    def deserialize(cls, data):

        # Basic packet length check
        if len(data) < 8:

            raise ValueError(
                "Packet is too short"
            )

        # ------------------------------------------
        # Extract received CRC
        # ------------------------------------------

        received_crc = (
            (data[-2] << 8)
            | data[-1]
        )

        # Remove CRC from packet
        packet_without_crc = data[:-2]

        # ------------------------------------------
        # Calculate CRC again
        # ------------------------------------------

        calculated_crc = crc16_ccitt(
            packet_without_crc
        )

        # ------------------------------------------
        # Check CRC
        # ------------------------------------------

        if received_crc != calculated_crc:

            raise ValueError(
                "CRC verification failed"
            )

        # ------------------------------------------
        # Extract header fields
        # ------------------------------------------

        version = data[0]

        message_type = data[1]

        node_id = data[2]

        sequence_id = data[3]

        priority = data[4]

        hop_count = data[5]

        # ------------------------------------------
        # Extract payload
        # ------------------------------------------

        payload = data[6:-2]

        # ------------------------------------------
        # Create decoded packet
        # ------------------------------------------

        return cls(

            version=version,

            message_type=message_type,

            node_id=node_id,

            sequence_id=sequence_id,

            priority=priority,

            hop_count=hop_count,

            payload=payload
        )
