module crc_checker (
    input  logic         clk,
    input  logic          rst,

    input  logic [23:0]  packet_in,
    input  logic           packet_valid,

    input  logic [7:0]   crc_expected,

    output logic           crc_pass,
    output logic           crc_done
);

    logic [7:0] crc_calc;

    always_ff @(posedge clk) begin
        if (rst) begin
            crc_calc <= 8'd0;
            crc_pass <= 1'b0;
            crc_done <= 1'b0;
        end
        else if (packet_valid) begin
            crc_calc <= packet_in[23:16] ^ packet_in[15:8] ^ packet_in[7:0];
            crc_pass <= ( (packet_in[23:16] ^ packet_in[15:8] ^ packet_in[7:0]) == crc_expected );
            crc_done <= 1'b1;
        end
        else begin
            crc_done <= 1'b0;
        end
    end

endmodule
