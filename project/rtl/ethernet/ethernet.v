module ethernet(
    input   i_CLK_125,
    input   i_CLK_156_25_P,
    input   i_CLK_156_25_N,
    input   i_reset,
    output  o_ll_tx_p,
    output  o_ll_tx_n,
    input   i_ll_rx_p,
    input   i_ll_rx_n,
    output  o_ll_tx_disable										// Clock domain - tx_clk_out
);
	reg ip_init;												// Clock domain - Async & ???
	
	reg o_ll_tx_disable_r; assign o_ll_tx_disable = o_ll_tx_disable_r;
	
	wire gt_rxp_in = i_ll_rx_p;                             	// Clock domain - global input
	wire gt_rxn_in = i_ll_rx_n;                             	// Clock domain - global input
	wire gt_txp_out; assign o_ll_tx_p = gt_txp_out;             // Clock domain - global output
	wire gt_txn_out; assign o_ll_tx_n = gt_txn_out; 			// Clock domain - global output
	wire tx_clk_out;											// Clock domain - tx_clk_out
	wire rx_clk_out;											// Clock domain - rx_clk_out
		
    reg  [2:0] gt_loopback_in;									// Clock domain - ???
    
    reg rx_reset_r; wire rx_reset = rx_reset_r || i_reset;		// Clock domain - Async
																
    wire user_rx_reset;                                         // Clock domain - ???
    wire rxrecclkout;                                           // Clock domain - ???
    
    wire rx_axis_tvalid;                                        // Clock domain - rx_core_clk == tx_clk_out
    wire [63:0] rx_axis_tdata;                                  // Clock domain - rx_core_clk == tx_clk_out
    wire rx_axis_tlast;                                         // Clock domain - rx_core_clk == tx_clk_out
    wire [7:0] rx_axis_tkeep;                                   // Clock domain - rx_core_clk == tx_clk_out
    wire rx_axis_tuser;                                         // Clock domain - rx_core_clk == tx_clk_out
    wire [55:0] rx_preambleout;                                 // Clock domain - rx_core_clk == tx_clk_out
    
    reg ctl_rx_test_pattern;                                    // Clock domain - rx_clk_out
    reg ctl_rx_test_pattern_enable;                             // Clock domain - rx_clk_out
    reg ctl_rx_data_pattern_select;                             // Clock domain - rx_clk_out
    reg ctl_rx_enable;                                          // Clock domain - rx_clk_out
    reg ctl_rx_delete_fcs;                                      // Clock domain - rx_clk_out
    reg ctl_rx_ignore_fcs;                                      // Clock domain - rx_clk_out
    reg [14:0] ctl_rx_max_packet_len;                           // Clock domain - rx_clk_out
    reg [7:0] ctl_rx_min_packet_len;                            // Clock domain - rx_clk_out
    reg ctl_rx_custom_preamble_enable;                          // Clock domain - rx_clk_out
    reg ctl_rx_check_sfd;                                       // Clock domain - rx_clk_out
    reg ctl_rx_check_preamble;                                  // Clock domain - rx_clk_out
    reg ctl_rx_process_lfi;                                     // Clock domain - rx_clk_out
    reg ctl_rx_force_resync;                                    // Clock domain - rx_clk_out
    
    wire stat_rx_block_lock;                                    // Clock domain - rx_clk_out
	wire stat_rx_framing_err_valid;                             // Clock domain - rx_clk_out
	wire stat_rx_framing_err;                                   // Clock domain - rx_clk_out
	wire stat_rx_hi_ber;                                        // Clock domain - rx_clk_out
	wire stat_rx_valid_ctrl_code;                               // Clock domain - rx_clk_out
	wire stat_rx_bad_code;                                      // Clock domain - rx_clk_out
	wire [1:0] stat_rx_total_packets;                           // Clock domain - rx_clk_out
	wire stat_rx_total_good_packets;                            // Clock domain - rx_clk_out
	wire [3:0] stat_rx_total_bytes;                             // Clock domain - rx_clk_out
	wire [13:0] stat_rx_total_good_bytes;                       // Clock domain - rx_clk_out
	wire stat_rx_packet_small;                                  // Clock domain - rx_clk_out
	wire stat_rx_jabber;                                        // Clock domain - rx_clk_out
	wire stat_rx_packet_large;                                  // Clock domain - rx_clk_out
	wire stat_rx_oversize;                                      // Clock domain - rx_clk_out
	wire stat_rx_undersize;                                     // Clock domain - rx_clk_out
	wire stat_rx_toolong;                                       // Clock domain - rx_clk_out
	wire stat_rx_fragment;                                      // Clock domain - rx_clk_out
	wire stat_rx_packet_64_bytes;                               // Clock domain - rx_clk_out
	wire stat_rx_packet_65_127_bytes;                          	// Clock domain - rx_clk_out
	wire stat_rx_packet_128_255_bytes;                         	// Clock domain - rx_clk_out
	wire stat_rx_packet_256_511_bytes;                          // Clock domain - rx_clk_out
	wire stat_rx_packet_512_1023_bytes;                         // Clock domain - rx_clk_out
	wire stat_rx_packet_1024_1518_bytes;                        // Clock domain - rx_clk_out
	wire stat_rx_packet_1519_1522_bytes;                        // Clock domain - rx_clk_out
	wire stat_rx_packet_1523_1548_bytes;                        // Clock domain - rx_clk_out
	wire [1:0] stat_rx_bad_fcs;                                 // Clock domain - rx_clk_out
	wire stat_rx_packet_bad_fcs;                                // Clock domain - rx_clk_out
	wire [1:0] stat_rx_stomped_fcs;                             // Clock domain - rx_clk_out
	wire stat_rx_packet_1549_2047_bytes;                        // Clock domain - rx_clk_out
	wire stat_rx_packet_2048_4095_bytes;                        // Clock domain - rx_clk_out
	wire stat_rx_packet_4096_8191_bytes;                        // Clock domain - rx_clk_out
	wire stat_rx_packet_8192_9215_bytes;                        // Clock domain - rx_clk_out
	wire stat_rx_unicast;                                       // Clock domain - rx_clk_out
	wire stat_rx_multicast;                                     // Clock domain - rx_clk_out
	wire stat_rx_broadcast;                                     // Clock domain - rx_clk_out
	wire stat_rx_vlan;                                          // Clock domain - rx_clk_out
	wire stat_rx_inrangeerr;                                    // Clock domain - rx_clk_out
	wire stat_rx_bad_preamble;                                  // Clock domain - rx_clk_out
	wire stat_rx_bad_sfd;                                       // Clock domain - rx_clk_out
	wire stat_rx_got_signal_os;                                 // Clock domain - rx_clk_out
	wire stat_rx_test_pattern_mismatch;                         // Clock domain - rx_clk_out
	wire stat_rx_truncated;                                     // Clock domain - rx_clk_out
	wire stat_rx_local_fault;                                   // Clock domain - rx_clk_out
	wire stat_rx_remote_fault;                                  // Clock domain - rx_clk_out
	wire stat_rx_internal_local_fault;                          // Clock domain - rx_clk_out
	wire stat_rx_received_local_fault;                          // Clock domain - rx_clk_out
	wire stat_rx_status;           
	
	reg tx_reset_r; wire tx_reset = tx_reset_r || i_reset;      // Clock domain - Async
	
	wire user_tx_reset;                                         // Clock domain - ???
	wire tx_axis_tready;                                        // Clock domain - tx_clk_out
	
	reg tx_axis_tvalid;                                         // Clock domain - tx_clk_out
	reg [63:0] tx_axis_tdata;                                   // Clock domain - tx_clk_out
	reg tx_axis_tlast;                                          // Clock domain - tx_clk_out
	reg [7:0] tx_axis_tkeep;                                    // Clock domain - tx_clk_out
	reg tx_axis_tuser;                                          // Clock domain - tx_clk_out
	
	wire tx_unfout;                                             // Clock domain - ???
	reg [55:0] tx_preamblein;                                   // Clock domain - tx_clk_out
	
	reg ctl_tx_test_pattern;                                    // Clock domain - tx_clk_out
	reg ctl_tx_test_pattern_enable;                             // Clock domain - tx_clk_out
	reg ctl_tx_test_pattern_select;                             // Clock domain - tx_clk_out
	reg ctl_tx_data_pattern_select;                             // Clock domain - tx_clk_out
	reg [57:0] ctl_tx_test_pattern_seed_a;                      // Clock domain - tx_clk_out
	reg [57:0] ctl_tx_test_pattern_seed_b;                      // Clock domain - tx_clk_out
	reg ctl_tx_enable;                                          // Clock domain - tx_clk_out
	reg ctl_tx_fcs_ins_enable;                                  // Clock domain - tx_clk_out
	reg [3:0] ctl_tx_ipg_value;                                 // Clock domain - tx_clk_out
	reg ctl_tx_send_lfi;                                        // Clock domain - tx_clk_out
	reg ctl_tx_send_rfi;                                        // Clock domain - tx_clk_out
	reg ctl_tx_send_idle;                                       // Clock domain - tx_clk_out
	reg ctl_tx_custom_preamble_enable;                          // Clock domain - tx_clk_out
	reg ctl_tx_ignore_fcs;                                      // Clock domain - tx_clk_out
	
	wire stat_tx_total_packets;                                 // Clock domain - tx_clk_out
	wire [3:0] stat_tx_total_bytes;                             // Clock domain - tx_clk_out
	wire stat_tx_total_good_packets;                            // Clock domain - tx_clk_out
	wire [13:0] stat_tx_total_good_bytes;                       // Clock domain - tx_clk_out
	wire stat_tx_packet_64_bytes;                               // Clock domain - tx_clk_out
	wire stat_tx_packet_65_127_bytes;                           // Clock domain - tx_clk_out
	wire stat_tx_packet_128_255_bytes;                          // Clock domain - tx_clk_out
	wire stat_tx_packet_256_511_bytes;                          // Clock domain - tx_clk_out
	wire stat_tx_packet_512_1023_bytes;                         // Clock domain - tx_clk_out
	wire stat_tx_packet_1024_1518_bytes;                        // Clock domain - tx_clk_out
	wire stat_tx_packet_1519_1522_bytes;                        // Clock domain - tx_clk_out
	wire stat_tx_packet_1523_1548_bytes;                        // Clock domain - tx_clk_out
	wire stat_tx_packet_small;                                  // Clock domain - tx_clk_out
	wire stat_tx_packet_large;                                  // Clock domain - tx_clk_out
	wire stat_tx_packet_1549_2047_bytes;                        // Clock domain - tx_clk_out
	wire stat_tx_packet_2048_4095_bytes;                        // Clock domain - tx_clk_out
	wire stat_tx_packet_4096_8191_bytes;                        // Clock domain - tx_clk_out
	wire stat_tx_packet_8192_9215_bytes;                        // Clock domain - tx_clk_out
	wire stat_tx_unicast;                        		        // Clock domain - tx_clk_out
	wire stat_tx_multicast;                                     // Clock domain - tx_clk_out
	wire stat_tx_broadcast;                                     // Clock domain - tx_clk_out
	wire stat_tx_vlan;                        		            // Clock domain - tx_clk_out
	wire stat_tx_bad_fcs;                   		            // Clock domain - tx_clk_out
	wire stat_tx_frame_error;                                   // Clock domain - tx_clk_out
	wire stat_tx_local_fault;                                   // Clock domain - tx_clk_out

	reg gtwiz_reset_tx_datapath_r; 	wire gtwiz_reset_tx_datapath = gtwiz_reset_tx_datapath_r || i_reset;	// Clock domain - ???
	reg gtwiz_reset_rx_datapath_r; 	wire gtwiz_reset_rx_datapath = gtwiz_reset_rx_datapath_r || i_reset;    // Clock domain - ???
	reg qpllreset_in_r; 			wire qpllreset_in			 = qpllreset_in_r || i_reset;               // Clock domain - ???
	wire gtpowergood_out;                                                                                   // Clock domain - ???
	reg [2:0] txoutclksel_in;                                                                               // Clock domain - ???
	reg [2:0] rxoutclksel_in;                                                                               // Clock domain - ???
	wire gt_refclk_p = i_CLK_156_25_P;                                                                      // Clock domain - global input
	wire gt_refclk_n = i_CLK_156_25_N;                                                                      // Clock domain - global input
	wire gt_refclk_out;                                                                                     // Clock domain - gt_refclk_out
	reg sys_reset_r; 				wire sys_reset				 = sys_reset_r || i_reset;                  // Clock domain - ???
	wire dclk = i_CLK_125;                                                                                  // Clock domain - global input
	
	always @(posedge tx_clk_out, posedge i_reset) begin		// Clock domain - tx_clk_out
		if (i_reset) begin
			o_ll_tx_disable_r 				<= 0;
						
			tx_axis_tvalid					<= 0;      
			tx_axis_tdata					<= 0;
			tx_axis_tlast					<= 0;       
			tx_axis_tkeep					<= 0; 
			tx_axis_tuser					<= 0;        
			tx_preamblein					<= 0;
				
			ctl_tx_test_pattern				<= 0;              
			ctl_tx_test_pattern_enable		<= 0;       
			ctl_tx_test_pattern_select		<= 0;       
			ctl_tx_data_pattern_select		<= 0;       
			ctl_tx_test_pattern_seed_a		<= 0;
			ctl_tx_test_pattern_seed_b		<= 0;
			ctl_tx_enable					<= 1;                    
			ctl_tx_fcs_ins_enable			<= 1;            
			ctl_tx_ipg_value				<= 0;           
			ctl_tx_send_lfi					<= 0;                  
			ctl_tx_send_rfi					<= 0;                  
			ctl_tx_send_idle				<= 0;                 
			ctl_tx_custom_preamble_enable	<= 0;    
			ctl_tx_ignore_fcs				<= 0;  
		end else begin
			if (~ip_init) begin
				ctl_tx_test_pattern				<= 0;
				ctl_tx_test_pattern_enable		<= 0;
				ctl_tx_test_pattern_select		<= 0;
				ctl_tx_data_pattern_select		<= 0;
				ctl_tx_test_pattern_seed_a		<= 0;
				ctl_tx_test_pattern_seed_b		<= 0;
				ctl_tx_enable					<= 1;
				ctl_tx_fcs_ins_enable			<= 1;
				ctl_tx_ipg_value				<= 0;
				ctl_tx_send_lfi					<= 0;
				ctl_tx_send_rfi					<= 0;
				ctl_tx_send_idle				<= 0;
				ctl_tx_custom_preamble_enable	<= 0;
				ctl_tx_ignore_fcs				<= 0;
			end else;
		end
	end
	
	always @(posedge rx_clk_out, posedge i_reset) begin 	// Clock domain - rx_clk_out
		if (i_reset) begin
			ctl_rx_test_pattern				<= 0;          
			ctl_rx_test_pattern_enable		<= 0;   
			ctl_rx_data_pattern_select		<= 0;   
			ctl_rx_enable					<= 1;                
			ctl_rx_delete_fcs				<= 1;            
			ctl_rx_ignore_fcs				<= 0;            
			ctl_rx_max_packet_len			<= 14'b00010111000000; // 1472 - max UDP packe lenght
			ctl_rx_min_packet_len			<= 8'd4; // min packet lenght = arp request length (42 bits)
			ctl_rx_custom_preamble_enable	<= 0;
			ctl_rx_check_sfd				<= 0;             
			ctl_rx_check_preamble			<= 0;        
			ctl_rx_process_lfi				<= 0;           
			ctl_rx_force_resync				<= 0;          
		end else begin
			if (~ip_init) begin
				ctl_rx_test_pattern				<= 0;
				ctl_rx_test_pattern_enable		<= 0;
				ctl_rx_data_pattern_select		<= 0;
				ctl_rx_enable					<= 1;
				ctl_rx_delete_fcs				<= 1;
				ctl_rx_ignore_fcs				<= 0;
				ctl_rx_max_packet_len			<= 14'b00010111000000;
				ctl_rx_min_packet_len			<= 8'd4;
				ctl_rx_custom_preamble_enable	<= 0;
				ctl_rx_check_sfd				<= 0;
				ctl_rx_check_preamble			<= 0;
				ctl_rx_process_lfi				<= 0;
				ctl_rx_force_resync				<= 0;
			end else;
		end
	end
	
	always @(posedge tx_clk_out, posedge i_reset) begin		// Clock domain - Async & ???
		if (i_reset) begin
			rx_reset_r 					<= 0;
			tx_reset_r 					<= 0;
			gt_loopback_in 				<= 0;
			gtwiz_reset_tx_datapath_r 	<= 0;
			gtwiz_reset_rx_datapath_r 	<= 0;
			qpllreset_in_r 				<= 0;
			txoutclksel_in 				<= 3'b101;
			rxoutclksel_in 				<= 3'b101;
			sys_reset_r 				<= 0;
			ip_init 					<= 0;
		end else begin
			ip_init <= (ip_init == 0) ? 1: ip_init;
			
			if (~ip_init) begin
				txoutclksel_in <= 3'b101;
				rxoutclksel_in <= 3'b101;
			end else;
		end
	end
	
    axi4_stream_sfp_ethernet_controller axi4_stream_sfp_ethernet_controller_inst(
             //// GT_0 Signals
        .gt_rxp_in_0(gt_rxp_in),                    							//	GT rx in   							//  input  wire gt_rxp_in_0;  
        .gt_rxn_in_0(gt_rxn_in),                    							//	GT rx in    						//  input  wire gt_rxn_in_0;  
        .gt_txp_out_0(gt_txp_out),                       						//	GT tx out							//  output wire gt_txp_out_0; 
        .gt_txn_out_0(gt_txn_out),                       						//	GT tx out							//  output wire gt_txn_out_0; 
        .tx_clk_out_0(tx_clk_out),                    							//	TX clocking							//  output wire tx_clk_out_0; 
        .rx_core_clk_0(tx_clk_out),                  							//	RX clocking  						//  input  wire rx_core_clk_0;
        .rx_clk_out_0(rx_clk_out),                    							//	RX clocking  						//  output wire rx_clk_out_0; 
        .gt_loopback_in_0(gt_loopback_in),              						//	GT loopback ???						//  input  wire [2:0] gt_loopback_in_0;
             //// RX_0 Signals																
        .rx_reset_0(rx_reset),              	 								//	RX reset 							//  input  wire rx_reset_0;     
        .user_rx_reset_0(user_rx_reset),              							//	RX reset out 						//  output wire user_rx_reset_0;
        .rxrecclkout_0(rxrecclkout),                  							//	Recovered rx clk 					//  output wire rxrecclkout_0;  
             //// RX_0 User Interface  Signals														
        .rx_axis_tvalid_0(rx_axis_tvalid),            							//	RX data valid 						//  output wire rx_axis_tvalid_0;       
        .rx_axis_tdata_0(rx_axis_tdata),              							//	RX data								//  output wire [63:0] rx_axis_tdata_0; 
        .rx_axis_tlast_0(rx_axis_tlast),              							//	RX last data	frame				//  output wire rx_axis_tlast_0;        
        .rx_axis_tkeep_0(rx_axis_tkeep),              							//	RX data byte	valid				//  output wire [7:0] rx_axis_tkeep_0;  
																				//	tdata[7:0] and tdata[15:8] valid -> tkeep == 8'b00000011
        .rx_axis_tuser_0(rx_axis_tuser),              							//	RX data error						//  output wire rx_axis_tuser_0;  
																				//	tlast == tuser == 1 -> data error
        .rx_preambleout_0(rx_preambleout),            							//	RX preambule						//  output wire [55:0] rx_preambleout_0;
																				//	Is separated from tdata !!!	
             //// RX_0 Control Signals			
        .ctl_rx_test_pattern_0(ctl_rx_test_pattern),                			//	RX core test						//  input  wire ctl_rx_test_pattern_0;          
        .ctl_rx_test_pattern_enable_0(ctl_rx_test_pattern_enable),  			//	RX core test enable  				//  input  wire ctl_rx_test_pattern_enable_0;   
        .ctl_rx_data_pattern_select_0(ctl_rx_data_pattern_select),          	//	???  								//  input  wire ctl_rx_data_pattern_select_0;   
        .ctl_rx_enable_0(ctl_rx_enable),              							//	1 - RX enable						//	input  wire ctl_rx_enable_0;                
        .ctl_rx_delete_fcs_0(ctl_rx_delete_fcs),                        		//	RX fcs deletion						//  input  wire ctl_rx_delete_fcs_0;            
																				//	1 - del fcs from received packet
        .ctl_rx_ignore_fcs_0(ctl_rx_ignore_fcs),                        		//	RX fcs error check					//  input  wire ctl_rx_ignore_fcs_0;            
																				//	0 - fcs error triggers tuser = 1
        .ctl_rx_max_packet_len_0(ctl_rx_max_packet_len),            			//	RX max packet len					//  input  wire [14:0] ctl_rx_max_packet_len_0; 
																				//	ctl_rx_max_packet_len[14] is reserved and = 0
        .ctl_rx_min_packet_len_0(ctl_rx_min_packet_len),                 		//	RX min packet len					//  input  wire [7:0] ctl_rx_min_packet_len_0;  
																				//	ctl_rx_min_packet_len >= 64Bytes
        .ctl_rx_custom_preamble_enable_0(ctl_rx_custom_preamble_enable),    	//	???									//  input  wire ctl_rx_custom_preamble_enable_0;
        .ctl_rx_check_sfd_0(ctl_rx_check_sfd),                         			//	??? 								//  input  wire ctl_rx_check_sfd_0;             
																				//	1 - check Start of Frame Delimiter of the received frame
        .ctl_rx_check_preamble_0(ctl_rx_check_preamble),                    	//	??? 								//  input  wire ctl_rx_check_preamble_0;        
																				//	1 - check the preamble of the received frame
        .ctl_rx_process_lfi_0(ctl_rx_process_lfi),                       		//	???									//  input  wire ctl_rx_process_lfi_0;           
																				//	1 - RX core to process LF control codes
        .ctl_rx_force_resync_0(ctl_rx_force_resync),  							//	RX path reset						//	input  wire ctl_rx_force_resync_0;    
																				//	one-cycle impulse
			//// RX_0 Stats Signals								
        .stat_rx_block_lock_0(stat_rx_block_lock),                        		//  output wire stat_rx_block_lock_0;                
        .stat_rx_framing_err_valid_0(stat_rx_framing_err_valid),              	//  output wire stat_rx_framing_err_valid_0;         
        .stat_rx_framing_err_0(stat_rx_framing_err),                       		//  output wire stat_rx_framing_err_0;		             
        .stat_rx_hi_ber_0(stat_rx_hi_ber),                            			//  output wire stat_rx_hi_ber_0;                    
        .stat_rx_valid_ctrl_code_0(stat_rx_valid_ctrl_code),                  	//  output wire stat_rx_valid_ctrl_code_0;
        .stat_rx_bad_code_0(stat_rx_bad_code),                          		//  output wire stat_rx_bad_code_0;                  
        .stat_rx_total_packets_0(stat_rx_total_packets),                     	//  output wire [1:0] stat_rx_total_packets_0;       
        .stat_rx_total_good_packets_0(stat_rx_total_good_packets),            	//  output wire stat_rx_total_good_packets_0;        
        .stat_rx_total_bytes_0(stat_rx_total_bytes),                       		//  output wire [3:0] stat_rx_total_bytes_0;         
        .stat_rx_total_good_bytes_0(stat_rx_total_good_bytes),                	//  output wire [13:0] stat_rx_total_good_bytes_0;   
        .stat_rx_packet_small_0(stat_rx_packet_small),                      	//  output wire stat_rx_packet_small_0;              
        .stat_rx_jabber_0(stat_rx_jabber),                            			//  output wire stat_rx_jabber_0;                    
        .stat_rx_packet_large_0(stat_rx_packet_large),                      	//  output wire stat_rx_packet_large_0;              
        .stat_rx_oversize_0(stat_rx_oversize),                          		//  output wire stat_rx_oversize_0;                  
        .stat_rx_undersize_0(stat_rx_undersize),                         		//  output wire stat_rx_undersize_0;
                                                                                //  Packet shorter than ctl_rx_min_packet_len with good FCS    
        .stat_rx_toolong_0(stat_rx_toolong),                           			//  output wire stat_rx_toolong_0;                   
        .stat_rx_fragment_0(stat_rx_fragment),                          		//  output wire stat_rx_fragment_0;                  
        .stat_rx_packet_64_bytes_0(stat_rx_packet_64_bytes),                  	//  output wire stat_rx_packet_64_bytes_0;           
        .stat_rx_packet_65_127_bytes_0(stat_rx_packet_65_127_bytes),          	//  output wire stat_rx_packet_65_127_bytes_0;       
        .stat_rx_packet_128_255_bytes_0(stat_rx_packet_128_255_bytes),        	//  output wire stat_rx_packet_128_255_bytes_0;      
        .stat_rx_packet_256_511_bytes_0(stat_rx_packet_256_511_bytes),        	//  output wire stat_rx_packet_256_511_bytes_0;      
        .stat_rx_packet_512_1023_bytes_0(stat_rx_packet_512_1023_bytes),      	//  output wire stat_rx_packet_512_1023_bytes_0;     
        .stat_rx_packet_1024_1518_bytes_0(stat_rx_packet_1024_1518_bytes),    	//  output wire stat_rx_packet_1024_1518_bytes_0;    
        .stat_rx_packet_1519_1522_bytes_0(stat_rx_packet_1519_1522_bytes),    	//  output wire stat_rx_packet_1519_1522_bytes_0;    
        .stat_rx_packet_1523_1548_bytes_0(stat_rx_packet_1523_1548_bytes),    	//  output wire stat_rx_packet_1523_1548_bytes_0;    
        .stat_rx_bad_fcs_0(stat_rx_bad_fcs),                           			//  output wire [1:0] stat_rx_bad_fcs_0;             
        .stat_rx_packet_bad_fcs_0(stat_rx_packet_bad_fcs),                    	//  output wire stat_rx_packet_bad_fcs_0;            
        .stat_rx_stomped_fcs_0(stat_rx_stomped_fcs),                       		//  output wire [1:0] stat_rx_stomped_fcs_0;         
        .stat_rx_packet_1549_2047_bytes_0(stat_rx_packet_1549_2047_bytes),    	//  output wire stat_rx_packet_1549_2047_bytes_0;    
        .stat_rx_packet_2048_4095_bytes_0(stat_rx_packet_2048_4095_bytes),    	//  output wire stat_rx_packet_2048_4095_bytes_0;    
        .stat_rx_packet_4096_8191_bytes_0(stat_rx_packet_4096_8191_bytes),    	//  output wire stat_rx_packet_4096_8191_bytes_0;    
        .stat_rx_packet_8192_9215_bytes_0(stat_rx_packet_8192_9215_bytes),    	//  output wire stat_rx_packet_8192_9215_bytes_0;    
        .stat_rx_unicast_0(stat_rx_unicast),                           			//  output wire stat_rx_unicast_0;      
        .stat_rx_multicast_0(stat_rx_multicast),                         		//  output wire stat_rx_multicast_0;    
        .stat_rx_broadcast_0(stat_rx_broadcast),                         		//  output wire stat_rx_broadcast_0;    
        .stat_rx_vlan_0(stat_rx_vlan),                              			//  output wire stat_rx_vlan_0;         
        .stat_rx_inrangeerr_0(stat_rx_inrangeerr),                        		//  output wire stat_rx_inrangeerr_0;   
        .stat_rx_bad_preamble_0(stat_rx_bad_preamble),                      	//  output wire stat_rx_bad_preamble_0; 
        .stat_rx_bad_sfd_0(stat_rx_bad_sfd),                           			//  output wire stat_rx_bad_sfd_0;      
        .stat_rx_got_signal_os_0(stat_rx_got_signal_os),                     	//  output wire stat_rx_got_signal_os_0;
        .stat_rx_test_pattern_mismatch_0(stat_rx_test_pattern_mismatch),      	//  output wire stat_rx_test_pattern_mismatch_0;
        .stat_rx_truncated_0(stat_rx_truncated),                         		//  output wire stat_rx_truncated_0;
        .stat_rx_local_fault_0(stat_rx_local_fault),                       		//  output wire stat_rx_local_fault_0;
        .stat_rx_remote_fault_0(stat_rx_remote_fault),                      	//  output wire stat_rx_remote_fault_0;
        .stat_rx_internal_local_fault_0(stat_rx_internal_local_fault),        	//  output wire stat_rx_internal_local_fault_0;
        .stat_rx_received_local_fault_0(stat_rx_received_local_fault),        	//  output wire stat_rx_received_local_fault_0;
        .stat_rx_status_0(stat_rx_status),                            			//  output wire  stat_rx_status_0;
			 //// TX_0 Signals
        .tx_reset_0(tx_reset),                           						// 	TX reset							//  input  wire tx_reset_0;     
        .user_tx_reset_0(user_tx_reset),              							// 	TX reset out						//  output wire user_tx_reset_0;
             //// TX_0 User Interface  Signals							
        .tx_axis_tready_0(tx_axis_tready),            							// 	TX core ready transmit				//  output wire tx_axis_tready_0; 
																				//	if tx_axis_tready = 0 must hold data until tx_axis_tready = 1
        .tx_axis_tvalid_0(tx_axis_tvalid),            							// 	TX data valid						//  input  wire tx_axis_tvalid_0;       
        .tx_axis_tdata_0(tx_axis_tdata),              							// 	TX data								//  input  wire [63:0] tx_axis_tdata_0; 
        .tx_axis_tlast_0(tx_axis_tlast),              							// 	TX data last frame					//  input  wire tx_axis_tlast_0;        
        .tx_axis_tkeep_0(tx_axis_tkeep),              							// 	TX data valid bytes					//  input  wire [7:0] tx_axis_tkeep_0;  
        .tx_axis_tuser_0(tx_axis_tuser),              							// 	Abort transmittion					//  input  wire tx_axis_tuser_0;        
																				//  tx_axis_tlast == tx_axis_tuser == 1
																				// 	tx_axis_tuser = tx_unfout || (my_logic)
		.tx_unfout_0(tx_unfout),                      							// 	1 - transmitting packet corruption	//  output wire tx_unfout_0;            
        .tx_preamblein_0(tx_preamblein),                            			// 	Custom preamble						//  input  wire [55:0] tx_preamblein_0; 
																				//  should be valid during the start of packet
			 //// TX_0 Control Signals							
        .ctl_tx_test_pattern_0(ctl_tx_test_pattern),                      		// 	Enable TX test mode					//  input  wire ctl_tx_test_pattern_0;              
        .ctl_tx_test_pattern_enable_0(ctl_tx_test_pattern_enable),          	// 	Enable TX test mode					//  input  wire ctl_tx_test_pattern_enable_0;       
        .ctl_tx_test_pattern_select_0(ctl_tx_test_pattern_select),          	// 	???									//  input  wire ctl_tx_test_pattern_select_0;       
        .ctl_tx_data_pattern_select_0(ctl_tx_data_pattern_select),          	// 	???									//  input  wire ctl_tx_data_pattern_select_0;       
        .ctl_tx_test_pattern_seed_a_0(ctl_tx_test_pattern_seed_a),          	// 	???									//  input  wire [57:0] ctl_tx_test_pattern_seed_a_0;
        .ctl_tx_test_pattern_seed_b_0(ctl_tx_test_pattern_seed_b),          	// 	???									//  input  wire [57:0] ctl_tx_test_pattern_seed_b_0;
        .ctl_tx_enable_0(ctl_tx_enable),              							// 	1 - TX enable						//  input  wire ctl_tx_enable_0;                    
        .ctl_tx_fcs_ins_enable_0(ctl_tx_fcs_ins_enable),                    	// 	1 - Calc & insert FCS to the packet	//  input  wire ctl_tx_fcs_ins_enable_0;            
        .ctl_tx_ipg_value_0(ctl_tx_ipg_value),                         			// 	minimum Inter Packet Gap (in bytes)	//  input  wire [3:0] ctl_tx_ipg_value_0;           
																				// 	Typical value is 12. The ctl_tx_ipg_value can 
																				// 	also be programmed to a value in the 0 to 7 range, 
																				// 	but in that case, it is interpreted as meaning "minimal IPG", 
																				// 	so only Terminate code word IPG is inserted
		.ctl_tx_send_lfi_0(ctl_tx_send_lfi),                          			// 	Transmit Local Fault Indication 	//  input  wire ctl_tx_send_lfi_0;                  
        .ctl_tx_send_rfi_0(ctl_tx_send_rfi),                          			// 	Transmit Remote Fault Indication	//  input  wire ctl_tx_send_rfi_0;                  
        .ctl_tx_send_idle_0(ctl_tx_send_idle),                         			// 	1 - TX transmits IDLE code words	//  input  wire ctl_tx_send_idle_0;                 
																				//  This input should be set to 1 when the partner is sending RFI code words
		.ctl_tx_custom_preamble_enable_0(ctl_tx_custom_preamble_enable),    	// 	Enable use of tx_preamblein			//  input  wire ctl_tx_custom_preamble_enable_0;    
        .ctl_tx_ignore_fcs_0(ctl_tx_ignore_fcs),                        		// 	Enable FCS error checking  			//  input  wire ctl_tx_ignore_fcs_0;
																				//  This input only has effect when ctl_tx_fcs_ins_enable is 0.
																				//  If set to 0 and a packet with bad FCS is being transmitted, it is not binned as good.
																				//  error is flagged on the signals stat_tx_bad_fcs 
																				//  and stomped_fcs and the packet is transmitted as it was received.
			//// TX_0 Stats Signals												
        .stat_tx_total_packets_0(stat_tx_total_packets),                     	//  output wire stat_tx_total_packets_0;          
        .stat_tx_total_bytes_0(stat_tx_total_bytes),                       		//  output wire [3:0] stat_tx_total_bytes_0;      
        .stat_tx_total_good_packets_0(stat_tx_total_good_packets),              //  output wire stat_tx_total_good_packets_0;     
        .stat_tx_total_good_bytes_0(stat_tx_total_good_bytes),                  //  output wire [13:0] stat_tx_total_good_bytes_0;
        .stat_tx_packet_64_bytes_0(stat_tx_packet_64_bytes),                   	//  output wire stat_tx_packet_64_bytes_0;        
        .stat_tx_packet_65_127_bytes_0(stat_tx_packet_65_127_bytes),            //  output wire stat_tx_packet_65_127_bytes_0;    
        .stat_tx_packet_128_255_bytes_0(stat_tx_packet_128_255_bytes),          //  output wire stat_tx_packet_128_255_bytes_0;   
        .stat_tx_packet_256_511_bytes_0(stat_tx_packet_256_511_bytes),          //  output wire stat_tx_packet_256_511_bytes_0;   
        .stat_tx_packet_512_1023_bytes_0(stat_tx_packet_512_1023_bytes),        //  output wire stat_tx_packet_512_1023_bytes_0;  
        .stat_tx_packet_1024_1518_bytes_0(stat_tx_packet_1024_1518_bytes),      //  output wire stat_tx_packet_1024_1518_bytes_0; 
        .stat_tx_packet_1519_1522_bytes_0(stat_tx_packet_1519_1522_bytes),      //  output wire stat_tx_packet_1519_1522_bytes_0; 
        .stat_tx_packet_1523_1548_bytes_0(stat_tx_packet_1523_1548_bytes),      //  output wire stat_tx_packet_1523_1548_bytes_0; 
        .stat_tx_packet_small_0(stat_tx_packet_small),                      	//  output wire stat_tx_packet_small_0;           
        .stat_tx_packet_large_0(stat_tx_packet_large),                      	//  output wire stat_tx_packet_large_0;           
        .stat_tx_packet_1549_2047_bytes_0(stat_tx_packet_1549_2047_bytes),      //  output wire stat_tx_packet_1549_2047_bytes_0; 
        .stat_tx_packet_2048_4095_bytes_0(stat_tx_packet_2048_4095_bytes),      //  output wire stat_tx_packet_2048_4095_bytes_0; 
        .stat_tx_packet_4096_8191_bytes_0(stat_tx_packet_4096_8191_bytes),      //  output wire stat_tx_packet_4096_8191_bytes_0; 
        .stat_tx_packet_8192_9215_bytes_0(stat_tx_packet_8192_9215_bytes),      //  output wire stat_tx_packet_8192_9215_bytes_0; 
        .stat_tx_unicast_0(stat_tx_unicast),                           			//  output wire stat_tx_unicast_0;                
        .stat_tx_multicast_0(stat_tx_multicast),                         		//  output wire stat_tx_multicast_0;              
        .stat_tx_broadcast_0(stat_tx_broadcast),                         		//  output wire stat_tx_broadcast_0;              
        .stat_tx_vlan_0(stat_tx_vlan),                              			//  output wire stat_tx_vlan_0;                   
        .stat_tx_bad_fcs_0(stat_tx_bad_fcs),                           			//  output wire stat_tx_bad_fcs_0;                
        .stat_tx_frame_error_0(stat_tx_frame_error),                       		//  output wire stat_tx_frame_error_0;            
        .stat_tx_local_fault_0(stat_tx_local_fault),                       		//  output wire stat_tx_local_fault_0;
            //// Other															
        .gtwiz_reset_tx_datapath_0(gtwiz_reset_tx_datapath),            		// 	TX Reset of transceiver primitives	//  input wire gtwiz_reset_tx_datapath_0;
        .gtwiz_reset_rx_datapath_0(gtwiz_reset_rx_datapath),            		// 	RX Reset of transceiver primitives	//  input wire gtwiz_reset_rx_datapath_0;
        .qpllreset_in_0(qpllreset_in),                       					// 	???	reset with sys_reset ???		//  input wire qpllreset_in_0;           
        .gtpowergood_out_0(gtpowergood_out),          							// 	???									//  output wire gtpowergood_out_0;       
        .txoutclksel_in_0(txoutclksel_in),                      				// 	???	should be 3'b101				//  input wire [2:0] txoutclksel_in_0;   
        .rxoutclksel_in_0(rxoutclksel_in),                      				// 	???	should be 3'b101				//  input wire [2:0] rxoutclksel_in_0;   
        .gt_refclk_p(gt_refclk_p),                   							// 	reference clock for the GT block	//  input  wire [0:0] gt_refclk_p;  
        .gt_refclk_n(gt_refclk_n),                   							// 	reference clock for the GT block	//  input  wire [0:0] gt_refclk_n;  
        .gt_refclk_out(gt_refclk_out),                  						// 	gt_refclk_out						//  output wire [0:0] gt_refclk_out;
        .sys_reset(sys_reset),                            						// 	IP CORE reset						//  input  wire sys_reset;
        .dclk(dclk)                                								// 	reference frequency 				//  input  wire dclk;    
																				// 	for the GT helper blocks which initiate the GT itself
    );
    
endmodule
