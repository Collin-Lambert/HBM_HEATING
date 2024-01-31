`timescale 1ns / 1ps

/***************************************************************************
*
* Module: BaudTimer
*
* Author: Collin Lambert
* Class: ECEN 220, Section 1, Spring 2022
* Date: June 1, 2022
*
* Description: A timer to divide the clock into the correct Baud rate
*
*
****************************************************************************/



module BaudTimer(
    input wire logic clk, 
    input wire logic clrTimer,
    output logic timerDone,
    output logic timerHalfDone
    );
    
    logic [12:0] count;
    
    always_ff @(posedge clk)
    begin
        if (clrTimer)
            count <= 0;
        else
            begin
                if (count == 5208)
                    begin
                        count <= 0;
                        timerDone <= 1;
                        timerHalfDone <= 0;
                    end
                else if (count == 2604)
                    begin
                        timerHalfDone <= 1;
                        count <= count + 1;
                    end
                else
                    begin
                        timerDone <= 0;
                        timerHalfDone <= 0;
                        count <= count + 1;
                    end    
            end    
    end
endmodule