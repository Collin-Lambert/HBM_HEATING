# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"


}

proc update_PARAM_VALUE.traffic_gen_num { PARAM_VALUE.traffic_gen_num } {
	# Procedure called to update traffic_gen_num when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.traffic_gen_num { PARAM_VALUE.traffic_gen_num } {
	# Procedure called to validate traffic_gen_num
	return true
}


proc update_MODELPARAM_VALUE.traffic_gen_num { MODELPARAM_VALUE.traffic_gen_num PARAM_VALUE.traffic_gen_num } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.traffic_gen_num}] ${MODELPARAM_VALUE.traffic_gen_num}
}

