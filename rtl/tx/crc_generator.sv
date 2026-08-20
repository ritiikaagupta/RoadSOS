`timescale 1ns/1ps

// ============================================================
// Streaming CRC Generator
//
// Polynomial : 0x1021
// Initial    : 0xFFFF
// Final XOR  : 0x0000
// RefIn      : FALSE
// RefOut     : FALSE
//
// Standard test vector:
// "123456789" -> 16'h29B1
//
// Operation:
//   1. Assert start for the first byte of a packet.
//   2. Assert data_valid whenever data_in is valid.
//   3. Assert last together with data_valid for the final byte.
//   4. crc_valid pulses for one clock when the CRC is ready.
//
// One byte is processed per clock cycle.
// ============================================================

module crc_generator (

    input  logic        clk,
    input  logic        rst_n,

    // --------------------------------------------------------
    // Packet control
    // --------------------------------------------------------
    input  logic        start,       // First byte of packet
    input  logic        data_valid,  // data_in is valid
    input  logic        last,        // Last byte of packet

    // --------------------------------------------------------
    // Input data
    // --------------------------------------------------------
    input  logic [7:0]  data_in,

    // --------------------------------------------------------
    // CRC output
    // --------------------------------------------------------
    output logic [15:0] crc_out,
    output logic        crc_valid
);

    // Current CRC state
    logic [15:0] crc_reg;

    // CRC after processing current byte
    logic [15:0] crc_next;


    // ========================================================
    // CRC-16/CCITT BYTE UPDATE
    //
    // Polynomial = 0x1021
    //
    // This implements the normal MSB-first CRC algorithm.
    // ========================================================

    function automatic [15:0] crc16_update;

        input [15:0] crc;
        input [7:0]  data;

        integer i;

        reg [15:0] c;

        begin

            c = crc;

            // Process data MSB first
            for (i = 0; i < 8; i = i + 1) begin

                if (c[15] ^ data[7-i]) begin
                    c = {c[14:0], 1'b0} ^ 16'h1021;
                end
                else begin
                    c = {c[14:0], 1'b0};
                end

            end

            crc16_update = c;

        end

    endfunction


    // ========================================================
    // NEXT CRC
    // ========================================================

    always_comb begin

        // For the first byte, begin from CRC = FFFF.
        if (start) begin
            crc_next = crc16_update(16'hFFFF, data_in);
        end
        else begin
            crc_next = crc16_update(crc_reg, data_in);
        end

    end


    // ========================================================
    // SEQUENTIAL CONTROL
    // ========================================================

    always_ff @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin

            crc_reg   <= 16'hFFFF;
            crc_out   <= 16'h0000;
            crc_valid <= 1'b0;

        end

        else begin

            // Default: CRC valid only for one clock
            crc_valid <= 1'b0;


            // ------------------------------------------------
            // Process one byte
            // ------------------------------------------------

            if (data_valid) begin

                // Update internal CRC
                crc_reg <= crc_next;


                // ------------------------------------------------
                // Last byte
                // ------------------------------------------------

                if (last) begin

                    // The CRC must include the final byte.
                    crc_out   <= crc_next;
                    crc_valid <= 1'b1;

                    // Prepare CRC engine for next packet.
                    crc_reg   <= 16'hFFFF;

                end

            end

        end

    end

endmodule
