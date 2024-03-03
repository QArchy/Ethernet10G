set_property SRC_FILE_INFO {cfile:d:/programming/RLCBC_BROD/project/Ethernet10G.srcs/sources_1/ip/axi4_stream_sfp_ethernet_controller/ip_0/synth/axi4_stream_sfp_ethernet_controller_gt.xdc rfile:../../../Ethernet10G.srcs/sources_1/ip/axi4_stream_sfp_ethernet_controller/ip_0/synth/axi4_stream_sfp_ethernet_controller_gt.xdc id:1 order:EARLY scoped_inst:inst/i_axi4_stream_sfp_ethernet_controller_gt/inst} [current_design]
current_instance inst/i_axi4_stream_sfp_ethernet_controller_gt/inst
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_property LOC GTHE4_CHANNEL_X0Y4 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[1].*gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST}]
current_instance
set_property src_info {type:SCOPED_XDC file:1 line:66 export:INPUT save:INPUT read:READ} [current_design]
set_case_analysis 1 [get_pins {inst/i_axi4_stream_sfp_ethernet_controller_gt/inst/gen_gtwizard_gthe4_top.axi4_stream_sfp_ethernet_controller_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_pwrgood_delay_inst[0].delay_powergood_inst/gen_powergood_delay.pwr_on_fsm_reg/Q}]
