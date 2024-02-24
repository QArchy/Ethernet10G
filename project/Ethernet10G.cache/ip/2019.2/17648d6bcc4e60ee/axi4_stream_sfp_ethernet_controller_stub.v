// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Mon Feb 19 16:10:39 2024
// Host        : VN-021-1297 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ axi4_stream_sfp_ethernet_controller_stub.v
// Design      : axi4_stream_sfp_ethernet_controller
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu9eg-ffvb1156-3-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "xxv_ethernet_v3_1_0,Vivado 2019.2" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(rx_reset_0, rx_axis_tvalid_0, 
  rx_axis_tdata_0, rx_axis_tlast_0, rx_axis_tkeep_0, rx_axis_tuser_0, rx_preambleout_0, 
  ctl_rx_test_pattern_0, ctl_rx_test_pattern_enable_0, ctl_rx_data_pattern_select_0, 
  ctl_rx_enable_0, ctl_rx_delete_fcs_0, ctl_rx_ignore_fcs_0, ctl_rx_max_packet_len_0, 
  ctl_rx_min_packet_len_0, ctl_rx_custom_preamble_enable_0, ctl_rx_check_sfd_0, 
  ctl_rx_check_preamble_0, ctl_rx_process_lfi_0, ctl_rx_force_resync_0, 
  stat_rx_block_lock_0, stat_rx_framing_err_valid_0, stat_rx_framing_err_0, 
  stat_rx_hi_ber_0, stat_rx_valid_ctrl_code_0, stat_rx_bad_code_0, 
  stat_rx_total_packets_0, stat_rx_total_good_packets_0, stat_rx_total_bytes_0, 
  stat_rx_total_good_bytes_0, stat_rx_packet_small_0, stat_rx_jabber_0, 
  stat_rx_packet_large_0, stat_rx_oversize_0, stat_rx_undersize_0, stat_rx_toolong_0, 
  stat_rx_fragment_0, stat_rx_packet_64_bytes_0, stat_rx_packet_65_127_bytes_0, 
  stat_rx_packet_128_255_bytes_0, stat_rx_packet_256_511_bytes_0, 
  stat_rx_packet_512_1023_bytes_0, stat_rx_packet_1024_1518_bytes_0, 
  stat_rx_packet_1519_1522_bytes_0, stat_rx_packet_1523_1548_bytes_0, 
  stat_rx_bad_fcs_0, stat_rx_packet_bad_fcs_0, stat_rx_stomped_fcs_0, 
  stat_rx_packet_1549_2047_bytes_0, stat_rx_packet_2048_4095_bytes_0, 
  stat_rx_packet_4096_8191_bytes_0, stat_rx_packet_8192_9215_bytes_0, 
  stat_rx_unicast_0, stat_rx_multicast_0, stat_rx_broadcast_0, stat_rx_vlan_0, 
  stat_rx_inrangeerr_0, stat_rx_bad_preamble_0, stat_rx_bad_sfd_0, 
  stat_rx_got_signal_os_0, stat_rx_test_pattern_mismatch_0, stat_rx_truncated_0, 
  stat_rx_local_fault_0, stat_rx_remote_fault_0, stat_rx_internal_local_fault_0, 
  stat_rx_received_local_fault_0, stat_rx_status_0, tx_reset_0, tx_axis_tready_0, 
  tx_axis_tvalid_0, tx_axis_tdata_0, tx_axis_tlast_0, tx_axis_tkeep_0, tx_axis_tuser_0, 
  tx_unfout_0, tx_preamblein_0, ctl_tx_test_pattern_0, ctl_tx_test_pattern_enable_0, 
  ctl_tx_test_pattern_select_0, ctl_tx_data_pattern_select_0, 
  ctl_tx_test_pattern_seed_a_0, ctl_tx_test_pattern_seed_b_0, ctl_tx_enable_0, 
  ctl_tx_fcs_ins_enable_0, ctl_tx_ipg_value_0, ctl_tx_send_lfi_0, ctl_tx_send_rfi_0, 
  ctl_tx_send_idle_0, ctl_tx_custom_preamble_enable_0, ctl_tx_ignore_fcs_0, 
  stat_tx_total_packets_0, stat_tx_total_bytes_0, stat_tx_total_good_packets_0, 
  stat_tx_total_good_bytes_0, stat_tx_packet_64_bytes_0, stat_tx_packet_65_127_bytes_0, 
  stat_tx_packet_128_255_bytes_0, stat_tx_packet_256_511_bytes_0, 
  stat_tx_packet_512_1023_bytes_0, stat_tx_packet_1024_1518_bytes_0, 
  stat_tx_packet_1519_1522_bytes_0, stat_tx_packet_1523_1548_bytes_0, 
  stat_tx_packet_small_0, stat_tx_packet_large_0, stat_tx_packet_1549_2047_bytes_0, 
  stat_tx_packet_2048_4095_bytes_0, stat_tx_packet_4096_8191_bytes_0, 
  stat_tx_packet_8192_9215_bytes_0, stat_tx_unicast_0, stat_tx_multicast_0, 
  stat_tx_broadcast_0, stat_tx_vlan_0, stat_tx_bad_fcs_0, stat_tx_frame_error_0, 
  stat_tx_local_fault_0, tx_core_clk_0, rx_core_clk_0, rx_serdes_clk_0, rx_serdes_reset_0, 
  rxgearboxslip_in_0, rxdatavalid_out_0, rxheader_out_0, rxheadervalid_out_0, 
  rx_serdes_data_out_0, tx_serdes_data_in_0, txheader_in_0)
