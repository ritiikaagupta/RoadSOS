`timescale 1ns/1ps

module tb_symbol_mapper;

    logic clk;
    logic rst;

    logic frame_valid;
    logic [31:0] frame;

    logic [6:0] symbol;
    logic symbol_valid;
    logic mapping_done;


    // ------------------------------------------
    // DUT
    // ------------------------------------------

    symbol_mapper #(
        .FRAME_WIDTH(32),
        .SF(7)
    ) dut (

        .clk          (clk),
        .rst          (rst),

        .frame_valid  (frame_valid),
        .frame        (frame),

        .symbol       (symbol),
        .symbol_valid (symbol_valid),
        .mapping_done (mapping_done)

    );


    // ------------------------------------------
    // Clock
    // ------------------------------------------

    always #5 clk = ~clk;


    // ------------------------------------------
    // Test
    // ------------------------------------------

    initial begin

        clk = 0;
        rst = 1;

        frame_valid = 0;

        frame = 32'b0;


        // --------------------------------------
        // Reset
        // --------------------------------------

        #20;

        rst = 0;


        // --------------------------------------
        // Provide frame
        // --------------------------------------

        #10;

        frame = 32'b10101010000100100011010011001100;

        frame_valid = 1;

        #10;

        frame_valid = 0;


        // --------------------------------------
        // Wait for mapping
        // --------------------------------------

        #100;

        $finish;

    end


    // ------------------------------------------
    // Monitor
    // ------------------------------------------

    always @(posedge clk) begin

        if (symbol_valid) begin

            $display(
                "TIME=%0t | SYMBOL=%0d | BINARY=%b",
                $time,
                symbol,
                symbol
            );

        end

        if (mapping_done) begin

            $display(
                "TIME=%0t | MAPPING COMPLETE",
                $time
            );

        end

    end

endmodule
