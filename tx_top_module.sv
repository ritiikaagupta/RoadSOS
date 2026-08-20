`timescale 1ns/1ps

module tx_top_module #(
    parameter logic [7:0]  HEADER     = 8'hA5,
    parameter logic [15:0] VEHICLE_ID = 16'h0001,

    parameter int PHASE_WIDTH  = 32,
    parameter int OUTPUT_WIDTH = 16,

    parameter logic [PHASE_WIDTH-1:0]
        BASE_PHASE_INCREMENT = 32'd1000000,

    parameter logic [PHASE_WIDTH-1:0]
        SYMBOL_PHASE_STEP = 32'd10000
)(
    input  logic clk,
    input  logic rst,

    // ------------------------------------------------------------
    // Emergency input
    // ------------------------------------------------------------
    input  logic       emergency_trigger,
    input  logic [7:0] event_id,

    // ------------------------------------------------------------
    // TX control/status
    // ------------------------------------------------------------
    output logic       busy,
    output logic       tx_done,

    // ------------------------------------------------------------
    // Digital I/Q output
    // ------------------------------------------------------------
    output logic signed [OUTPUT_WIDTH-1:0] i_out,
    output logic signed [OUTPUT_WIDTH-1:0] q_out,
    output logic                            tx_valid
);

    // ============================================================
    // Emergency input
    // ============================================================

    logic       event_valid;
    logic [7:0] event_id_int;


    // ============================================================
    // Packet generator
    // ============================================================

    logic [47:0] packet;
    logic        packet_valid;
    logic        packet_done;


    // ============================================================
    // Frame generator
    // ============================================================

    logic [63:0] frame;
    logic        frame_valid;
    logic        frame_done;


    // ============================================================
    // Symbol mapper
    // ============================================================

    logic [6:0] symbol;
    logic       symbol_valid;
    logic       mapping_done;


    // ============================================================
    // Chirp generator
    // ============================================================

    logic signed [OUTPUT_WIDTH-1:0] chirp_i;
    logic signed [OUTPUT_WIDTH-1:0] chirp_q;
    logic                           chirp_valid;


    // ============================================================
    // Simple TX state machine
    // ============================================================

    typedef enum logic [2:0] {
        TX_IDLE,
        TX_PACKET,
        TX_FRAME,
        TX_SYMBOL,
        TX_DONE
    } tx_state_t;

    tx_state_t state;


    // ============================================================
    // Emergency input
    // ============================================================

    emergency_input u_emergency_input (
        .clk              (clk),
        .rst              (rst),
        .emergency_trigger(emergency_trigger),
        .event_id         (event_id),

        .event_valid      (event_valid),
        .event_id_out     (event_id_int)
    );


    // ============================================================
    // Packet generator
    // ============================================================

    packet_generator #(
        .HEADER(HEADER)
    ) u_packet_generator (
        .clk         (clk),
        .rst         (rst),

        .packet_start(state == TX_PACKET),
        .event_id    (event_id_int),
        .vehicle_id  (VEHICLE_ID),

        .packet      (packet),
        .packet_valid (packet_valid),
        .packet_done  (packet_done)
    );


    // ============================================================
    // Frame generator
    // ============================================================

    frame_generator u_frame_generator (
        .clk         (clk),
        .rst         (rst),

        .packet_valid(packet_valid),
        .packet      (packet),

        .frame_valid (frame_valid),
        .frame        (frame),
        .frame_done   (frame_done)
    );


    // ============================================================
    // Symbol mapper
    // ============================================================

    symbol_mapper #(
        .FRAME_WIDTH(64),
        .SF(7)
    ) u_symbol_mapper (
        .clk          (clk),
        .rst          (rst),

        .frame_valid  (frame_valid),
        .frame        (frame),

        .symbol       (symbol),
        .symbol_valid (symbol_valid),
        .mapping_done (mapping_done)
    );


    // ============================================================
    // Chirp generator
    // ============================================================

    chirp_generator #(
        .PHASE_WIDTH(PHASE_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .BASE_PHASE_INCREMENT(BASE_PHASE_INCREMENT),
        .SYMBOL_PHASE_STEP(SYMBOL_PHASE_STEP)
    ) u_chirp_generator (
        .clk         (clk),
        .reset       (rst),

        .enable      (state == TX_SYMBOL),

        .symbol      (symbol),
        .symbol_valid(symbol_valid),

        .i_out       (chirp_i),
        .q_out       (chirp_q),
        .valid       (chirp_valid)
    );


    // ============================================================
    // TX FSM
    // ============================================================

    always_ff @(posedge clk) begin

        if (rst) begin
            state   <= TX_IDLE;
            tx_done <= 1'b0;
        end

        else begin

            tx_done <= 1'b0;

            case (state)

                TX_IDLE: begin
                    if (event_valid)
                        state <= TX_PACKET;
                end


                TX_PACKET: begin
                    if (packet_done)
                        state <= TX_FRAME;
                end


                TX_FRAME: begin
                    if (frame_done)
                        state <= TX_SYMBOL;
                end


                TX_SYMBOL: begin
                    if (mapping_done)
                        state <= TX_DONE;
                end


                TX_DONE: begin
                    tx_done <= 1'b1;
                    state   <= TX_IDLE;
                end


                default: begin
                    state <= TX_IDLE;
                end

            endcase
        end
    end


    // ============================================================
    // Outputs
    // ============================================================

    assign i_out   = chirp_i;
    assign q_out   = chirp_q;

    assign tx_valid = chirp_valid;

    assign busy =
        (state != TX_IDLE) &&
        (state != TX_DONE);

endmodule
