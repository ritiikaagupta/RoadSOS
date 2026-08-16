`timescale 1ns/1ps

module tb_preamble_detector;

    logic clk;
    logic rst;
    logic sample_in;
    logic valid_in;
    logic preamble_detected;

    // Instantiate the DUT (Device Under Test)
    preamble_detector dut (
        .clk               (clk),
        .rst               (rst),
        .sample_in         (sample_in),
        .valid_in          (valid_in),
        .preamble_detected (preamble_detected)
    );

    // Clock generation: 10ns period (100 MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    // Bit stream we will send, one bit per clock
    logic [11:0] test_bits = 12'b1010_1010_1100;
    integer i;

    initial begin
        // Initialize
        rst      = 1;
        valid_in = 0;
        sample_in = 0;

        // Hold reset for a couple of cycles
        @(posedge clk);
        @(posedge clk);
        rst = 0;

        // Send each bit, one per clock cycle
        for (i = 11; i >= 0; i = i - 1) begin
            @(posedge clk);
            sample_in <= test_bits[i];
            valid_in  <= 1'b1;
        end

        // Stop sending
        @(posedge clk);
        valid_in <= 1'b0;

        // Let it settle a bit
        @(posedge clk);
        @(posedge clk);

        $display("Simulation finished.");
        $stop;
    end

endmodule
