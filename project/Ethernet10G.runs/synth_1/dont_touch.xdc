# This file is automatically generated.
# It contains project source information necessary for synthesis and implementation.

# XDC: C:/Users/hudyakovas/Desktop/Khudyakov/MyProjects/RLCBC_BROD/dbg/constraints.xdc

# IP: ip/axi4_stream_sfp_ethernet_controller/axi4_stream_sfp_ethernet_controller.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==axi4_stream_sfp_ethernet_controller || ORIG_REF_NAME==axi4_stream_sfp_ethernet_controller} -quiet] -quiet

# IP: ip/axi4_stream_sfp_ethernet_controller/ip_0/axi4_stream_sfp_ethernet_controller_gt.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==axi4_stream_sfp_ethernet_controller_gt || ORIG_REF_NAME==axi4_stream_sfp_ethernet_controller_gt} -quiet] -quiet

# XDC: ip/axi4_stream_sfp_ethernet_controller/ip_0/synth/axi4_stream_sfp_ethernet_controller_gt_ooc.xdc

# XDC: ip/axi4_stream_sfp_ethernet_controller/ip_0/synth/axi4_stream_sfp_ethernet_controller_gt.xdc
set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==axi4_stream_sfp_ethernet_controller_gt || ORIG_REF_NAME==axi4_stream_sfp_ethernet_controller_gt} -quiet] {/inst } ]/inst ] -quiet] -quiet

# XDC: ip/axi4_stream_sfp_ethernet_controller/synth/axi4_stream_sfp_ethernet_controller_board.xdc
set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==axi4_stream_sfp_ethernet_controller || ORIG_REF_NAME==axi4_stream_sfp_ethernet_controller} -quiet] {/inst } ]/inst ] -quiet] -quiet

# XDC: ip/axi4_stream_sfp_ethernet_controller/synth/axi4_stream_sfp_ethernet_controller.xdc
#dup# set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==axi4_stream_sfp_ethernet_controller || ORIG_REF_NAME==axi4_stream_sfp_ethernet_controller} -quiet] {/inst } ]/inst ] -quiet] -quiet

# XDC: ip/axi4_stream_sfp_ethernet_controller/synth/axi4_stream_sfp_ethernet_controller_exceptions.xdc
#dup# set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==axi4_stream_sfp_ethernet_controller || ORIG_REF_NAME==axi4_stream_sfp_ethernet_controller} -quiet] {/inst } ]/inst ] -quiet] -quiet

# XDC: ip/axi4_stream_sfp_ethernet_controller/synth/axi4_stream_sfp_ethernet_controller_ooc.xdc
