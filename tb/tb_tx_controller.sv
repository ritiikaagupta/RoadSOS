`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2026 10:56:53 PM
// Design Name: 
// Module Name: tb_tx_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module tb_tx_controller;

    logic clk;
    logic rst;

    logic emergency_trigger;
    logic [3:0] event_id;

    logic packet_done;
    logic crc_done;
    logic frame_done;
    logic tx_done;

    logic event_valid;
    logic packet_start;
    logic crc_start;
    logic frame_start;

    logic tx_active;
    logic busy;

    logic [3:0] event_id_out;


    // ------------------------------------------------
    // DUT
    // ------------------------------------------------

    tx_controller dut (

        .clk               (clk),
        .rst               (rst),

        .emergency_trigger (emergency_trigger),
        .event_id          (event_id),

        .packet_done       (packet_done),
        .crc_done          (crc_done),
        .frame_done        (frame_done),
        .tx_done           (tx_done),

        .event_valid       (event_valid),
        .packet_start      (packet_start),
        .crc_start         (crc_start),
        .frame_start       (frame_start),

        .tx_active         (tx_active),
        .busy              (busy),

        .event_id_out      (event_id_out)

    );


    // ------------------------------------------------
    // Clock
    // ------------------------------------------------

    always #5 clk = ~clk;


    // ------------------------------------------------
    // Test
    // ------------------------------------------------

    initial begin

        clk = 0;
        rst = 1;

        emergency_trigger = 0;
        event_id = 0;

        packet_done = 0;
        crc_done = 0;
        frame_done = 0;
        tx_done = 0;


        // Reset
        #20;

        rst = 0;


        // --------------------------------------------
        // Emergency occurs
        // --------------------------------------------

        #10;

        event_id = 4'b0011;
        emergency_trigger = 1;

        #10;

        emergency_trigger = 0;


        // --------------------------------------------
        // Packet complete
        // --------------------------------------------

        #20;

        packet_done = 1;

        #10;

        packet_done = 0;


        // --------------------------------------------
        // CRC complete
        // --------------------------------------------

        #20;

        crc_done = 1;

        #10;

        crc_done = 0;


        // --------------------------------------------
        // Frame complete
        // --------------------------------------------

        #20;

        frame_done = 1;

        #10;

        frame_done = 0;


        // --------------------------------------------
        // Transmission complete
        // --------------------------------------------

        #50;

        tx_done = 1;

        #10;

        tx_done = 0;


        #30;

        $finish;

    end


    // ------------------------------------------------
    // Monitor
    // ------------------------------------------------

    always @(posedge clk) begin

        $display(
            "TIME=%0t BUSY=%b EVENT_VALID=%b PACKET=%b CRC=%b FRAME=%b TX=%b DONE=%b",
            $time,
            busy,
            event_valid,
            packet_start,
            crc_start,
            frame_start,
            tx_active,
            tx_done
        );

    end

endmodule
