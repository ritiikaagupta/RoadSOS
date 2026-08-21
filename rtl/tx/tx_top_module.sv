`timescale 1ns/1ps

module tx_top_module #(
    parameter int CLK_FREQ_HZ = 100_000_000,
    parameter int BAUD_RATE   = 115_200,

    parameter logic [15:0] VEHICLE_ID = 16'h0017,

    // ---------------------------------------------------------
    // LED indication duration
    // 100 MHz × 0.5 sec = 50,000,000 cycles
    // ---------------------------------------------------------
    parameter int LED_HOLD_CYCLES = 50_000_000
)(
    input  logic        clk,
    input  logic        rst,

    // ---------------------------------------------------------
    // Emergency input
    // ---------------------------------------------------------
    input  logic        emergency_trigger,

    // ---------------------------------------------------------
    // Event ID from switches
    // ---------------------------------------------------------
    input  logic [7:0]  event_id,

    // ---------------------------------------------------------
    // UART
    // ---------------------------------------------------------
    output logic        uart_tx,

    // ---------------------------------------------------------
    // Main status outputs
    // ---------------------------------------------------------
    output logic        busy,
    output logic        tx_done,

    // ---------------------------------------------------------
    // Debug outputs
    // ---------------------------------------------------------
    output logic [7:0]  debug_event_id,
    output logic [15:0] debug_vehicle_id,

    // ---------------------------------------------------------
    // Status LEDs / RGB channels
    // ---------------------------------------------------------
    output logic        led_emergency,
    output logic        led_packet,
    output logic        led_tx,
    output logic        led_done
);


    // =========================================================
    // INTERNAL SIGNALS
    // =========================================================

    logic       uart_start;
    logic       uart_busy;
    logic       uart_byte_done;

    logic [7:0] uart_data;

    logic       packet_done;
    logic [47:0] packet_out;

    logic       event_pulse;
    logic [7:0] event_latched;


    // =========================================================
    // EMERGENCY INPUT MODULE
    // =========================================================

    emergency_input u_evt (
        .clk               (clk),
        .rst               (rst),
        .emergency_trigger (emergency_trigger),
        .event_id          (event_id),
        .event_valid       (event_pulse),
        .event_id_out      (event_latched)
    );


    // =========================================================
    // PACKET GENERATOR
    // =========================================================

    packet_generator u_pkt (
        .clk              (clk),
        .rst              (rst),

        .emergency_trigger(event_pulse),
        .event_id         (event_latched),
        .vehicle_id       (VEHICLE_ID),

        .uart_busy        (uart_busy),
        .uart_done        (uart_byte_done),

        .uart_start       (uart_start),
        .uart_data        (uart_data),

        .busy             (busy),
        .packet_done      (packet_done),
        .packet_out       (packet_out)
    );


    // =========================================================
    // UART TRANSMITTER
    // =========================================================

    uart_tx #(
        .CLK_FREQ_HZ (CLK_FREQ_HZ),
        .BAUD_RATE   (BAUD_RATE)
    ) u_uart (
        .clk       (clk),
        .rst       (rst),

        .tx_start  (uart_start),
        .tx_data   (uart_data),

        .tx        (uart_tx),
        .tx_busy   (uart_busy),
        .tx_done   (uart_byte_done)
    );


    // =========================================================
    // DEBUG OUTPUTS
    // =========================================================

    assign tx_done = packet_done;

    // Event ID from generated packet
    assign debug_event_id = packet_out[39:32];

    // Vehicle ID from generated packet
    assign debug_vehicle_id = packet_out[31:16];


    // =========================================================
    // LED COUNTERS
    // =========================================================

    logic [31:0] emergency_led_counter;
    logic [31:0] packet_led_counter;
    logic [31:0] done_led_counter;


    // =========================================================
    // STATUS LED LOGIC
    // =========================================================
    //
    // led_emergency:
    //     ON for LED_HOLD_CYCLES when an emergency event occurs.
    //
    // led_packet:
    //     ON for LED_HOLD_CYCLES when packet processing begins.
    //
    // led_tx:
    //     ON while UART is actively transmitting.
    //
    // led_done:
    //     ON for LED_HOLD_CYCLES when packet transmission finishes.
    //
    // =========================================================

    always_ff @(posedge clk) begin

        // -----------------------------------------------------
        // RESET
        // -----------------------------------------------------

        if (rst) begin

            emergency_led_counter <= 32'd0;
            packet_led_counter    <= 32'd0;
            done_led_counter      <= 32'd0;

            led_emergency <= 1'b0;
            led_packet    <= 1'b0;
            led_tx        <= 1'b0;
            led_done      <= 1'b0;

        end

        else begin

            // =================================================
            // EMERGENCY LED TIMER
            // =================================================

            if (emergency_led_counter != 0) begin

                emergency_led_counter <=
                    emergency_led_counter - 1'b1;

            end

            else begin

                led_emergency <= 1'b0;

            end


            // =================================================
            // PACKET LED TIMER
            // =================================================

            if (packet_led_counter != 0) begin

                packet_led_counter <=
                    packet_led_counter - 1'b1;

            end

            else begin

                led_packet <= 1'b0;

            end


            // =================================================
            // DONE LED TIMER
            // =================================================

            if (done_led_counter != 0) begin

                done_led_counter <=
                    done_led_counter - 1'b1;

            end

            else begin

                led_done <= 1'b0;

            end


            // =================================================
            // EMERGENCY DETECTED
            // =================================================

            if (event_pulse) begin

                led_emergency <= 1'b1;

                emergency_led_counter <=
                    LED_HOLD_CYCLES;


                // Packet generation begins
                led_packet <= 1'b1;

                packet_led_counter <=
                    LED_HOLD_CYCLES;

            end


            // =================================================
            // UART TRANSMISSION
            // =================================================

            if (uart_busy) begin

                led_tx <= 1'b1;

            end

            else begin

                led_tx <= 1'b0;

            end


            // =================================================
            // TRANSMISSION COMPLETE
            // =================================================

            if (packet_done) begin

                led_done <= 1'b1;

                done_led_counter <=
                    LED_HOLD_CYCLES;

            end

        end

    end

endmodule
