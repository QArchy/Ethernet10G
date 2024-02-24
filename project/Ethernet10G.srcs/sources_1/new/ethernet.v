module ethernet(
    input   i_CLK_125,
    input   i_CLK_156_25_P,
    input   i_CLK_156_25_N,
    input   i_reset,
    output  o_ll_tx_p,
    output  o_ll_tx_n,
    input   i_ll_rx_p,
    input   i_ll_rx_n,
    output  o_ll_tx_disable
);
        //// GT_0 Signals
    wire tx_clk_out_0; 
    wire rx_clk_out_0; 
        //// RX_0 Signals
    wire user_rx_reset_0; 
    wire rxrecclkout_0;
        //// RX_0 User Interface  Signals
    wire        rx_axis_tvalid_0;       
    wire [63:0] rx_axis_tdata_0; 
    wire        rx_axis_tlast_0;        
    wire [7:0]  rx_axis_tkeep_0;  
    wire        rx_axis_tuser_0;        
    wire [55:0] rx_preambleout_0;
        //// RX_0 Control Signals
    reg ctl_rx_enable_0;
    
    /* Resync after each rx msg */
    reg ctl_rx_force_resync_0;
    reg prev_rx_valid;
    always @(posedge i_CLK_156_25, posedge i_reset) begin
        if (i_reset) begin
            ctl_rx_force_resync_0 <= 1;
        end else begin
            prev_rx_valid <= rx_axis_tvalid_0;
            
            if (prev_rx_valid && ~rx_axis_tvalid_0) begin
                ctl_rx_force_resync_0 <= 1;
            end else begin
                ctl_rx_force_resync_0 <= 0;
            end
        end
    end
    
        //// TX_0 Signals
    wire            user_tx_reset_0;
        //// TX_0 User Interface  Signals
    wire            tx_axis_tready_0;
    reg             tx_axis_tvalid_0;      
    reg     [63:0]  tx_axis_tdata_0;
    reg             tx_axis_tlast_0;       
    reg     [7:0]   tx_axis_tkeep_0; 
    reg             tx_axis_tuser_0;      
    wire            tx_unfout_0;
        //// TX_0 Control Signals
    reg             ctl_tx_enable_0;
    assign          o_ll_tx_disable = ctl_tx_enable_0;
        //// Other
    wire            gtpowergood_out_0;
    wire            gt_refclk_out;
    
    axi4_stream_sfp_ethernet_controller axi4_stream_sfp_ethernet_controller_inst(
             //// GT_0 Signals
        .gt_rxp_in_0(i_ll_rx_p),                        //  input  wire gt_rxp_in_0;  
        .gt_rxn_in_0(i_ll_rx_n),                        //  input  wire gt_rxn_in_0;  
        .gt_txp_out_0(o_ll_tx_p),                       //  output wire gt_txp_out_0; 
        .gt_txn_out_0(o_ll_tx_n),                       //  output wire gt_txn_out_0; 
        .tx_clk_out_0(tx_clk_out_0),                    //  output wire tx_clk_out_0; 
        .rx_core_clk_0(i_CLK_156_25),                   //  input  wire rx_core_clk_0;
        .rx_clk_out_0(rx_clk_out_0),                    //  output wire rx_clk_out_0; 
        .gt_loopback_in_0(0),                           //  input  wire [2:0] gt_loopback_in_0;
             //// RX_0 Signals
        .rx_reset_0(i_reset),                           //  input  wire rx_reset_0;     
        .user_rx_reset_0(user_rx_reset_0),              //  output wire user_rx_reset_0;
        .rxrecclkout_0(rxrecclkout_0),                  //  output wire rxrecclkout_0;  
             //// RX_0 User Interface  Signals
        .rx_axis_tvalid_0(rx_axis_tvalid_0),            //  output wire rx_axis_tvalid_0;       
        .rx_axis_tdata_0(rx_axis_tdata_0),              //  output wire [63:0] rx_axis_tdata_0; 
        .rx_axis_tlast_0(rx_axis_tlast_0),              //  output wire rx_axis_tlast_0;        
        .rx_axis_tkeep_0(rx_axis_tkeep_0),              //  output wire [7:0] rx_axis_tkeep_0;  
        .rx_axis_tuser_0(rx_axis_tuser_0),              //  output wire rx_axis_tuser_0;        
        .rx_preambleout_0(rx_preambleout_0),            //  output wire [55:0] rx_preambleout_0;
             //// RX_0 Control Signals
        .ctl_rx_test_pattern_0(0),                      //  input  wire ctl_rx_test_pattern_0;          
        .ctl_rx_test_pattern_enable_0(0),               //  input  wire ctl_rx_test_pattern_enable_0;   
        .ctl_rx_data_pattern_select_0(0),               //  input  wire ctl_rx_data_pattern_select_0;   
        .ctl_rx_enable_0(ctl_rx_enable_0),              //  input  wire ctl_rx_enable_0;                
        .ctl_rx_delete_fcs_0(0),                        //  input  wire ctl_rx_delete_fcs_0;            
        .ctl_rx_ignore_fcs_0(0),                        //  input  wire ctl_rx_ignore_fcs_0;            
        .ctl_rx_max_packet_len_0(14'd16383),            //  input  wire [14:0] ctl_rx_max_packet_len_0; 
        .ctl_rx_min_packet_len_0(8'd4),                 //  input  wire [7:0] ctl_rx_min_packet_len_0;  
        .ctl_rx_custom_preamble_enable_0(0),            //  input  wire ctl_rx_custom_preamble_enable_0;
        .ctl_rx_check_sfd_0(0),                         //  input  wire ctl_rx_check_sfd_0;             
        .ctl_rx_check_preamble_0(0),                    //  input  wire ctl_rx_check_preamble_0;        
        .ctl_rx_process_lfi_0(0),                       //  input  wire ctl_rx_process_lfi_0;           
        .ctl_rx_force_resync_0(ctl_rx_force_resync_0),  //  input  wire ctl_rx_force_resync_0;    
           //// RX_0 Stats Signals
        .stat_rx_block_lock_0(),                        //  output wire stat_rx_block_lock_0;                
        .stat_rx_framing_err_valid_0(),                 //  output wire stat_rx_framing_err_valid_0;         
        .stat_rx_framing_err_0(),                       //  output wire stat_rx_framing_err_0;               
        .stat_rx_hi_ber_0(),                            //  output wire stat_rx_hi_ber_0;                    
        .stat_rx_valid_ctrl_code_0(),                   //  output wire stat_rx_valid_ctrl_code_0;           
        .stat_rx_bad_code_0(),                          //  output wire stat_rx_bad_code_0;                  
        .stat_rx_total_packets_0(),                     //  output wire [1:0] stat_rx_total_packets_0;       
        .stat_rx_total_good_packets_0(),                //  output wire stat_rx_total_good_packets_0;        
        .stat_rx_total_bytes_0(),                       //  output wire [3:0] stat_rx_total_bytes_0;         
        .stat_rx_total_good_bytes_0(),                  //  output wire [13:0] stat_rx_total_good_bytes_0;   
        .stat_rx_packet_small_0(),                      //  output wire stat_rx_packet_small_0;              
        .stat_rx_jabber_0(),                            //  output wire stat_rx_jabber_0;                    
        .stat_rx_packet_large_0(),                      //  output wire stat_rx_packet_large_0;              
        .stat_rx_oversize_0(),                          //  output wire stat_rx_oversize_0;                  
        .stat_rx_undersize_0(),                         //  output wire stat_rx_undersize_0;                 
        .stat_rx_toolong_0(),                           //  output wire stat_rx_toolong_0;                   
        .stat_rx_fragment_0(),                          //  output wire stat_rx_fragment_0;                  
        .stat_rx_packet_64_bytes_0(),                   //  output wire stat_rx_packet_64_bytes_0;           
        .stat_rx_packet_65_127_bytes_0(),               //  output wire stat_rx_packet_65_127_bytes_0;       
        .stat_rx_packet_128_255_bytes_0(),              //  output wire stat_rx_packet_128_255_bytes_0;      
        .stat_rx_packet_256_511_bytes_0(),              //  output wire stat_rx_packet_256_511_bytes_0;      
        .stat_rx_packet_512_1023_bytes_0(),             //  output wire stat_rx_packet_512_1023_bytes_0;     
        .stat_rx_packet_1024_1518_bytes_0(),            //  output wire stat_rx_packet_1024_1518_bytes_0;    
        .stat_rx_packet_1519_1522_bytes_0(),            //  output wire stat_rx_packet_1519_1522_bytes_0;    
        .stat_rx_packet_1523_1548_bytes_0(),            //  output wire stat_rx_packet_1523_1548_bytes_0;    
        .stat_rx_bad_fcs_0(),                           //  output wire [1:0] stat_rx_bad_fcs_0;             
        .stat_rx_packet_bad_fcs_0(),                    //  output wire stat_rx_packet_bad_fcs_0;            
        .stat_rx_stomped_fcs_0(),                       //  output wire [1:0] stat_rx_stomped_fcs_0;         
        .stat_rx_packet_1549_2047_bytes_0(),            //  output wire stat_rx_packet_1549_2047_bytes_0;    
        .stat_rx_packet_2048_4095_bytes_0(),            //  output wire stat_rx_packet_2048_4095_bytes_0;    
        .stat_rx_packet_4096_8191_bytes_0(),            //  output wire stat_rx_packet_4096_8191_bytes_0;    
        .stat_rx_packet_8192_9215_bytes_0(),            //  output wire stat_rx_packet_8192_9215_bytes_0;    
        .stat_rx_unicast_0(),                           //  output wire stat_rx_unicast_0;                   
        .stat_rx_multicast_0(),                         //  output wire stat_rx_multicast_0;                 
        .stat_rx_broadcast_0(),                         //  output wire stat_rx_broadcast_0;                 
        .stat_rx_vlan_0(),                              //  output wire stat_rx_vlan_0;                      
        .stat_rx_inrangeerr_0(),                        //  output wire stat_rx_inrangeerr_0;                
        .stat_rx_bad_preamble_0(),                      //  output wire stat_rx_bad_preamble_0;              
        .stat_rx_bad_sfd_0(),                           //  output wire stat_rx_bad_sfd_0;                   
        .stat_rx_got_signal_os_0(),                     //  output wire stat_rx_got_signal_os_0;             
        .stat_rx_test_pattern_mismatch_0(),             //  output wire stat_rx_test_pattern_mismatch_0;     
        .stat_rx_truncated_0(),                         //  output wire stat_rx_truncated_0;                 
        .stat_rx_local_fault_0(),                       //  output wire stat_rx_local_fault_0;               
        .stat_rx_remote_fault_0(),                      //  output wire stat_rx_remote_fault_0;              
        .stat_rx_internal_local_fault_0(),              //  output wire stat_rx_internal_local_fault_0;      
        .stat_rx_received_local_fault_0(),              //  output wire stat_rx_received_local_fault_0;      
        .stat_rx_status_0(),                            //  output wire  stat_rx_status_0;            
             //// TX_0 Signals
        .tx_reset_0(i_reset),                           //  input  wire tx_reset_0;     
        .user_tx_reset_0(user_tx_reset_0),              //  output wire user_tx_reset_0;
             //// TX_0 User Interface  Signals
        .tx_axis_tready_0(tx_axis_tready_0),            //  output wire tx_axis_tready_0;       
        .tx_axis_tvalid_0(tx_axis_tvalid_0),            //  input  wire tx_axis_tvalid_0;       
        .tx_axis_tdata_0(tx_axis_tdata_0),              //  input  wire [63:0] tx_axis_tdata_0; 
        .tx_axis_tlast_0(tx_axis_tlast_0),              //  input  wire tx_axis_tlast_0;        
        .tx_axis_tkeep_0(tx_axis_tkeep_0),              //  input  wire [7:0] tx_axis_tkeep_0;  
        .tx_axis_tuser_0(tx_axis_tuser_0),              //  input  wire tx_axis_tuser_0;        
        .tx_unfout_0(tx_unfout_0),                      //  output wire tx_unfout_0;            
        .tx_preamblein_0(1),                            //  input  wire [55:0] tx_preamblein_0; 
             //// TX_0 Control Signals
        .ctl_tx_test_pattern_0(0),                      //  input  wire ctl_tx_test_pattern_0;              
        .ctl_tx_test_pattern_enable_0(0),               //  input  wire ctl_tx_test_pattern_enable_0;       
        .ctl_tx_test_pattern_select_0(0),               //  input  wire ctl_tx_test_pattern_select_0;       
        .ctl_tx_data_pattern_select_0(0),               //  input  wire ctl_tx_data_pattern_select_0;       
        .ctl_tx_test_pattern_seed_a_0(0),               //  input  wire [57:0] ctl_tx_test_pattern_seed_a_0;
        .ctl_tx_test_pattern_seed_b_0(0),               //  input  wire [57:0] ctl_tx_test_pattern_seed_b_0;
        .ctl_tx_enable_0(ctl_tx_enable_0),              //  input  wire ctl_tx_enable_0;                    
        .ctl_tx_fcs_ins_enable_0(1),                    //  input  wire ctl_tx_fcs_ins_enable_0;            
        .ctl_tx_ipg_value_0(0),                         //  input  wire [3:0] ctl_tx_ipg_value_0;           
        .ctl_tx_send_lfi_0(0),                          //  input  wire ctl_tx_send_lfi_0;                  
        .ctl_tx_send_rfi_0(0),                          //  input  wire ctl_tx_send_rfi_0;                  
        .ctl_tx_send_idle_0(0),                         //  input  wire ctl_tx_send_idle_0;                 
        .ctl_tx_custom_preamble_enable_0(0),            //  input  wire ctl_tx_custom_preamble_enable_0;    
        .ctl_tx_ignore_fcs_0(0),                        //  input  wire ctl_tx_ignore_fcs_0;
        /*  //// TX_0 Stats Signals
        .stat_tx_total_packets_0(),                     //  output wire stat_tx_total_packets_0;          
        .stat_tx_total_bytes_0(),                       //  output wire [3:0] stat_tx_total_bytes_0;      
        .stat_tx_total_good_packets_0(),                //  output wire stat_tx_total_good_packets_0;     
        .stat_tx_total_good_bytes_0(),                  //  output wire [13:0] stat_tx_total_good_bytes_0;
        .stat_tx_packet_64_bytes_0(),                   //  output wire stat_tx_packet_64_bytes_0;        
        .stat_tx_packet_65_127_bytes_0(),               //  output wire stat_tx_packet_65_127_bytes_0;    
        .stat_tx_packet_128_255_bytes_0(),              //  output wire stat_tx_packet_128_255_bytes_0;   
        .stat_tx_packet_256_511_bytes_0(),              //  output wire stat_tx_packet_256_511_bytes_0;   
        .stat_tx_packet_512_1023_bytes_0(),             //  output wire stat_tx_packet_512_1023_bytes_0;  
        .stat_tx_packet_1024_1518_bytes_0(),            //  output wire stat_tx_packet_1024_1518_bytes_0; 
        .stat_tx_packet_1519_1522_bytes_0(),            //  output wire stat_tx_packet_1519_1522_bytes_0; 
        .stat_tx_packet_1523_1548_bytes_0(),            //  output wire stat_tx_packet_1523_1548_bytes_0; 
        .stat_tx_packet_small_0(),                      //  output wire stat_tx_packet_small_0;           
        .stat_tx_packet_large_0(),                      //  output wire stat_tx_packet_large_0;           
        .stat_tx_packet_1549_2047_bytes_0(),            //  output wire stat_tx_packet_1549_2047_bytes_0; 
        .stat_tx_packet_2048_4095_bytes_0(),            //  output wire stat_tx_packet_2048_4095_bytes_0; 
        .stat_tx_packet_4096_8191_bytes_0(),            //  output wire stat_tx_packet_4096_8191_bytes_0; 
        .stat_tx_packet_8192_9215_bytes_0(),            //  output wire stat_tx_packet_8192_9215_bytes_0; 
        .stat_tx_unicast_0(),                           //  output wire stat_tx_unicast_0;                
        .stat_tx_multicast_0(),                         //  output wire stat_tx_multicast_0;              
        .stat_tx_broadcast_0(),                         //  output wire stat_tx_broadcast_0;              
        .stat_tx_vlan_0(),                              //  output wire stat_tx_vlan_0;                   
        .stat_tx_bad_fcs_0(),                           //  output wire stat_tx_bad_fcs_0;                
        .stat_tx_frame_error_0(),                       //  output wire stat_tx_frame_error_0;            
        .stat_tx_local_fault_0(),                       //  output wire stat_tx_local_fault_0;        */
            //// Other
        .gtwiz_reset_tx_datapath_0(i_reset),            //  input wire gtwiz_reset_tx_datapath_0;
        .gtwiz_reset_rx_datapath_0(i_reset),            //  input wire gtwiz_reset_rx_datapath_0;
        .qpllreset_in_0(i_reset),                       //  input wire qpllreset_in_0;           
        .gtpowergood_out_0(gtpowergood_out_0),          //  output wire gtpowergood_out_0;       
        .txoutclksel_in_0(3'b101),                      //  input wire [2:0] txoutclksel_in_0;   
        .rxoutclksel_in_0(3'b101),                      //  input wire [2:0] rxoutclksel_in_0;   
        .gt_refclk_p(i_CLK_156_25_P),                   //  input  wire [0:0] gt_refclk_p;  
        .gt_refclk_n(i_CLK_156_25_N),                   //  input  wire [0:0] gt_refclk_n;  
        .gt_refclk_out(gt_refclk_out),                  //  output wire [0:0] gt_refclk_out;
        .sys_reset(i_reset),                            //  input  wire sys_reset;
        .dclk(i_CLK_125)                                //  input  wire dclk;     
    );
    
endmodule
