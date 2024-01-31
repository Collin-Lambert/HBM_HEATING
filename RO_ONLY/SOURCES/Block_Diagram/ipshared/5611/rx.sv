`timescale 1ns / 1ps

/***************************************************************************
*
* Module: rx
*
* Author: Collin Lambert
* Class: ECEN 220, Section 1, Spring 2022
* Date: June 8, 2022
*
* Description: A UART receiver module
*
*
****************************************************************************/


module rx(
        input wire logic clk,
        input wire logic Reset,
        input wire logic Sin,
        input wire logic Received,
        output logic Receive,
        output logic [7:0] Dout,
        output logic parityErr
    );
    
    typedef enum logic [2:0] {IDLE, SYNC, SHIFT, ACK, HANDSHAKE} state;
    state ns, cs;
    
    //Declaration of baud timer and related signals
    logic clrTimer;
    logic timerDone;
    logic timerHalfDone;
    BaudTimer timer (.clk(clk), .clrTimer(clrTimer), .timerDone(timerDone), .timerHalfDone(timerHalfDone));
    
    //Declaration of bit counter and related signals
    logic clrBit;
    logic incBit;
    logic bitDone;
    BitCounter_RX counter (.clk(clk), .clrBit(clrBit), .inc(incBit), .bitDone(bitDone));
    
    //Other signals
    logic shift;
    logic [9:0] shiftRegister;
    logic parity; //Signal to tell the error checker what the parity should be
    logic observedParity; //The parity of the received signal
    
    //State Machine
    always_comb
        begin
        clrTimer = 0;
        clrBit = 0;
        incBit = 0;
        shift = 0;
        Receive = 0;
        parity = 0;
        ns = IDLE;
            if (Reset)
                begin
                    ns = IDLE;
                    clrTimer = 1;
                    clrBit = 1;
                end
            else
                case (cs)
                    IDLE:
                        begin
                        clrBit = 1;
                        clrTimer = 1;
                            if (Sin)
                                ns = IDLE;
                            else
                                ns = SYNC;
                        end
                    SYNC:
                        begin
                            if (timerHalfDone)
                                begin
                                    clrTimer = 1;
                                    clrBit = 1;
                                    ns = SHIFT;
                                end
                            else
                                ns = SYNC;
                        end
                    SHIFT:
                        begin
                            if (timerDone & !bitDone)
                                begin
                                    incBit = 1;
                                    shift = 1;
                                    ns = SHIFT;
                                end
                            else if (!timerDone)
                                ns = SHIFT;
                            else if (timerDone & bitDone)
                                begin
                                    shift = 1;
                                    ns = ACK;
                                end
                        end
                    ACK:
                        begin
                            parity = shiftRegister[8];
                            Receive = 1;
                            if (Received)
                                ns = HANDSHAKE;
                            else
                                ns = ACK;
                        end
                    HANDSHAKE:
                        begin
                            if (Received)
                                ns = HANDSHAKE;
                            else
                                ns = IDLE;
                        end
               endcase
        end
        
    //Error checker
    always_comb
        begin
            observedParity = ~^Dout[7:0];
            if (observedParity == parity)
                parityErr = 0;
            else
                parityErr = 1;
        end
        
    //Dout
    assign Dout = shiftRegister [7:0];
        
    always_ff @(posedge clk)
    begin
        cs <= ns;
        if (shift)
            begin
                shiftRegister <= {Sin, shiftRegister [9:1]};
            end
    end
    
endmodule
