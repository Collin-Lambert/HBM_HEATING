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

set_property PACKAGE_PIN B28 [get_ports Trash]
set_property IOSTANDARD LVCMOS18 [get_ports Trash]
create_clock -period 10.000 -name sysclk3 [get_ports SYS_CLK3_P]


connect_debug_port dbg_hub/clk [get_nets clk_out]
