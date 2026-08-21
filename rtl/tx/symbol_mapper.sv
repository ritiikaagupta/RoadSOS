/*`timescale 1ns/1ps

// Maps a 64-bit frame into 7-bit symbols.
// 64 bits require 10 symbols:
// 10*7 = 70 bits.
// The upper 6 bits are zero padding.

module symbol_mapper #(
    parameter int FRAME_WIDTH = 64,
    parameter int SF = 7
)(
    input  logic          clk,
    input  logic          rst,

    input  logic          frame_valid,
    input  logic [FRAME_WIDTH-1:0] frame,

    output logic [SF-1:0] symbol,
    output logic          symbol_valid,
    output logic          mapping_done
);

    localparam int NUM_SYMBOLS = (FRAME_WIDTH + SF - 1) / SF;
    localparam int PAD_WIDTH   = NUM_SYMBOLS * SF;
    localparam int COUNT_WIDTH = (NUM_SYMBOLS <= 2) ? 1 : $clog2(NUM_SYMBOLS);

    logic [PAD_WIDTH-1:0] padded_frame;
    logic [COUNT_WIDTH-1:0] symbol_count;
    logic mapping_active;

    always_ff @(posedge clk) begin
        if (rst) begin
            symbol         <= '0;
            symbol_valid   <= 1'b0;
            mapping_done   <= 1'b0;
            padded_frame   <= '0;
            symbol_count   <= '0;
            mapping_active <= 1'b0;
        end else begin
            symbol_valid <= 1'b0;
            mapping_done <= 1'b0;

            if (frame_valid && !mapping_active) begin
                padded_frame <= {{(PAD_WIDTH-FRAME_WIDTH){1'b0}}, frame};
                symbol_count <= '0;
                mapping_active <= 1'b1;
            end else if (mapping_active) begin
                symbol <= padded_frame[
                    PAD_WIDTH-1-symbol_count*SF -: SF
                ];
                symbol_valid <= 1'b1;

                if (symbol_count == NUM_SYMBOLS-1) begin
                    mapping_active <= 1'b0;
                    mapping_done <= 1'b1;
                end else begin
                    symbol_count <= symbol_count + 1'b1;
                end
            end
        end
    end

endmodule
*/
`timescale 1ns/1ps
module symbol_mapper #(parameter int FRAME_WIDTH=64,parameter int SF=7)(input logic clk,input logic rst,input logic frame_valid,input logic [FRAME_WIDTH-1:0] frame,output logic [SF-1:0] symbol,output logic symbol_valid,output logic mapping_done);
    localparam int N=(FRAME_WIDTH+SF-1)/SF; localparam int P=N*SF; localparam int CW=(N<=2)?1:$clog2(N);
    logic [P-1:0] buf; logic [CW-1:0] count; logic active;
    always_ff @(posedge clk) begin
        if(rst) begin buf<='0; count<='0; active<=0; symbol<='0; symbol_valid<=0; mapping_done<=0; end
        else begin symbol_valid<=0; mapping_done<=0;
            if(frame_valid && !active) begin buf<={{(P-FRAME_WIDTH){1'b0}},frame}; count<='0; active<=1; end
            else if(active) begin symbol<=buf[P-1-count*SF -: SF]; symbol_valid<=1; if(count==N-1) begin active<=0; mapping_done<=1; end else count<=count+1'b1; end
        end
    end
endmodule
