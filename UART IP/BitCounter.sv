`timescale 1ns / 1ps

/***************************************************************************
*
* Module: BitCounter
*
* Author: Collin Lambert
* Class: ECEN 220, Section 1, Spring 2022
* Date: June 1, 2022
*
* Description: A counter to count the number of bits per packet
*
*
****************************************************************************/



module BitCounter(
    input wire logic clk, 
    input wire logic clrBit,
    input wire logic inc,
    output logic bitDone,
    output logic [2:0] count
    );
    
    always_ff @(posedge clk)
        begin
            if (clrBit)
            begin
                count <= 0;
                bitDone <= 0;
            end
            if (count == 3'b111)
                    bitDone <= 1;
            else if (inc)
                begin
                    bitDone <= 0;
                    count <= count + 1;    
                end
            else
                bitDone <= 0;
        end
endmodule