`timescale 1ns / 1ps
/***************************************************************************
*
* Module: tx
*
* Author: Collin Lambert
* Class: ECEN 220, Section 1, Spring 2022
* Date: June 1, 2022
*
* Description: A UART transmitter module
*
*
****************************************************************************/

typedef enum logic [2:0] {IDLE, START, BITS, PAR, STOP, ACK} State;

module tx(
    input wire logic clk,
    input wire logic Reset,
    input wire logic Send,
    input wire logic [7:0] Din,
    output logic Sent,
    output logic Sout
    );
    
    //Declaration of all internal logic signals
    logic startBit;
    logic dataBit;
    logic parityBit;
    logic [2:0] bitNum;
    logic clrTimer;
    logic clrBit;
    logic timerDone;
    logic bitDone;
    logic incBit;
    
    //Declaration of other modules, baud timer and bit counter
    BaudTimer timer (.timerDone(timerDone), .clrTimer(clrTimer), .clk(clk));
    BitCounter counter (.bitDone(bitDone), .count(bitNum), .inc(incBit), .clrBit(clrBit), .clk(clk));
    
    //Transmitter datapath
    always_ff @(posedge clk)
        if (startBit)
            Sout <= 0;
        else if (dataBit)
            Sout <= Din[bitNum];
        else if (parityBit)
            Sout <= ~^Din;
        else
            Sout <= 1;
            
    //This is the state machine / IFL
    State ns;
    State cs;
        
    always_comb
    begin
        startBit = 0;
        dataBit = 0;
        parityBit = 0;
        clrTimer = 0;
        clrBit = 0;
        incBit = 0;
        parityBit = 0;
        Sent = 0;
        ns = IDLE; 
        
        if (Reset)
        ns = IDLE;
        else
            case (cs)
                IDLE: 
                    begin
                        clrTimer = 1;
                        if (Send)
                            ns = START;
                        else
                            ns = IDLE;
                    end
                START:
                    begin
                        startBit = 1;
                        if (timerDone)
                            begin
                                ns = BITS;
                                clrBit = 1;
                            end
                        else
                            ns = START;
                    end
                BITS:
                    begin
                        dataBit = 1;
                        if (~timerDone)
                            ns = BITS;
                        else if (timerDone & ~bitDone)
                            begin
                                ns = BITS;
                                incBit = 1;
                            end
                        else
                        ns = PAR;
                    end
                PAR:
                    begin
                        parityBit = 1;
                        if (timerDone)
                            ns = STOP;
                        else
                            ns = PAR;
                    end
                STOP:
                    begin
                        if (timerDone)
                            ns = ACK;
                        else
                            ns = STOP;
                    end
                ACK:
                    begin
                        Sent = 1;
                        if (Send)
                            ns = ACK;
                        else
                            ns = IDLE;
                    end
            endcase            
    end
    
//flip-flop portion of state machine
always_ff @(posedge clk)
    cs <= ns;
       
endmodule
