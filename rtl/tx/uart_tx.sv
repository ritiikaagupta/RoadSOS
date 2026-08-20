`timescale 1ns/1ps

// UART transmitter: 100 MHz clock, 115200 baud, 8-N-1.
//
// Interface:
//   tx_start : pulse for one clock when tx_data should be sent.
//   tx_data  : byte to transmit.
//   tx_busy  : high while the byte is being transmitted.
//   tx       : UART serial output, idle high.
//
// One byte is transmitted as:
//   1 start bit (0) + 8 data bits, LSB first + 1 stop bit (1).
//
// For 100 MHz / 115200 baud:
//   100,000,000 / 115,200 = 868.0556
// We use 868 clocks/bit here. Baud error is about -0.0064%.

module uart_tx #(
    parameter int CLK_FREQ_HZ = 100_000_000,
    parameter int BAUD_RATE   = 115_200
)(
    input  logic       clk,
    input  logic       rst,

    input  logic       tx_start,
    input  logic [7:0] tx_data,

    output logic       tx,
    output logic       tx_busy
);

    localparam int CLKS_PER_BIT = CLK_FREQ_HZ / BAUD_RATE;
    localparam int COUNT_WIDTH  = (CLKS_PER_BIT <= 2) ? 1 : $clog2(CLKS_PER_BIT);

    logic [COUNT_WIDTH-1:0] clk_count;
    logic [3:0]             bit_count;
    logic [9:0]             tx_shift;

    always_ff @(posedge clk) begin
        if (rst) begin
            tx        <= 1'b1;
            tx_busy   <= 1'b0;
            clk_count <= '0;
            bit_count <= '0;
            tx_shift  <= 10'b1111111111;
        end else begin

            if (!tx_busy) begin
                tx        <= 1'b1;
                clk_count <= '0;
                bit_count <= '0;

                if (tx_start) begin
                    // {stop, data[7:0], start}
                    tx_shift  <= {1'b1, tx_data, 1'b0};
                    tx_busy   <= 1'b1;
                    tx        <= 1'b0; // start bit begins immediately
                end

            end else begin

                if (clk_count == CLKS_PER_BIT-1) begin
                    clk_count <= '0;

                    if (bit_count == 4'd9) begin
                        // Last bit (stop bit) has completed.
                        tx_busy   <= 1'b0;
                        bit_count <= '0;
                        tx        <= 1'b1;
                    end else begin
                        bit_count <= bit_count + 1'b1;
                        tx_shift  <= {1'b1, tx_shift[9:1]};
                        tx        <= tx_shift[1];
                    end

                end else begin
                    clk_count <= clk_count + 1'b1;
                end
            end
        end
    end

endmodule
