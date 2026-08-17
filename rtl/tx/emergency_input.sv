`timescale 1ns/1ps

module emergency_input #(
    parameter int EVENT_ID_WIDTH = 8
)(
    input  logic                    clk,
    input  logic                    rst,
    input  logic                    emergency_trigger,
    input  logic [EVENT_ID_WIDTH-1:0] event_id,

    output logic                    event_valid,
    output logic [EVENT_ID_WIDTH-1:0] event_id_out
);

    always_ff @(posedge clk) begin
        if (rst) begin
            event_valid  <= 1'b0;
            event_id_out <= '0;
        end else begin
            event_valid <= 1'b0;

            if (emergency_trigger) begin
                event_id_out <= event_id;
                event_valid  <= 1'b1;
            end
        end
    end

endmodule
