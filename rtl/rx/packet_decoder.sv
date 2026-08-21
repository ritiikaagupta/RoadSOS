`timescale 1ns/1ps

module tb_packet_decoder;

    logic clk, rst;
    logic [2:0] symbol_in;
    logic symbol_valid;
    logic [23:0] packet_out;
    logic packet_valid;

    packet_decoder dut (
        .clk(clk), .rst(rst),
        .symbol_in(symbol_in), .symbol_valid(symbol_valid),
        .packet_out(packet_out), .packet_valid(packet_valid)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    // 8 symbols, 3 bits each -> expect packet_out = 011_010_101_110_001_100_111_000
    logic [2:0] test_symbols [0:7];
    integer k;

    initial begin
        test_symbols[0] = 3'b011;
        test_symbols[1] = 3'b010;
        test_symbols[2] = 3'b101;
        test_symbols[3] = 3'b110;
        test_symbols[4] = 3'b001;
        test_symbols[5] = 3'b100;
        test_symbols[6] = 3'b111;
        test_symbols[7] = 3'b000;

        rst = 1;
        symbol_in = 0;
        symbol_valid = 0;

        @(posedge clk);
        @(posedge clk);
        rst = 0;

        for (k = 0; k < 8; k = k + 1) begin
            @(posedge clk);
            symbol_in    <= test_symbols[k];
            symbol_valid <= 1'b1;
        end

        @(posedge clk);
        symbol_valid <= 1'b0;

        @(posedge clk);
        @(posedge clk);

        $display("Simulation finished.");
        $stop;
    end

endmodule
