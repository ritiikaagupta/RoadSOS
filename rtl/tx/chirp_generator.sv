`timescale 1ns/1ps

// Digital baseband chirp prototype.
//
// The 7-bit symbol controls the phase increment.
// This is a DIGITAL I/Q prototype, not an RF transmitter.

module chirp_generator #(
    parameter int PHASE_WIDTH = 32,
    parameter int OUTPUT_WIDTH = 16,
    parameter logic [PHASE_WIDTH-1:0] BASE_PHASE_INCREMENT = 32'd1000000,
    parameter logic [PHASE_WIDTH-1:0] SYMBOL_PHASE_STEP     = 32'd10000
)(
    input  logic                         clk,
    input  logic                         reset,
    input  logic                         enable,

    input  logic [6:0]                   symbol,
    input  logic                         symbol_valid,

    output logic signed [OUTPUT_WIDTH-1:0] i_out,
    output logic signed [OUTPUT_WIDTH-1:0] q_out,
    output logic                          valid
);

    logic [PHASE_WIDTH-1:0] phase_accumulator;
    logic [PHASE_WIDTH-1:0] phase_increment;

    always_ff @(posedge clk) begin
        if (reset) begin
            phase_accumulator <= '0;
            phase_increment   <= BASE_PHASE_INCREMENT;
            valid             <= 1'b0;
        end else if (enable) begin
            if (symbol_valid)
                phase_increment <= BASE_PHASE_INCREMENT +
                                   (symbol * SYMBOL_PHASE_STEP);

            phase_accumulator <= phase_accumulator + phase_increment;
            valid <= 1'b1;
        end else begin
            valid <= 1'b0;
        end
    end

    // Four-quadrant prototype LUT.
    always_comb begin
        i_out = '0;
        q_out = '0;

        case (phase_accumulator[PHASE_WIDTH-1:PHASE_WIDTH-2])
            2'b00: begin
                i_out = 16'sd32767;
                q_out = 16'sd0;
            end
            2'b01: begin
                i_out = 16'sd0;
                q_out = 16'sd32767;
            end
            2'b10: begin
                i_out = -16'sd32767;
                q_out = 16'sd0;
            end
            2'b11: begin
                i_out = 16'sd0;
                q_out = -16'sd32767;
            end
            default: begin
                i_out = '0;
                q_out = '0;
            end
        endcase
    end

endmodule
