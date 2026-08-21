/*`timescale 1ns/1ps

// SF=7 means the symbol is 7 bits wide (0..127).
//
// This is still a simplified detector: it searches 8 samples and
// returns the strongest sample index, zero-extended to 7 bits.
// It therefore exercises the 7-bit interface correctly, while the
// actual 128-bin LoRa detector can be developed later.
/*
module symbol_detector (
    input  logic clk,
    input  logic rst,

    input  logic signed [15:0] i_in,
    input  logic signed [15:0] q_in,
    input  logic               valid_in,

    output logic [6:0] symbol_out,
    output logic       symbol_valid
);

    logic [31:0] magnitude;
    logic [31:0] max_magnitude;
    logic [2:0]  max_index;
    logic [2:0]  sample_count;

    always_ff @(posedge clk) begin
        if (rst) begin
            sample_count  <= 3'd0;
            max_magnitude <= 32'd0;
            max_index     <= 3'd0;
            symbol_out    <= 7'd0;
            symbol_valid  <= 1'b0;
        end else if (valid_in) begin
            magnitude = (i_in * i_in) + (q_in * q_in);

            if (magnitude > max_magnitude) begin
                max_magnitude <= magnitude;
                max_index     <= sample_count;
            end

            if (sample_count == 3'd7) begin
                symbol_out    <= {4'd0, max_index};
                symbol_valid  <= 1'b1;
                sample_count  <= 3'd0;
                max_magnitude <= 32'd0;
            end else begin
                sample_count <= sample_count + 1'b1;
                symbol_valid <= 1'b0;
            end
        end else begin
            symbol_valid <= 1'b0;
        end
    end

endmodule
*/
`timescale 1ns/1ps
module symbol_detector(input logic clk,input logic rst,input logic signed [15:0] i_in,input logic signed [15:0] q_in,input logic valid_in,output logic [6:0] symbol_out,output logic symbol_valid);
    always_ff @(posedge clk) begin if(rst) begin symbol_out<=0;symbol_valid<=0; end else begin symbol_valid<=0; end end
endmodule
