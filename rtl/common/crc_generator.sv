module crc_generator #(
    parameter int DATA_BYTES = 9
)(
    input  logic [8*DATA_BYTES-1:0] data,
    output logic [15:0] crc
);

    integer i;
    integer j;

    logic [15:0] crc_temp;
    logic [7:0]  current_byte;

    always_comb begin

        crc_temp = 16'hFFFF;

        for (i = 0; i < DATA_BYTES; i = i + 1) begin

            current_byte = data[8*DATA_BYTES-1 - i*8 -: 8];

            crc_temp = crc_temp ^ (current_byte << 8);

            for (j = 0; j < 8; j = j + 1) begin

                if (crc_temp[15] == 1'b1) begin
                    crc_temp = (crc_temp << 1) ^ 16'h1021;
                end
                else begin
                    crc_temp = crc_temp << 1;
                end

            end
        end

        crc = crc_temp;

    end

endmodule
