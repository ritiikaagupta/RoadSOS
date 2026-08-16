module preamble_detector (
    input  logic clk,
    input  logic rst,

    input  logic sample_in,
    input  logic valid_in,

    output logic preamble_detected
);

    logic [7:0] preamble_pattern;
    logic [7:0] sample_buffer;

    initial begin
        preamble_pattern = 8'b10101010;
    end

    always_ff @(posedge clk) begin

        if (rst) begin
            sample_buffer     <= 8'b0;
            preamble_detected <= 1'b0;
        end

        else if (valid_in) begin

            sample_buffer <= {sample_buffer[6:0], sample_in};

            if ({sample_buffer[6:0], sample_in} == preamble_pattern)
                preamble_detected <= 1'b1;
            else
                preamble_detected <= 1'b0;
        end

        else begin
            preamble_detected <= 1'b0;
        end

    end

endmodule
