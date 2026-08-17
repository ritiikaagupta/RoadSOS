`timescale 1ns/1ps

// Controller for the corrected TX chain.
//
// CRC is not a separate state because packet_generator owns CRC generation.
// crc_start is retained as a compatibility/debug output and is always 0.

module tx_controller #(
    parameter int EVENT_ID_WIDTH = 8
)(
    input  logic clk,
    input  logic rst,

    input  logic                      emergency_trigger,
    input  logic [EVENT_ID_WIDTH-1:0] event_id,

    input  logic packet_done,
    input  logic frame_done,
    input  logic tx_done,

    output logic event_valid,
    output logic packet_start,
    output logic crc_start,
    output logic frame_start,

    output logic tx_active,
    output logic busy,

    output logic [EVENT_ID_WIDTH-1:0] event_id_out
);

    typedef enum logic [2:0] {
        IDLE,
        CAPTURE_EVENT,
        BUILD_PACKET,
        BUILD_FRAME,
        TRANSMIT,
        DONE
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    always_comb begin
        next_state = state;

        case (state)
            IDLE:
                if (emergency_trigger)
                    next_state = CAPTURE_EVENT;

            CAPTURE_EVENT:
                next_state = BUILD_PACKET;

            BUILD_PACKET:
                if (packet_done)
                    next_state = BUILD_FRAME;

            BUILD_FRAME:
                if (frame_done)
                    next_state = TRANSMIT;

            TRANSMIT:
                if (tx_done)
                    next_state = DONE;

            DONE:
                next_state = IDLE;

            default:
                next_state = IDLE;
        endcase
    end

    always_comb begin
        event_valid = 1'b0;
        packet_start = 1'b0;
        crc_start = 1'b0;
        frame_start = 1'b0;
        tx_active = 1'b0;
        busy = 1'b1;

        case (state)
            IDLE: begin
                busy = 1'b0;
            end

            CAPTURE_EVENT: begin
                event_valid = 1'b1;
            end

            BUILD_PACKET: begin
                packet_start = 1'b1;
            end

            BUILD_FRAME: begin
                frame_start = 1'b1;
            end

            TRANSMIT: begin
                tx_active = 1'b1;
            end

            DONE: begin
                busy = 1'b0;
            end

            default: begin
                busy = 1'b0;
            end
        endcase
    end

    always_ff @(posedge clk) begin
        if (rst)
            event_id_out <= '0;
        else if (state == CAPTURE_EVENT)
            event_id_out <= event_id;
    end

endmodule
