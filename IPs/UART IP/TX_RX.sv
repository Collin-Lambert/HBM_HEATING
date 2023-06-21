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


module TX_RX(
    input wire clk,
    input wire USB_UART_RX,
    output logic USB_UART_TX,
    output logic [2:0] read_write,
    output logic address_inc,
    output logic start,
    output logic [31:0] port_mask
    );
    
    logic [8:0] counter;
    logic reset;
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
    
    
    logic [7:0] din_temp;
<<<<<<< HEAD
    logic [31:0] port_mask_temp;
    logic send_async, start_async, stop_async, read_async, write_async, rw_async, qr_async, reset_state_machine;
    logic qw_async, address_inc_async, address_static_async, port_select, enable_port_select, disable_port_select;  
    logic bytes_received_inc, output_port_mask;
    logic [3:0] bytes_received;
=======
    logic send_async, start_async, stop_async, read_async, write_async, rw_async;  
>>>>>>> b29fe04f2901e3a7bb2196c344df2acd025f04df
    
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
<<<<<<< HEAD
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
                end
            if (output_port_mask)
                begin
                    port_mask <= port_mask_temp;
                    bytes_received <= 0;
                end
=======
>>>>>>> b29fe04f2901e3a7bb2196c344df2acd025f04df
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
            if (req)
                begin
                if (RX_OUT == 'h39 || port_select) //Port Select
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
                else if (RX_OUT == 'h40) //RESET
                    begin
                        reset_state_machine = 1;
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
<<<<<<< HEAD
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
=======
>>>>>>> b29fe04f2901e3a7bb2196c344df2acd025f04df
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
