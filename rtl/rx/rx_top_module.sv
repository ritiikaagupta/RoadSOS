/*`timescale 1ns/1ps

module rx_top_module #(
    parameter int SAMPLES_PER_SYMBOL = 8
)(
    input  logic               clk,
    input  logic               rst,

    // ------------------------------------------------------------
    // I/Q input from RF/baseband interface
    // ------------------------------------------------------------
    input  logic signed [15:0] i_in,
    input  logic signed [15:0] q_in,
    input  logic               valid_in,

    // ------------------------------------------------------------
    // RX outputs
    // ------------------------------------------------------------
    output logic [47:0]        packet_out,
    output logic               packet_valid,

    output logic               crc_pass,
    output logic               crc_done,

    output logic [7:0]         event_id,
    output logic               emergency_alert,

    output logic               synchronized,
    output logic               preamble_detected
);

    // ============================================================
    // 1. RX INTERFACE SIGNALS
    // ============================================================

    logic signed [15:0] i_if;
    logic signed [15:0] q_if;
    logic               valid_if;


    // ============================================================
    // 2. PREAMBLE DETECTOR SIGNALS
    // ============================================================

    logic preamble_detected_int;


    // ============================================================
    // 3. SYNCHRONIZER SIGNALS
    // ============================================================

    logic symbol_start;
    logic synchronized_int;


    // ============================================================
    // 4. DECHIRPER SIGNALS
    // ============================================================

    logic signed [15:0] i_dechirped;
    logic signed [15:0] q_dechirped;
    logic               valid_dechirped;


    // ============================================================
    // 5. SYMBOL DETECTOR SIGNALS
    // ============================================================

    logic [6:0] symbol;
    logic       symbol_valid;


    // ============================================================
    // 6. PACKET DECODER SIGNALS
    // ============================================================

    logic [47:0] packet;
    logic        packet_valid_int;


    // ============================================================
    // 7. CRC CHECKER SIGNALS
    // ============================================================

    logic crc_pass_int;
    logic crc_done_int;


    // ============================================================
    // MODULE 1: RX INTERFACE
    // ============================================================

    rx_interface u_rx_interface (
        .clk       (clk),
        .rst       (rst),

        .i_in      (i_in),
        .q_in      (q_in),
        .valid_in  (valid_in),

        .i_out     (i_if),
        .q_out     (q_if),
        .valid_out (valid_if)
    );


    // ============================================================
    // MODULE 2: PREAMBLE DETECTOR
    // ============================================================

    preamble_detector u_preamble_detector (
        .clk              (clk),
        .rst              (rst),

        .i_in             (i_if),
        .q_in             (q_if),
        .valid_in         (valid_if),

        .preamble_detected(preamble_detected_int)
    );


    // ============================================================
    // MODULE 3: SYNCHRONIZER
    // ============================================================

    synchronizer #(
        .SAMPLES_PER_SYMBOL(SAMPLES_PER_SYMBOL)
    ) u_synchronizer (
        .clk              (clk),
        .rst              (rst),

        .preamble_detected(preamble_detected_int),

        .symbol_start     (symbol_start),
        .synchronized     (synchronized_int)
    );


    // ============================================================
    // MODULE 4: DECHIRPER
    // ============================================================

    dechirper u_dechirper (
        .clk       (clk),
        .rst       (rst),

        .i_in      (i_if),
        .q_in      (q_if),

        // Only process samples after synchronization
        .valid_in  (valid_if && synchronized_int),

        .i_out     (i_dechirped),
        .q_out     (q_dechirped),
        .valid_out (valid_dechirped)
    );


    // ============================================================
    // MODULE 5: SYMBOL DETECTOR
    // ============================================================

    symbol_detector u_symbol_detector (
        .clk         (clk),
        .rst         (rst),

        .i_in        (i_dechirped),
        .q_in        (q_dechirped),
        .valid_in    (valid_dechirped),

        .symbol_out  (symbol),
        .symbol_valid(symbol_valid)
    );


    // ============================================================
    // MODULE 6: PACKET DECODER
    // ============================================================

    packet_decoder u_packet_decoder (
        .clk         (clk),
        .rst         (rst),

        .symbol_in   (symbol),
        .symbol_valid(symbol_valid),

        .packet_out  (packet),
        .packet_valid(packet_valid_int)
    );


    // ============================================================
    // MODULE 7: CRC CHECKER
    // ============================================================

    crc_checker u_crc_checker (
        .clk        (clk),
        .rst        (rst),

        .packet_in  (packet),
        .packet_valid(packet_valid_int),

        .crc_pass   (crc_pass_int),
        .crc_done   (crc_done_int)
    );


    // ============================================================
    // OUTPUT ASSIGNMENTS
    // ============================================================

    assign packet_out        = packet;
    assign packet_valid      = packet_valid_int;

    assign crc_pass          = crc_pass_int;
    assign crc_done          = crc_done_int;

    assign event_id          = packet[39:32];

    assign synchronized      = synchronized_int;
    assign preamble_detected = preamble_detected_int;


    // ============================================================
    // EMERGENCY ALERT
    // ============================================================
    //
    // For the current prototype, a valid packet with a passing
    // CRC is treated as a valid emergency communication packet.
    //
    // This can later be changed to:
    //     packet[39:32] == EMERGENCY_EVENT_ID
    //
    // once the team freezes the event-ID specification.
    // ============================================================

    assign emergency_alert = packet_valid_int && crc_pass_int;

endmodule
*/
`timescale 1ns/1ps
module rx_top_module #(
    parameter int CLK_FREQ_HZ=100_000_000,
    parameter int BAUD_RATE=115_200
)(
    input logic clk, input logic rst, input logic uart_rx,
    output logic [47:0] packet_out, output logic packet_valid,
    output logic crc_pass, output logic crc_done,
    output logic [7:0] event_id, output logic [15:0] vehicle_id,
    output logic emergency_alert, output logic frame_error, output logic uart_activity
);
    logic [7:0] rx_byte, parsed_event;
    logic rx_valid, parsed_valid;
    logic [15:0] parsed_vehicle;
    logic [47:0] parsed_packet;

    uart_rx #(.CLK_FREQ_HZ(CLK_FREQ_HZ),.BAUD_RATE(BAUD_RATE)) u_uart(
        .clk(clk),.rst(rst),.rxd(uart_rx),.data_out(rx_byte),.data_valid(rx_valid)
    );
    packet_decoder u_parser(
        .clk(clk),.rst(rst),.byte_in(rx_byte),.byte_valid(rx_valid),
        .packet_out(parsed_packet),.packet_valid(parsed_valid),.event_id(parsed_event),
        .vehicle_id(parsed_vehicle),.frame_error(frame_error)
    );
    crc_checker u_crc(
        .clk(clk),.rst(rst),.packet_in(parsed_packet),.packet_valid(parsed_valid),
        .crc_pass(crc_pass),.crc_done(crc_done)
    );
    assign packet_out=parsed_packet;
    assign packet_valid=parsed_valid;
    assign event_id=parsed_event;
    assign vehicle_id=parsed_vehicle;
    assign emergency_alert=crc_done && crc_pass;
    assign uart_activity=rx_valid;
endmodule
