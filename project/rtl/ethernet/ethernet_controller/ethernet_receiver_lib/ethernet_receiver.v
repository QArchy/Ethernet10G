module ethernet_receiver #(parameter FPGA_MAC = 48'h211abcdef112, parameter FPGA_IP  = 32'hC0000186) (
	input 					i_clk,
	input 					i_reset,
			
	input					i_rx_axis_tvalid,
	input	[63:0] 			i_rx_axis_tdata,
	input					i_rx_axis_tlast, 
	input	[7:0] 			i_rx_axis_tkeep,
	
	output 					o_arp_valid,
	output 					o_icmp_valid,
	output 					o_udp_valid,
	
	output 	[42*8-1:0]		o_data_head,
	output 					o_data_head_valid,
	output 					o_data_head_frame_payload_valid,
	output 	[6*8-1:0]		o_data_head_frame_payload,		
	output 	[5:0]			o_data_head_frame_payload_keep,
	
	output 	reg [20:0]		o_icmp_crc_part,
	output 	reg 			o_icmp_crc_part_ready
);
	initial begin 
		o_icmp_crc_part 		<= 0;
		o_icmp_crc_part_ready 	<= 0;
	end
	
	ethernet_header_receiver ethernet_header_receiver_inst(
		.i_clk(i_clk),                                                      //	input 					i_clk,
		.i_reset(i_reset),                                                  //	input 					i_reset,
		                                                                    //	
		.i_rx_axis_tvalid(i_rx_axis_tvalid),                                //	input					i_rx_axis_tvalid,
		.i_rx_axis_tdata(i_rx_axis_tdata),                                  //	input		[63:0] 		i_rx_axis_tdata, 
		.i_rx_axis_tlast(i_rx_axis_tlast),                                  //	input					i_rx_axis_tlast, 
		.i_rx_axis_tkeep(i_rx_axis_tkeep),                                  //	input		[7:0] 		i_rx_axis_tkeep, 
		                                                                    //	
		.o_data_head(o_data_head),                                          //	output reg 	[42*8-1:0]	o_data_head,
		.o_data_head_valid(o_data_head_valid),                              //	output reg 				o_data_head_valid,
		.o_data_head_frame_payload_valid(o_data_head_frame_payload_valid),	//	output reg 				o_data_head_frame_payload_valid,
		.o_data_head_frame_payload(o_data_head_frame_payload),              //	output reg 	[6*8-1:0]	o_data_head_frame_payload,
		.o_data_head_frame_payload_keep(o_data_head_frame_payload_keep)     //	output reg 	[5:0]		o_data_head_frame_payload_keep
	);
	
	//	/* GENERAl */
	//	assign o_MAC_DST				= 	o_data_head[42*8-1:36*8];
	//	assign o_MAC_SRC				= 	o_data_head[36*8-1:30*8];
	//	assign o_eth_tp					= 	o_data_head[30*8-1:28*8];
	//	/* ARP 	*/				
	//	assign o_HTYPE					= 	o_data_head[28*8-1:26*8];
	//	assign o_PTYPE					= 	o_data_head[26*8-1:24*8];
	//	assign o_HLEN					= 	o_data_head[24*8-1:23*8];
	//	assign o_PLEN					= 	o_data_head[23*8-1:22*8];
	//	assign o_OPER					= 	o_data_head[22*8-1:20*8];
	//	assign o_SHA					= 	o_data_head[20*8-1:14*8];
	//	assign o_SPA					= 	o_data_head[14*8-1:10*8];
	//	assign o_THA					= 	o_data_head[10*8-1:4*8];
	//	assign o_TPA					= 	o_data_head[4*8-1:0];
	//	
	//	
	assign o_arp_valid 					= 	((o_data_head[42*8-1:36*8] 	== FPGA_MAC) || (o_data_head[42*8-1:36*8] == 48'hFFFFFFFFFFFF)) &&
											(o_data_head[30*8-1:28*8]	== 16'h0806) &&
											(o_data_head[28*8-1:26*8]	== 16'h0001) &&
											(o_data_head[26*8-1:24*8]	== 16'h0800) &&
											(o_data_head[22*8-1:20*8]	== 16'h0001) &&
											((o_data_head[10*8-1:4*8]	== FPGA_MAC) || (o_data_head[10*8-1:4*8]  == 48'h000000000000)) &&
											(o_data_head[4*8-1:0]		== FPGA_IP);
	//									
	//	/* ICMP + UDP GENERAL */
	//	assign o_version				= 	o_data_head[28*8-1:27*8+4];
	//	assign o_IHL					= 	o_data_head[28*8-5:27*8];
	//	assign o_DSCP					= 	o_data_head[27*8-1:26*8+6];
	//	assign o_ECN					= 	o_data_head[27*8-3:26*8];
	//	assign o_tot_len				= 	o_data_head[26*8-1:24*8];
	//	assign o_identification			= 	o_data_head[24*8-1:22*8];
	//	assign o_flags					= 	o_data_head[22*8-1:20*8+13];
	//	assign o_fragment_offset		= 	o_data_head[22*8-4:20*8];
	//	assign o_ttl					= 	o_data_head[20*8-1:19*8];
	//	assign o_protocol				= 	o_data_head[19*8-1:18*8];
	//	assign o_header_checksum		= 	o_data_head[18*8-1:16*8];
	//	assign o_IP_SRC					= 	o_data_head[16*8-1:12*8];
	//	assign o_IP_DST					= 	o_data_head[12*8-1:8*8];
	//	/* ICMP	*/	
	//	assign o_type_of_message		= 	o_data_head[8*8-1:7*8];
	//	assign o_code					= 	o_data_head[7*8-1:6*8];
	//	assign o_icmp_header_checksum	= 	o_data_head[6*8-1:4*8];
	//	assign o_header_data			= 	o_data_head[4*8-1:0];
	//		
	assign o_icmp_valid 				= 	(o_data_head[42*8-1:36*8] 	== FPGA_MAC) &&
											(o_data_head[30*8-1:28*8]	== 16'h0800) &&
											(o_data_head[28*8-1:27*8+4]	== 4'h4) 	 &&
											(o_data_head[28*8-5:27*8]	== 4'h5) 	 &&
											(o_data_head[19*8-1:18*8]	== 8'h01) 	 &&
											(o_data_head[12*8-1:8*8]	== FPGA_IP)  &&
											(o_data_head[8*8-1:7*8]		== 8'h08) 	 &&
											(o_data_head[7*8-1:6*8]		== 8'h00);
	//								   
	//	/* UDP 	*/
	//	assign o_SRC_PORT				= 	o_data_head[8*8-1:6*8];
	//	assign o_DST_PORT				= 	o_data_head[6*8-1:4*8];
	//	assign o_length					= 	o_data_head[4*8-1:2*8];
	//	assign o_udp_header_checksum 	= 	o_data_head[2*8-1:0];
	//		
	assign o_udp_valid 					= 	(o_data_head[42*8-1:36*8] 	== FPGA_MAC) && 
											(o_data_head[30*8-1:28*8]	== 16'h0800) && 
											(o_data_head[28*8-1:27*8+4]	== 4'h4) 	 && 
											(o_data_head[28*8-5:27*8]	== 4'h5) 	 && 
											(o_data_head[19*8-1:18*8]	== 8'h11) 	 && 
											(o_data_head[12*8-1:8*8]	== FPGA_IP);
											
	always @(posedge i_clk, posedge i_reset) begin
		if (i_reset) begin
			o_icmp_crc_part <= 0;
		end else begin
			o_icmp_crc_part <= (o_data_head_valid && o_icmp_valid) ? 
							   ({21{1'b0}} + {8'h00, o_data_head[7*8-1:6*8]} + o_data_head[4*8-1:2*8] + o_data_head[2*8-1:0] +
								{o_data_head_frame_payload[5*8-1:4*8], o_data_head_frame_payload[6*8-1:5*8]} + 
								{o_data_head_frame_payload[3*8-1:2*8], o_data_head_frame_payload[4*8-1:3*8]} + 
								{o_data_head_frame_payload[1*8-1:0], o_data_head_frame_payload[2*8-1:1*8]} + 
								{i_rx_axis_tdata[7*8-1:6*8], i_rx_axis_tdata[8*8-1:7*8]} + {i_rx_axis_tdata[5*8-1:4*8], i_rx_axis_tdata[6*8-1:5*8]} + 
								{i_rx_axis_tdata[3*8-1:2*8], i_rx_axis_tdata[4*8-1:3*8]} + {i_rx_axis_tdata[1*8-1:0], i_rx_axis_tdata[2*8-1:1*8]}) : 0;
			o_icmp_crc_part_ready <= (o_data_head_valid && o_icmp_valid) ? 1 : 0;
		end
	end
	
endmodule