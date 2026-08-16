`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2026 10:54:17 PM
// Design Name: 
// Module Name: tx_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tx_controller #(
    parameter EVENT_ID_WIDTH = 4
)(
    input  logic clk,
    input  logic rst,

    // Emergency event
    input  logic                     emergency_trigger,
    input  logic [EVENT_ID_WIDTH-1:0] event_id,

    // Processing completion signals
    input  logic packet_done,
    input  logic crc_done,
    input  logic frame_done,
    input  logic tx_done,

    // Control signals
    output logic event_valid,
    output logic packet_start,
    output logic crc_start,
    output logic frame_start,

    output logic tx_active,
    output logic busy,

    // Captured event
    output logic [EVENT_ID_WIDTH-1:0] event_id_out
);


    // ------------------------------------------------
    // State definition
    // ------------------------------------------------

    typedef enum logic [3:0] {

        IDLE,
        CAPTURE_EVENT,
        BUILD_PACKET,
        CALCULATE_CRC,
        BUILD_FRAME,
        TRANSMIT,
        DONE

    } state_t;


    state_t state, next_state;


    // ------------------------------------------------
    // State register
    // ------------------------------------------------

    always_ff @(posedge clk) begin

        if (rst) begin

            state <= IDLE;

        end

        else begin

            state <= next_state;

        end

    end


    // ------------------------------------------------
    // Next-state logic
    // ------------------------------------------------

    always_comb begin

        next_state = state;

        case (state)

            // -----------------------------------------
            // Waiting for emergency
            // -----------------------------------------

            IDLE: begin

                if (emergency_trigger)
                    next_state = CAPTURE_EVENT;

            end


            // -----------------------------------------
            // Capture event
            // -----------------------------------------

            CAPTURE_EVENT: begin

                next_state = BUILD_PACKET;

            end


            // -----------------------------------------
            // Create packet
            // -----------------------------------------

            BUILD_PACKET: begin

                if (packet_done)
                    next_state = CALCULATE_CRC;

            end


            // -----------------------------------------
            // Calculate CRC
            // -----------------------------------------

            CALCULATE_CRC: begin

                if (crc_done)
                    next_state = BUILD_FRAME;

            end


            // -----------------------------------------
            // Create frame
            // -----------------------------------------

            BUILD_FRAME: begin

                if (frame_done)
                    next_state = TRANSMIT;

            end


            // -----------------------------------------
            // Transmit
            // -----------------------------------------

            TRANSMIT: begin

                if (tx_done)
                    next_state = DONE;

            end


            // -----------------------------------------
            // Transmission finished
            // -----------------------------------------

            DONE: begin

                next_state = IDLE;

            end


            default: begin

                next_state = IDLE;

            end

        endcase

    end


    // ------------------------------------------------
    // Output logic
    // ------------------------------------------------

    always_comb begin

        // Defaults
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


            CALCULATE_CRC: begin

                crc_start = 1'b1;

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


    // ------------------------------------------------
    // Capture event ID
    // ------------------------------------------------

    always_ff @(posedge clk) begin

        if (rst) begin

            event_id_out <= '0;

        end

        else if (state == CAPTURE_EVENT) begin

            event_id_out <= event_id;

        end

    end

endmodule
