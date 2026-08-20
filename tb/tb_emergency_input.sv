`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2026 10:25:11 PM
// Design Name: 
// Module Name: tb_emergency_input
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


module tb_emergency_input;

    logic clk;
    logic rst;

    logic emergency_trigger;
    logic [7:0] event_id;

    logic event_valid;
    logic [7:0] event_id_out;


    // DUT
    emergency_input dut (

        .clk                (clk),
        .rst                (rst),

        .emergency_trigger  (emergency_trigger),
        .event_id           (event_id),

        .event_valid        (event_valid),
        .event_id_out       (event_id_out)

    );


    // Clock: 10 ns period
    always #5 clk = ~clk;


    initial begin

        clk = 0;
        rst = 1;

        emergency_trigger = 0;
        event_id = 4'b0000;

        // Reset
        #20;

        rst = 0;


        // -----------------------------------------
        // Test 1: Sudden braking
        // Event ID = 0001
        // -----------------------------------------

        #10;

        event_id = 4'b0001;
        emergency_trigger = 1;

        #10;

        emergency_trigger = 0;


        // -----------------------------------------
        // Test 2: Vehicle breakdown
        // Event ID = 0011
        // -----------------------------------------

        #20;

        event_id = 4'b0011;
        emergency_trigger = 1;

        #10;

        emergency_trigger = 0;


        // -----------------------------------------
        // Finish
        // -----------------------------------------

        #30;

        $finish;

    end


    // Monitor
    always @(posedge clk) begin

        if (event_valid) begin

            $display(
                "TIME=%0t EVENT_VALID=%b EVENT_ID=%b",
                $time,
                event_valid,
                event_id_out
            );

        end

    end

endmodule
