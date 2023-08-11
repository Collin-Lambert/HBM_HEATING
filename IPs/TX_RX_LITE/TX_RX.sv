`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: Collin Lambert
// 
// Create Date: 05/30/2023 12:39:15 PM
// Design Name: 
// Module Name: TX_RX_LITE
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
typedef enum logic [6:0] {WAIT, TEMPERATURE_SEND} state;






module TX_RX_LITE(
    input wire clk,
    input wire USB_UART_RX,
    
    input wire [6:0] hbm_temperature,
    
    output logic USB_UART_TX,
    output logic start
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
    logic send_async, start_async, stop_async, reset_state_machine;
    
    //Intermediary signals
    logic [7:0] din_temp;
    
    logic fsm_active;
    
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
            
            if (reset_state_machine)
                begin
                    start <= 0;
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
            reset_state_machine = 0;
            reset = 0;
            fsm_active = 1;
            
            
            
            ns = WAIT;
            
            case (cs)
                WAIT:
                    begin
                        fsm_active = 0;
                        
                        if (req && RX_OUT == 'h2F) //POLL TEMPERATURE
                            begin
                                ns = TEMPERATURE_SEND;
                                ack = 1;
                            end
                        else
                            ns = cs;
                    end
                
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
                        din_temp = 'h52; //Signal that the terminal is interacting with the RO heater instead of the HBM
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
                ack = 1;      
                end
        end
    

endmodule