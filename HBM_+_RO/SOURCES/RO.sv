`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2023 02:45:19 PM
// Design Name: 
// Module Name: RO
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


(* keep *) module RO(
        input wire enable
    );
    
    (* keep *) logic nand_out, not_1_out, not_2_out;
    //assign out = not_2_out;
    
    (* keep *) LUT6 #(
        .INIT(4'h7)
    ) nand_enable (
        .O(nand_out),
        .I0(enable),
        .I1(not_2_out),
        .I2(0),
        .I3(0),
        .I4(0),
        .I5(0)
    );
    
    (* keep *) LUT6 #(
        .INIT(2'b01)
    ) not_1 (
        .O(not_1_out),
        .I0(nand_out),
        .I1(0),
        .I2(0),
        .I3(0),
        .I4(0),
        .I5(0)
    );
    
    (* keep *) LUT6 #(
        .INIT(2'b01)
    ) not_2 (
        .O(not_2_out),
        .I0(not_1_out),
        .I1(0),
        .I2(0),
        .I3(0),
        .I4(0),
        .I5(0)
    );
    
    
endmodule
