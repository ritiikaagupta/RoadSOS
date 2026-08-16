`timescale 1ns/1ps

module tb_crc_checker;

    logic clk, rst;
    logic [23:0] packet_in;
    logic packet_valid;
    logic [7:0] crc_expected;
    logic crc_pass, crc_done;

    crc_checker dut (
        .clk(clk), .rst(rst),
        .packet_in(packet_in), .packet_valid(packet_valid),
        .crc_expected(crc_expected),
        .crc_pass(crc_pass), .crc_done(crc_done)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 1;
        packet_in = 24'd0;
        packet_valid = 0;
        crc_expected = 8'd0;

        @(posedge clk);
        @(posedge clk);
        rst = 0;

        // Test case 1: packet = 0xAA_BB_CC, XOR = 0x55 -> expect PASS
        @(posedge clk);
        packet_in     <= 24'hAABBCC;
        crc_expected  <= 8'h55;
        packet_valid  <= 1'b1;

        @(posedge clk);
        packet_valid <= 1'b0;

        @(posedge clk);
        @(posedge clk);

        // Test case 2: wrong CRC -> expect FAIL
        @(posedge clk);
        packet_in     <= 24'hAABBCC;
        crc_expected  <= 8'h00;
        packet_valid  <= 1'b1;

        @(posedge clk);
        packet_valid <= 1'b0;

        @(posedge clk);
        @(posedge clk);

        $display("Simulation finished.");
        $stop;
    end

endmodule
