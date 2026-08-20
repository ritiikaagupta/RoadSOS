`timescale 1ns/1ps

module rx_top_module_tb;

    // ============================================================
    // CLOCK / RESET
    // ============================================================

    logic clk;
    logic rst;

    // ============================================================
    // RX INPUT
    // ============================================================

    logic signed [15:0] i_in;
    logic signed [15:0] q_in;
    logic               valid_in;

    // ============================================================
    // RX OUTPUTS
    // ============================================================

    logic [47:0] packet_out;
    logic        packet_valid;

    logic        crc_pass;
    logic        crc_done;

    logic [7:0]  event_id;
    logic        emergency_alert;

    logic        synchronized;
    logic        preamble_detected;


    // ============================================================
    // DUT
    // ============================================================

    rx_top_module #(
        .SAMPLES_PER_SYMBOL(8)
    ) dut (
        .clk              (clk),
        .rst              (rst),

        .i_in             (i_in),
        .q_in             (q_in),
        .valid_in         (valid_in),

        .packet_out       (packet_out),
        .packet_valid     (packet_valid),

        .crc_pass         (crc_pass),
        .crc_done         (crc_done),

        .event_id         (event_id),
        .emergency_alert  (emergency_alert),

        .synchronized     (synchronized),
        .preamble_detected(preamble_detected)
    );


    // ============================================================
    // CLOCK
    // 10 ns period = 100 MHz
    // ============================================================

    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end


    // ============================================================
    // RESET
    // ============================================================

    task reset_dut;
        begin
            rst      = 1'b1;
            i_in     = 16'sd0;
            q_in     = 16'sd0;
            valid_in = 1'b0;

            repeat (5) @(posedge clk);

            rst = 1'b0;

            repeat (2) @(posedge clk);
        end
    endtask


    // ============================================================
    // SEND ONE I/Q SAMPLE
    // ============================================================

    task send_sample(
        input logic signed [15:0] i_sample,
        input logic signed [15:0] q_sample
    );
        begin
            @(posedge clk);

            i_in     <= i_sample;
            q_in     <= q_sample;
            valid_in <= 1'b1;

            @(posedge clk);

            valid_in <= 1'b0;
            i_in     <= 16'sd0;
            q_in     <= 16'sd0;
        end
    endtask


    // ============================================================
    // SEND SIMPLE TEST PREAMBLE
    //
    // Current repository prototype uses a simplified preamble
    // representation, so this testbench sends alternating samples.
    // ============================================================

    task send_test_preamble;
        integer k;

        begin
            $display("------------------------------------------------");
            $display("Sending test preamble...");
            $display("------------------------------------------------");

            for (k = 0; k < 16; k = k + 1) begin

                if (k % 2 == 0)
                    send_sample(16'sd1000, 16'sd0);
                else
                    send_sample(16'sd0, 16'sd1000);

            end
        end
    endtask


    // ============================================================
    // SEND TEST DATA
    // ============================================================

    task send_test_data;
        integer k;

        begin
            $display("------------------------------------------------");
            $display("Sending test RX data...");
            $display("------------------------------------------------");

            for (k = 0; k < 80; k = k + 1) begin

                if (k % 4 == 0)
                    send_sample(16'sd1000, 16'sd0);

                else if (k % 4 == 1)
                    send_sample(16'sd707, 16'sd707);

                else if (k % 4 == 2)
                    send_sample(16'sd0, 16'sd1000);

                else
                    send_sample(-16'sd707, 16'sd707);

            end
        end
    endtask


    // ============================================================
    // MONITOR
    // ============================================================

    always @(posedge clk) begin

        if (preamble_detected)
            $display(
                "[%0t] PREAMBLE DETECTED",
                $time
            );

        if (synchronized)
            $display(
                "[%0t] RECEIVER SYNCHRONIZED",
                $time
            );

        if (packet_valid)
            $display(
                "[%0t] PACKET VALID = %h",
                $time,
                packet_out
            );

        if (crc_done) begin

            if (crc_pass)
                $display(
                    "[%0t] CRC PASS",
                    $time
                );

            else
                $display(
                    "[%0t] CRC FAIL",
                    $time
                );

        end

        if (emergency_alert)
            $display(
                "[%0t] *** EMERGENCY ALERT *** EVENT ID = %h",
                $time,
                event_id
            );

    end


    // ============================================================
    // MAIN TEST
    // ============================================================

    initial begin

        $display("");
        $display("================================================");
        $display("       RoadSOS RX TOP MODULE TESTBENCH");
        $display("================================================");
        $display("");

        // Initialize
        clk      = 1'b0;
        rst      = 1'b0;

        i_in     = 16'sd0;
        q_in     = 16'sd0;
        valid_in = 1'b0;


        // --------------------------------------------------------
        // TEST 1: RESET
        // --------------------------------------------------------

        $display("");
        $display("TEST 1: RESET");

        reset_dut;

        $display("Reset completed.");


        // --------------------------------------------------------
        // TEST 2: PREAMBLE
        // --------------------------------------------------------

        $display("");
        $display("TEST 2: PREAMBLE DETECTION");

        send_test_preamble;

        repeat (10) @(posedge clk);


        // --------------------------------------------------------
        // TEST 3: DATA
        // --------------------------------------------------------

        $display("");
        $display("TEST 3: RX DATA");

        send_test_data;

        repeat (100) @(posedge clk);


        // --------------------------------------------------------
        // FINISH
        // --------------------------------------------------------

        $display("");
        $display("================================================");
        $display("             TESTBENCH COMPLETE");
        $display("================================================");
        $display("");

        $finish;

    end


    // ============================================================
    // TIMEOUT PROTECTION
    // ============================================================

    initial begin

        #100000;

        $display("");
        $display("ERROR: Simulation timeout!");
        $display("");

        $finish;

    end

endmodule
