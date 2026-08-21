/*`timescale 1ns/1ps

module synchronizer #(
    parameter int SAMPLES_PER_SYMBOL = 8
)(
    input  logic clk,
    input  logic rst,

    input  logic preamble_detected,

    output logic symbol_start,
    output logic synchronized
);

    localparam int COUNT_WIDTH =
        (SAMPLES_PER_SYMBOL <= 2) ? 1 : $clog2(SAMPLES_PER_SYMBOL);

    logic [COUNT_WIDTH-1:0] sample_count;

    always_ff @(posedge clk) begin
        if (rst) begin
            sample_count <= '0;
            symbol_start <= 1'b0;
            synchronized <= 1'b0;
        end else begin
            symbol_start <= 1'b0;

            if (!synchronized) begin
                sample_count <= '0;

                if (preamble_detected) begin
                    synchronized <= 1'b1;
                    sample_count <= '0;
                    symbol_start <= 1'b1;
                end
            end else begin
                if (sample_count == SAMPLES_PER_SYMBOL-1) begin
                    sample_count <= '0;
                    symbol_start <= 1'b1;
                end else begin
                    sample_count <= sample_count + 1'b1;
                end
            end
        end
    end

endmodule
*/

`timescale 1ns/1ps
module synchronizer #(parameter int SAMPLES_PER_SYMBOL=8)(input logic clk,input logic rst,input logic preamble_detected,output logic symbol_start,output logic synchronized);
    always_ff @(posedge clk) begin if(rst) begin symbol_start<=0;synchronized<=0; end else begin symbol_start<=preamble_detected; if(preamble_detected) synchronized<=1; end end
endmodule
