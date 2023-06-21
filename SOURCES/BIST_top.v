`timescale 1 ps / 1 ps

module BIST_top (
  SYS_CLK3_P,
  SYS_CLK3_N,
//  SYS_CLK0_P,
//  SYS_CLK0_N,
  resetn,
  USB_UART_RX,
  USB_UART_TX,
  clk_450
);
  input SYS_CLK3_P;
  input SYS_CLK3_N;
//  input SYS_CLK0_P;
//  input SYS_CLK0_N;
  input resetn;
  input USB_UART_RX;
  output USB_UART_TX;
  output clk_450;

  wire resetn;
  wire clk_out;
  reg temp_rst;

  // Instantiate the IBUFDS for differential clock input
  IBUFDS diff_clk (
    .O(clk_out),
    .I(SYS_CLK3_P),
    .IB(SYS_CLK3_N)
  );
  
//  IBUFDS diff_clk_1 (
//    .O(clk_uart),
//    .I(SYS_CLK0_P),
//    .IB(SYS_CLK0_N)
//  );
    
//  MMCME2_ADV #(
//	.BANDWIDTH("OPTIMIZED"),
//	.CLKFBOUT_MULT_F(4'd12),
//	.CLKIN1_PERIOD(10.0),
//	.CLKOUT0_DIVIDE_F(4'd12),
//	.CLKOUT0_PHASE(1'd0),
//	.CLKOUT1_DIVIDE(4'd12),
//	.CLKOUT1_PHASE(1'd0),
//	.REF_JITTER1(0.01)
//) MMCME2_ADV (
//	.CLKIN1(clk_out),
//	.CLKOUT0(clk_bist),
//	.CLKOUT1(clk_uart)
//);
  
  

  top top_i (
    .clk(clk_out),
    .clk_uart(clk_out),
    .resetn(resetn),
    .USB_UART_RX(USB_UART_RX),
    .USB_UART_TX(USB_UART_TX),
    .clk_450(clk_450)
  );
  
endmodule
