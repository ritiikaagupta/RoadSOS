`timescale 1ns/1ps

module tb_frame_generator;

    // --------------------------------------------------------
    // Parameters
    // --------------------------------------------------------

    localparam PAYLOAD_WIDTH = 32;
    localparam CRC_WIDTH     = 16;

    localparam FRAME_WIDTH =
        PAYLOAD_WIDTH + CRC_WIDTH + 16;


    // --------------------------------------------------------
    // Signals
    // --------------------------------------------------------

    logic clk;
    logic rst;

    logic                     payload_valid;
    logic [PAYLOAD_WIDTH-1:0] payload;
    logic [CRC_WIDTH-1:0]     crc;

    logic                     frame_valid;
    logic [FRAME_WIDTH-1:0]   frame;
    logic                     frame_done;


    // --------------------------------------------------------
    // DUT
    // --------------------------------------------------------

    frame_generator #(
        .PAYLOAD_WIDTH(PAYLOAD_WIDTH),
        .CRC_WIDTH(CRC_WIDTH)
    )
    dut (
        .clk(clk),
        .rst(rst),

        .payload_valid(payload_valid),
        .payload(payload),
        .crc(crc),

        .frame_valid(frame_valid),
        .frame(frame),
        .frame_done(frame_done)
    );


    // --------------------------------------------------------
    // Clock
    // 10 ns period
    // --------------------------------------------------------

    always #5 clk = ~clk;


    // --------------------------------------------------------
    // Test sequence
    // --------------------------------------------------------

    initial begin

        // Initial values
        clk = 1'b0;
        rst = 1'b1;

        payload_valid = 1'b0;
        payload = 32'h00000000;
        crc = 16'h0000;


        // ----------------------------------------------------
        // Reset
        // ----------------------------------------------------

        #20;

        rst = 1'b0;


        // ----------------------------------------------------
        // TEST 1
        // ----------------------------------------------------

        #10;

        payload = 32'h12345678;
        crc     = 16'hABCD;

        payload_valid = 1'b1;

        #10;

        payload_valid = 1'b0;


        // ----------------------------------------------------
        // Wait
        // ----------------------------------------------------

        #20;


        // ----------------------------------------------------
        // TEST 2
        // ----------------------------------------------------

        payload = 32'hDEADBEEF;
        crc     = 16'h55AA;

        payload_valid = 1'b1;

        #10;

        payload_valid = 1'b0;


        // ----------------------------------------------------
        // Finish
        // ----------------------------------------------------

        #30;

        $finish;

    end


    // --------------------------------------------------------
    // Monitor
    // --------------------------------------------------------

    always @(posedge clk) begin

        if (frame_valid) begin

            $display(
                "TIME=%0t | FRAME_VALID=%b | FRAME=%h | FRAME_DONE=%b",
                $time,
                frame_valid,
                frame,
                frame_done
            );

        end

    end

endmodule
