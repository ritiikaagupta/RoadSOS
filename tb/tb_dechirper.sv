`timescale 1ns/1ps

module tb_dechirper;

    logic clk, rst;
    logic signed [15:0] i_in, q_in;
    logic valid_in;
    logic signed [15:0] i_out, q_out;
    logic valid_out;

    dechirper dut (
        .clk(clk), .rst(rst),
        .i_in(i_in), .q_in(q_in), .valid_in(valid_in),
        .i_out(i_out), .q_out(q_out), .valid_out(valid_out)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    integer k;

    initial begin
        rst = 1;
        valid_in = 0;
        i_in = 0;
        q_in = 0;

        @(posedge clk);
        @(posedge clk);
        rst = 0;

        // Send 8 sample I/Q pairs, one per clock
        for (k = 0; k < 8; k = k + 1) begin
            @(posedge clk);
            i_in     <= 16'sd100;
            q_in     <= 16'sd0;
            valid_in <= 1'b1;
        end

        @(posedge clk);
        valid_in <= 1'b0;

        @(posedge clk);
        @(posedge clk);

        $display("Simulation finished.");
        $stop;
    end

endmodule
