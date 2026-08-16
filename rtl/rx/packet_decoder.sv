module packet_decoder (
    input  logic        clk,
    input  logic         rst,

    input  logic [2:0]  symbol_in,
    input  logic          symbol_valid,

    output logic [23:0] packet_out,
    output logic          packet_valid
);

    logic [23:0] buffer;
    logic [3:0]  symbol_count;

    always_ff @(posedge clk) begin
        if (rst) begin
            buffer       <= 24'd0;
            symbol_count <= 4'd0;
            packet_out   <= 24'd0;
            packet_valid <= 1'b0;
        end
        else if (symbol_valid) begin
            buffer <= {buffer[20:0], symbol_in};

            if (symbol_count == 4'd7) begin
                packet_out   <= {buffer[20:0], symbol_in};
                packet_valid <= 1'b1;
                symbol_count <= 4'd0;
            end
            else begin
                symbol_count <= symbol_count + 4'd1;
                packet_valid <= 1'b0;
            end
        end
        else begin
            packet_valid <= 1'b0;
        end
    end

endmodule
