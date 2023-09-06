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
  output logic clk_450
);

  logic clk_out;
  logic temp_rst;

  // Instantiate the IBUFDS for differential clock input
  IBUFDS diff_clk (
    .O(clk_out),
    .I(SYS_CLK3_P),
    .IB(SYS_CLK3_N)
  );
  
  

  top top_i (
    .clk(clk_out),
    .clk_uart(clk_out),
    .resetn(resetn),
    .USB_UART_RX(USB_UART_RX),
    .USB_UART_TX(USB_UART_TX),
    .clk_450(clk_450)
  );
  
endmodule
