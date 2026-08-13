class DuplicateFilter:

    def __init__(self):

        self.seen_messages = set()

    # --------------------------------------------------
    # Check whether message was already received
    # --------------------------------------------------

    def is_duplicate(
        self,
        node_id,
        sequence_id
    ):

        message_id = (
            node_id,
            sequence_id
        )

        if message_id in self.seen_messages:

            return True

        self.seen_messages.add(
            message_id
        )

        return False
