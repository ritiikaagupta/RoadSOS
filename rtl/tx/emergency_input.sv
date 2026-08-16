`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2026 10:23:28 PM
// Design Name: 
// Module Name: emergency_input
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module emergency_input #(
    parameter EVENT_ID_WIDTH = 4
)(
    input  logic                     clk,
    input  logic                     rst,

    input  logic                     emergency_trigger,
    input  logic [EVENT_ID_WIDTH-1:0] event_id,

    output logic                     event_valid,
    output logic [EVENT_ID_WIDTH-1:0] event_id_out
);

    always_ff @(posedge clk) begin

        if (rst) begin

            event_valid <= 1'b0;
            event_id_out <= '0;

        end

        else begin

            // Default: no new event
            event_valid <= 1'b0;

            // Capture emergency event
            if (emergency_trigger) begin

                event_id_out <= event_id;
                event_valid <= 1'b1;

            end

        end

    end

endmodule

