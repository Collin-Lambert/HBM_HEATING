`timescale 1 ps / 1 ps

//////////////////////////////////////////////////////////////////////////////////
// Company: Brigham Young University
// Engineer: Collin Lambert
// 
// Create Date: 06/29/23
// Design Name: 
// Module Name: Traffic_Generator_top
// Project Name: HBM_HEATING
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

module Traffic_Generator_top (
  input wire SYS_CLK3_P,
  input wire SYS_CLK3_N,
  input wire resetn,
  input wire USB_UART_RX,
  output logic USB_UART_TX,
  output logic ro_out
);

  logic clk_out;
  logic temp_rst;
  logic ro_start;

  // Instantiate the IBUFDS for differential clock input
  IBUFDS diff_clk (
    .O(clk_out),
    .I(SYS_CLK3_P),
    .IB(SYS_CLK3_N)
  );
  
  //logic [9:0] out_0;
  logic [65535:0] out_0;
  logic [65535:0] out_1;  
//  logic [65535:0] out_2;
//  logic [65535:0] out_3;  
//  logic [65535:0] out_4;
  logic clk_450;
  
  assign ro_out = (|out_0) | (|out_1);
  //assign ro_out = |out_0;
  
  genvar i;
	generate
	   //65536
	   for (i = 0; i < 65536; i = i + 1) begin : RO_0
	       RO ro_0 (.enable(ro_start), .out(out_0[i]));
	       RO ro_1 (.enable(ro_start), .out(out_1[i]));
//	       RO ro_2 (.enable(ro_start), .out(out_2[i]));
//	       RO ro_3 (.enable(ro_start), .out(out_3[i]));
//	       RO ro_4 (.enable(ro_start), .out(out_4[i]));
	   end
	endgenerate
  

  top top_i (
    .clk(clk_out),
    .clk_uart(clk_out),
    .resetn(resetn),
    .USB_UART_RX(USB_UART_RX),
    .USB_UART_TX(USB_UART_TX),
    .clk_450(clk_450),
    .start(ro_start)
  );
  
endmodule
