/*
`timescale 1ns/1ps

module tx_top_module_tb;

    // ============================================================
    // PARAMETERS
    // ============================================================

    localparam int OUTPUT_WIDTH = 16;


    // ============================================================
    // CLOCK / RESET
    // ============================================================

    logic clk;
    logic rst;


    // ============================================================
    // TX INPUTS
    // ============================================================

    logic       emergency_trigger;
    logic [7:0] event_id;


    // ============================================================
    // TX OUTPUTS
    // ============================================================

    logic signed [OUTPUT_WIDTH-1:0] i_out;
    logic signed [OUTPUT_WIDTH-1:0] q_out;

    logic tx_valid;
    logic busy;
    logic tx_done;


    // ============================================================
    // DUT
    // ============================================================

    tx_top_module #(
        .HEADER                  (8'hA5),
        .VEHICLE_ID              (16'h0001),

        .PHASE_WIDTH             (32),
        .OUTPUT_WIDTH            (OUTPUT_WIDTH),

        .BASE_PHASE_INCREMENT    (32'd1000000),
        .SYMBOL_PHASE_STEP       (32'd10000)
    ) dut (

        .clk                (clk),
        .rst                (rst),

        .emergency_trigger  (emergency_trigger),
        .event_id           (event_id),

        .busy               (busy),
        .tx_done            (tx_done),

        .i_out              (i_out),
        .q_out              (q_out),
        .tx_valid           (tx_valid)
    );


    // ============================================================
    // 100 MHz CLOCK
    // Period = 10 ns
    // ============================================================

    initial begin

        clk = 1'b0;

        forever #5 clk = ~clk;

    end


    // ============================================================
    // RESET TASK
    // ============================================================

    task reset_dut;

        begin

            rst = 1'b1;

            emergency_trigger = 1'b0;
            event_id          = 8'h00;

            repeat (5)
                @(posedge clk);

            rst = 1'b0;

            repeat (2)
                @(posedge clk);

        end

    endtask


    // ============================================================
    // SEND EMERGENCY EVENT
    // ============================================================

    task send_emergency;

        input [7:0] event_code;

        begin

            @(posedge clk);

            event_id          <= event_code;
            emergency_trigger <= 1'b1;

            @(posedge clk);

            emergency_trigger <= 1'b0;

            $display(
                "[%0t] Emergency event triggered: EVENT_ID = 0x%02h",
                $time,
                event_code
            );

        end

    endtask


    // ============================================================
    // MONITOR TX OUTPUT
    // ============================================================

    always @(posedge clk) begin

        if (tx_valid) begin

            $display(
                "[%0t] TX SAMPLE | I = %0d | Q = %0d",
                $time,
                i_out,
                q_out
            );

        end


        if (busy) begin

            $display(
                "[%0t] TX BUSY",
                $time
            );

        end


        if (tx_done) begin

            $display(
                "[%0t] TX DONE",
                $time
            );

        end

    end


    // ============================================================
    // MAIN TEST
    // ============================================================

    initial begin

        $display("");
        $display("================================================");
        $display("       RoadSOS TX TOP MODULE TESTBENCH");
        $display("================================================");
        $display("");


        // --------------------------------------------------------
        // INITIAL VALUES
        // --------------------------------------------------------

        clk = 1'b0;

        rst = 1'b0;

        emergency_trigger = 1'b0;

        event_id = 8'h00;


        // --------------------------------------------------------
        // TEST 1: RESET
        // --------------------------------------------------------

        $display("");
        $display("TEST 1: RESET");
        $display("");

        reset_dut;

        $display("Reset completed.");


        // --------------------------------------------------------
        // TEST 2: SEND EVENT
        // --------------------------------------------------------

        $display("");
        $display("TEST 2: EMERGENCY EVENT");
        $display("");

        send_emergency(8'h01);


        // --------------------------------------------------------
        // WAIT FOR TRANSMISSION
        // --------------------------------------------------------

        wait (busy == 1'b1);

        $display(
            "[%0t] Transmission started.",
            $time
        );


        // --------------------------------------------------------
        // WAIT FOR TX DONE
        // --------------------------------------------------------

        wait (tx_done == 1'b1);

        $display(
            "[%0t] Transmission completed.",
            $time
        );


        // --------------------------------------------------------
        // TEST 3: SECOND EVENT
        // --------------------------------------------------------

        repeat (5)
            @(posedge clk);

        $display("");
        $display("TEST 3: SECOND EMERGENCY EVENT");
        $display("");

        send_emergency(8'h02);

        wait (busy == 1'b1);

        wait (tx_done == 1'b1);

        $display(
            "[%0t] Second transmission completed.",
            $time
        );


        // --------------------------------------------------------
        // FINISH
        // --------------------------------------------------------

        repeat (10)
            @(posedge clk);

        $display("");
        $display("================================================");
        $display("             TX TESTBENCH COMPLETE");
        $display("================================================");
        $display("");

        $finish;

    end


    // ============================================================
    // TIMEOUT
    // ============================================================

    initial begin

        #200000;

        $display("");
        $display("ERROR: Simulation timeout!");
        $display("");

        $finish;

    end

endmodule
*/
`timescale 1ns/1ps
module tb_tx_top_module;
    logic clk=0,rst=1,trigger=0; logic [7:0] event_id=8'h01;
    logic uart_tx,busy,tx_done; logic [7:0] debug_event_id; logic [15:0] debug_vehicle_id;
    tx_top_module #(.VEHICLE_ID(16'h0017)) dut(.clk(clk),.rst(rst),.emergency_trigger(trigger),.event_id(event_id),.uart_tx(uart_tx),.busy(busy),.tx_done(tx_done),.debug_event_id(debug_event_id),.debug_vehicle_id(debug_vehicle_id));
    always #5 clk=~clk;
    initial begin
        repeat(20) @(posedge clk); rst=0; repeat(5) @(posedge clk); trigger=1; @(posedge clk); trigger=0;
        wait(tx_done); if(debug_event_id!==8'h01 || debug_vehicle_id!==16'h0017) begin $display("TX TEST FAIL"); $fatal; end
        $display("TX TEST PASS event=%h vehicle=%h",debug_event_id,debug_vehicle_id); #100 $finish;
    end
    initial begin #1000000; $fatal; end
endmodule
