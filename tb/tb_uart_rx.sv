`timescale 1ns/1ps

module tb_uart_rx;

    localparam int CLK_FREQ_HZ = 1_000_000;
    localparam int BAUD_RATE   = 100_000;
    localparam int CLKS_PER_BIT = CLK_FREQ_HZ / BAUD_RATE;
    localparam real CLK_PERIOD_NS = 1_000_000_000.0 / CLK_FREQ_HZ;
    localparam real BIT_PERIOD_NS = CLK_PERIOD_NS * CLKS_PER_BIT;

    logic clk;
    logic rst;
    logic rxd;

    logic [7:0] data_out;
    logic       data_valid;

    int errors = 0;

    uart_rx #(
        .CLK_FREQ_HZ(CLK_FREQ_HZ),
        .BAUD_RATE  (BAUD_RATE)
    ) dut (
        .clk       (clk),
        .rst       (rst),
        .rxd       (rxd),
        .data_out  (data_out),
        .data_valid(data_valid)
    );

    always #(CLK_PERIOD_NS/2) clk = ~clk;

    task automatic send_uart_byte(input [7:0] data);
        int i;
        begin
            rxd = 1'b0;
            #(BIT_PERIOD_NS);

            for (i = 0; i < 8; i = i + 1) begin
                rxd = data[i];
                #(BIT_PERIOD_NS);
            end

            rxd = 1'b1;
            #(BIT_PERIOD_NS);
        end
    endtask

    task automatic check_byte(input [7:0] expected);
        begin
            @(posedge data_valid);
            if (data_out !== expected) begin
                $display("FAIL: expected 0x%02h, got 0x%02h at time %0t",
                          expected, data_out, $time);
                errors = errors + 1;
            end else begin
                $display("PASS: received 0x%02h correctly at time %0t",
                          data_out, $time);
            end
        end
    endtask

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        rxd = 1'b1;

        #(BIT_PERIOD_NS * 2);
        rst = 1'b0;
        #(BIT_PERIOD_NS * 2);

        fork
            send_uart_byte(8'hA5);
            check_byte(8'hA5);
        join

        #(BIT_PERIOD_NS * 2);

        fork
            send_uart_byte(8'h00);
            check_byte(8'h00);
        join

        #(BIT_PERIOD_NS * 2);

        fork
            send_uart_byte(8'hFF);
            check_byte(8'hFF);
        join

        #(BIT_PERIOD_NS * 2);

        fork
            begin
                send_uart_byte(8'h12);
                send_uart_byte(8'h34);
            end
            begin
                check_byte(8'h12);
                check_byte(8'h34);
            end
        join

        #(BIT_PERIOD_NS * 4);

        if (errors == 0)
            $display("=== ALL TESTS PASSED ===");
        else
            $display("=== %0d TEST(S) FAILED ===", errors);

        $finish;
    end

endmodule
