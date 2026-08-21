`timescale 1ns/1ps

module rx_top_module #(
    parameter int CLK_FREQ_HZ = 100_000_000,
    parameter int BAUD_RATE   = 115_200,

    // ---------------------------------------------------------
    // LED indication duration
    // 100 MHz × 0.5 sec = 50,000,000 cycles
    // ---------------------------------------------------------
    parameter int LED_HOLD_CYCLES = 50_000_000
)(
    input  logic clk,
    input  logic rst,
    input  logic uart_rx,

    // =========================================================
    // ORIGINAL RX STATUS OUTPUTS
    // =========================================================

    output logic packet_valid,
    output logic crc_pass,
    output logic crc_done,
    output logic emergency_alert,

    // =========================================================
    // PHYSICAL LED OUTPUTS
    // =========================================================

    output logic led_packet,
    output logic led_crc_pass,
    output logic led_crc_fail,
    output logic led_emergency
);


    // =========================================================
    // UART RECEIVER
    // =========================================================

    logic [7:0] rx_byte;
    logic       rx_valid;


    // =========================================================
    // PACKET DECODER
    // =========================================================

    logic [47:0] parsed_packet;
    logic        parsed_valid;

    logic [7:0]  parsed_event;
    logic [15:0] parsed_vehicle;

    logic        frame_error;


    // =========================================================
    // CRC CHECKER
    // =========================================================

    logic crc_pass_int;
    logic crc_done_int;


    // =========================================================
    // UART RX
    // =========================================================

    uart_rx #(
        .CLK_FREQ_HZ (CLK_FREQ_HZ),
        .BAUD_RATE   (BAUD_RATE)
    ) u_uart (
        .clk        (clk),
        .rst        (rst),
        .rxd        (uart_rx),
        .data_out   (rx_byte),
        .data_valid (rx_valid)
    );


    // =========================================================
    // PACKET DECODER
    // =========================================================

    packet_decoder u_parser (
        .clk          (clk),
        .rst          (rst),

        .byte_in      (rx_byte),
        .byte_valid   (rx_valid),

        .packet_out   (parsed_packet),
        .packet_valid (parsed_valid),

        .event_id     (parsed_event),
        .vehicle_id   (parsed_vehicle),

        .frame_error  (frame_error)
    );


    // =========================================================
    // CRC CHECKER
    // =========================================================

    crc_checker u_crc (
        .clk          (clk),
        .rst          (rst),

        .packet_in    (parsed_packet),
        .packet_valid (parsed_valid),

        .crc_pass     (crc_pass_int),
        .crc_done     (crc_done_int)
    );


    // =========================================================
    // ORIGINAL FUNCTIONAL OUTPUTS
    //
    // These remain the actual internal status signals.
    // =========================================================

    assign packet_valid   = parsed_valid;
    assign crc_pass       = crc_pass_int;
    assign crc_done       = crc_done_int;

    assign emergency_alert =
        crc_done_int && crc_pass_int;


    // =========================================================
    // LED COUNTERS
    // =========================================================

    logic [31:0] packet_led_counter;
    logic [31:0] crc_pass_led_counter;
    logic [31:0] crc_fail_led_counter;
    logic [31:0] emergency_led_counter;


    // =========================================================
    // RX PHYSICAL LED STATUS LOGIC
    //
    // led_packet:
    //     Complete packet detected.
    //
    // led_crc_pass:
    //     CRC verification successful.
    //
    // led_crc_fail:
    //     CRC verification failed.
    //
    // led_emergency:
    //     Valid emergency packet received.
    //
    // LEDs remain visible for LED_HOLD_CYCLES.
    // =========================================================

    always_ff @(posedge clk) begin

        // =====================================================
        // RESET
        // =====================================================

        if (rst) begin

            packet_led_counter      <= 32'd0;
            crc_pass_led_counter    <= 32'd0;
            crc_fail_led_counter    <= 32'd0;
            emergency_led_counter   <= 32'd0;

            led_packet              <= 1'b0;
            led_crc_pass            <= 1'b0;
            led_crc_fail            <= 1'b0;
            led_emergency           <= 1'b0;

        end

        else begin

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
            // CRC PASS LED TIMER
            // =================================================

            if (crc_pass_led_counter != 0) begin

                crc_pass_led_counter <=
                    crc_pass_led_counter - 1'b1;

            end

            else begin

                led_crc_pass <= 1'b0;

            end


            // =================================================
            // CRC FAIL LED TIMER
            // =================================================

            if (crc_fail_led_counter != 0) begin

                crc_fail_led_counter <=
                    crc_fail_led_counter - 1'b1;

            end

            else begin

                led_crc_fail <= 1'b0;

            end


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
            // COMPLETE PACKET RECEIVED
            // =================================================

            if (parsed_valid) begin

                led_packet <= 1'b1;

                packet_led_counter <=
                    LED_HOLD_CYCLES;

            end


            // =================================================
            // CRC VERIFICATION COMPLETE
            // =================================================

            if (crc_done_int) begin

                if (crc_pass_int) begin

                    // -------------------------------
                    // CRC PASSED
                    // -------------------------------

                    led_crc_pass <= 1'b1;

                    crc_pass_led_counter <=
                        LED_HOLD_CYCLES;

                end

                else begin

                    // -------------------------------
                    // CRC FAILED
                    // -------------------------------

                    led_crc_fail <= 1'b1;

                    crc_fail_led_counter <=
                        LED_HOLD_CYCLES;

                end

            end


            // =================================================
            // VALID EMERGENCY PACKET
            //
            // CRC passed + packet successfully received
            // =================================================

            if (crc_done_int && crc_pass_int) begin

                led_emergency <= 1'b1;

                emergency_led_counter <=
                    LED_HOLD_CYCLES;

            end

        end

    end

endmodule
