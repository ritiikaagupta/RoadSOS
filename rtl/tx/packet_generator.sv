/*
`timescale 1ns/1ps

// ============================================================
// PACKET GENERATOR
//
// Packet format:
//
//   BYTE 0 : 0xAA          -> Synchronization byte
//   BYTE 1 : 0x01          -> Packet type / version
//   BYTE 2 : event_id
//   BYTE 3 : vehicle_id[15:8]
//   BYTE 4 : vehicle_id[7:0]
//   BYTE 5 : CRC[15:8]`timescale 1ns/1ps
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

//   BYTE 6 : CRC[7:0]
//
// CRC is calculated over:
//   0x01
//   event_id
//   vehicle_id[15:8]
//   vehicle_id[7:0]
//
// CRC engine:
//   CRC-16/CCITT-FALSE
//   Polynomial = 0x1021
//   Initial    = 0xFFFF
//
// Interface:
//   emergency_trigger -> starts a new packet
//
// Outputs:
//   packet_start -> first CRC byte
//   packet_valid -> packet_data is valid
//   packet_done  -> last byte of complete packet
//
// ============================================================

module packet_generator (

    input  logic        clk,
    input  logic        rst_n,

    // --------------------------------------------------------
    // Packet generation request
    // --------------------------------------------------------
    input  logic        emergency_trigger,

    // --------------------------------------------------------
    // Packet information
    // --------------------------------------------------------
    input  logic [7:0]  event_id,
    input  logic [15:0] vehicle_id,

    // --------------------------------------------------------
    // CRC result from crc_generator
    // --------------------------------------------------------
    input  logic [15:0] crc_out,
    input  logic        crc_valid,

    // --------------------------------------------------------
    // Packet output
    // --------------------------------------------------------
    output logic [7:0]  packet,
    output logic        packet_valid,
    output logic        packet_start,
    output logic        packet_done,

    // --------------------------------------------------------
    // CRC control signals
    //
    // These connect directly to crc_generator.
    // --------------------------------------------------------
    output logic        crc_start,
    output logic        crc_data_valid,
    output logic        crc_last,
    output logic [7:0]  crc_data,

    // --------------------------------------------------------
    // Generator status
    // --------------------------------------------------------
    output logic        busy
);


    // ========================================================
    // FSM STATES
    // ========================================================

    typedef enum logic [3:0] {

        IDLE,

        SEND_SYNC,

        SEND_TYPE,

        SEND_EVENT,

        SEND_VEHICLE_H,

        SEND_VEHICLE_L,

        WAIT_CRC,

        SEND_CRC_H,

        SEND_CRC_L

    } state_t;

    state_t state;


    // ========================================================
    // STORED PACKET INFORMATION
    // ========================================================

    logic [7:0]  event_id_reg;
    logic [15:0] vehicle_id_reg;

    logic [15:0] crc_reg;


    // ========================================================
    // SEQUENTIAL FSM
    // ========================================================

    always_ff @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin

            state          <= IDLE;

            event_id_reg   <= 8'h00;
            vehicle_id_reg <= 16'h0000;

            crc_reg        <= 16'h0000;

        end

        else begin

            case (state)

                // =================================================
                // IDLE
                // =================================================

                IDLE: begin

                    if (emergency_trigger) begin

                        // Capture packet information
                        event_id_reg   <= event_id;
                        vehicle_id_reg <= vehicle_id;

                        // Start packet
                        state <= SEND_SYNC;

                    end

                end


                // =================================================
                // SEND SYNC BYTE
                // =================================================

                SEND_SYNC: begin

                    state <= SEND_TYPE;

                end


                // =================================================
                // SEND PACKET TYPE
                //
                // First byte that goes into CRC.
                // =================================================

                SEND_TYPE: begin

                    state <= SEND_EVENT;

                end


                // =================================================
                // SEND EVENT ID
                // =================================================

                SEND_EVENT: begin

                    state <= SEND_VEHICLE_H;

                end


                // =================================================
                // SEND VEHICLE ID HIGH BYTE
                // =================================================

                SEND_VEHICLE_H: begin

                    state <= SEND_VEHICLE_L;

                end


                // =================================================
                // SEND VEHICLE ID LOW BYTE
                //
                // This is the final byte sent to CRC.
                // =================================================

                SEND_VEHICLE_L: begin

                    state <= WAIT_CRC;

                end


                // =================================================
                // WAIT FOR CRC
                // =================================================

                WAIT_CRC: begin

                    if (crc_valid) begin

                        crc_reg <= crc_out;

                        state <= SEND_CRC_H;

                    end

                end


                // =================================================
                // SEND CRC HIGH BYTE
                // =================================================

                SEND_CRC_H: begin

                    state <= SEND_CRC_L;

                end


                // =================================================
                // SEND CRC LOW BYTE
                // =================================================

                SEND_CRC_L: begin

                    state <= IDLE;

                end


                default: begin

                    state <= IDLE;

                end

            endcase

        end

    end


    // ========================================================
    // OUTPUT LOGIC
    //
    // All outputs are combinationally generated from FSM state.
    // ========================================================

    always_comb begin

        // ----------------------------------------------------
        // Default outputs
        // ----------------------------------------------------

        packet         = 8'h00;

        packet_valid   = 1'b0;
        packet_start   = 1'b0;
        packet_done    = 1'b0;

        crc_start      = 1'b0;
        crc_data_valid = 1'b0;
        crc_last       = 1'b0;
        crc_data       = 8'h00;

        busy           = 1'b1;


        // ====================================================
        // IDLE
        // ====================================================

        if (state == IDLE) begin

            busy = 1'b0;

        end


        // ====================================================
        // SYNC BYTE
        //
        // 0xAA is NOT included in CRC.
        // ====================================================

        else if (state == SEND_SYNC) begin

            packet       = 8'hAA;
            packet_valid = 1'b1;

        end


        // ====================================================
        // PACKET TYPE
        //
        // 0x01 is first byte of CRC calculation.
        // ====================================================

        else if (state == SEND_TYPE) begin

            packet         = 8'h01;
            packet_valid   = 1'b1;

            crc_data       = 8'h01;
            crc_data_valid = 1'b1;
            crc_start      = 1'b1;

        end


        // ====================================================
        // EVENT ID
        // ====================================================

        else if (state == SEND_EVENT) begin

            packet         = event_id_reg;
            packet_valid   = 1'b1;

            crc_data       = event_id_reg;
            crc_data_valid = 1'b1;

        end


        // ====================================================
        // VEHICLE ID HIGH BYTE
        // ====================================================

        else if (state == SEND_VEHICLE_H) begin

            packet         = vehicle_id_reg[15:8];
            packet_valid   = 1'b1;

            crc_data       = vehicle_id_reg[15:8];
            crc_data_valid = 1'b1;

        end


        // ====================================================
        // VEHICLE ID LOW BYTE
        //
        // FINAL CRC BYTE
        // ====================================================

        else if (state == SEND_VEHICLE_L) begin

            packet         = vehicle_id_reg[7:0];
            packet_valid   = 1'b1;

            crc_data       = vehicle_id_reg[7:0];
            crc_data_valid = 1'b1;

            crc_last       = 1'b1;

        end


        // ====================================================
        // CRC HIGH BYTE
        // ====================================================

        else if (state == SEND_CRC_H) begin

            packet         = crc_reg[15:8];
            packet_valid   = 1'b1;

        end


        // ====================================================
        // CRC LOW BYTE
        //
        // Last byte of complete packet.
        // ====================================================

        else if (state == SEND_CRC_L) begin

            packet         = crc_reg[7:0];
            packet_valid   = 1'b1;

            packet_done    = 1'b1;

        end
*/

        `timescale 1ns/1ps
// SAFE-Link prototype application frame, sent over UART during the no-RF phase.
// Bytes: A5 | EVENT_ID | VEHICLE_ID[15:8] | VEHICLE_ID[7:0] | CRC[15:8] | CRC[7:0] | 5A | 0A
// CRC-16/CCITT-FALSE covers the first four bytes: A5, EVENT_ID, VEHICLE_ID_H, VEHICLE_ID_L.
module packet_generator (
    input logic clk, input logic rst,
    input logic emergency_trigger,
    input logic [7:0] event_id,
    input logic [15:0] vehicle_id,
    input logic uart_busy, input logic uart_done,
    output logic uart_start, output logic [7:0] uart_data,
    output logic busy, output logic packet_done,
    output logic [47:0] packet_out
);
    typedef enum logic [3:0] {IDLE, SEND_A5, SEND_EVENT, SEND_VH, SEND_VL, SEND_CRC_H, SEND_CRC_L, SEND_5A, SEND_NL} state_t;
    state_t state;
    logic [7:0] event_reg; logic [15:0] vehicle_reg, crc_reg;
    logic [15:0] crc_calc;
    function automatic [15:0] crc_byte(input [15:0] crc, input [7:0] data);
        integer i; reg [15:0] c;
        begin c=crc; for(i=0;i<8;i=i+1) begin if(c[15]^data[7-i]) c={c[14:0],1'b0}^16'h1021; else c={c[14:0],1'b0}; end crc_byte=c; end
    endfunction
    always_comb begin
        crc_calc=crc_byte(crc_byte(crc_byte(crc_byte(16'hFFFF,8'hA5),event_reg),vehicle_reg[15:8]),vehicle_reg[7:0]);
    end
    always_ff @(posedge clk) begin
        if(rst) begin state<=IDLE; event_reg<=0; vehicle_reg<=0; crc_reg<=0; packet_out<=0; end
        else begin
            case(state)
                IDLE: if(emergency_trigger) begin event_reg<=event_id; vehicle_reg<=vehicle_id; crc_reg<=crc_byte(crc_byte(crc_byte(crc_byte(16'hFFFF,8'hA5),event_id),vehicle_id[15:8]),vehicle_id[7:0]); packet_out<={8'hA5,event_id,vehicle_id,crc_byte(crc_byte(crc_byte(crc_byte(16'hFFFF,8'hA5),event_id),vehicle_id[15:8]),vehicle_id[7:0])}; state<=SEND_A5; end
                SEND_A5: if(!uart_busy) state<=SEND_EVENT;
                SEND_EVENT: if(!uart_busy) state<=SEND_VH;
                SEND_VH: if(!uart_busy) state<=SEND_VL;
                SEND_VL: if(!uart_busy) state<=SEND_CRC_H;
                SEND_CRC_H: if(!uart_busy) state<=SEND_CRC_L;
                SEND_CRC_L: if(!uart_busy) state<=SEND_5A;
                SEND_5A: if(!uart_busy) state<=SEND_NL;
                SEND_NL: if(!uart_busy) state<=IDLE;
                default: state<=IDLE;
            endcase
        end
    end
    always_comb begin
        uart_start=0; uart_data=0; busy=(state!=IDLE); packet_done=0;
        case(state)
            SEND_A5: begin uart_data=8'hA5; if(!uart_busy) uart_start=1; end
            SEND_EVENT: begin uart_data=event_reg; if(!uart_busy) uart_start=1; end
            SEND_VH: begin uart_data=vehicle_reg[15:8]; if(!uart_busy) uart_start=1; end
            SEND_VL: begin uart_data=vehicle_reg[7:0]; if(!uart_busy) uart_start=1; end
            SEND_CRC_H: begin uart_data=crc_reg[15:8]; if(!uart_busy) uart_start=1; end
            SEND_CRC_L: begin uart_data=crc_reg[7:0]; if(!uart_busy) uart_start=1; end
            SEND_5A: begin uart_data=8'h5A; if(!uart_busy) uart_start=1; end
            SEND_NL: begin uart_data=8'h0A; if(!uart_busy) begin uart_start=1; packet_done=1; end end
            default: ;
        endcase
    end
endmodule


    end

endmodule
