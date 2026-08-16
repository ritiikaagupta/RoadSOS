`timescale 1ns/1ps

module tb_symbol_detector;

    logic clk, rst;
    logic signed [15:0] i_in, q_in;
    logic valid_in;
    logic [2:0] symbol_out;
    logic symbol_valid;

    symbol_detector dut (
        .clk(clk), .rst(rst),
        .i_in(i_in), .q_in(q_in), .valid_in(valid_in),
        .symbol_out(symbol_out), .symbol_valid(symbol_valid)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    logic signed [15:0] test_i [0:7];
    logic signed [15:0] test_q [0:7];
    integer k;

    initial begin
        test_i[0]=16'sd10; test_q[0]=16'sd10;
        test_i[1]=16'sd20; test_q[1]=16'sd10;
        test_i[2]=16'sd15; test_q[2]=16'sd5;
        test_i[3]=16'sd90; test_q[3]=16'sd90;   // strongest -> expect symbol_out = 3
        test_i[4]=16'sd5;  test_q[4]=16'sd5;
        test_i[5]=16'sd10; test_q[5]=16'sd0;
        test_i[6]=16'sd0;  test_q[6]=16'sd10;
        test_i[7]=16'sd20; test_q[7]=16'sd20;

        rst = 1;
        valid_in = 0;
        i_in = 0;
        q_in = 0;

        @(posedge clk);
        @(posedge clk);
        rst = 0;

        for (k = 0; k < 8; k = k + 1) begin
            @(posedge clk);
            i_in     <= test_i[k];
            q_in     <= test_q[k];
            valid_in <= 1'b1;
        end

        @(posedge clk);
        valid_in <= 1'b0;

        @(posedge clk);
        @(posedge clk);
        @(posedge clk);

        $display("Simulation finished.");
        $stop;
    end

endmodule
