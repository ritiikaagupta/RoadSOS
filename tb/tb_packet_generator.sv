`timescale 1ns/1ps

module tb_packet_generator;

    logic [7:0]  header;
    logic [7:0]  event_id;
    logic [15:0] vehicle_id;

    logic [47:0] packet;

    packet_generator dut (

        .header(header),
        .event_id(event_id),
        .vehicle_id(vehicle_id),
        .packet(packet)

    );

    initial begin

        // Test case
        header     = 8'hA5;
        event_id   = 8'h01;
        vehicle_id = 16'h0017;

        #10;

        $display("--------------------------------");
        $display("PACKET GENERATOR TEST");
        $display("--------------------------------");

        $display("Header     = %h", header);
        $display("Event ID   = %h", event_id);
        $display("Vehicle ID = %h", vehicle_id);
        $display("Packet     = %h", packet);

        if (packet == 48'hA50100178715) begin
            $display("RESULT: PASS");
        end
        else begin
            $display("RESULT: FAIL");
        end

        $display("--------------------------------");

        $finish;

    end

endmodule
