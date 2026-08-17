module crc_checker (
    input  logic        clk,
    input  logic        rst,

    input  logic [31:0] packet_in,
    input  logic        packet_valid,

    input  logic [15:0] crc_expected,

    output logic        crc_pass,
    output logic        crc_done
);

    logic [15:0] crc_calc;

    integer i;
    integer j;

    logic [15:0] crc_temp;
    logic [7:0]  current_byte;

    always_comb begin

        crc_temp = 16'hFFFF;
        current_byte = 8'h00;

        // Process 4 bytes = 32-bit payload
        for (i = 0; i < 4; i = i + 1) begin

            current_byte = packet_in[31 - i*8 -: 8];

            crc_temp = crc_temp ^ (current_byte << 8);

            for (j = 0; j < 8; j = j + 1) begin

                if (crc_temp[15]) begin
                    crc_temp = (crc_temp << 1) ^ 16'h1021;
                end
                else begin
                    crc_temp = crc_temp << 1;
                end

            end
        end

        crc_calc = crc_temp;

    end


    always_ff @(posedge clk) begin

        if (rst) begin
            crc_pass <= 1'b0;
            crc_done <= 1'b0;
        end

        else begin

            crc_done <= 1'b0;

            if (packet_valid) begin

                if (crc_calc == crc_expected)
                    crc_pass <= 1'b1;
                else
                    crc_pass <= 1'b0;

                crc_done <= 1'b1;

            end
        end
    end

endmodule
