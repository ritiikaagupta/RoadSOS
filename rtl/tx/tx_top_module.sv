/*`timescale 1ns/1ps

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

*/

`timescale 1ns/1ps

module tx_top_module #(
    parameter int CLK_FREQ_HZ = 100_000_000,
    parameter int BAUD_RATE   = 115_200,
    parameter logic [15:0] VEHICLE_ID = 16'h0017,
    parameter int LED_HOLD_CYCLES = 50_000_000   // 0.5 sec @ 100 MHz
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

output logic led_idle,

    output logic led_emergency,
    output logic led_packet,
    output logic led_tx,
    output logic led_done
);


    // =========================================================
    // INTERNAL UART SIGNALS
    // =========================================================

    logic uart_start;
    logic uart_busy;
    logic uart_byte_done;

    logic [7:0] uart_data;

    logic packet_done;
    logic [47:0] packet_out;

    logic event_pulse;
    logic [7:0] event_latched;


    // =========================================================
    // EMERGENCY DETECTION
    // =========================================================

    emergency_input u_evt(

        .clk(clk),
        .rst(rst),

        .emergency_trigger(emergency_trigger),
        .event_id(event_id),

        .event_valid(event_pulse),
        .event_id_out(event_latched)

    );


    // =========================================================
    // PACKET GENERATION
    // =========================================================

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


    // =========================================================
    // UART TRANSMITTER
    // =========================================================

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


    // =========================================================
    // DEBUG / STATUS
    // =========================================================

    // tx_done represents completion of the COMPLETE packet.
    assign tx_done = packet_done;


    // =========================================================
    // VEHICLE ID DEBUG
    //
    // Always show the configured vehicle ID on LD0-LD15.
    //
    // Previously this was:
    //     packet_out[31:16]
    //
    // That meant LEDs stayed 0000 until the first packet.
    // =========================================================

    assign debug_vehicle_id = VEHICLE_ID;


    // =========================================================
    // 7-SEGMENT DISPLAY DECODER
    //
    // packet_out format:
    //
    // A5 | EVENT | VEH_H | VEH_L | CRC_H | CRC_L
    //      ^
    //      |
    //      packet_out[39:32]
    //
    // Active-low segments.
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


    // =========================================================
    // LED HOLD TIMERS
    //
    // event_pulse and packet_done are very short pulses.
    // We stretch them so humans can actually see the LEDs.
    //
    // 50,000,000 cycles @ 100 MHz = 0.5 second
    // =========================================================

    localparam int HOLD_CW =
        (LED_HOLD_CYCLES <= 1) ? 1 : $clog2(LED_HOLD_CYCLES + 1);

    logic [HOLD_CW-1:0] emergency_led_counter;
    logic [HOLD_CW-1:0] packet_led_counter;


    // =========================================================
    // LED HOLD LOGIC
    // =========================================================

    always_ff @(posedge clk) begin

        if (rst) begin

            emergency_led_counter <= '0;
            packet_led_counter    <= '0;

        end else begin

            // -------------------------------------------------
            // Emergency LED timer
            // -------------------------------------------------

            if (event_pulse) begin

                emergency_led_counter <= LED_HOLD_CYCLES;

            end else if (emergency_led_counter != 0) begin

                emergency_led_counter <= emergency_led_counter - 1'b1;

            end


            // -------------------------------------------------
            // Packet-done LED timer
            // -------------------------------------------------

            if (packet_done) begin

                packet_led_counter <= LED_HOLD_CYCLES;

            end else if (packet_led_counter != 0) begin

                packet_led_counter <= packet_led_counter - 1'b1;

            end

        end

    end

// =========================================================
// STATUS LED OUTPUTS
// =========================================================

// RGB0 RED
// Emergency detected
assign led_emergency = (emergency_led_counter != 0);


// RGB0 GREEN
// Packet completed
assign led_packet = (packet_led_counter != 0);


// RGB1 RED
// UART actively transmitting
assign led_tx = uart_busy;


// RGB1 GREEN
// Complete packet transmission finished
assign led_done = (packet_led_counter != 0);


// RGB1 BLUE
// TX module is idle and ready
//
// Do NOT turn BLUE on during the DONE indication.
assign led_idle = (!busy) &&
                  (packet_led_counter == 0);

endmodule






