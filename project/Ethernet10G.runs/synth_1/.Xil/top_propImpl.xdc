set_property SRC_FILE_INFO {cfile:c:/Users/hudyakovas/Desktop/Khudyakov/MyProjects/RLCBC_BROD/project/Ethernet10G.srcs/sources_1/ip/axi4_stream_sfp_ethernet_controller/ip_0/synth/axi4_stream_sfp_ethernet_controller_gt.xdc rfile:../../../Ethernet10G.srcs/sources_1/ip/axi4_stream_sfp_ethernet_controller/ip_0/synth/axi4_stream_sfp_ethernet_controller_gt.xdc id:1 order:EARLY scoped_inst:ethernet_inst/axi4_stream_sfp_ethernet_controller_inst/inst/i_axi4_stream_sfp_ethernet_controller_gt/inst} [current_design]
set_property SRC_FILE_INFO {cfile:C:/Users/hudyakovas/Desktop/Khudyakov/MyProjects/RLCBC_BROD/dbg/constraints.xdc rfile:../../../../dbg/constraints.xdc id:2} [current_design]
current_instance ethernet_inst/axi4_stream_sfp_ethernet_controller_inst/inst/i_axi4_stream_sfp_ethernet_controller_gt/inst
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_property LOC GTHE4_CHANNEL_X0Y4 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[1].*gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST}]
current_instance
set_property src_info {type:SCOPED_XDC file:1 line:66 export:INPUT save:INPUT read:READ} [current_design]
set_case_analysis 1 [get_pins {ethernet_inst/axi4_stream_sfp_ethernet_controller_inst/inst/i_axi4_stream_sfp_ethernet_controller_gt/inst/gen_gtwizard_gthe4_top.axi4_stream_sfp_ethernet_controller_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_pwrgood_delay_inst[0].delay_powergood_inst/gen_powergood_delay.pwr_on_fsm_reg/Q}]
set_property src_info {type:XDC file:2 line:10 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN G21        [get_ports i_CLK_125_P]
set_property src_info {type:XDC file:2 line:11 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN F21        [get_ports i_CLK_125_N]
set_property src_info {type:XDC file:2 line:15 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AK15       [get_ports i_CLK_74_25_P]
set_property src_info {type:XDC file:2 line:16 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AK14       [get_ports i_CLK_74_25_N]
set_property src_info {type:XDC file:2 line:20 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AM13       [get_ports i_reset]
set_property src_info {type:XDC file:2 line:25 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AG15       [get_ports i_push_btn[0]]
set_property src_info {type:XDC file:2 line:27 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AE14       [get_ports i_push_btn[1]]
set_property src_info {type:XDC file:2 line:29 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AF15       [get_ports i_push_btn[2]]
set_property src_info {type:XDC file:2 line:31 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AE15       [get_ports i_push_btn[3]]
set_property src_info {type:XDC file:2 line:33 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AG13       [get_ports i_push_btn[4]]
set_property src_info {type:XDC file:2 line:36 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AN14       [get_ports i_DIP_sw[0]]
set_property src_info {type:XDC file:2 line:38 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AP14       [get_ports i_DIP_sw[1]]
set_property src_info {type:XDC file:2 line:40 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AM14       [get_ports i_DIP_sw[2]]
set_property src_info {type:XDC file:2 line:42 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AN13       [get_ports i_DIP_sw[3]]
set_property src_info {type:XDC file:2 line:44 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AN12       [get_ports i_DIP_sw[4]]
set_property src_info {type:XDC file:2 line:46 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AP12       [get_ports i_DIP_sw[5]]
set_property src_info {type:XDC file:2 line:48 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AL13       [get_ports i_DIP_sw[6]]
set_property src_info {type:XDC file:2 line:50 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AK13       [get_ports i_DIP_sw[7]]
set_property src_info {type:XDC file:2 line:53 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AG14       [get_ports o_led[0]]
set_property src_info {type:XDC file:2 line:55 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AF13       [get_ports o_led[1]]
set_property src_info {type:XDC file:2 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AE13       [get_ports o_led[2]]
set_property src_info {type:XDC file:2 line:59 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AJ14       [get_ports o_led[3]]
set_property src_info {type:XDC file:2 line:61 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AJ15       [get_ports o_led[4]]
set_property src_info {type:XDC file:2 line:63 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AH13       [get_ports o_led[5]]
set_property src_info {type:XDC file:2 line:65 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AH14       [get_ports o_led[6]]
set_property src_info {type:XDC file:2 line:67 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AL12       [get_ports o_led[7]]
set_property src_info {type:XDC file:2 line:104 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AL8        [get_ports i_CLK_156_25_P]
set_property src_info {type:XDC file:2 line:105 export:INPUT save:INPUT read:READ} [current_design]
set_property IOSTANDARD DIFF_SSTL12 [get_ports i_CLK_156_25_P]
set_property src_info {type:XDC file:2 line:106 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AL7        [get_ports i_CLK_156_25_N]
set_property src_info {type:XDC file:2 line:107 export:INPUT save:INPUT read:READ} [current_design]
set_property IOSTANDARD DIFF_SSTL12 [get_ports i_CLK_156_25_N]
set_property src_info {type:XDC file:2 line:130 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN A8         [get_ports o_ll_tx_p]
set_property src_info {type:XDC file:2 line:131 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN A7         [get_ports o_ll_tx_n]
set_property src_info {type:XDC file:2 line:132 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN A4         [get_ports i_ll_rx_p]
set_property src_info {type:XDC file:2 line:133 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN A3         [get_ports i_ll_rx_n]
set_property src_info {type:XDC file:2 line:134 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN C13        [get_ports o_ll_tx_disable]
