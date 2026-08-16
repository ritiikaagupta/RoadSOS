// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

module tb_synchronizer;

    logic clk;
    logic rst;

    logic preamble_detected;

    logic symbol_start;
    logic synchronized;


    // ------------------------------------------
    // DUT
    // ------------------------------------------

    synchronizer #(
        .SAMPLES_PER_SYMBOL(16)
    ) dut (

        .clk               (clk),
        .rst               (rst),

        .preamble_detected (preamble_detected),

        .symbol_start      (symbol_start),
        .synchronized      (synchronized)

    );


    // ------------------------------------------
    // Clock
    // ------------------------------------------

    always #5 clk = ~clk;


    // ------------------------------------------
    // Test
    // ------------------------------------------

    initial begin

        clk = 0;
        rst = 1;
        preamble_detected = 0;

        // Reset
        #20;

        rst = 0;

        // --------------------------------------
        // Pretend preamble has been detected
        // --------------------------------------

        #20;

        preamble_detected = 1;

        #10;

        preamble_detected = 0;


        // --------------------------------------
        // Let synchronizer run
        // --------------------------------------

        #400;

        $finish;

    end


    // ------------------------------------------
    // Monitor
    // ------------------------------------------

    always @(posedge clk) begin

        $display(
            "TIME=%0t  PREAMBLE=%b  SYNC=%b  SYMBOL_START=%b  COUNT=%0d",
            $time,
            preamble_detected,
            synchronized,
            symbol_start,
            dut.sample_count
        );

    end

endmodule
