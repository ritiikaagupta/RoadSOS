`timescale 1ns / 1ps

// ============================================================
// SAFE-Link LoRa Chirp Generator
// Step 10 - Basic RTL Prototype
// ============================================================

module chirp_generator #(
    parameter PHASE_WIDTH  = 32,
    parameter OUTPUT_WIDTH = 16
)(
    input  wire                         clk,
    input  wire                         reset,
    input  wire                         enable,

    input  wire [PHASE_WIDTH-1:0]       phase_increment,

    output reg signed [OUTPUT_WIDTH-1:0] i_out,
    output reg signed [OUTPUT_WIDTH-1:0] q_out,

    output reg                          valid
);

    // ========================================================
    // Phase accumulator
    // ========================================================

    reg [PHASE_WIDTH-1:0] phase_accumulator;


    // ========================================================
    // Phase accumulator update
    // ========================================================

    always @(posedge clk) begin

        if (reset) begin

            phase_accumulator <= 0;
            valid <= 1'b0;

        end

        else if (enable) begin

            phase_accumulator <=
                phase_accumulator + phase_increment;

            valid <= 1'b1;

        end

        else begin

            valid <= 1'b0;

        end

    end


    // ========================================================
    // Simple 4-point I/Q lookup
    // ========================================================

    always @(*) begin

        i_out = 16'sd0;
        q_out = 16'sd0;

        case (
            phase_accumulator[PHASE_WIDTH-1:PHASE_WIDTH-2]
        )

            // 0 degrees
            2'b00: begin
                i_out = 16'sd32767;
                q_out = 16'sd0;
            end

            // 90 degrees
            2'b01: begin
                i_out = 16'sd0;
                q_out = 16'sd32767;
            end

            // 180 degrees
            2'b10: begin
                i_out = -16'sd32767;
                q_out = 16'sd0;
            end

            // 270 degrees
            2'b11: begin
                i_out = 16'sd0;
                q_out = -16'sd32767;
            end

            default: begin
                i_out = 16'sd0;
                q_out = 16'sd0;
            end

        endcase

    end

endmodule
