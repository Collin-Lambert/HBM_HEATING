//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.2 (lin64) Build 3671981 Fri Oct 14 04:59:54 MDT 2022
//Date        : Tue May 23 13:28:32 2023
//Host        : cb461-ccl0 running 64-bit Ubuntu 22.04.2 LTS
//Command     : generate_target top_wrapper.bd
//Design      : top_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module BIST_top
   (SYS_CLK3_P,
    SYS_CLK3_N,
    resetn,
    USB_UART_RX,
    USB_UART_TX
    );
    
    
  input SYS_CLK3_P;
  input SYS_CLK3_N;
  input resetn;
  input USB_UART_RX;
  output USB_UART_TX;
  

  wire resetn;
  wire clk_out;
  reg temp_rst;
  
  IBUFDS diff_clk (
        .O (clk_out),
        .I (SYS_CLK3_P),
        .IB (SYS_CLK3_N)
    );
    

  
  
//  TX_RX tx_rx (
//    .clk(clk_out),
//    .USB_UART_RX(USB_UART_RX),
//    .USB_UART_TX(USB_UART_TX),
//    .read_write(read_write),
//    .start(start)
//  );
  
//  reg [12:0] counter;
  
//  always @(posedge clk_out)
//    begin
//        if (counter < 5)
//            begin
//                counter <= counter + 1;
//                temp_rst <= 0;
//            end
//        else
//            temp_rst <= 1;
//    end

  top top_i
       (.clk(clk_out),
        .resetn(resetn),
        .USB_UART_RX(USB_UART_RX),
        .USB_UART_TX(USB_UART_TX));
endmodule
