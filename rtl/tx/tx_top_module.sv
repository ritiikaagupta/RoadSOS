`timescale 1ns/1ps

module tx_top_module #(
    parameter int CLK_FREQ_HZ = 100_000_000,
    parameter int BAUD_RATE = 115_200,
    parameter logic [15:0] VEHICLE_ID = 16'h0017
)
(
    input  logic clk,
    input  logic rst,

    input  logic emergency_trigger,
    input  logic [7:0] event_id,

    output logic uart_tx,

    output logic busy,
    output logic tx_done,

    output logic [7:0] debug_event_id,
    output logic [15:0] debug_vehicle_id,

    output logic led_emergency,
    output logic led_packet,
    output logic led_tx,
    output logic led_done
);


logic uart_start;
logic uart_busy;
logic uart_byte_done;

logic [7:0] uart_data;

logic packet_done;

logic [47:0] packet_out;

logic event_pulse;
logic [7:0] event_latched;



// Emergency detection

emergency_input u_evt(

    .clk(clk),
    .rst(rst),

    .emergency_trigger(emergency_trigger),
    .event_id(event_id),

    .event_valid(event_pulse),
    .event_id_out(event_latched)

);



// Packet generation

packet_generator u_pkt(

    .clk(clk),
    .rst(rst),

    .emergency_trigger(event_pulse),
    .event_id(event_latched),

    .vehicle_id(VEHICLE_ID),

    .uart_busy(uart_busy),
    .uart_done(uart_byte_done),

    .uart_start(uart_start),
    .uart_data(uart_data),

    .busy(busy),

    .packet_done(packet_done),
    .packet_out(packet_out)

);



// UART transmitter

uart_tx #(
    .CLK_FREQ_HZ(CLK_FREQ_HZ),
    .BAUD_RATE(BAUD_RATE)

)
u_uart(

    .clk(clk),
    .rst(rst),

    .tx_start(uart_start),
    .tx_data(uart_data),

    .tx(uart_tx),

    .tx_busy(uart_busy),
    .tx_done(uart_byte_done)

);



// Debug outputs

assign tx_done = packet_done;


// =========================================================
// 7-SEGMENT DISPLAY DECODER
// debug_event_id[0] -> CA
// debug_event_id[1] -> CB
// debug_event_id[2] -> CC
// debug_event_id[3] -> CD
// debug_event_id[4] -> CE
// debug_event_id[5] -> CF
// debug_event_id[6] -> CG
// debug_event_id[7] -> DP
//
// Active-low seven-segment display
// =========================================================

always_comb begin

    // Decimal point OFF
    debug_event_id[7] = 1'b1;

    case (packet_out[39:32])

        8'h00: debug_event_id[6:0] = 7'b1000000; // 0
        8'h01: debug_event_id[6:0] = 7'b1111001; // 1
        8'h02: debug_event_id[6:0] = 7'b0100100; // 2
        8'h03: debug_event_id[6:0] = 7'b0110000; // 3
        8'h04: debug_event_id[6:0] = 7'b0011001; // 4
        8'h05: debug_event_id[6:0] = 7'b0010010; // 5
        8'h06: debug_event_id[6:0] = 7'b0000010; // 6
        8'h07: debug_event_id[6:0] = 7'b1111000; // 7
        8'h08: debug_event_id[6:0] = 7'b0000000; // 8
        8'h09: debug_event_id[6:0] = 7'b0010000; // 9

        8'h0A: debug_event_id[6:0] = 7'b0001000; // A
        8'h0B: debug_event_id[6:0] = 7'b0000011; // b
        8'h0C: debug_event_id[6:0] = 7'b1000110; // C
        8'h0D: debug_event_id[6:0] = 7'b0100001; // d
        8'h0E: debug_event_id[6:0] = 7'b0000110; // E
        8'h0F: debug_event_id[6:0] = 7'b0001110; // F

        default:
            debug_event_id[6:0] = 7'b1111111; // blank

    endcase
end


assign debug_vehicle_id =
packet_out[31:16];



// Status LEDs

assign led_emergency = event_pulse;

assign led_packet = packet_done;

assign led_tx = uart_busy;

assign led_done = tx_done;



endmodule