/* synthesis syn_black_box black_box_pad_pin="rx_reset_0,rx_axis_tvalid_0,rx_axis_tdata_0[63:0],rx_axis_tlast_0,rx_axis_tkeep_0[7:0],rx_axis_tuser_0,rx_preambleout_0[55:0],ctl_rx_test_pattern_0,ctl_rx_test_pattern_enable_0,ctl_rx_data_pattern_select_0,ctl_rx_enable_0,ctl_rx_delete_fcs_0,ctl_rx_ignore_fcs_0,ctl_rx_max_packet_len_0[14:0],ctl_rx_min_packet_len_0[7:0],ctl_rx_custom_preamble_enable_0,ctl_rx_check_sfd_0,ctl_rx_check_preamble_0,ctl_rx_process_lfi_0,ctl_rx_force_resync_0,stat_rx_block_lock_0,stat_rx_framing_err_valid_0,stat_rx_framing_err_0,stat_rx_hi_ber_0,stat_rx_valid_ctrl_code_0,stat_rx_bad_code_0,stat_rx_total_packets_0[1:0],stat_rx_total_good_packets_0,stat_rx_total_bytes_0[3:0],stat_rx_total_good_bytes_0[13:0],stat_rx_packet_small_0,stat_rx_jabber_0,stat_rx_packet_large_0,stat_rx_oversize_0,stat_rx_undersize_0,stat_rx_toolong_0,stat_rx_fragment_0,stat_rx_packet_64_bytes_0,stat_rx_packet_65_127_bytes_0,stat_rx_packet_128_255_bytes_0,stat_rx_packet_256_511_bytes_0,stat_rx_packet_512_1023_bytes_0,stat_rx_packet_1024_1518_bytes_0,stat_rx_packet_1519_1522_bytes_0,stat_rx_packet_1523_1548_bytes_0,stat_rx_bad_fcs_0[1:0],stat_rx_packet_bad_fcs_0,stat_rx_stomped_fcs_0[1:0],stat_rx_packet_1549_2047_bytes_0,stat_rx_packet_2048_4095_bytes_0,stat_rx_packet_4096_8191_bytes_0,stat_rx_packet_8192_9215_bytes_0,stat_rx_unicast_0,stat_rx_multicast_0,stat_rx_broadcast_0,stat_rx_vlan_0,stat_rx_inrangeerr_0,stat_rx_bad_preamble_0,stat_rx_bad_sfd_0,stat_rx_got_signal_os_0,stat_rx_test_pattern_mismatch_0,stat_rx_truncated_0,stat_rx_local_fault_0,stat_rx_remote_fault_0,stat_rx_internal_local_fault_0,stat_rx_received_local_fault_0,stat_rx_status_0,tx_reset_0,tx_axis_tready_0,tx_axis_tvalid_0,tx_axis_tdata_0[63:0],tx_axis_tlast_0,tx_axis_tkeep_0[7:0],tx_axis_tuser_0,tx_unfout_0,tx_preamblein_0[55:0],ctl_tx_test_pattern_0,ctl_tx_test_pattern_enable_0,ctl_tx_test_pattern_select_0,ctl_tx_data_pattern_select_0,ctl_tx_test_pattern_seed_a_0[57:0],ctl_tx_test_pattern_seed_b_0[57:0],ctl_tx_enable_0,ctl_tx_fcs_ins_enable_0,ctl_tx_ipg_value_0[3:0],ctl_tx_send_lfi_0,ctl_tx_send_rfi_0,ctl_tx_send_idle_0,ctl_tx_custom_preamble_enable_0,ctl_tx_ignore_fcs_0,stat_tx_total_packets_0,stat_tx_total_bytes_0[3:0],stat_tx_total_good_packets_0,stat_tx_total_good_bytes_0[13:0],stat_tx_packet_64_bytes_0,stat_tx_packet_65_127_bytes_0,stat_tx_packet_128_255_bytes_0,stat_tx_packet_256_511_bytes_0,stat_tx_packet_512_1023_bytes_0,stat_tx_packet_1024_1518_bytes_0,stat_tx_packet_1519_1522_bytes_0,stat_tx_packet_1523_1548_bytes_0,stat_tx_packet_small_0,stat_tx_packet_large_0,stat_tx_packet_1549_2047_bytes_0,stat_tx_packet_2048_4095_bytes_0,stat_tx_packet_4096_8191_bytes_0,stat_tx_packet_8192_9215_bytes_0,stat_tx_unicast_0,stat_tx_multicast_0,stat_tx_broadcast_0,stat_tx_vlan_0,stat_tx_bad_fcs_0,stat_tx_frame_error_0,stat_tx_local_fault_0,tx_core_clk_0,rx_core_clk_0,rx_serdes_clk_0,rx_serdes_reset_0,rxgearboxslip_in_0[0:0],rxdatavalid_out_0[1:0],rxheader_out_0[5:0],rxheadervalid_out_0[1:0],rx_serdes_data_out_0[127:0],tx_serdes_data_in_0[127:0],txheader_in_0[5:0]" */;
  input rx_reset_0;
  output rx_axis_tvalid_0;
  output [63:0]rx_axis_tdata_0;
  output rx_axis_tlast_0;
  output [7:0]rx_axis_tkeep_0;
  output rx_axis_tuser_0;
  output [55:0]rx_preambleout_0;
  input ctl_rx_test_pattern_0;
  input ctl_rx_test_pattern_enable_0;
  input ctl_rx_data_pattern_select_0;
  input ctl_rx_enable_0;
  input ctl_rx_delete_fcs_0;
  input ctl_rx_ignore_fcs_0;
  input [14:0]ctl_rx_max_packet_len_0;
  input [7:0]ctl_rx_min_packet_len_0;
  input ctl_rx_custom_preamble_enable_0;
  input ctl_rx_check_sfd_0;
  input ctl_rx_check_preamble_0;
  input ctl_rx_process_lfi_0;
  input ctl_rx_force_resync_0;
  output stat_rx_block_lock_0;
  output stat_rx_framing_err_valid_0;
  output stat_rx_framing_err_0;
  output stat_rx_hi_ber_0;
  output stat_rx_valid_ctrl_code_0;
  output stat_rx_bad_code_0;
  output [1:0]stat_rx_total_packets_0;
  output stat_rx_total_good_packets_0;
  output [3:0]stat_rx_total_bytes_0;
  output [13:0]stat_rx_total_good_bytes_0;
  output stat_rx_packet_small_0;
  output stat_rx_jabber_0;
  output stat_rx_packet_large_0;
  output stat_rx_oversize_0;
  output stat_rx_undersize_0;
  output stat_rx_toolong_0;
  output stat_rx_fragment_0;
  output stat_rx_packet_64_bytes_0;
  output stat_rx_packet_65_127_bytes_0;
  output stat_rx_packet_128_255_bytes_0;
  output stat_rx_packet_256_511_bytes_0;
  output stat_rx_packet_512_1023_bytes_0;
  output stat_rx_packet_1024_1518_bytes_0;
  output stat_rx_packet_1519_1522_bytes_0;
  output stat_rx_packet_1523_1548_bytes_0;
  output [1:0]stat_rx_bad_fcs_0;
  output stat_rx_packet_bad_fcs_0;
  output [1:0]stat_rx_stomped_fcs_0;
  output stat_rx_packet_1549_2047_bytes_0;
  output stat_rx_packet_2048_4095_bytes_0;
  output stat_rx_packet_4096_8191_bytes_0;
  output stat_rx_packet_8192_9215_bytes_0;
  output stat_rx_unicast_0;
  output stat_rx_multicast_0;
  output stat_rx_broadcast_0;
  output stat_rx_vlan_0;
  output stat_rx_inrangeerr_0;
  output stat_rx_bad_preamble_0;
  output stat_rx_bad_sfd_0;
  output stat_rx_got_signal_os_0;
  output stat_rx_test_pattern_mismatch_0;
  output stat_rx_truncated_0;
  output stat_rx_local_fault_0;
  output stat_rx_remote_fault_0;
  output stat_rx_internal_local_fault_0;
  output stat_rx_received_local_fault_0;
  output stat_rx_status_0;
  input tx_reset_0;
  output tx_axis_tready_0;
  input tx_axis_tvalid_0;
  input [63:0]tx_axis_tdata_0;
  input tx_axis_tlast_0;
  input [7:0]tx_axis_tkeep_0;
  input tx_axis_tuser_0;
  output tx_unfout_0;
  input [55:0]tx_preamblein_0;
  input ctl_tx_test_pattern_0;
  input ctl_tx_test_pattern_enable_0;
  input ctl_tx_test_pattern_select_0;
  input ctl_tx_data_pattern_select_0;
  input [57:0]ctl_tx_test_pattern_seed_a_0;
  input [57:0]ctl_tx_test_pattern_seed_b_0;
  input ctl_tx_enable_0;
  input ctl_tx_fcs_ins_enable_0;
  input [3:0]ctl_tx_ipg_value_0;
  input ctl_tx_send_lfi_0;
  input ctl_tx_send_rfi_0;
  input ctl_tx_send_idle_0;
  input ctl_tx_custom_preamble_enable_0;
  input ctl_tx_ignore_fcs_0;
  output stat_tx_total_packets_0;
  output [3:0]stat_tx_total_bytes_0;
  output stat_tx_total_good_packets_0;
  output [13:0]stat_tx_total_good_bytes_0;
  output stat_tx_packet_64_bytes_0;
  output stat_tx_packet_65_127_bytes_0;
  output stat_tx_packet_128_255_bytes_0;
  output stat_tx_packet_256_511_bytes_0;
  output stat_tx_packet_512_1023_bytes_0;
  output stat_tx_packet_1024_1518_bytes_0;
  output stat_tx_packet_1519_1522_bytes_0;
  output stat_tx_packet_1523_1548_bytes_0;
  output stat_tx_packet_small_0;
  output stat_tx_packet_large_0;
  output stat_tx_packet_1549_2047_bytes_0;
  output stat_tx_packet_2048_4095_bytes_0;
  output stat_tx_packet_4096_8191_bytes_0;
  output stat_tx_packet_8192_9215_bytes_0;
  output stat_tx_unicast_0;
  output stat_tx_multicast_0;
  output stat_tx_broadcast_0;
  output stat_tx_vlan_0;
  output stat_tx_bad_fcs_0;
  output stat_tx_frame_error_0;
  output stat_tx_local_fault_0;
  input tx_core_clk_0;
  input rx_core_clk_0;
  input rx_serdes_clk_0;
  input rx_serdes_reset_0;
  output [0:0]rxgearboxslip_in_0;
  input [1:0]rxdatavalid_out_0;
  input [5:0]rxheader_out_0;
  input [1:0]rxheadervalid_out_0;
  input [127:0]rx_serdes_data_out_0;
  output [127:0]tx_serdes_data_in_0;
  output [5:0]txheader_in_0;
endmodule
