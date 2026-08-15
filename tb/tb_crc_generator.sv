`timescale 1ns/1ps

module tb_crc_generator;

    logic [8*9-1:0] data;
    logic [15:0] crc;

    crc_generator #(
        .DATA_BYTES(9)
    ) dut (
        .data(data),
        .crc(crc)
    );

    initial begin

        // "123456789"
        data = "123456789";

        #10;

        $display("--------------------------------");
        $display("CRC TEST");
        $display("--------------------------------");

        $display("Input : %s", data);
        $display("CRC   : %h", crc);

        if (crc == 16'h29B1) begin
            $display("RESULT: PASS");
        end
        else begin
            $display("RESULT: FAIL");
        end

        $display("--------------------------------");

        $finish;
    end

endmodule
