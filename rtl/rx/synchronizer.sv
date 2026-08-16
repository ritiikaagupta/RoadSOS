// Code your design here
module synchronizer #(
    parameter int SAMPLES_PER_SYMBOL = 1024
)(
    input  logic clk,
    input  logic rst,

    // Indicates that the preamble has been detected
    input  logic preamble_detected,

    // One pulse for each detected symbol boundary
    output logic symbol_start,

    // Indicates that synchronization is active
    output logic synchronized
);

    // Counter for samples within one symbol
    logic [$clog2(SAMPLES_PER_SYMBOL)-1:0] sample_count;


    always_ff @(posedge clk) begin

        if (rst) begin

            sample_count <= '0;
            symbol_start <= 1'b0;
            synchronized <= 1'b0;

        end

        else begin

            // Default:
            // symbol_start is only HIGH for one clock
            symbol_start <= 1'b0;


            // ------------------------------------------
            // Wait for preamble detection
            // ------------------------------------------

            if (!synchronized) begin

                sample_count <= '0;

                if (preamble_detected) begin

                    synchronized <= 1'b1;

                    // First symbol begins after
                    // synchronization is established
                    sample_count <= '0;

                    symbol_start <= 1'b1;

                end

            end


            // ------------------------------------------
            // Synchronization active
            // ------------------------------------------

            else begin

                if (sample_count == SAMPLES_PER_SYMBOL - 1) begin

                    // Reached the end of one symbol

                    sample_count <= '0;

                    // Start of next symbol
                    symbol_start <= 1'b1;

                end

                else begin

                    sample_count <= sample_count + 1'b1;

                end

            end

        end

    end

endmodule
