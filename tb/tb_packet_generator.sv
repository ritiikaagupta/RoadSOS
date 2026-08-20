`timescale 1ns/1ps

module tb_packet_generator;

    // ============================================================
    // CLOCK / RESET
    // ============================================================

    logic clk;
    logic rst_n;

    // ============================================================
    // PACKET GENERATOR INPUTS
    // ============================================================

    logic        emergency_trigger;
    logic [7:0]  event_id;
    logic [15:0] vehicle_id;

    // ============================================================
    // CRC CONNECTION
    // ============================================================

    logic [15:0] crc_out;
    logic        crc_valid;

    // ============================================================
    // PACKET OUTPUT
    // ============================================================

    logic [7:0] packet;
    logic       packet_valid;
    logic       packet_start;
    logic       packet_done;

    // ============================================================
    // CRC CONTROL
    // ============================================================

    logic       crc_start;
    logic       crc_data_valid;
    logic       crc_last;
    logic [7:0] crc_data;

    // ============================================================
    // STATUS
    // ============================================================

    logic busy;


    // ============================================================
    // CLOCK
    //
    // 100 MHz clock
    // Period = 10 ns
    // ============================================================

    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end


    // ============================================================
    // CRC GENERATOR
    // ============================================================

    crc_generator u_crc_generator (

        .clk        (clk),
        .rst_n      (rst_n),

        .start      (crc_start),
        .data_valid (crc_data_valid),
        .last       (crc_last),

        .data_in    (crc_data),

        .crc_out    (crc_out),
        .crc_valid  (crc_valid)

    );


    // ============================================================
    // PACKET GENERATOR
    // ============================================================

    packet_generator u_packet_generator (

        .clk               (clk),
        .rst_n             (rst_n),

        .emergency_trigger (emergency_trigger),

        .event_id          (event_id),
        .vehicle_id        (vehicle_id),

        .crc_out           (crc_out),
        .crc_valid         (crc_valid),

        .packet             (packet),
        .packet_valid      (packet_valid),
        .packet_start      (packet_start),
        .packet_done       (packet_done),

        .crc_start         (crc_start),
        .crc_data_valid    (crc_data_valid),
        .crc_last          (crc_last),
        .crc_data          (crc_data),

        .busy              (busy)

    );


    // ============================================================
    // TEST VARIABLES
    // ============================================================

    integer byte_count;

    logic [7:0] expected_packet [0:6];


    // ============================================================
    // TEST SEQUENCE
    // ============================================================

    initial begin

        // --------------------------------------------------------
        // Expected packet
        // --------------------------------------------------------

        expected_packet[0] = 8'hAA;
        expected_packet[1] = 8'h01;
        expected_packet[2] = 8'h05;
        expected_packet[3] = 8'h12;
        expected_packet[4] = 8'h34;
        expected_packet[5] = 8'h0A;
        expected_packet[6] = 8'h42;


        // --------------------------------------------------------
        // Initialize inputs
        // --------------------------------------------------------

        rst_n             = 1'b0;

        emergency_trigger = 1'b0;

        event_id          = 8'h00;
        vehicle_id        = 16'h0000;

        byte_count        = 0;


        // --------------------------------------------------------
        // Reset
        // --------------------------------------------------------

        #20;

        rst_n = 1'b1;

        $display("");
        $display("==============================================");
        $display("        PACKET GENERATOR TEST START");
        $display("==============================================");

        // --------------------------------------------------------
        // Give packet information
        // --------------------------------------------------------

        event_id   = 8'h05;
        vehicle_id = 16'h1234;

        // --------------------------------------------------------
        // Trigger emergency packet
        // --------------------------------------------------------

        @(posedge clk);

        emergency_trigger = 1'b1;

        @(posedge clk);

        emergency_trigger = 1'b0;


        // --------------------------------------------------------
        // Wait until packet is completely transmitted
        // --------------------------------------------------------

        wait(packet_done);

        @(posedge clk);

        // --------------------------------------------------------
        // Finish
        // --------------------------------------------------------

        $display("");
        $display("==============================================");
        $display("        PACKET GENERATOR TEST END");
        $display("==============================================");

        #20;

        $finish;

    end


    // ============================================================
    // PACKET MONITOR
    // ============================================================

    always @(posedge clk) begin

        if (packet_valid) begin

            $display(
                "TIME=%0t ns | PACKET BYTE [%0d] = %02h",
                $time,
                byte_count,
                packet
            );

            // ----------------------------------------------------
            // Check packet byte
            // ----------------------------------------------------

            if (packet !== expected_packet[byte_count]) begin

                $display(
                    "ERROR: Expected %02h but received %02h",
                    expected_packet[byte_count],
                    packet
                );

                $finish;

            end
            else begin

                $display(
                    "       PASS: Byte %0d correct",
                    byte_count
                );

            end


            // ----------------------------------------------------
            // Increment byte counter
            // ----------------------------------------------------

            byte_count = byte_count + 1;


            // ----------------------------------------------------
            // Check final byte
            // ----------------------------------------------------

            if (packet_done) begin

                if (byte_count == 7) begin

                    $display("");
                    $display("==============================================");
                    $display("             ALL BYTES CORRECT");
                    $display("==============================================");

                    $display("Packet = AA 01 05 12 34 0A 42");
                    $display("CRC    = 0A42");

                    $display("");
                    $display("TEST PASSED");
                    $display("==============================================");

                end
                else begin

                    $display(
                        "ERROR: Expected 7 bytes, received %0d bytes",
                        byte_count
                    );

                    $finish;

                end

            end

        end

    end


    // ============================================================
    // CRC DEBUG MONITOR
    // ============================================================

    always @(posedge clk) begin

        if (crc_data_valid) begin

            $display(
                "             CRC INPUT = %02h | start=%b last=%b",
                crc_data,
                crc_start,
                crc_last
            );

        end

        if (crc_valid) begin

            $display(
                "             CRC READY = %04h",
                crc_out
            );

        end

    end


    // ============================================================
    // WAVEFORM DUMP
    // ============================================================

    initial begin

        $dumpfile("packet_generator.vcd");

        $dumpvars(0, tb_packet_generator);

    end

endmodule
