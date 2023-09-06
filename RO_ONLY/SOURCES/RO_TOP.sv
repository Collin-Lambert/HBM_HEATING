`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/04/2023 10:41:31 AM
// Design Name: 
// Module Name: RO_TOP
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


module RO_TOP(
    input wire SYS_CLK3_P,
    input wire SYS_CLK3_N,
    input wire USB_UART_RX,
    //output logic final_out,
    output logic USB_UART_TX
    );
    
//    logic [65535:0] out_0;
//    logic [65535:0] out_1;  
//    logic [65535:0] out_2;
    
    (* keep *) logic clk_out, enable_master, enable_0, enable_1, enable_2, enable_3, enable_4, enable_5;
      
    //assign final_out = (|out_0) | (|out_1) | (|out_2);
    (* keep *) LUT1 #(
        .INIT(2'b10)
    ) lut_enable_0 (
        .I0(enable_master),
        .O(enable_0)
    );
    
    (* keep *) LUT1 #(
        .INIT(2'b10)
    ) lut_enable_1 (
        .I0(enable_master),
        .O(enable_1)
    );
    
    (* keep *) LUT1 #(
        .INIT(2'b10)
    ) lut_enable_2 (
        .I0(enable_master),
        .O(enable_2)
    );
    
    (* keep *) LUT1 #(
        .INIT(2'b10)
    ) lut_enable_3 (
        .I0(enable_master),
        .O(enable_3)
    );
    
    (* keep *) LUT1 #(
        .INIT(2'b10)
    ) lut_enable_4 (
        .I0(enable_master),
        .O(enable_4)
    );
    
    (* keep *) LUT1 #(
        .INIT(2'b10)
    ) lut_enable_5 (
        .I0(enable_master),
        .O(enable_5)
    );
    
    // Instantiate the IBUFDS for differential clock input
    IBUFDS diff_clk (
      .O(clk_out),
      .I(SYS_CLK3_P),
      .IB(SYS_CLK3_N)
    );
      
    genvar i;
	generate
	   for (i = 0; i < 65536; i = i + 1) begin : RO
	       RO ro_0 (.enable(enable_0));
	       RO ro_1 (.enable(enable_1));
	       RO ro_2 (.enable(enable_2));
	       RO ro_3 (.enable(enable_3));
	       RO ro_4 (.enable(enable_4));
	       RO ro_5 (.enable(enable_5));
	   end
	endgenerate
	
	design_1 HBM (
	   .clk(clk_out),
	   .resetn(1),
	   .USB_UART_RX(USB_UART_RX),
	   .USB_UART_TX(USB_UART_TX),
	   .start(enable_master)
	   
	);
	
endmodule
