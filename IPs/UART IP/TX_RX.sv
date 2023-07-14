`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: Collin Lambert
// 
// Create Date: 05/30/2023 12:39:15 PM
// Design Name: 
// Module Name: TX_RX
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
typedef enum logic [3:0] {WAIT, SAMPLE_INIT, SAMPLE, TX_1, TX_2, TX_3, TX_4, CHECK} sample_state;

module TX_RX(
    input wire clk,
    input wire USB_UART_RX,
    
    input wire transaction_trigger_0,
    input wire transaction_trigger_1,
    input wire transaction_trigger_2,
    input wire transaction_trigger_3,
    input wire transaction_trigger_4,
    input wire transaction_trigger_5,
    input wire transaction_trigger_6,
    input wire transaction_trigger_7,
    input wire transaction_trigger_8,
    input wire transaction_trigger_9,
    input wire transaction_trigger_10,
    input wire transaction_trigger_11,
    input wire transaction_trigger_12,
    input wire transaction_trigger_13,
    input wire transaction_trigger_14,
    input wire transaction_trigger_15,
    input wire transaction_trigger_16,
    input wire transaction_trigger_17,
    input wire transaction_trigger_18,
    input wire transaction_trigger_19,
    input wire transaction_trigger_20,
    input wire transaction_trigger_21,
    input wire transaction_trigger_22,
    input wire transaction_trigger_23,
    input wire transaction_trigger_24,
    input wire transaction_trigger_25,
    input wire transaction_trigger_26,
    input wire transaction_trigger_27,
    input wire transaction_trigger_28,
    input wire transaction_trigger_29,
    input wire transaction_trigger_30,
    input wire transaction_trigger_31,
    
    output logic USB_UART_TX,
    output logic [2:0] read_write,
    output logic address_inc,
    output logic start,
    output logic [31:0] port_mask,
    output logic [3:0] length,
    output logic transaction_counter_ena
    );
    
    sample_state ns, cs;
    
    
    
    logic reset;
    
    //TX / RX signals
    logic send_character;
    logic Sent;
    logic [7:0] din;
    logic req, ack, perr;
    logic[7:0] RX_OUT;
    
    
    //TX
    tx tx_inst (
        .clk(clk),
        .Din(din),
        .Send(send_character),
        .Reset(reset),
        .Sent(Sent),
        .Sout(USB_UART_TX)
    );
        
    
    //RX
    rx rx_inst(
        .clk(clk),
        .Reset(reset),
        .Sin(USB_UART_RX),
        .Receive(req),
        .Received(ack),
        .Dout(RX_OUT),
        .parityErr(perr)
    );
    
    //async signals
    logic send_async, start_async, stop_async, read_async, write_async, rw_async, qr_async, qw_async;
    logic address_inc_async, address_static_async, reset_state_machine;
    
    //Intermediary signals
    logic [7:0] din_temp;
    logic [31:0] port_mask_temp;
    
    //Port Select Signals
    logic port_select, enable_port_select, disable_port_select, bytes_received_inc, output_port_mask;  
    logic enable_length_select, disable_length_select, length_select, output_length;
    logic [3:0] bytes_received;
    
    //Data Rate Sampling Signals
    logic sample_start_async, sample_timer_ena, sample_timer_done, timer_10ths_ena, timer_10ths_done;
    logic transmission_inc, transmission_count_rst, transaction_counter_rst;
    
    
    Timer #(100000) sample_timer (.clk(clk), .enable(sample_timer_ena), .done(sample_timer_done));
    Timer #(10000000) timer_10ths (.clk(clk), .enable(timer_10ths_ena), .done(timer_10ths_done));
    
    logic [5:0] transmission_count;
    
    logic [31:0] transaction_triggers;
    
    assign transaction_triggers[0] = transaction_trigger_0;
    assign transaction_triggers[1] = transaction_trigger_1;
    assign transaction_triggers[2] = transaction_trigger_2;
    assign transaction_triggers[3] = transaction_trigger_3;
    assign transaction_triggers[4] = transaction_trigger_4;
    assign transaction_triggers[5] = transaction_trigger_5;
    assign transaction_triggers[6] = transaction_trigger_6;
    assign transaction_triggers[7] = transaction_trigger_7;
    assign transaction_triggers[8] = transaction_trigger_8;
    assign transaction_triggers[9] = transaction_trigger_9;
    assign transaction_triggers[10] = transaction_trigger_10;
    assign transaction_triggers[11] = transaction_trigger_11;
    assign transaction_triggers[12] = transaction_trigger_12;
    assign transaction_triggers[13] = transaction_trigger_13;
    assign transaction_triggers[14] = transaction_trigger_14;
    assign transaction_triggers[15] = transaction_trigger_15;
    assign transaction_triggers[16] = transaction_trigger_16;
    assign transaction_triggers[17] = transaction_trigger_17;
    assign transaction_triggers[18] = transaction_trigger_18;
    assign transaction_triggers[19] = transaction_trigger_19;
    assign transaction_triggers[20] = transaction_trigger_20;
    assign transaction_triggers[21] = transaction_trigger_21;
    assign transaction_triggers[22] = transaction_trigger_22;
    assign transaction_triggers[23] = transaction_trigger_23;
    assign transaction_triggers[24] = transaction_trigger_24;
    assign transaction_triggers[25] = transaction_trigger_25;
    assign transaction_triggers[26] = transaction_trigger_26;
    assign transaction_triggers[27] = transaction_trigger_27;
    assign transaction_triggers[28] = transaction_trigger_28;
    assign transaction_triggers[29] = transaction_trigger_29;
    assign transaction_triggers[30] = transaction_trigger_30;
    assign transaction_triggers[31] = transaction_trigger_31;
    
    
    
    reg [21:0] transaction_counts [0:31];
    
//    assign transaction_counts[0] = 'h30;
//    assign transaction_counts[1] = 'h31;
//    assign transaction_counts[2] = 'h32;
//    assign transaction_counts[3] = 'h33;
//    assign transaction_counts[4] = 'h34;
//    assign transaction_counts[5] = 'h35;
//    assign transaction_counts[6] = 'h36;
//    assign transaction_counts[7] = 'h37;
//    assign transaction_counts[8] = 'h38;
//    assign transaction_counts[9] = 'h39;
//    assign transaction_counts[10] = 'h3A;
//    assign transaction_counts[11] = 'h3B;
//    assign transaction_counts[12] = 'h3C;
//    assign transaction_counts[13] = 'h3D;
//    assign transaction_counts[14] = 'h3F;
//    assign transaction_counts[15] = 'h40;
//    assign transaction_counts[16] = 'h41;
//    assign transaction_counts[17] = 'h42;
//    assign transaction_counts[18] = 'h43;
//    assign transaction_counts[19] = 'h44;
//    assign transaction_counts[20] = 'h45;
//    assign transaction_counts[21] = 'h46;
//    assign transaction_counts[22] = 'h47;
//    assign transaction_counts[23] = 'h48;
//    assign transaction_counts[24] = 'h49;
//    assign transaction_counts[25] = 'h4A;
//    assign transaction_counts[26] = 'h4B;
//    assign transaction_counts[27] = 'h4C;
//    assign transaction_counts[28] = 'h4D;
//    assign transaction_counts[29] = 'h4E;
//    assign transaction_counts[30] = 'h4F;
//    assign transaction_counts[31] = 'h50;
   
    //Transaction counters
    genvar i;
	generate
	   for (i = 0; i < 32; i = i + 1) begin : transaction_counter_block
	       always_ff @(posedge transaction_triggers[i])
	           begin
	               if (transaction_counter_rst)
		              transaction_counts[i] <= 0;
	               else if (transaction_counter_ena)
		              transaction_counts[i] <= transaction_counts[i] + 1;
	           end
	   end
	endgenerate
    
    always_ff @(posedge clk)
        begin
            send_character <= 0;
            if (send_async)
                begin
                    din <= din_temp;
                    send_character <= 1;
                end
            if (start_async)
                start <= 1;
            if (stop_async)
                start <= 0;
            if (read_async)
                read_write <= 0;
            if (write_async)
                read_write <= 1;
            if (rw_async)
                read_write <= 2;
            if (qr_async)
                read_write <= 3;
            if (qw_async)
                read_write <= 4;
            if (address_inc_async)
                address_inc <= 1;
            if (address_static_async)
                address_inc <= 0;
            if (enable_port_select)
                port_select <= 1;
            if (disable_port_select)
                begin
                    port_select <= 0;
                end
            if (bytes_received_inc)
                begin
                    bytes_received <= bytes_received + 1;
                    port_mask_temp <= {port_mask_temp[23 : 0], RX_OUT};
                end
            if (reset_state_machine)
                begin
                    bytes_received <= 0;
                    port_mask <= 0;
                    port_select <= 0;
                    port_mask_temp <= 0;
                    port_select <= 0;
                    start <= 0;
                    length_select <= 0;
                    length <= 15;
                    transmission_count <= 0;
                end
            if (output_port_mask)
                begin
                    port_mask <= port_mask_temp;
                    bytes_received <= 0;
                end
            if (enable_length_select && !disable_length_select)
                begin
                    length_select <= 1;
                end
            if (disable_length_select)
                begin
                    length_select <= 0;
                end
            if (output_length)
                begin
                    length <= RX_OUT[3:0];
                end
            if (transmission_inc && !transmission_count_rst)
                begin
                    transmission_count <= transmission_count + 1;
                end
            if (transmission_count_rst)
                begin
                    transmission_count <= 0;
                end
                
            cs <= ns;
        end
        
    
        
    always_comb
        begin
            din_temp = 'h3F; //ERR
            send_async = 0;
            ack = 0;
            start_async = 0;
            stop_async = 0;
            write_async = 0;
            read_async = 0;
            rw_async = 0;
            qr_async = 0;
            qw_async = 0;
            address_inc_async = 0;
            address_static_async = 0;
            enable_port_select = 0;
            disable_port_select = 0;
            bytes_received_inc = 0;
            reset_state_machine = 0;
            output_port_mask = 0;
            enable_length_select = 0;
            disable_length_select = 0;
            output_length = 0;
            sample_start_async = 0;
            transmission_inc = 0;
            transmission_count_rst = 0;
            transaction_counter_ena = 0;
            transaction_counter_rst = 1;
            timer_10ths_ena = 0;
            sample_timer_ena = 0;
            reset = 0;
            
            
            ns = WAIT;
            
            case (cs)
                WAIT:
                    begin
                        if (req && RX_OUT == 'h3B && !length_select && !port_select)
                            begin
                                ns = SAMPLE_INIT;
                                din_temp = 'h4D;
                                send_async = 1;
                            end
                        else
                            ns = cs;
                    end
                SAMPLE_INIT:
                	begin
                		transaction_counter_ena = 1;
                		timer_10ths_ena = 1;
                		if (timer_10ths_done)
                			ns = SAMPLE;
                		else
                			ns = cs;
                	end
               	SAMPLE:
               		begin
               			transaction_counter_ena = 1;
               			transaction_counter_rst = 0;
               			sample_timer_ena = 1;
               			if (sample_timer_done)
               				ns = TX_1;
               			else
               				ns = cs;
               		end
                TX_1:
                    begin
                        din_temp = transaction_counts[transmission_count][7:0];
                        transaction_counter_rst = 0;
                        send_async = 1;
                        ns = TX_2;
                    end
                TX_2:
                    begin
                        transaction_counter_rst = 0;
                        if (Sent)
                            begin
                                din_temp = transaction_counts[transmission_count][15:8];
                                send_async = 1;
                                ns = TX_3;
                            end
                        else
                            ns = cs;
                    end
                TX_3:
                    begin
                        transaction_counter_rst = 0;
                        if (Sent)
                            begin
                                din_temp = {2'b00, transaction_counts[transmission_count][21:16]};
                                send_async = 1;
                                ns = TX_4;
                            end
                        else
                            ns = cs;
                    end
                TX_4:
                    begin
                        transaction_counter_rst = 0;
                        if (Sent)
                            begin
                                //din_temp = transaction_counts[transmission_count][31:24];
                                din_temp = 8'h00;
                                send_async = 1;
                                ns = CHECK;
                            end
                        else
                            ns = cs;
                    end
                CHECK:  
                    begin
                        transaction_counter_rst = 0;
                        if (Sent)
                            begin
                                transmission_inc = 1;
                                if (transmission_count == 31)
                                    begin
                                        ns = WAIT;
                                        transmission_count_rst = 1;
                                    end
                                else
                                    ns = TX_1;
                            end
                        else
                            ns = CHECK;
                    end
            endcase
            
            if (req)
                begin
                if ((RX_OUT == 'h39 || port_select) && !length_select) //Port Select
                    begin
                        enable_port_select = 1;
                        if (port_select)
                            begin
                                if (bytes_received < 4)
                                    begin
                                        bytes_received_inc = 1;
                                    end
                            end
                    end
                else if (RX_OUT == 'h3A || length_select) //axi_len
                    begin
                        enable_length_select = 1;
                        if (length_select)
                            begin
                                output_length = 1;
                                din_temp = 'h4C;
                                send_async = 1;
                                disable_length_select = 1;
                            end
                    end
                else if (RX_OUT == 'h40) //RESET
                    begin
                        reset_state_machine = 1;
                        din_temp = 'h4B;
                        send_async = 1;
                    end
                else if (RX_OUT == 'h30) //Start Command
                    begin
                        din_temp = 'h41;
                        send_async = 1;
                        start_async = 1;
                    end  
                else if (RX_OUT == 'h31) //Stop Command
                    begin
                        din_temp = 'h42;
                        send_async = 1;
                        stop_async = 1;
                    end  
                else if (RX_OUT == 'h32) //Write_set Command
                    begin
                        din_temp = 'h43;
                        send_async = 1;
                        write_async = 1;
                    end     
                else if (RX_OUT == 'h33) //Read_set Command
                    begin
                        din_temp = 'h44;
                        send_async = 1;
                        read_async = 1;
                    end 
                else if (RX_OUT == 'h34) //READ / WRITE Command
                    begin
                        din_temp = 'h45;
                        send_async = 1;
                        rw_async = 1;
                    end
                else if (RX_OUT == 'h35) //Queued Read
                    begin
                        din_temp = 'h46;
                        send_async = 1;
                        qr_async = 1;
                    end
                else if (RX_OUT == 'h36) //Queued Write
                    begin
                        din_temp = 'h47;
                        send_async = 1;
                        qw_async = 1;
                    end
                else if (RX_OUT == 'h37) //Enable address_increment
                    begin
                        din_temp = 'h48;
                        send_async = 1;
                        address_inc_async = 1;
                    end
                else if (RX_OUT == 'h38) //Disable address_increment
                    begin
                        din_temp = 'h49;
                        send_async = 1;
                        address_static_async = 1;
                    end
//                else if (RX_OUT == 'h3B) //Get Throughput
//                    begin
//                        din_temp = 'h4D;
//                        send_async = 1;
//                        sample_start_async = 1;
//                    end
                ack = 1;      
                end
            else
                begin
                    if (bytes_received == 4)
                       begin
                            din_temp = 'h4A;
                            enable_port_select = 0;
                            disable_port_select = 1;
                            send_async = 1;
                            output_port_mask = 1;
                        end
                end
        end
    

endmodule