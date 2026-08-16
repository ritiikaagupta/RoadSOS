module packet_generator (

    input  logic [7:0]  header,
    input  logic [7:0]  event_id,
    input  logic [15:0] vehicle_id,

    output logic [47:0] packet

);

    logic [31:0] payload;
    logic [15:0] crc;

    // First 32 bits of the packet
    assign payload = {
        header,
        event_id,
        vehicle_id
    };

    // Reuse our CRC module
    crc_generator #(
        .DATA_BYTES(4)
    ) crc_inst (

        .data(payload),
        .crc(crc)

    );

    // Complete packet
    assign packet = {
        payload,
        crc
    };

endmodule
