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
    output logic start
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
    logic send_async, start_async, stop_async, read_async, write_async, rw_async;  
    
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
        end
        
    always_comb
        begin
            din_temp = 8'b00111111; //ERR
            send_async = 0;
            ack = 0;
            start_async = 0;
            stop_async = 0;
            write_async = 0;
            read_async = 0;
            rw_async = 0;
            if (req)
                begin
                if (RX_OUT == 8'b00110000) //Start Command
                    begin
                        din_temp = 8'b01000001;
                        send_async = 1;
                        start_async = 1;
                    end  
                else if (RX_OUT == 8'b00110001) //Stop Command
                    begin
                        din_temp = 8'b01000010;
                        send_async = 1;
                        stop_async = 1;
                    end  
                else if (RX_OUT == 8'b00110010) //Write_set Command
                    begin
                        din_temp = 8'b01000011;
                        send_async = 1;
                        write_async = 1;
                    end     
                else if (RX_OUT == 8'b00110011) //Read_set Command
                    begin
                        din_temp = 8'b01000100;
                        send_async = 1;
                        read_async = 1;
                    end 
                else if (RX_OUT == 8'b00110100) //READ / WRITE Command
                    begin
                        din_temp = 8'b01000101;
                        send_async = 1;
                        rw_async = 1;
                    end
                ack = 1;      
                end
            else
                send_async <= 0;
        end
    
endmodule
