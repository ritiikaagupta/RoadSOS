`timescale 1ns/1ps

// Prototype preamble detector.
// It converts the sign of I into a 1-bit stream and searches for
// 10101010. This keeps the detector in the I/Q domain at its input.
//
// For a real LoRa PHY this should eventually be replaced by
// correlation against the actual preamble chirps.

module preamble_detector (
    input  logic clk,
    input  logic rst,

    input  logic signed [15:0] i_in,
    input  logic signed [15:0] q_in,
    input  logic               valid_in,

    output logic preamble_detected
);

    localparam logic [7:0] PREAMBLE_PATTERN = 8'b10101010;

    logic [7:0] sample_buffer;
    logic       bit_sample;

    always_comb begin
        bit_sample = ~i_in[15];
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            sample_buffer     <= 8'd0;
            preamble_detected <= 1'b0;
        end else if (valid_in) begin
            sample_buffer <= {sample_buffer[6:0], bit_sample};

            if ({sample_buffer[6:0], bit_sample} == PREAMBLE_PATTERN)
                preamble_detected <= 1'b1;
            else
                preamble_detected <= 1'b0;
        end else begin
            preamble_detected <= 1'b0;
        end
    end

endmodule
