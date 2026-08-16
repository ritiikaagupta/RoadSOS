module symbol_mapper #(
    parameter int FRAME_WIDTH = 32,
    parameter int SF = 7
)(
    input  logic clk,
    input  logic rst,

    // Start symbol mapping
    input  logic frame_valid,

    // Input frame
    input  logic [FRAME_WIDTH-1:0] frame,

    // Output symbol
    output logic [SF-1:0] symbol,

    // Indicates that a symbol is available
    output logic symbol_valid,

    // Indicates that all symbols have been sent
    output logic mapping_done
);

    // ------------------------------------------------
    // Calculate number of symbols
    // ------------------------------------------------

    localparam int NUM_SYMBOLS =
        (FRAME_WIDTH + SF - 1) / SF;

    localparam int PAD_WIDTH =
        NUM_SYMBOLS * SF;


    // ------------------------------------------------
    // Internal padded frame
    // ------------------------------------------------

    logic [PAD_WIDTH-1:0] padded_frame;


    // Current symbol index
    logic [$clog2(NUM_SYMBOLS)-1:0] symbol_count;


    // Mapping active
    logic mapping_active;


    // ------------------------------------------------
    // Main logic
    // ------------------------------------------------

    always_ff @(posedge clk) begin

        if (rst) begin

            symbol        <= '0;
            symbol_valid  <= 1'b0;
            mapping_done  <= 1'b0;

            padded_frame  <= '0;
            symbol_count  <= '0;

            mapping_active <= 1'b0;

        end

        else begin

            // Default outputs
            symbol_valid <= 1'b0;
            mapping_done <= 1'b0;


            // ----------------------------------------
            // Start mapping
            // ----------------------------------------

            if (frame_valid && !mapping_active) begin

                // Add zero padding
                padded_frame <= {
                    {(PAD_WIDTH-FRAME_WIDTH){1'b0}},
                    frame
                };

                symbol_count <= '0;

                mapping_active <= 1'b1;

            end


            // ----------------------------------------
            // Generate symbols
            // ----------------------------------------

            else if (mapping_active) begin

                symbol_valid <= 1'b1;


                // Extract current symbol
                symbol <= padded_frame[
                    PAD_WIDTH - 1 -
                    symbol_count*SF -:
                    SF
                ];


                // ------------------------------------
                // Last symbol
                // ------------------------------------

                if (symbol_count == NUM_SYMBOLS-1) begin

                    mapping_active <= 1'b0;

                    mapping_done <= 1'b1;

                end

                else begin

                    symbol_count <= symbol_count + 1'b1;

                end

            end

        end

    end

endmodule
