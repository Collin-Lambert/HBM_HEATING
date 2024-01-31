# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "bist_num" -parent ${Page_0}


}

proc update_PARAM_VALUE.bist_num { PARAM_VALUE.bist_num } {
	# Procedure called to update bist_num when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.bist_num { PARAM_VALUE.bist_num } {
	# Procedure called to validate bist_num
	return true
}


proc update_MODELPARAM_VALUE.bist_num { MODELPARAM_VALUE.bist_num PARAM_VALUE.bist_num } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.bist_num}] ${MODELPARAM_VALUE.bist_num}
}

