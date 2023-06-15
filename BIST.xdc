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

set_clock_groups -name TX_RX -asynchronous -group clk_out1_top_clk_wiz_1_0








#create_debug_core u_ila_0 ila
#set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
#set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
#set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
#set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
#set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
#set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
#set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
#set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
#set_property port_width 1 [get_debug_ports u_ila_0/clk]
#connect_debug_port u_ila_0/clk [get_nets [list top_i/clk_wiz_0/inst/MHz_450]]
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
#set_property port_width 6 [get_debug_ports u_ila_0/probe0]
#connect_debug_port u_ila_0/probe0 [get_nets [list {top_i/BIST_0/inst/outstanding_writes_reg[0]} {top_i/BIST_0/inst/outstanding_writes_reg[1]} {top_i/BIST_0/inst/outstanding_writes_reg[2]} {top_i/BIST_0/inst/outstanding_writes_reg[3]} {top_i/BIST_0/inst/outstanding_writes_reg[4]} {top_i/BIST_0/inst/outstanding_writes_reg[5]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
#set_property port_width 6 [get_debug_ports u_ila_0/probe1]
#connect_debug_port u_ila_0/probe1 [get_nets [list {top_i/BIST_0/inst/outstanding_reads_reg[0]} {top_i/BIST_0/inst/outstanding_reads_reg[1]} {top_i/BIST_0/inst/outstanding_reads_reg[2]} {top_i/BIST_0/inst/outstanding_reads_reg[3]} {top_i/BIST_0/inst/outstanding_reads_reg[4]} {top_i/BIST_0/inst/outstanding_reads_reg[5]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
#set_property port_width 2 [get_debug_ports u_ila_0/probe2]
#connect_debug_port u_ila_0/probe2 [get_nets [list {top_i/BIST_0/inst/qwcs[0]} {top_i/BIST_0/inst/qwcs[1]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
#set_property port_width 2 [get_debug_ports u_ila_0/probe3]
#connect_debug_port u_ila_0/probe3 [get_nets [list {top_i/BIST_0_axi_RRESP[0]} {top_i/BIST_0_axi_RRESP[1]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
#set_property port_width 256 [get_debug_ports u_ila_0/probe4]
#connect_debug_port u_ila_0/probe4 [get_nets [list {top_i/BIST_0_axi_WDATA[0]} {top_i/BIST_0_axi_WDATA[1]} {top_i/BIST_0_axi_WDATA[2]} {top_i/BIST_0_axi_WDATA[3]} {top_i/BIST_0_axi_WDATA[4]} {top_i/BIST_0_axi_WDATA[5]} {top_i/BIST_0_axi_WDATA[6]} {top_i/BIST_0_axi_WDATA[7]} {top_i/BIST_0_axi_WDATA[8]} {top_i/BIST_0_axi_WDATA[9]} {top_i/BIST_0_axi_WDATA[10]} {top_i/BIST_0_axi_WDATA[11]} {top_i/BIST_0_axi_WDATA[12]} {top_i/BIST_0_axi_WDATA[13]} {top_i/BIST_0_axi_WDATA[14]} {top_i/BIST_0_axi_WDATA[15]} {top_i/BIST_0_axi_WDATA[16]} {top_i/BIST_0_axi_WDATA[17]} {top_i/BIST_0_axi_WDATA[18]} {top_i/BIST_0_axi_WDATA[19]} {top_i/BIST_0_axi_WDATA[20]} {top_i/BIST_0_axi_WDATA[21]} {top_i/BIST_0_axi_WDATA[22]} {top_i/BIST_0_axi_WDATA[23]} {top_i/BIST_0_axi_WDATA[24]} {top_i/BIST_0_axi_WDATA[25]} {top_i/BIST_0_axi_WDATA[26]} {top_i/BIST_0_axi_WDATA[27]} {top_i/BIST_0_axi_WDATA[28]} {top_i/BIST_0_axi_WDATA[29]} {top_i/BIST_0_axi_WDATA[30]} {top_i/BIST_0_axi_WDATA[31]} {top_i/BIST_0_axi_WDATA[32]} {top_i/BIST_0_axi_WDATA[33]} {top_i/BIST_0_axi_WDATA[34]} {top_i/BIST_0_axi_WDATA[35]} {top_i/BIST_0_axi_WDATA[36]} {top_i/BIST_0_axi_WDATA[37]} {top_i/BIST_0_axi_WDATA[38]} {top_i/BIST_0_axi_WDATA[39]} {top_i/BIST_0_axi_WDATA[40]} {top_i/BIST_0_axi_WDATA[41]} {top_i/BIST_0_axi_WDATA[42]} {top_i/BIST_0_axi_WDATA[43]} {top_i/BIST_0_axi_WDATA[44]} {top_i/BIST_0_axi_WDATA[45]} {top_i/BIST_0_axi_WDATA[46]} {top_i/BIST_0_axi_WDATA[47]} {top_i/BIST_0_axi_WDATA[48]} {top_i/BIST_0_axi_WDATA[49]} {top_i/BIST_0_axi_WDATA[50]} {top_i/BIST_0_axi_WDATA[51]} {top_i/BIST_0_axi_WDATA[52]} {top_i/BIST_0_axi_WDATA[53]} {top_i/BIST_0_axi_WDATA[54]} {top_i/BIST_0_axi_WDATA[55]} {top_i/BIST_0_axi_WDATA[56]} {top_i/BIST_0_axi_WDATA[57]} {top_i/BIST_0_axi_WDATA[58]} {top_i/BIST_0_axi_WDATA[59]} {top_i/BIST_0_axi_WDATA[60]} {top_i/BIST_0_axi_WDATA[61]} {top_i/BIST_0_axi_WDATA[62]} {top_i/BIST_0_axi_WDATA[63]} {top_i/BIST_0_axi_WDATA[64]} {top_i/BIST_0_axi_WDATA[65]} {top_i/BIST_0_axi_WDATA[66]} {top_i/BIST_0_axi_WDATA[67]} {top_i/BIST_0_axi_WDATA[68]} {top_i/BIST_0_axi_WDATA[69]} {top_i/BIST_0_axi_WDATA[70]} {top_i/BIST_0_axi_WDATA[71]} {top_i/BIST_0_axi_WDATA[72]} {top_i/BIST_0_axi_WDATA[73]} {top_i/BIST_0_axi_WDATA[74]} {top_i/BIST_0_axi_WDATA[75]} {top_i/BIST_0_axi_WDATA[76]} {top_i/BIST_0_axi_WDATA[77]} {top_i/BIST_0_axi_WDATA[78]} {top_i/BIST_0_axi_WDATA[79]} {top_i/BIST_0_axi_WDATA[80]} {top_i/BIST_0_axi_WDATA[81]} {top_i/BIST_0_axi_WDATA[82]} {top_i/BIST_0_axi_WDATA[83]} {top_i/BIST_0_axi_WDATA[84]} {top_i/BIST_0_axi_WDATA[85]} {top_i/BIST_0_axi_WDATA[86]} {top_i/BIST_0_axi_WDATA[87]} {top_i/BIST_0_axi_WDATA[88]} {top_i/BIST_0_axi_WDATA[89]} {top_i/BIST_0_axi_WDATA[90]} {top_i/BIST_0_axi_WDATA[91]} {top_i/BIST_0_axi_WDATA[92]} {top_i/BIST_0_axi_WDATA[93]} {top_i/BIST_0_axi_WDATA[94]} {top_i/BIST_0_axi_WDATA[95]} {top_i/BIST_0_axi_WDATA[96]} {top_i/BIST_0_axi_WDATA[97]} {top_i/BIST_0_axi_WDATA[98]} {top_i/BIST_0_axi_WDATA[99]} {top_i/BIST_0_axi_WDATA[100]} {top_i/BIST_0_axi_WDATA[101]} {top_i/BIST_0_axi_WDATA[102]} {top_i/BIST_0_axi_WDATA[103]} {top_i/BIST_0_axi_WDATA[104]} {top_i/BIST_0_axi_WDATA[105]} {top_i/BIST_0_axi_WDATA[106]} {top_i/BIST_0_axi_WDATA[107]} {top_i/BIST_0_axi_WDATA[108]} {top_i/BIST_0_axi_WDATA[109]} {top_i/BIST_0_axi_WDATA[110]} {top_i/BIST_0_axi_WDATA[111]} {top_i/BIST_0_axi_WDATA[112]} {top_i/BIST_0_axi_WDATA[113]} {top_i/BIST_0_axi_WDATA[114]} {top_i/BIST_0_axi_WDATA[115]} {top_i/BIST_0_axi_WDATA[116]} {top_i/BIST_0_axi_WDATA[117]} {top_i/BIST_0_axi_WDATA[118]} {top_i/BIST_0_axi_WDATA[119]} {top_i/BIST_0_axi_WDATA[120]} {top_i/BIST_0_axi_WDATA[121]} {top_i/BIST_0_axi_WDATA[122]} {top_i/BIST_0_axi_WDATA[123]} {top_i/BIST_0_axi_WDATA[124]} {top_i/BIST_0_axi_WDATA[125]} {top_i/BIST_0_axi_WDATA[126]} {top_i/BIST_0_axi_WDATA[127]} {top_i/BIST_0_axi_WDATA[128]} {top_i/BIST_0_axi_WDATA[129]} {top_i/BIST_0_axi_WDATA[130]} {top_i/BIST_0_axi_WDATA[131]} {top_i/BIST_0_axi_WDATA[132]} {top_i/BIST_0_axi_WDATA[133]} {top_i/BIST_0_axi_WDATA[134]} {top_i/BIST_0_axi_WDATA[135]} {top_i/BIST_0_axi_WDATA[136]} {top_i/BIST_0_axi_WDATA[137]} {top_i/BIST_0_axi_WDATA[138]} {top_i/BIST_0_axi_WDATA[139]} {top_i/BIST_0_axi_WDATA[140]} {top_i/BIST_0_axi_WDATA[141]} {top_i/BIST_0_axi_WDATA[142]} {top_i/BIST_0_axi_WDATA[143]} {top_i/BIST_0_axi_WDATA[144]} {top_i/BIST_0_axi_WDATA[145]} {top_i/BIST_0_axi_WDATA[146]} {top_i/BIST_0_axi_WDATA[147]} {top_i/BIST_0_axi_WDATA[148]} {top_i/BIST_0_axi_WDATA[149]} {top_i/BIST_0_axi_WDATA[150]} {top_i/BIST_0_axi_WDATA[151]} {top_i/BIST_0_axi_WDATA[152]} {top_i/BIST_0_axi_WDATA[153]} {top_i/BIST_0_axi_WDATA[154]} {top_i/BIST_0_axi_WDATA[155]} {top_i/BIST_0_axi_WDATA[156]} {top_i/BIST_0_axi_WDATA[157]} {top_i/BIST_0_axi_WDATA[158]} {top_i/BIST_0_axi_WDATA[159]} {top_i/BIST_0_axi_WDATA[160]} {top_i/BIST_0_axi_WDATA[161]} {top_i/BIST_0_axi_WDATA[162]} {top_i/BIST_0_axi_WDATA[163]} {top_i/BIST_0_axi_WDATA[164]} {top_i/BIST_0_axi_WDATA[165]} {top_i/BIST_0_axi_WDATA[166]} {top_i/BIST_0_axi_WDATA[167]} {top_i/BIST_0_axi_WDATA[168]} {top_i/BIST_0_axi_WDATA[169]} {top_i/BIST_0_axi_WDATA[170]} {top_i/BIST_0_axi_WDATA[171]} {top_i/BIST_0_axi_WDATA[172]} {top_i/BIST_0_axi_WDATA[173]} {top_i/BIST_0_axi_WDATA[174]} {top_i/BIST_0_axi_WDATA[175]} {top_i/BIST_0_axi_WDATA[176]} {top_i/BIST_0_axi_WDATA[177]} {top_i/BIST_0_axi_WDATA[178]} {top_i/BIST_0_axi_WDATA[179]} {top_i/BIST_0_axi_WDATA[180]} {top_i/BIST_0_axi_WDATA[181]} {top_i/BIST_0_axi_WDATA[182]} {top_i/BIST_0_axi_WDATA[183]} {top_i/BIST_0_axi_WDATA[184]} {top_i/BIST_0_axi_WDATA[185]} {top_i/BIST_0_axi_WDATA[186]} {top_i/BIST_0_axi_WDATA[187]} {top_i/BIST_0_axi_WDATA[188]} {top_i/BIST_0_axi_WDATA[189]} {top_i/BIST_0_axi_WDATA[190]} {top_i/BIST_0_axi_WDATA[191]} {top_i/BIST_0_axi_WDATA[192]} {top_i/BIST_0_axi_WDATA[193]} {top_i/BIST_0_axi_WDATA[194]} {top_i/BIST_0_axi_WDATA[195]} {top_i/BIST_0_axi_WDATA[196]} {top_i/BIST_0_axi_WDATA[197]} {top_i/BIST_0_axi_WDATA[198]} {top_i/BIST_0_axi_WDATA[199]} {top_i/BIST_0_axi_WDATA[200]} {top_i/BIST_0_axi_WDATA[201]} {top_i/BIST_0_axi_WDATA[202]} {top_i/BIST_0_axi_WDATA[203]} {top_i/BIST_0_axi_WDATA[204]} {top_i/BIST_0_axi_WDATA[205]} {top_i/BIST_0_axi_WDATA[206]} {top_i/BIST_0_axi_WDATA[207]} {top_i/BIST_0_axi_WDATA[208]} {top_i/BIST_0_axi_WDATA[209]} {top_i/BIST_0_axi_WDATA[210]} {top_i/BIST_0_axi_WDATA[211]} {top_i/BIST_0_axi_WDATA[212]} {top_i/BIST_0_axi_WDATA[213]} {top_i/BIST_0_axi_WDATA[214]} {top_i/BIST_0_axi_WDATA[215]} {top_i/BIST_0_axi_WDATA[216]} {top_i/BIST_0_axi_WDATA[217]} {top_i/BIST_0_axi_WDATA[218]} {top_i/BIST_0_axi_WDATA[219]} {top_i/BIST_0_axi_WDATA[220]} {top_i/BIST_0_axi_WDATA[221]} {top_i/BIST_0_axi_WDATA[222]} {top_i/BIST_0_axi_WDATA[223]} {top_i/BIST_0_axi_WDATA[224]} {top_i/BIST_0_axi_WDATA[225]} {top_i/BIST_0_axi_WDATA[226]} {top_i/BIST_0_axi_WDATA[227]} {top_i/BIST_0_axi_WDATA[228]} {top_i/BIST_0_axi_WDATA[229]} {top_i/BIST_0_axi_WDATA[230]} {top_i/BIST_0_axi_WDATA[231]} {top_i/BIST_0_axi_WDATA[232]} {top_i/BIST_0_axi_WDATA[233]} {top_i/BIST_0_axi_WDATA[234]} {top_i/BIST_0_axi_WDATA[235]} {top_i/BIST_0_axi_WDATA[236]} {top_i/BIST_0_axi_WDATA[237]} {top_i/BIST_0_axi_WDATA[238]} {top_i/BIST_0_axi_WDATA[239]} {top_i/BIST_0_axi_WDATA[240]} {top_i/BIST_0_axi_WDATA[241]} {top_i/BIST_0_axi_WDATA[242]} {top_i/BIST_0_axi_WDATA[243]} {top_i/BIST_0_axi_WDATA[244]} {top_i/BIST_0_axi_WDATA[245]} {top_i/BIST_0_axi_WDATA[246]} {top_i/BIST_0_axi_WDATA[247]} {top_i/BIST_0_axi_WDATA[248]} {top_i/BIST_0_axi_WDATA[249]} {top_i/BIST_0_axi_WDATA[250]} {top_i/BIST_0_axi_WDATA[251]} {top_i/BIST_0_axi_WDATA[252]} {top_i/BIST_0_axi_WDATA[253]} {top_i/BIST_0_axi_WDATA[254]} {top_i/BIST_0_axi_WDATA[255]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
#set_property port_width 2 [get_debug_ports u_ila_0/probe5]
#connect_debug_port u_ila_0/probe5 [get_nets [list {top_i/BIST_0_axi_BRESP[0]} {top_i/BIST_0_axi_BRESP[1]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
#set_property port_width 256 [get_debug_ports u_ila_0/probe6]
#connect_debug_port u_ila_0/probe6 [get_nets [list {top_i/BIST_0_axi_RDATA[0]} {top_i/BIST_0_axi_RDATA[1]} {top_i/BIST_0_axi_RDATA[2]} {top_i/BIST_0_axi_RDATA[3]} {top_i/BIST_0_axi_RDATA[4]} {top_i/BIST_0_axi_RDATA[5]} {top_i/BIST_0_axi_RDATA[6]} {top_i/BIST_0_axi_RDATA[7]} {top_i/BIST_0_axi_RDATA[8]} {top_i/BIST_0_axi_RDATA[9]} {top_i/BIST_0_axi_RDATA[10]} {top_i/BIST_0_axi_RDATA[11]} {top_i/BIST_0_axi_RDATA[12]} {top_i/BIST_0_axi_RDATA[13]} {top_i/BIST_0_axi_RDATA[14]} {top_i/BIST_0_axi_RDATA[15]} {top_i/BIST_0_axi_RDATA[16]} {top_i/BIST_0_axi_RDATA[17]} {top_i/BIST_0_axi_RDATA[18]} {top_i/BIST_0_axi_RDATA[19]} {top_i/BIST_0_axi_RDATA[20]} {top_i/BIST_0_axi_RDATA[21]} {top_i/BIST_0_axi_RDATA[22]} {top_i/BIST_0_axi_RDATA[23]} {top_i/BIST_0_axi_RDATA[24]} {top_i/BIST_0_axi_RDATA[25]} {top_i/BIST_0_axi_RDATA[26]} {top_i/BIST_0_axi_RDATA[27]} {top_i/BIST_0_axi_RDATA[28]} {top_i/BIST_0_axi_RDATA[29]} {top_i/BIST_0_axi_RDATA[30]} {top_i/BIST_0_axi_RDATA[31]} {top_i/BIST_0_axi_RDATA[32]} {top_i/BIST_0_axi_RDATA[33]} {top_i/BIST_0_axi_RDATA[34]} {top_i/BIST_0_axi_RDATA[35]} {top_i/BIST_0_axi_RDATA[36]} {top_i/BIST_0_axi_RDATA[37]} {top_i/BIST_0_axi_RDATA[38]} {top_i/BIST_0_axi_RDATA[39]} {top_i/BIST_0_axi_RDATA[40]} {top_i/BIST_0_axi_RDATA[41]} {top_i/BIST_0_axi_RDATA[42]} {top_i/BIST_0_axi_RDATA[43]} {top_i/BIST_0_axi_RDATA[44]} {top_i/BIST_0_axi_RDATA[45]} {top_i/BIST_0_axi_RDATA[46]} {top_i/BIST_0_axi_RDATA[47]} {top_i/BIST_0_axi_RDATA[48]} {top_i/BIST_0_axi_RDATA[49]} {top_i/BIST_0_axi_RDATA[50]} {top_i/BIST_0_axi_RDATA[51]} {top_i/BIST_0_axi_RDATA[52]} {top_i/BIST_0_axi_RDATA[53]} {top_i/BIST_0_axi_RDATA[54]} {top_i/BIST_0_axi_RDATA[55]} {top_i/BIST_0_axi_RDATA[56]} {top_i/BIST_0_axi_RDATA[57]} {top_i/BIST_0_axi_RDATA[58]} {top_i/BIST_0_axi_RDATA[59]} {top_i/BIST_0_axi_RDATA[60]} {top_i/BIST_0_axi_RDATA[61]} {top_i/BIST_0_axi_RDATA[62]} {top_i/BIST_0_axi_RDATA[63]} {top_i/BIST_0_axi_RDATA[64]} {top_i/BIST_0_axi_RDATA[65]} {top_i/BIST_0_axi_RDATA[66]} {top_i/BIST_0_axi_RDATA[67]} {top_i/BIST_0_axi_RDATA[68]} {top_i/BIST_0_axi_RDATA[69]} {top_i/BIST_0_axi_RDATA[70]} {top_i/BIST_0_axi_RDATA[71]} {top_i/BIST_0_axi_RDATA[72]} {top_i/BIST_0_axi_RDATA[73]} {top_i/BIST_0_axi_RDATA[74]} {top_i/BIST_0_axi_RDATA[75]} {top_i/BIST_0_axi_RDATA[76]} {top_i/BIST_0_axi_RDATA[77]} {top_i/BIST_0_axi_RDATA[78]} {top_i/BIST_0_axi_RDATA[79]} {top_i/BIST_0_axi_RDATA[80]} {top_i/BIST_0_axi_RDATA[81]} {top_i/BIST_0_axi_RDATA[82]} {top_i/BIST_0_axi_RDATA[83]} {top_i/BIST_0_axi_RDATA[84]} {top_i/BIST_0_axi_RDATA[85]} {top_i/BIST_0_axi_RDATA[86]} {top_i/BIST_0_axi_RDATA[87]} {top_i/BIST_0_axi_RDATA[88]} {top_i/BIST_0_axi_RDATA[89]} {top_i/BIST_0_axi_RDATA[90]} {top_i/BIST_0_axi_RDATA[91]} {top_i/BIST_0_axi_RDATA[92]} {top_i/BIST_0_axi_RDATA[93]} {top_i/BIST_0_axi_RDATA[94]} {top_i/BIST_0_axi_RDATA[95]} {top_i/BIST_0_axi_RDATA[96]} {top_i/BIST_0_axi_RDATA[97]} {top_i/BIST_0_axi_RDATA[98]} {top_i/BIST_0_axi_RDATA[99]} {top_i/BIST_0_axi_RDATA[100]} {top_i/BIST_0_axi_RDATA[101]} {top_i/BIST_0_axi_RDATA[102]} {top_i/BIST_0_axi_RDATA[103]} {top_i/BIST_0_axi_RDATA[104]} {top_i/BIST_0_axi_RDATA[105]} {top_i/BIST_0_axi_RDATA[106]} {top_i/BIST_0_axi_RDATA[107]} {top_i/BIST_0_axi_RDATA[108]} {top_i/BIST_0_axi_RDATA[109]} {top_i/BIST_0_axi_RDATA[110]} {top_i/BIST_0_axi_RDATA[111]} {top_i/BIST_0_axi_RDATA[112]} {top_i/BIST_0_axi_RDATA[113]} {top_i/BIST_0_axi_RDATA[114]} {top_i/BIST_0_axi_RDATA[115]} {top_i/BIST_0_axi_RDATA[116]} {top_i/BIST_0_axi_RDATA[117]} {top_i/BIST_0_axi_RDATA[118]} {top_i/BIST_0_axi_RDATA[119]} {top_i/BIST_0_axi_RDATA[120]} {top_i/BIST_0_axi_RDATA[121]} {top_i/BIST_0_axi_RDATA[122]} {top_i/BIST_0_axi_RDATA[123]} {top_i/BIST_0_axi_RDATA[124]} {top_i/BIST_0_axi_RDATA[125]} {top_i/BIST_0_axi_RDATA[126]} {top_i/BIST_0_axi_RDATA[127]} {top_i/BIST_0_axi_RDATA[128]} {top_i/BIST_0_axi_RDATA[129]} {top_i/BIST_0_axi_RDATA[130]} {top_i/BIST_0_axi_RDATA[131]} {top_i/BIST_0_axi_RDATA[132]} {top_i/BIST_0_axi_RDATA[133]} {top_i/BIST_0_axi_RDATA[134]} {top_i/BIST_0_axi_RDATA[135]} {top_i/BIST_0_axi_RDATA[136]} {top_i/BIST_0_axi_RDATA[137]} {top_i/BIST_0_axi_RDATA[138]} {top_i/BIST_0_axi_RDATA[139]} {top_i/BIST_0_axi_RDATA[140]} {top_i/BIST_0_axi_RDATA[141]} {top_i/BIST_0_axi_RDATA[142]} {top_i/BIST_0_axi_RDATA[143]} {top_i/BIST_0_axi_RDATA[144]} {top_i/BIST_0_axi_RDATA[145]} {top_i/BIST_0_axi_RDATA[146]} {top_i/BIST_0_axi_RDATA[147]} {top_i/BIST_0_axi_RDATA[148]} {top_i/BIST_0_axi_RDATA[149]} {top_i/BIST_0_axi_RDATA[150]} {top_i/BIST_0_axi_RDATA[151]} {top_i/BIST_0_axi_RDATA[152]} {top_i/BIST_0_axi_RDATA[153]} {top_i/BIST_0_axi_RDATA[154]} {top_i/BIST_0_axi_RDATA[155]} {top_i/BIST_0_axi_RDATA[156]} {top_i/BIST_0_axi_RDATA[157]} {top_i/BIST_0_axi_RDATA[158]} {top_i/BIST_0_axi_RDATA[159]} {top_i/BIST_0_axi_RDATA[160]} {top_i/BIST_0_axi_RDATA[161]} {top_i/BIST_0_axi_RDATA[162]} {top_i/BIST_0_axi_RDATA[163]} {top_i/BIST_0_axi_RDATA[164]} {top_i/BIST_0_axi_RDATA[165]} {top_i/BIST_0_axi_RDATA[166]} {top_i/BIST_0_axi_RDATA[167]} {top_i/BIST_0_axi_RDATA[168]} {top_i/BIST_0_axi_RDATA[169]} {top_i/BIST_0_axi_RDATA[170]} {top_i/BIST_0_axi_RDATA[171]} {top_i/BIST_0_axi_RDATA[172]} {top_i/BIST_0_axi_RDATA[173]} {top_i/BIST_0_axi_RDATA[174]} {top_i/BIST_0_axi_RDATA[175]} {top_i/BIST_0_axi_RDATA[176]} {top_i/BIST_0_axi_RDATA[177]} {top_i/BIST_0_axi_RDATA[178]} {top_i/BIST_0_axi_RDATA[179]} {top_i/BIST_0_axi_RDATA[180]} {top_i/BIST_0_axi_RDATA[181]} {top_i/BIST_0_axi_RDATA[182]} {top_i/BIST_0_axi_RDATA[183]} {top_i/BIST_0_axi_RDATA[184]} {top_i/BIST_0_axi_RDATA[185]} {top_i/BIST_0_axi_RDATA[186]} {top_i/BIST_0_axi_RDATA[187]} {top_i/BIST_0_axi_RDATA[188]} {top_i/BIST_0_axi_RDATA[189]} {top_i/BIST_0_axi_RDATA[190]} {top_i/BIST_0_axi_RDATA[191]} {top_i/BIST_0_axi_RDATA[192]} {top_i/BIST_0_axi_RDATA[193]} {top_i/BIST_0_axi_RDATA[194]} {top_i/BIST_0_axi_RDATA[195]} {top_i/BIST_0_axi_RDATA[196]} {top_i/BIST_0_axi_RDATA[197]} {top_i/BIST_0_axi_RDATA[198]} {top_i/BIST_0_axi_RDATA[199]} {top_i/BIST_0_axi_RDATA[200]} {top_i/BIST_0_axi_RDATA[201]} {top_i/BIST_0_axi_RDATA[202]} {top_i/BIST_0_axi_RDATA[203]} {top_i/BIST_0_axi_RDATA[204]} {top_i/BIST_0_axi_RDATA[205]} {top_i/BIST_0_axi_RDATA[206]} {top_i/BIST_0_axi_RDATA[207]} {top_i/BIST_0_axi_RDATA[208]} {top_i/BIST_0_axi_RDATA[209]} {top_i/BIST_0_axi_RDATA[210]} {top_i/BIST_0_axi_RDATA[211]} {top_i/BIST_0_axi_RDATA[212]} {top_i/BIST_0_axi_RDATA[213]} {top_i/BIST_0_axi_RDATA[214]} {top_i/BIST_0_axi_RDATA[215]} {top_i/BIST_0_axi_RDATA[216]} {top_i/BIST_0_axi_RDATA[217]} {top_i/BIST_0_axi_RDATA[218]} {top_i/BIST_0_axi_RDATA[219]} {top_i/BIST_0_axi_RDATA[220]} {top_i/BIST_0_axi_RDATA[221]} {top_i/BIST_0_axi_RDATA[222]} {top_i/BIST_0_axi_RDATA[223]} {top_i/BIST_0_axi_RDATA[224]} {top_i/BIST_0_axi_RDATA[225]} {top_i/BIST_0_axi_RDATA[226]} {top_i/BIST_0_axi_RDATA[227]} {top_i/BIST_0_axi_RDATA[228]} {top_i/BIST_0_axi_RDATA[229]} {top_i/BIST_0_axi_RDATA[230]} {top_i/BIST_0_axi_RDATA[231]} {top_i/BIST_0_axi_RDATA[232]} {top_i/BIST_0_axi_RDATA[233]} {top_i/BIST_0_axi_RDATA[234]} {top_i/BIST_0_axi_RDATA[235]} {top_i/BIST_0_axi_RDATA[236]} {top_i/BIST_0_axi_RDATA[237]} {top_i/BIST_0_axi_RDATA[238]} {top_i/BIST_0_axi_RDATA[239]} {top_i/BIST_0_axi_RDATA[240]} {top_i/BIST_0_axi_RDATA[241]} {top_i/BIST_0_axi_RDATA[242]} {top_i/BIST_0_axi_RDATA[243]} {top_i/BIST_0_axi_RDATA[244]} {top_i/BIST_0_axi_RDATA[245]} {top_i/BIST_0_axi_RDATA[246]} {top_i/BIST_0_axi_RDATA[247]} {top_i/BIST_0_axi_RDATA[248]} {top_i/BIST_0_axi_RDATA[249]} {top_i/BIST_0_axi_RDATA[250]} {top_i/BIST_0_axi_RDATA[251]} {top_i/BIST_0_axi_RDATA[252]} {top_i/BIST_0_axi_RDATA[253]} {top_i/BIST_0_axi_RDATA[254]} {top_i/BIST_0_axi_RDATA[255]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
#set_property port_width 2 [get_debug_ports u_ila_0/probe7]
#connect_debug_port u_ila_0/probe7 [get_nets [list {top_i/BIST_0/inst/qarcs[0]} {top_i/BIST_0/inst/qarcs[1]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
#set_property port_width 2 [get_debug_ports u_ila_0/probe8]
#connect_debug_port u_ila_0/probe8 [get_nets [list {top_i/BIST_0/inst/qrcs[0]} {top_i/BIST_0/inst/qrcs[1]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
#set_property port_width 2 [get_debug_ports u_ila_0/probe9]
#connect_debug_port u_ila_0/probe9 [get_nets [list {top_i/BIST_0/inst/rcs[0]} {top_i/BIST_0/inst/rcs[1]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
#set_property port_width 2 [get_debug_ports u_ila_0/probe10]
#connect_debug_port u_ila_0/probe10 [get_nets [list {top_i/BIST_0/inst/wcs[0]} {top_i/BIST_0/inst/wcs[1]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
#set_property port_width 2 [get_debug_ports u_ila_0/probe11]
#connect_debug_port u_ila_0/probe11 [get_nets [list {top_i/BIST_0/inst/qawcs[0]} {top_i/BIST_0/inst/qawcs[1]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
#set_property port_width 1 [get_debug_ports u_ila_0/probe12]
#connect_debug_port u_ila_0/probe12 [get_nets [list top_i/BIST_0/inst/axi_arready]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
#set_property port_width 1 [get_debug_ports u_ila_0/probe13]
#connect_debug_port u_ila_0/probe13 [get_nets [list top_i/BIST_0/inst/axi_arvalid]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
#set_property port_width 1 [get_debug_ports u_ila_0/probe14]
#connect_debug_port u_ila_0/probe14 [get_nets [list top_i/BIST_0/inst/axi_awready]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
#set_property port_width 1 [get_debug_ports u_ila_0/probe15]
#connect_debug_port u_ila_0/probe15 [get_nets [list top_i/BIST_0/inst/axi_awvalid]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
#set_property port_width 1 [get_debug_ports u_ila_0/probe16]
#connect_debug_port u_ila_0/probe16 [get_nets [list top_i/BIST_0/inst/axi_bready]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
#set_property port_width 1 [get_debug_ports u_ila_0/probe17]
#connect_debug_port u_ila_0/probe17 [get_nets [list top_i/BIST_0/inst/axi_bvalid]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
#set_property port_width 1 [get_debug_ports u_ila_0/probe18]
#connect_debug_port u_ila_0/probe18 [get_nets [list top_i/BIST_0/inst/axi_rlast]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
#set_property port_width 1 [get_debug_ports u_ila_0/probe19]
#connect_debug_port u_ila_0/probe19 [get_nets [list top_i/BIST_0/inst/axi_rready]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
#set_property port_width 1 [get_debug_ports u_ila_0/probe20]
#connect_debug_port u_ila_0/probe20 [get_nets [list top_i/BIST_0/inst/axi_rvalid]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
#set_property port_width 1 [get_debug_ports u_ila_0/probe21]
#connect_debug_port u_ila_0/probe21 [get_nets [list top_i/BIST_0/inst/axi_wlast]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
#set_property port_width 1 [get_debug_ports u_ila_0/probe22]
#connect_debug_port u_ila_0/probe22 [get_nets [list top_i/BIST_0/inst/axi_wready]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
#set_property port_width 1 [get_debug_ports u_ila_0/probe23]
#connect_debug_port u_ila_0/probe23 [get_nets [list top_i/BIST_0/inst/axi_wvalid]]
#set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
#set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
#set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
#connect_debug_port dbg_hub/clk [get_nets clk_450_OBUF]
connect_debug_port dbg_hub/clk [get_nets clk_out]
