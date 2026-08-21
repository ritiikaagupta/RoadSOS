`timescale 1ns/1ps
// CRC-16/CCITT-FALSE streaming engine.
// Polynomial 0x1021, initial value 0xFFFF, MSB first, no reflection, no xorout.
module crc_generator (
    input  logic        clk,
    input  logic        rst,
    input  logic        start,
    input  logic        data_valid,
    input  logic        last,
    input  logic [7:0]  data_in,
    output logic [15:0] crc_out,
    output logic        crc_valid
);
    logic [15:0] crc_reg;
    logic [15:0] crc_next;

    function automatic [15:0] crc16_update(input [15:0] crc, input [7:0] data);
        integer i;
        reg [15:0] c;
        begin
            c = crc;
            for (i=0; i<8; i=i+1) begin
                if (c[15] ^ data[7-i])
                    c = {c[14:0],1'b0} ^ 16'h1021;
                else
                    c = {c[14:0],1'b0};
            end
            crc16_update = c;
        end
    endfunction

    always_comb begin
        if (start)
            crc_next = crc16_update(16'hFFFF, data_in);
        else
            crc_next = crc16_update(crc_reg, data_in);
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            crc_reg   <= 16'hFFFF;
            crc_out   <= 16'h0000;
            crc_valid <= 1'b0;
        end else begin
            crc_valid <= 1'b0;
            if (data_valid) begin
                crc_reg <= crc_next;
                if (last) begin
                    crc_out   <= crc_next;
                    crc_valid <= 1'b1;
                    crc_reg   <= 16'hFFFF;
                end
            end
        end
    end
endmodule
