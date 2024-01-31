# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "axi_len_param"
  ipgui::add_param $IPINST -name "axi_size_param"
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"


}

proc update_PARAM_VALUE.axi_len_param { PARAM_VALUE.axi_len_param } {
	# Procedure called to update axi_len_param when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.axi_len_param { PARAM_VALUE.axi_len_param } {
	# Procedure called to validate axi_len_param
	return true
}

proc update_PARAM_VALUE.axi_size_param { PARAM_VALUE.axi_size_param } {
	# Procedure called to update axi_size_param when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.axi_size_param { PARAM_VALUE.axi_size_param } {
	# Procedure called to validate axi_size_param
	return true
}


proc update_MODELPARAM_VALUE.axi_len_param { MODELPARAM_VALUE.axi_len_param PARAM_VALUE.axi_len_param } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.axi_len_param}] ${MODELPARAM_VALUE.axi_len_param}
}

proc update_MODELPARAM_VALUE.axi_size_param { MODELPARAM_VALUE.axi_size_param PARAM_VALUE.axi_size_param } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.axi_size_param}] ${MODELPARAM_VALUE.axi_size_param}
}

