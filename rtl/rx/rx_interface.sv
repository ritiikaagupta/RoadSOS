/*`timescale 1ns/1ps

module rx_interface (
    input  logic clk,
    input  logic rst,

    input  logic signed [15:0] i_in,
    input  logic signed [15:0] q_in,
    input  logic               valid_in,

    output logic signed [15:0] i_out,
    output logic signed [15:0] q_out,
    output logic               valid_out
);

    always_ff @(posedge clk) begin
        if (rst) begin
            i_out     <= 16'sd0;
            q_out     <= 16'sd0;
            valid_out <= 1'b0;
        end else begin
            i_out     <= i_in;
            q_out     <= q_in;
            valid_out <= valid_in;
        end
    end

endmodule
*/
`timescale 1ns/1ps
// UART-to-byte interface wrapper retained for future RF/IQ integration.
module rx_interface(input logic clk,input logic rst,input logic [7:0] uart_data,input logic uart_valid,output logic [7:0] data_out,output logic data_valid);
    always_ff @(posedge clk) begin if(rst) begin data_out<=0;data_valid<=0; end else begin data_out<=uart_data;data_valid<=uart_valid; end end
endmodule
