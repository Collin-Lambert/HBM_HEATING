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
typedef enum logic [6:0] {WAIT, SAMPLE_INIT, SAMPLE, TX_1, TX_2, TX_3, TX_4, CHECK,

                         CLK_650_CONFIG, CLK_450_CONFIG, CLK_325_CONFIG, CLK0_0, CLK0_1, CLK1_0, CLK1_1,
                         DIV_CLK, CLKFB_1, CLKFB_2, LOCK_1, LOCK_2, LOCK_3, FILTER_1, FILTER_2, RECONFIG, LOCK_WAIT,
                         
                         BYTE_0, BYTE_0_WAIT, BYTE_1, BYTE_1_WAIT, BYTE_2, BYTE_2_WAIT, BYTE_3, BYTE_3_WAIT, SET_PORTS,
                         
                         LENGTH_RECEIVE, LENGTH_SET,
                         
                         TEMPERATURE_SEND} state;






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
    
    input wire clk_locked,
    input wire transaction_complete,
    
    input wire [6:0] hbm_temperature,
    
    output logic USB_UART_TX,
    output logic [2:0] read_write,
    output logic address_inc,
    output logic start,
    output logic [31:0] port_mask,
    output logic [3:0] length,
    output logic transaction_counter_ena,
    output logic transact,
    output logic [10:0] clk_addr,
    output logic [31:0] clk_data
    );
    
    state ns, cs;
    
    
    
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
    
    //Length Select Signals
    logic output_length;
    
    //Port Select Signals 
    logic port_mask_set, output_port_mask;
    
    //Data Rate Sampling Signals
    logic sample_start_async, sample_timer_ena, sample_timer_done, timer_10ths_ena, timer_10ths_done;
    logic transmission_inc, transmission_count_rst, transaction_counter_rst;
    
    //Clock Reconfiguration Signals
    logic clk_650_config, clk_450_config, clk_325_config;
    logic [15:0] clk0_0, clk0_1, clk1_0, clk1_1, div_clk, clkfb_1, clkfb_2, lock_1, lock_2, lock_3, filter_1, filter_2;
    
    logic fsm_active;
    
    //More Sampling Signals
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
            if (port_mask_set)
                begin
                    port_mask_temp <= {port_mask_temp[23 : 0], RX_OUT};
                end
            if (reset_state_machine)
                begin
                    port_mask <= 0;
                    port_mask_temp <= 0;
                    start <= 0;
                    length <= 15;
                    transmission_count <= 0;
                    
                    clk0_0 <= 'h1041;
                    clk0_1 <= 'h0000;
                    clk1_0 <= 'h1105;
                    clk1_1 <= 'h0080;
                    
                    div_clk <= 'h1041;
                    
                    clkfb_1 <= 'h1105;
                    clkfb_2 <= 'h0080;
                    
                    lock_1 <= 'h03E8;
                    lock_2 <= 'h6401;
                    lock_3 <= 'h67E9;
                    
                    filter_1 <= 'h0900;
                    filter_2 <= 'h1890;
                end
            if (output_port_mask)
                begin
                    port_mask <= port_mask_temp;
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
            if (clk_650_config)
                begin
                    clk0_0 <= 'h1041;
                    clk0_1 <= 'h0000;
                    clk1_0 <= 'h1105;
                    clk1_1 <= 'h0080;
                    
                    div_clk <= 'h1041;
                    
                    clkfb_1 <= 'h1187;
                    clkfb_2 <= 'h0080;
                    
                    lock_1 <= 'h02EE;
                    lock_2 <= 'h7C01;
                    lock_3 <= 'h7FE9;
                    
                    filter_1 <= 'h0900;
                    filter_2 <= 'h8890;
                end
            if (clk_450_config)
                begin
                    clk0_0 <= 'h1041;
                    clk0_1 <= 'h0000;
                    clk1_0 <= 'h1105;
                    clk1_1 <= 'h0080;
                    
                    div_clk <= 'h1041;
                    
                    clkfb_1 <= 'h1105;
                    clkfb_2 <= 'h0080;
                    
                    lock_1 <= 'h03E8;
                    lock_2 <= 'h6401;
                    lock_3 <= 'h67E9;
                    
                    filter_1 <= 'h0900;
                    filter_2 <= 'h1890;
                end
            if (clk_325_config)
                begin
                    clk0_0 <= 'h1082;
                    clk0_1 <= 'h0000;
                    clk1_0 <= 'h1249;
                    clk1_1 <= 'h0000;
                    
                    div_clk <= 'h1041;
                    
                    clkfb_1 <= 'h1187;
                    clkfb_2 <= 'h0080;
                    
                    lock_1 <= 'h02EE;
                    lock_2 <= 'h7C01;
                    lock_3 <= 'h7FE9;
                    
                    filter_1 <= 'h0900;
                    filter_2 <= 'h8890;
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
            reset_state_machine = 0;
            output_port_mask = 0;
            output_length = 0;
            sample_start_async = 0;
            transmission_inc = 0;
            transmission_count_rst = 0;
            transaction_counter_ena = 0;
            transaction_counter_rst = 1;
            timer_10ths_ena = 0;
            sample_timer_ena = 0;
            reset = 0;
            port_mask_set = 0;
            fsm_active = 1;
            
            clk_650_config = 0;
            clk_450_config = 0;
            clk_325_config = 0;
            clk_addr = 'h0;
            clk_data = 'h0000;
            transact = 0;
            
            
            
            ns = WAIT;
            
            case (cs)
                WAIT:
                    begin
                        fsm_active = 0;
                        
                        if (req && RX_OUT == 'h3B) //SAMPLE
                            begin
                                ns = SAMPLE_INIT;
                                din_temp = 'h4D;
                                send_async = 1;
                                ack = 1; 
                            end
                        else if (req && RX_OUT == 'h3C) //SET CLK to 650 MHz
                            begin
                                ns = CLK_650_CONFIG;
                                din_temp = 'h4E;
                                send_async = 1;
                                ack = 1; 
                            end
                            
                        else if (req && RX_OUT == 'h3D) //SET CLK to 450 MHz
                            begin
                                ns = CLK_450_CONFIG;
                                din_temp = 'h4F;
                                send_async = 1;
                                ack = 1; 
                            end
                            
                        else if (req && RX_OUT == 'h3E) //SET CLK to 325 MHz
                            begin
                                ns = CLK_325_CONFIG;
                                din_temp = 'h50;
                                send_async = 1;
                                ack = 1; 
                            end
                            
                        else if (req && RX_OUT == 'h39) //PORT SELECT
                            begin
                                ns = BYTE_0;
                                ack = 1; 
                            end
                        else if (req && RX_OUT == 'h3A) //LENGTH SELECT
                            begin
                                ns = LENGTH_SET;
                                ack = 1; 
                            end
                        else if (req && RX_OUT == 'h2F) //POLL TEMPERATURE
                            begin
                                ns = TEMPERATURE_SEND;
                                ack = 1;
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
                    
                ////////////////////////////////////////////////////////////////////////////////    
                    

                BYTE_0:
                    begin
                        if (req)
                            begin
                                port_mask_set = 1;
                                ns = BYTE_0_WAIT;
                            end
                        else
                            ns = cs;
                    end
                BYTE_0_WAIT:
                    begin
                        ack = 1; 
                        if (!req)
                            ns = BYTE_1;
                        else
                            ns = cs;
                    end 
                BYTE_1:
                    begin
                        if (req)
                            begin
                                port_mask_set = 1;
                                ns = BYTE_1_WAIT;
                            end
                        else
                            ns = cs;
                    end
                BYTE_1_WAIT:
                    begin
                        ack = 1; 
                        if (!req)
                            ns = BYTE_2;
                        else
                            ns = cs;
                    end 
                BYTE_2:
                    begin
                        if (req)
                            begin
                                port_mask_set = 1;
                                ns = BYTE_2_WAIT;
                            end
                        else
                            ns = cs;
                    end
                BYTE_2_WAIT:
                    begin
                        ack = 1; 
                        if (!req)
                            ns = BYTE_3;
                        else
                            ns = cs;
                    end 
                BYTE_3:
                    begin
                        if (req)
                            begin
                                port_mask_set = 1;
                                ns = BYTE_3_WAIT;
                            end
                        else
                            ns = cs;
                    end
                BYTE_3_WAIT:
                    begin
                        ack = 1; 
                        if (!req)
                            ns = SET_PORTS;
                        else
                            ns = cs;
                    end 
                SET_PORTS:
                    begin
                        din_temp = 'h4A;
                        send_async = 1;
                        ns = WAIT;
                        output_port_mask = 1;
                    end
                    
                    
                ////////////////////////////////////////////////////////////////////////////
                

                CLK_650_CONFIG:
                    begin
                        clk_650_config = 1;
                        ns = CLK0_0;
                    end
                CLK_450_CONFIG:
                    begin
                        clk_450_config = 1;
                        ns = CLK0_0;
                    end
                CLK_325_CONFIG:
                    begin
                        clk_325_config = 1;
                        ns = CLK0_0;
                    end
                CLK0_0:
                    begin
                        clk_addr = 'h304;
                        clk_data = clk0_0;
                        transact = 1;
                        
                        if (transaction_complete)
                            begin
                                transact = 0;
                                ns = CLK0_1;
                            end
                        else
                            ns = cs;
                    end
                CLK0_1:
                    begin
                        clk_addr = 'h308;
                        clk_data = clk0_1;
                        transact = 1;
                        
                        if (transaction_complete)
                            begin
                                transact = 0;
                                ns = CLK1_0;
                            end
                        else
                            ns = cs;
                    end
                CLK1_0:
                    begin
                        clk_addr = 'h30C;
                        clk_data = clk1_0;
                        transact = 1;
                        
                        if (transaction_complete)
                            begin
                                transact = 0;
                                ns = CLK1_1;
                            end
                        else
                            ns = cs;
                    end
                CLK1_1:
                    begin
                        clk_addr = 'h310;
                        clk_data = clk1_1;
                        transact = 1;
                        
                        if (transaction_complete)
                            begin
                                transact = 0;
                                ns = DIV_CLK;
                            end
                        else
                            ns = cs;
                    end
                DIV_CLK:
                    begin
                        clk_addr = 'h33C;
                        clk_data = div_clk;
                        transact = 1;
                        
                        if (transaction_complete)
                            begin
                                transact = 0;
                                ns = CLKFB_1;
                            end
                        else
                            ns = cs;
                    end
                CLKFB_1:
                    begin
                        clk_addr = 'h340;
                        clk_data = clkfb_1;
                        transact = 1;
                        
                        if (transaction_complete)
                            begin
                                transact = 0;
                                ns = CLKFB_2;
                            end
                        else
                            ns = cs;
                    end
                CLKFB_2:
                    begin
                        clk_addr = 'h344;
                        clk_data = clkfb_2;
                        transact = 1;
                        
                        if (transaction_complete)
                            begin
                                transact = 0;
                                ns = LOCK_1;
                            end
                        else
                            ns = cs;
                    end
                LOCK_1:
                    begin
                        clk_addr = 'h348;
                        clk_data = lock_1;
                        transact = 1;
                        
                        if (transaction_complete)
                            begin
                                transact = 0;
                                ns = LOCK_2;
                            end
                        else
                            ns = cs;
                    end
                LOCK_2:
                    begin
                        clk_addr = 'h34C;
                        clk_data = lock_2;
                        transact = 1;
                        
                        if (transaction_complete)
                            begin
                                transact = 0;
                                ns = LOCK_3;
                            end
                        else
                            ns = cs;
                    end
                LOCK_3:
                    begin
                        clk_addr = 'h350;
                        clk_data = lock_3;
                        transact = 1;
                        
                        if (transaction_complete)
                            begin
                                transact = 0;
                                ns = FILTER_1;
                            end
                        else
                            ns = cs;
                    end
                FILTER_1:
                    begin
                        clk_addr = 'h354;
                        clk_data = filter_1;
                        transact = 1;
                        
                        if (transaction_complete)
                            begin
                                transact = 0;
                                ns = FILTER_2;
                            end
                        else
                            ns = cs;
                    end
                FILTER_2:
                    begin
                        clk_addr = 'h358;
                        clk_data = filter_2;
                        transact = 1;
                        
                        if (transaction_complete)
                            begin
                                transact = 0;
                                ns = RECONFIG;
                            end
                        else
                            ns = cs;
                    end
                RECONFIG:
                    begin
                        clk_addr = 'h35C;
                        clk_data = 'h0003;
                        transact = 1;
                        
                        if (transaction_complete)
                            begin
                                transact = 0;
                                ns = LOCK_WAIT;
                            end 
                        else
                            ns = cs;
                    end
                LOCK_WAIT:
                    begin
                        if (clk_locked)
                            begin
                                ns = WAIT;
                            end
                        else
                            ns = cs;
                    end
                    
                ///////////////////////////////////////////////////////////////
                    
                LENGTH_SET:
                    begin
                        if (req)
                            begin
                                output_length = 1;
                                din_temp = 'h4C;
                                send_async = 1;
                                ack = 1; 
                                ns = WAIT; 
                            end
                        else
                            ns = cs;
                    end
                
                
                ///////////////////////////////////////////////////////////////
                
                TEMPERATURE_SEND:
                    begin
                        din_temp = {1'b0, hbm_temperature};
                        send_async = 1;
                        ns = WAIT;
                    end
            endcase
            
            
            if (req && !fsm_active)
                begin
                if (RX_OUT == 'h40) //RESET
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
                    
                ack = 1;      
                end
        end
    

endmodule