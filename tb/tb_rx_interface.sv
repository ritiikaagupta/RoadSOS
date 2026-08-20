`timescale 1ns/1ps

module tb_rx_interface;

    // Inputs
    logic clk;
    logic rst;
    logic signed [15:0] i_in;
    logic signed [15:0] q_in;
    logic valid_in;

    // Outputs
    logic signed [15:0] i_out;
    logic signed [15:0] q_out;
    logic valid_out;

    // DUT
    rx_interface dut (
        .clk       (clk),
        .rst       (rst),
        .i_in      (i_in),
        .q_in      (q_in),
        .valid_in  (valid_in),
        .i_out     (i_out),
        .q_out     (q_out),
        .valid_out (valid_out)
    );

    // 100 MHz clock
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // Test
    initial begin

        $display("======================================");
        $display("   RoadSOS RX INTERFACE TESTBENCH");
        $display("======================================");

        // Initial values
        rst      = 1'b1;
        i_in     = 16'sd0;
        q_in     = 16'sd0;
        valid_in = 1'b0;

        // Reset
        repeat (2) @(posedge clk);
        rst = 1'b0;

        // -----------------------------
        // TEST 1
        // -----------------------------
        $display("\nTEST 1: I/Q sample transfer");

        @(posedge clk);
        i_in     <= 16'sd1000;
        q_in     <= 16'sd500;
        valid_in <= 1'b1;

        @(posedge clk);
        #1;

        if (i_out == 16'sd1000 &&
            q_out == 16'sd500 &&
            valid_out == 1'b1)
            $display("PASS: I=1000 Q=500");
        else
            $display("FAIL: I=%0d Q=%0d VALID=%b",
                     i_out, q_out, valid_out);

        // -----------------------------
        // TEST 2
        // -----------------------------
        $display("\nTEST 2: Negative I/Q values");

        @(posedge clk);
        i_in     <= -16'sd700;
        q_in     <= 16'sd300;
        valid_in <= 1'b1;

        @(posedge clk);
        #1;

        if (i_out == -16'sd700 &&
            q_out == 16'sd300 &&
            valid_out == 1'b1)
            $display("PASS: I=-700 Q=300");
        else
            $display("FAIL: I=%0d Q=%0d VALID=%b",
                     i_out, q_out, valid_out);

        // -----------------------------
        // TEST 3
        // -----------------------------
        $display("\nTEST 3: valid_in = 0");

        @(posedge clk);
        i_in     <= 16'sd200;
        q_in     <= 16'sd100;
        valid_in <= 1'b0;

        @(posedge clk);
        #1;

        if (valid_out == 1'b0)
            $display("PASS: valid_out = 0");
        else
            $display("FAIL: valid_out = %b", valid_out);

        // -----------------------------
        // TEST 4
        // -----------------------------
        $display("\nTEST 4: Reset");

        rst = 1'b1;

        @(posedge clk);
        #1;

        if (i_out == 0 &&
            q_out == 0 &&
            valid_out == 1'b0)
            $display("PASS: Reset successful");
        else
            $display("FAIL: Reset unsuccessful");

        rst = 1'b0;

        // Finish
        repeat (2) @(posedge clk);

        $display("\n======================================");
        $display("       TESTBENCH COMPLETE");
        $display("======================================");

        $finish;
    end

endmodule
