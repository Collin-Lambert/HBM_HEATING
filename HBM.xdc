# Bitstream Configuration
# ------------------------------------------------------------------------
set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property BITSTREAM.CONFIG.CONFIGFALLBACK Enable [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 85.0 [current_design]
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN disable [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR Yes [current_design]
# ------------------------------------------------------------------------

#  CPU_RESET_FPGA Connects to SW1 push button On the top edge of the PCB Assembly, also connects to Satellite Contoller
#                 Desinged to be a active low reset input to the FPGA.
#
set_property PACKAGE_PIN L30 [get_ports resetn]
set_property IOSTANDARD LVCMOS18 [get_ports resetn]

set_property PACKAGE_PIN B33 [get_ports USB_UART_TX]
set_property IOSTANDARD LVCMOS18 [get_ports USB_UART_TX]
set_property PACKAGE_PIN A28 [get_ports USB_UART_RX]
set_property IOSTANDARD LVCMOS18 [get_ports USB_UART_RX]

set_property IOSTANDARD LVDS [get_ports SYS_CLK3_N]
set_property PACKAGE_PIN G31 [get_ports SYS_CLK3_P]
set_property PACKAGE_PIN F31 [get_ports SYS_CLK3_N]
set_property IOSTANDARD LVDS [get_ports SYS_CLK3_P]

#set_property PACKAGE_PIN BJ44              [ get_ports  {SYS_CLK0_N} ]
#set_property IOSTANDARD  LVDS              [ get_ports  {SYS_CLK0_N} ]
#set_property PACKAGE_PIN BJ43              [ get_ports  {SYS_CLK0_P} ]
#set_property IOSTANDARD  LVDS              [ get_ports  {SYS_CLK0_P} ]

create_clock -period 10.000 -name SYS_CLK3_P [get_ports SYS_CLK3_P]

#create_clock -period 10.000 -name SYS_CLK0_P [get_ports SYS_CLK0_P]

#set_clock_groups -name async_clks -asynchronous #-group [get_clocks -of_objects[get_pins MMCME2_ADV/clkout0]] #-group [get_clocks -of_objects[get_pins MMCME2_ADV/clkout1]]


set_property PACKAGE_PIN F30 [get_ports clk_450]
set_property IOSTANDARD LVCMOS18 [get_ports clk_450]

set_property PACKAGE_PIN G30 [get_ports sr_out]
set_property IOSTANDARD LVCMOS18 [get_ports sr_out]

set_clock_groups -name TX_RX -asynchronous -group clk_out1_top_clk_wiz_1_0


connect_debug_port dbg_hub/clk [get_nets clk_out]
