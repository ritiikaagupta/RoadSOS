`timescale 1ns/1ps
// SAFE-Link UART prototype frame:
// A5 | EVENT | VEH_H | VEH_L | CRC_H | CRC_L | 5A | 0A
// CRC covers A5, EVENT, VEH_H, VEH_L only.
module packet_generator (
    input  logic        clk,
    input  logic        rst,
    input  logic        emergency_trigger,
    input  logic [7:0]  event_id,
    input  logic [15:0] vehicle_id,
    input  logic        uart_busy,
    input  logic        uart_done,
    output logic        uart_start,
    output logic [7:0]  uart_data,
    output logic        busy,
    output logic        packet_done,
    output logic [47:0] packet_out
);
    typedef enum logic [4:0] {
        IDLE, CRC_A5, CRC_EVENT, CRC_VH, CRC_VL, CRC_WAIT,
        SEND_A5, SEND_EVENT, SEND_VH, SEND_VL, SEND_CRC_H,
        SEND_CRC_L, SEND_5A, SEND_NL
    } state_t;
    state_t state;

    logic [7:0]  event_reg;
    logic [15:0] vehicle_reg;
    logic [15:0] crc_reg;
    logic [15:0] crc_out;
    logic        crc_valid;
    logic        crc_start, crc_data_valid, crc_last;
    logic [7:0]  crc_data;

    crc_generator u_crc (
        .clk(clk), .rst(rst), .start(crc_start),
        .data_valid(crc_data_valid), .last(crc_last),
        .data_in(crc_data), .crc_out(crc_out), .crc_valid(crc_valid)
    );

    always_ff @(posedge clk) begin
        if (rst) begin
            state       <= IDLE;
            event_reg   <= 8'h00;
            vehicle_reg <= 16'h0000;
            crc_reg     <= 16'h0000;
            packet_out  <= 48'h0;
        end else begin
            case (state)
                IDLE: begin
                    if (emergency_trigger) begin
                        event_reg   <= event_id;
                        vehicle_reg <= vehicle_id;
                        state       <= CRC_A5;
                    end
                end
                CRC_A5:   state <= CRC_EVENT;
                CRC_EVENT:state <= CRC_VH;
                CRC_VH:   state <= CRC_VL;
                CRC_VL:   state <= CRC_WAIT;
                CRC_WAIT: begin
                    if (crc_valid) begin
                        crc_reg    <= crc_out;
                        packet_out <= {8'hA5, event_reg, vehicle_reg, crc_out};
                        state      <= SEND_A5;
                    end
                end
                SEND_A5:    if (!uart_busy) state <= SEND_EVENT;
                SEND_EVENT: if (!uart_busy) state <= SEND_VH;
                SEND_VH:    if (!uart_busy) state <= SEND_VL;
                SEND_VL:    if (!uart_busy) state <= SEND_CRC_H;
                SEND_CRC_H: if (!uart_busy) state <= SEND_CRC_L;
                SEND_CRC_L: if (!uart_busy) state <= SEND_5A;
                SEND_5A:    if (!uart_busy) state <= SEND_NL;
                SEND_NL:    if (uart_done) state <= IDLE;
                default: state <= IDLE;
            endcase
        end
    end

    always_comb begin
        crc_start      = 1'b0;
        crc_data_valid = 1'b0;
        crc_last       = 1'b0;
        crc_data       = 8'h00;
        uart_start     = 1'b0;
        uart_data      = 8'h00;
        busy           = (state != IDLE);
        packet_done    = 1'b0;

        case (state)
            CRC_A5: begin
                crc_start = 1'b1; crc_data_valid = 1'b1; crc_data = 8'hA5;
            end
            CRC_EVENT: begin
                crc_data_valid = 1'b1; crc_data = event_reg;
            end
            CRC_VH: begin
                crc_data_valid = 1'b1; crc_data = vehicle_reg[15:8];
            end
            CRC_VL: begin
                crc_data_valid = 1'b1; crc_last = 1'b1; crc_data = vehicle_reg[7:0];
            end
            SEND_A5: begin uart_data=8'hA5; if (!uart_busy) uart_start=1'b1; end
            SEND_EVENT: begin uart_data=event_reg; if (!uart_busy) uart_start=1'b1; end
            SEND_VH: begin uart_data=vehicle_reg[15:8]; if (!uart_busy) uart_start=1'b1; end
            SEND_VL: begin uart_data=vehicle_reg[7:0]; if (!uart_busy) uart_start=1'b1; end
            SEND_CRC_H: begin uart_data=crc_reg[15:8]; if (!uart_busy) uart_start=1'b1; end
            SEND_CRC_L: begin uart_data=crc_reg[7:0]; if (!uart_busy) uart_start=1'b1; end
            SEND_5A: begin uart_data=8'h5A; if (!uart_busy) uart_start=1'b1; end
            SEND_NL: begin
                uart_data=8'h0A;
                if (!uart_busy) uart_start=1'b1;
                if (uart_done) packet_done=1'b1;
            end
            default: ;
        endcase
    end
endmodule
