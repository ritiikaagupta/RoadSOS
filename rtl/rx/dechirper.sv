module dechirper (
    input  logic        clk,
    input  logic         rst,

    input  logic signed [15:0] i_in,
    input  logic signed [15:0] q_in,
    input  logic               valid_in,

    output logic signed [15:0] i_out,
    output logic signed [15:0] q_out,
    output logic               valid_out
);

    // Small fixed reference downchirp pattern (8 samples)
    // Simplified values for learning stage
    logic signed [15:0] ref_i [0:7];
    logic signed [15:0] ref_q [0:7];

    logic [2:0] idx;

    initial begin
        ref_i[0] = 16'sd100;  ref_q[0] = 16'sd0;
        ref_i[1] = 16'sd70;   ref_q[1] = 16'sd70;
        ref_i[2] = 16'sd0;    ref_q[2] = 16'sd100;
        ref_i[3] = -16'sd70;  ref_q[3] = 16'sd70;
        ref_i[4] = -16'sd100; ref_q[4] = 16'sd0;
        ref_i[5] = -16'sd70;  ref_q[5] = -16'sd70;
        ref_i[6] = 16'sd0;    ref_q[6] = -16'sd100;
        ref_i[7] = 16'sd70;   ref_q[7] = -16'sd70;
    end

    // Complex multiply: (i_in + j*q_in) * (ref_i - j*ref_q)  [conjugate for dechirp]
    always_ff @(posedge clk) begin
        if (rst) begin
            idx       <= 3'd0;
            i_out     <= 16'sd0;
            q_out     <= 16'sd0;
            valid_out <= 1'b0;
        end
        else if (valid_in) begin
            i_out     <= ( (i_in * ref_i[idx]) + (q_in * ref_q[idx]) ) >>> 8;
            q_out     <= ( (q_in * ref_i[idx]) - (i_in * ref_q[idx]) ) >>> 8;
            valid_out <= 1'b1;
            idx       <= idx + 3'd1;
        end
        else begin
            valid_out <= 1'b0;
        end
    end

endmodule
