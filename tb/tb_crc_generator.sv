/*
`timescale 1ns/1ps

module crc16_ccitt_stream_tb;

    // ============================================================
    // DUT SIGNALS
    // ============================================================

    logic        clk;
    logic        rst_n;

    logic        start;
    logic        data_valid;
    logic        last;

    logic [7:0]  data_in;

    logic [15:0] crc_out;
    logic        crc_valid;


    // ============================================================
    // DUT
    // ============================================================

    crc16_ccitt_stream dut (
        .clk        (clk),
        .rst_n      (rst_n),

        .start      (start),
        .data_valid (data_valid),
        .last       (last),

        .data_in    (data_in),

        .crc_out    (crc_out),
        .crc_valid  (crc_valid)
    );


    // ============================================================
    // CLOCK
    // 10 ns period = 100 MHz
    // ============================================================

    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end


    // ============================================================
    // TEST PROCEDURE
    // ============================================================

    initial begin

        // --------------------------------------------------------
        // Initial values
        // --------------------------------------------------------

        rst_n      = 1'b0;

        start      = 1'b0;
        data_valid = 1'b0;
        last       = 1'b0;
        data_in    = 8'h00;


        // --------------------------------------------------------
        // Apply reset
        // --------------------------------------------------------

        #20;

        rst_n = 1'b1;


        // --------------------------------------------------------
        // Send "123456789"
        //
        // ASCII:
        // 1 = 8'h31
        // 2 = 8'h32
        // 3 = 8'h33
        // 4 = 8'h34
        // 5 = 8'h35
        // 6 = 8'h36
        // 7 = 8'h37
        // 8 = 8'h38
        // 9 = 8'h39
        // --------------------------------------------------------

        send_byte(8'h31, 1'b1, 1'b0);  // '1'
        send_byte(8'h32, 1'b0, 1'b0);  // '2'
        send_byte(8'h33, 1'b0, 1'b0);  // '3'
        send_byte(8'h34, 1'b0, 1'b0);  // '4'
        send_byte(8'h35, 1'b0, 1'b0);  // '5'
        send_byte(8'h36, 1'b0, 1'b0);  // '6'
        send_byte(8'h37, 1'b0, 1'b0);  // '7'
        send_byte(8'h38, 1'b0, 1'b0);  // '8'
        send_byte(8'h39, 1'b0, 1'b1);  // '9' - LAST


        // --------------------------------------------------------
        // Wait for CRC result
        // --------------------------------------------------------

        @(posedge clk);

        #1;

        if (crc_valid !== 1'b1) begin

            $display("ERROR: crc_valid was not asserted.");

        end
        else if (crc_out !== 16'h29B1) begin

            $display("ERROR: CRC mismatch!");
            $display("Expected CRC = 16'h29B1");
            $display("Actual CRC   = 16'h%04h", crc_out);

        end
        else begin

            $display("--------------------------------------------");
            $display("CRC TEST PASSED");
            $display("Input        = 123456789");
            $display("Expected CRC = 16'h29B1");
            $display("Actual CRC   = 16'h%04h", crc_out);
            $display("--------------------------------------------");

        end


        // --------------------------------------------------------
        // Finish simulation
        // --------------------------------------------------------

        #20;

        $finish;

    end


    // ============================================================
    // TASK: SEND ONE BYTE
    // ============================================================

    task send_byte;

        input [7:0] byte_data;
        input       byte_start;
        input       byte_last;

        begin

            // Put byte and control signals before clock edge
            @(negedge clk);

            data_in    = byte_data;
            start      = byte_start;
            data_valid = 1'b1;
            last       = byte_last;

            // Wait for DUT to process byte
            @(posedge clk);

            #1;

            // Deassert controls
            data_valid = 1'b0;
            start      = 1'b0;
            last       = 1'b0;

        end

    endtask


    // ============================================================
    // MONITOR
    // ============================================================

    always @(posedge clk) begin

        if (data_valid) begin

            $display(
                "Time=%0t | DATA=%h | start=%b | last=%b | CRC_REG=%h",
                $time,
                data_in,
                start,
                last,
                dut.crc_reg
            );

        end

        if (crc_valid) begin

            $display(
                "Time=%0t | CRC VALID | CRC_OUT=%h",
                $time,
                crc_out
            );

        end

    end

endmodule
*/

`timescale 1ns/1ps
module tb_crc_generator;
    logic clk=0, rst=1, start=0, data_valid=0, last=0;
    logic [7:0] data_in=0; logic [15:0] crc_out; logic crc_valid;
    crc_generator dut(.clk(clk),.rst(rst),.start(start),.data_valid(data_valid),.last(last),.data_in(data_in),.crc_out(crc_out),.crc_valid(crc_valid));
    always #5 clk=~clk;
    task automatic send_byte(input [7:0] b,input bit first,input bit final_byte);
        begin @(negedge clk); data_in=b; start=first; data_valid=1; last=final_byte; @(posedge clk); #1; data_valid=0; start=0; last=0; end
    endtask
    initial begin
        repeat(2) @(posedge clk); rst=0;
        send_byte(8'h31,1,0); send_byte(8'h32,0,0); send_byte(8'h33,0,0); send_byte(8'h34,0,0);
        send_byte(8'h35,0,0); send_byte(8'h36,0,0); send_byte(8'h37,0,0); send_byte(8'h38,0,0); send_byte(8'h39,0,1);
        #1;
        if (!crc_valid || crc_out !== 16'h29B1) begin $display("CRC TEST FAIL: got %h valid=%b",crc_out,crc_valid); $fatal; end
        $display("CRC TEST PASS: 123456789 -> %h",crc_out);
        #20 $finish;
    end
endmodule
