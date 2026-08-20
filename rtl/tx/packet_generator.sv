`timescale 1ns/1ps

// ============================================================
// PACKET GENERATOR
//
// Packet format:
//
//   BYTE 0 : 0xAA          -> Synchronization byte
//   BYTE 1 : 0x01          -> Packet type / version
//   BYTE 2 : event_id
//   BYTE 3 : vehicle_id[15:8]
//   BYTE 4 : vehicle_id[7:0]
//   BYTE 5 : CRC[15:8]
//   BYTE 6 : CRC[7:0]
//
// CRC is calculated over:
//   0x01
//   event_id
//   vehicle_id[15:8]
//   vehicle_id[7:0]
//
// CRC engine:
//   CRC-16/CCITT-FALSE
//   Polynomial = 0x1021
//   Initial    = 0xFFFF
//
// Interface:
//   emergency_trigger -> starts a new packet
//
// Outputs:
//   packet_start -> first CRC byte
//   packet_valid -> packet_data is valid
//   packet_done  -> last byte of complete packet
//
// ============================================================

module packet_generator (

    input  logic        clk,
    input  logic        rst_n,

    // --------------------------------------------------------
    // Packet generation request
    // --------------------------------------------------------
    input  logic        emergency_trigger,

    // --------------------------------------------------------
    // Packet information
    // --------------------------------------------------------
    input  logic [7:0]  event_id,
    input  logic [15:0] vehicle_id,

    // --------------------------------------------------------
    // CRC result from crc_generator
    // --------------------------------------------------------
    input  logic [15:0] crc_out,
    input  logic        crc_valid,

    // --------------------------------------------------------
    // Packet output
    // --------------------------------------------------------
    output logic [7:0]  packet,
    output logic        packet_valid,
    output logic        packet_start,
    output logic        packet_done,

    // --------------------------------------------------------
    // CRC control signals
    //
    // These connect directly to crc_generator.
    // --------------------------------------------------------
    output logic        crc_start,
    output logic        crc_data_valid,
    output logic        crc_last,
    output logic [7:0]  crc_data,

    // --------------------------------------------------------
    // Generator status
    // --------------------------------------------------------
    output logic        busy
);


    // ========================================================
    // FSM STATES
    // ========================================================

    typedef enum logic [3:0] {

        IDLE,

        SEND_SYNC,

        SEND_TYPE,

        SEND_EVENT,

        SEND_VEHICLE_H,

        SEND_VEHICLE_L,

        WAIT_CRC,

        SEND_CRC_H,

        SEND_CRC_L

    } state_t;

    state_t state;


    // ========================================================
    // STORED PACKET INFORMATION
    // ========================================================

    logic [7:0]  event_id_reg;
    logic [15:0] vehicle_id_reg;

    logic [15:0] crc_reg;


    // ========================================================
    // SEQUENTIAL FSM
    // ========================================================

    always_ff @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin

            state          <= IDLE;

            event_id_reg   <= 8'h00;
            vehicle_id_reg <= 16'h0000;

            crc_reg        <= 16'h0000;

        end

        else begin

            case (state)

                // =================================================
                // IDLE
                // =================================================

                IDLE: begin

                    if (emergency_trigger) begin

                        // Capture packet information
                        event_id_reg   <= event_id;
                        vehicle_id_reg <= vehicle_id;

                        // Start packet
                        state <= SEND_SYNC;

                    end

                end


                // =================================================
                // SEND SYNC BYTE
                // =================================================

                SEND_SYNC: begin

                    state <= SEND_TYPE;

                end


                // =================================================
                // SEND PACKET TYPE
                //
                // First byte that goes into CRC.
                // =================================================

                SEND_TYPE: begin

                    state <= SEND_EVENT;

                end


                // =================================================
                // SEND EVENT ID
                // =================================================

                SEND_EVENT: begin

                    state <= SEND_VEHICLE_H;

                end


                // =================================================
                // SEND VEHICLE ID HIGH BYTE
                // =================================================

                SEND_VEHICLE_H: begin

                    state <= SEND_VEHICLE_L;

                end


                // =================================================
                // SEND VEHICLE ID LOW BYTE
                //
                // This is the final byte sent to CRC.
                // =================================================

                SEND_VEHICLE_L: begin

                    state <= WAIT_CRC;

                end


                // =================================================
                // WAIT FOR CRC
                // =================================================

                WAIT_CRC: begin

                    if (crc_valid) begin

                        crc_reg <= crc_out;

                        state <= SEND_CRC_H;

                    end

                end


                // =================================================
                // SEND CRC HIGH BYTE
                // =================================================

                SEND_CRC_H: begin

                    state <= SEND_CRC_L;

                end


                // =================================================
                // SEND CRC LOW BYTE
                // =================================================

                SEND_CRC_L: begin

                    state <= IDLE;

                end


                default: begin

                    state <= IDLE;

                end

            endcase

        end

    end


    // ========================================================
    // OUTPUT LOGIC
    //
    // All outputs are combinationally generated from FSM state.
    // ========================================================

    always_comb begin

        // ----------------------------------------------------
        // Default outputs
        // ----------------------------------------------------

        packet         = 8'h00;

        packet_valid   = 1'b0;
        packet_start   = 1'b0;
        packet_done    = 1'b0;

        crc_start      = 1'b0;
        crc_data_valid = 1'b0;
        crc_last       = 1'b0;
        crc_data       = 8'h00;

        busy           = 1'b1;


        // ====================================================
        // IDLE
        // ====================================================

        if (state == IDLE) begin

            busy = 1'b0;

        end


        // ====================================================
        // SYNC BYTE
        //
        // 0xAA is NOT included in CRC.
        // ====================================================

        else if (state == SEND_SYNC) begin

            packet       = 8'hAA;
            packet_valid = 1'b1;

        end


        // ====================================================
        // PACKET TYPE
        //
        // 0x01 is first byte of CRC calculation.
        // ====================================================

        else if (state == SEND_TYPE) begin

            packet         = 8'h01;
            packet_valid   = 1'b1;

            crc_data       = 8'h01;
            crc_data_valid = 1'b1;
            crc_start      = 1'b1;

        end


        // ====================================================
        // EVENT ID
        // ====================================================

        else if (state == SEND_EVENT) begin

            packet         = event_id_reg;
            packet_valid   = 1'b1;

            crc_data       = event_id_reg;
            crc_data_valid = 1'b1;

        end


        // ====================================================
        // VEHICLE ID HIGH BYTE
        // ====================================================

        else if (state == SEND_VEHICLE_H) begin

            packet         = vehicle_id_reg[15:8];
            packet_valid   = 1'b1;

            crc_data       = vehicle_id_reg[15:8];
            crc_data_valid = 1'b1;

        end


        // ====================================================
        // VEHICLE ID LOW BYTE
        //
        // FINAL CRC BYTE
        // ====================================================

        else if (state == SEND_VEHICLE_L) begin

            packet         = vehicle_id_reg[7:0];
            packet_valid   = 1'b1;

            crc_data       = vehicle_id_reg[7:0];
            crc_data_valid = 1'b1;

            crc_last       = 1'b1;

        end


        // ====================================================
        // CRC HIGH BYTE
        // ====================================================

        else if (state == SEND_CRC_H) begin

            packet         = crc_reg[15:8];
            packet_valid   = 1'b1;

        end


        // ====================================================
        // CRC LOW BYTE
        //
        // Last byte of complete packet.
        // ====================================================

        else if (state == SEND_CRC_L) begin

            packet         = crc_reg[7:0];
            packet_valid   = 1'b1;

            packet_done    = 1'b1;

        end

    end

endmodule
