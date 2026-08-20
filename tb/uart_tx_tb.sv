`timescale 1ns/1ps

module uart_tx_tb;

    localparam int CLK_FREQ_HZ = 100_000_000;
    localparam int BAUD_RATE   = 115_200;
    localparam time CLK_PERIOD = 10ns;
    localparam int CLKS_PER_BIT = CLK_FREQ_HZ / BAUD_RATE;

    logic clk = 1'b0;
    logic rst = 1'b1;
    logic tx_start = 1'b0;
    logic [7:0] tx_data = 8'h00;

    logic tx;
    logic tx_busy;

    uart_tx #(
        .CLK_FREQ_HZ(CLK_FREQ_HZ),
        .BAUD_RATE  (BAUD_RATE)
    ) dut (
        .clk      (clk),
        .rst      (rst),
        .tx_start (tx_start),
        .tx_data  (tx_data),
        .tx       (tx),
        .tx_busy  (tx_busy)
    );

    always #(CLK_PERIOD/2) clk = ~clk;

    task automatic send_byte(input logic [7:0] b);
        begin
            @(posedge clk);
            while (tx_busy) @(posedge clk);

            tx_data  <= b;
            tx_start <= 1'b1;

            @(posedge clk);
            tx_start <= 1'b0;

            wait (!tx_busy);
            // Give the UART one idle clock before the next byte.
            @(posedge clk);
        end
    endtask

    task automatic check_byte(input logic [7:0] expected);
        integer i;
        logic [7:0] received;

        begin
            // Wait for start bit.
            @(negedge tx);
            // Sample the middle of each data bit.
            #(CLK_PERIOD * CLKS_PER_BIT * 1.5);

            received = 8'h00;

            for (i = 0; i < 8; i = i + 1) begin
                received[i] = tx;
                #(CLK_PERIOD * CLKS_PER_BIT);
            end

            // We should now be in the stop bit.
            if (tx !== 1'b1) begin
                $error("STOP BIT ERROR: tx=%b", tx);
            end

            if (received !== expected) begin
                $error("UART DATA ERROR: expected=0x%02h received=0x%02h",
                       expected, received);
            end else begin
                $display("UART OK: 0x%02h (%c)", received, received);
            end
        end
    endtask

    // Simple monitor for the test message.
    // The stimulus and checking are separated so that the waveform can
    // also be inspected in Vivado/your simulator.
    initial begin
        $dumpfile("uart_tx_tb.vcd");
        $dumpvars(0, uart_tx_tb);

        #200;
        rst = 1'b0;

        // Send H, E, L, L, O, CR, LF.
        send_byte("H");
        send_byte("E");
        send_byte("L");
        send_byte("L");
        send_byte("O");
        send_byte(8'h0D);
        send_byte(8'h0A);

        #1000;
        $display("UART TX simulation completed.");
        $finish;
    end

endmodule
