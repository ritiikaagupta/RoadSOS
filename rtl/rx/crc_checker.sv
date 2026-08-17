`timescale 1ns/1ps

// Checks the complete 48-bit packet.
//
// [47:40] Header
// [39:32] Event ID
// [31:16] Vehicle ID
// [15: 0] Received CRC-16

module crc_checker (
    input  logic        clk,
    input  logic        rst,

    input  logic [47:0] packet_in,
    input  logic        packet_valid,

    output logic        crc_pass,
    output logic        crc_done
);

    logic [15:0] crc_calc;
    logic [31:0] payload;

    integer i;
    integer j;
    logic [15:0] crc_temp;
    logic [7:0] current_byte;

    assign payload = packet_in[47:16];

    always_comb begin
        crc_temp     = 16'hFFFF;
        current_byte = 8'h00;

        for (i = 0; i < 4; i = i + 1) begin
            current_byte = payload[31-i*8 -: 8];

            crc_temp = crc_temp ^ (current_byte << 8);

            for (j = 0; j < 8; j = j + 1) begin
                if (crc_temp[15])
                    crc_temp = (crc_temp << 1) ^ 16'h1021;
                else
                    crc_temp = crc_temp << 1;
            end
        end

        crc_calc = crc_temp;
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            crc_pass <= 1'b0;
            crc_done <= 1'b0;
        end else begin
            crc_done <= 1'b0;

            if (packet_valid) begin
                crc_pass <= (crc_calc == packet_in[15:0]);
                crc_done <= 1'b1;
            end
        end
    end

endmodule
