/*`timescale 1ns/1ps

module uart_rx #(
    parameter int CLK_FREQ_HZ = 100_000_000,
    parameter int BAUD_RATE   = 115_200
)(
    input  logic clk,
    input  logic rst,

    input  logic       rxd,
    output logic [7:0] data_out,
    output logic       data_valid
);

    localparam int CLKS_PER_BIT      = CLK_FREQ_HZ / BAUD_RATE;
    localparam int CLKS_PER_HALF_BIT = CLKS_PER_BIT / 2;
    localparam int CNT_WIDTH         = $clog2(CLKS_PER_BIT + 1);

    typedef enum logic [2:0] {
        RX_IDLE,
        RX_START_BIT,
        RX_DATA_BITS,
        RX_STOP_BIT,
        RX_CLEANUP
    } rx_state_t;

    rx_state_t state;

    logic rxd_meta, rxd_sync;

    always_ff @(posedge clk) begin
        if (rst) begin
            rxd_meta <= 1'b1;
            rxd_sync <= 1'b1;
        end else begin
            rxd_meta <= rxd;
            rxd_sync <= rxd_meta;
        end
    end

    logic [CNT_WIDTH-1:0] clk_count;
    logic [2:0]           bit_index;
    logic [7:0]           rx_byte;

    always_ff @(posedge clk) begin
        if (rst) begin
            state      <= RX_IDLE;
            clk_count  <= '0;
            bit_index  <= 3'd0;
            rx_byte    <= 8'd0;
            data_out   <= 8'd0;
            data_valid <= 1'b0;
        end else begin

            data_valid <= 1'b0;

            case (state)

                RX_IDLE: begin
                    clk_count <= '0;
                    bit_index <= 3'd0;

                    if (rxd_sync == 1'b0)
                        state <= RX_START_BIT;
                end

                RX_START_BIT: begin
                    if (clk_count == CLKS_PER_HALF_BIT - 1) begin
                        if (rxd_sync == 1'b0) begin
                            clk_count <= '0;
                            state     <= RX_DATA_BITS;
                        end else begin
                            state <= RX_IDLE;
                        end
                    end else begin
                        clk_count <= clk_count + 1'b1;
                    end
                end

                RX_DATA_BITS: begin
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1'b1;
                    end else begin
                        clk_count           <= '0;
                        rx_byte[bit_index]  <= rxd_sync;

                        if (bit_index < 3'd7) begin
                            bit_index <= bit_index + 1'b1;
                        end else begin
                            bit_index <= 3'd0;
                            state     <= RX_STOP_BIT;
                        end
                    end
                end

                RX_STOP_BIT: begin
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1'b1;
                    end else begin
                        data_out   <= rx_byte;
                        data_valid <= 1'b1;
                        clk_count  <= '0;
                        state      <= RX_CLEANUP;
                    end
                end

                RX_CLEANUP: begin
                    state <= RX_IDLE;
                end

                default: state <= RX_IDLE;

            endcase
        end
    end

endmodule

*/
`timescale 1ns/1ps
module uart_rx #(
    parameter int CLK_FREQ_HZ=100_000_000,
    parameter int BAUD_RATE=115_200
)(
    input logic clk, input logic rst, input logic rxd,
    output logic [7:0] data_out, output logic data_valid
);
    localparam int CPB=CLK_FREQ_HZ/BAUD_RATE;
    localparam int CW=(CPB<2)?1:$clog2(CPB);
    typedef enum logic [1:0] {IDLE,START,DATA,STOP} st_t;
    st_t st;
    logic rmeta, rsync;
    logic [CW-1:0] cnt;
    logic [2:0] bit_idx;
    logic [7:0] shift;
    always_ff @(posedge clk) begin
        if (rst) begin rmeta<=1'b1; rsync<=1'b1; end
        else begin rmeta<=rxd; rsync<=rmeta; end
    end
    always_ff @(posedge clk) begin
        if (rst) begin
            st<=IDLE; cnt<='0; bit_idx<='0; shift<='0; data_out<='0; data_valid<=1'b0;
        end else begin
            data_valid<=1'b0;
            case(st)
                IDLE: if(!rsync) begin cnt<='0; st<=START; end
                START: if(cnt==CPB/2-1) begin cnt<='0; if(!rsync) st<=DATA; else st<=IDLE; end else cnt<=cnt+1'b1;
                DATA: if(cnt==CPB-1) begin cnt<='0; shift[bit_idx]<=rsync; if(bit_idx==3'd7) begin bit_idx<='0; st<=STOP; end else bit_idx<=bit_idx+1'b1; end else cnt<=cnt+1'b1;
                STOP: if(cnt==CPB-1) begin cnt<='0; data_out<=shift; data_valid<=1'b1; st<=IDLE; end else cnt<=cnt+1'b1;
                default: st<=IDLE;
            endcase
        end
    end
endmodule

