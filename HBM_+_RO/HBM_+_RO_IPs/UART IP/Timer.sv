`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/30/2023 03:14:22 PM
// Design Name: 
// Module Name: Timer
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


module Timer #(parameter length = 10000) (
        input wire clk,
        input wire enable,
        output logic done
    );
    
    logic [23:0] counter;
    
    always_ff @(posedge clk)
        begin
        done <= 0;
            if (!enable)
                begin
                    counter <= 0;
                end
            else if (counter != length)
                begin
                    counter <= counter + 1;
                end
            else if (counter == length)
                begin
                    done <= 1;
                end
        end
endmodule
