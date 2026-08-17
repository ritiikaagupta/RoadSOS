`timescale 1ns/1ps

module packet_generator #(
    parameter logic [7:0] HEADER = 8'hA5
)(
    input  logic        clk,
    input  logic        rst,

    input  logic        packet_start,
    input  logic [7:0]  event_id,
    input  logic [15:0] vehicle_id,

    output logic [47:0] packet,
    output logic        packet_valid,
    output logic        packet_done
);

    logic [31:0] payload;
    logic [15:0] crc;

    assign payload = {
        HEADER,
        event_id,
        vehicle_id
    };

    crc_generator #(
        .DATA_BYTES(4)
    ) u_crc_generator (
        .data(payload),
        .crc(crc)
    );

    always_ff @(posedge clk) begin
        if (rst) begin
            packet       <= 48'd0;
            packet_valid <= 1'b0;
            packet_done  <= 1'b0;
        end else begin
            packet_valid <= 1'b0;
            packet_done  <= 1'b0;

            if (packet_start) begin
                packet       <= {payload, crc};
                packet_valid <= 1'b1;
                packet_done  <= 1'b1;
            end
        end
    end

endmodule
