`timescale 1ns/1ps

// Frame format:
// [63:56] SOF      = 8'hA5
// [55: 8] PACKET   = 48 bits
// [ 7: 0] EOF      = 8'h5A
//
// Total = 64 bits.

module frame_generator #(
    parameter int PACKET_WIDTH = 48
)(
    input  logic                  clk,
    input  logic                  rst,

    input  logic                  packet_valid,
    input  logic [PACKET_WIDTH-1:0] packet,

    output logic                  frame_valid,
    output logic [63:0]            frame,
    output logic                  frame_done
);

    localparam logic [7:0] SOF = 8'hA5;
    localparam logic [7:0] EOF_MARKER = 8'h5A;

    always_ff @(posedge clk) begin
        if (rst) begin
            frame       <= 64'd0;
            frame_valid <= 1'b0;
            frame_done  <= 1'b0;
        end else begin
            frame_valid <= 1'b0;
            frame_done  <= 1'b0;

            if (packet_valid) begin
                frame       <= {SOF, packet, EOF_MARKER};
                frame_valid <= 1'b1;
                frame_done  <= 1'b1;
            end
        end
    end

endmodule
