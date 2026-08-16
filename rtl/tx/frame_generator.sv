`timescale 1ns/1ps

module frame_generator #(
    parameter PAYLOAD_WIDTH = 32,
    parameter CRC_WIDTH     = 16
)(
    input  logic                     clk,
    input  logic                     rst,

    // Input packet information
    input  logic                     payload_valid,
    input  logic [PAYLOAD_WIDTH-1:0] payload,
    input  logic [CRC_WIDTH-1:0]     crc,

    // Generated frame
    output logic                     frame_valid,
    output logic [PAYLOAD_WIDTH+CRC_WIDTH+16-1:0] frame,

    // Indicates that the frame has been generated
    output logic                     frame_done
);

    // --------------------------------------------------------
    // Frame constants
    // --------------------------------------------------------

    localparam logic [7:0] SOF = 8'hA5;
    localparam logic [7:0] EOF_MARKER = 8'h5A;

    localparam FRAME_WIDTH =
        PAYLOAD_WIDTH + CRC_WIDTH + 16;


    // --------------------------------------------------------
    // Frame generation
    // --------------------------------------------------------

    always_ff @(posedge clk) begin

        if (rst) begin

            frame       <= '0;
            frame_valid <= 1'b0;
            frame_done  <= 1'b0;

        end

        else begin

            // Default outputs
            frame_valid <= 1'b0;
            frame_done  <= 1'b0;

            // Generate frame when payload is valid
            if (payload_valid) begin

                frame <= {
                    SOF,
                    payload,
                    crc,
                    EOF_MARKER
                };

                frame_valid <= 1'b1;
                frame_done  <= 1'b1;

            end

        end

    end

endmodule
