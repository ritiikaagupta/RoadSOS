`timescale 1ns/1ps
module tb_uart_bridge;
    logic clk=0,rst=1,trigger=0,rx_line;
    logic [7:0] event_id=8'h02;
    logic uart_tx,busy,tx_done;
    logic [47:0] packet_out;
    logic packet_valid,crc_pass,crc_done;
    logic [7:0] rx_event; logic [15:0] rx_vehicle;
    logic alert,err,activity;
    always #5 clk=~clk;
    tx_top_module #(.VEHICLE_ID(16'h0017)) tx(.clk(clk),.rst(rst),.emergency_trigger(trigger),.event_id(event_id),.uart_tx(uart_tx),.busy(busy),.tx_done(tx_done),.debug_event_id(),.debug_vehicle_id());
    rx_top_module rx(.clk(clk),.rst(rst),.uart_rx(uart_tx),.packet_out(packet_out),.packet_valid(packet_valid),.crc_pass(crc_pass),.crc_done(crc_done),.event_id(rx_event),.vehicle_id(rx_vehicle),.emergency_alert(alert),.frame_error(err),.uart_activity(activity));
    initial begin
        $dumpfile("tb_uart_bridge.vcd"); $dumpvars(0,tb_uart_bridge);
        #100; rst=0; #100; trigger=1; #10; trigger=0;
        wait(alert); $display("PASS packet=%h event=%h vehicle=%h crc_pass=%b",packet_out,rx_event,rx_vehicle,crc_pass);
        #1000; $finish;
    end
endmodule
