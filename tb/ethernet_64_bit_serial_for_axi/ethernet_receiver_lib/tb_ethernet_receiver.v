module tb_ethernet_receiver #(parameter FPGA_MAC = 48'h211abcdef112, parameter FPGA_IP  = 32'hC0000186) (
	input 					i_clk,
	input 					i_reset,
			
	input					i_rx_axis_tvalid,
	input	[63:0] 			i_rx_axis_tdata,
	input					i_rx_axis_tlast, 
	input	[7:0] 			i_rx_axis_tkeep,
		
	output 	[6*8-1:0]		o_MAC_DST,			
	output 	[6*8-1:0]		o_MAC_SRC,			
	output 	[2*8-1:0]		o_eth_tp,				
	/* ARP 	*/	
	output 	[15:0] 			o_HTYPE,				
	output 	[15:0] 			o_PTYPE,				
	output 	[7:0] 			o_HLEN,				
	output 	[7:0] 			o_PLEN,				
	output 	[15:0] 			o_OPER,				
	output 	[6*8-1:0] 		o_SHA,				
	output 	[4*8-1:0] 		o_SPA,				
	output 	[6*8-1:0] 		o_THA,				
	output 	[4*8-1:0] 		o_TPA,				
		
	output 					o_arp_valid,
	
	/* ICMP + UDP GENERAL */
	output 	[3:0]			o_version,			
	output 	[3:0]			o_IHL,				
	output 	[5:0]			o_DSCP,				
	output 	[1:0]			o_ECN,				
	output 	[15:0]			o_tot_len,			
	output 	[15:0]			o_identification,		
	output 	[2:0]			o_flags,				
	output 	[12:0]			o_fragment_offset,	
	output 	[7:0] 			o_ttl,				
	output 	[7:0] 			o_protocol,			
	output 	[15:0] 			o_header_checksum,	
	output 	[31:0] 			o_IP_SRC,				
	output 	[31:0] 			o_IP_DST,				
	/* ICMP	*/	
	output  [7:0] 			o_type_of_message,	
	output  [7:0] 			o_code,				
	output  [15:0] 			o_icmp_header_checksum,
	output  [31:0] 			o_header_data,		
	
	output 					o_icmp_valid,
		
	/* UDP 	*/	
	output  [15:0] 			o_SRC_PORT,			
	output  [15:0] 			o_DST_PORT,			
	output  [15:0] 			o_length,				
	output  [15:0] 			o_udp_header_checksum, 
		
	output 					o_udp_valid,
		
	output 					o_data_head_frame_payload_valid,
	output 	[6*8-1:0]		o_data_head_frame_payload,		
	output 	[5:0]			o_data_head_frame_payload_keep		
);
	wire [42*8-1:0]	data_head;
	
	tb_ethernet_header_receiver tb_ethernet_header_receiver_inst(
		.i_clk(i_clk),                                                      //	input 					i_clk,
		.i_reset(i_reset),                                                  //	input 					i_reset,
		                                                                    //	
		.i_rx_axis_tvalid(i_rx_axis_tvalid),                                //	input					i_rx_axis_tvalid,
		.i_rx_axis_tdata(i_rx_axis_tdata),                                  //	input		[63:0] 		i_rx_axis_tdata, 
		.i_rx_axis_tlast(i_rx_axis_tlast),                                  //	input					i_rx_axis_tlast, 
		.i_rx_axis_tkeep(i_rx_axis_tkeep),                                  //	input		[7:0] 		i_rx_axis_tkeep, 
		                                                                    //	
		.o_data_head(data_head),                                            //	output reg 	[42*8-1:0]	o_data_head,
		.o_data_head_frame_payload_valid(o_data_head_frame_payload_valid),	//	output reg 				o_data_head_frame_payload_valid,
		.o_data_head_frame_payload(o_data_head_frame_payload),              //	output reg 	[6*8-1:0]	o_data_head_frame_payload,
		.o_data_head_frame_payload_keep(o_data_head_frame_payload_keep)     //	output reg 	[5:0]		o_data_head_frame_payload_keep
	);
	
	/* GENERAl */
	assign o_MAC_DST				= 	data_head[42*8-1:36*8];
	assign o_MAC_SRC				= 	data_head[36*8-1:30*8];
	assign o_eth_tp					= 	data_head[30*8-1:28*8];
	/* ARP 	*/				
	assign o_HTYPE					= 	data_head[28*8-1:26*8];
	assign o_PTYPE					= 	data_head[26*8-1:24*8];
	assign o_HLEN					= 	data_head[24*8-1:23*8];
	assign o_PLEN					= 	data_head[23*8-1:22*8];
	assign o_OPER					= 	data_head[22*8-1:20*8];
	assign o_SHA					= 	data_head[20*8-1:14*8];
	assign o_SPA					= 	data_head[14*8-1:10*8];
	assign o_THA					= 	data_head[10*8-1:4*8];
	assign o_TPA					= 	data_head[4*8-1:0];
	
	assign o_arp_valid 				= 	(o_MAC_DST 			== FPGA_MAC) &&
										(o_eth_tp			== 16'h0806) &&
										(o_HTYPE			== 16'h0001) &&
										(o_PTYPE			== 16'h0800) &&
										(o_OPER				== 16'h0001) &&
										(o_THA				== FPGA_MAC) &&
										(o_TPA				== FPGA_IP);
								
	/* ICMP + UDP GENERAL */
	assign o_version				= 	data_head[28*8-1:27*8+4];
	assign o_IHL					= 	data_head[28*8-5:27*8];
	assign o_DSCP					= 	data_head[27*8-1:26*8+6];
	assign o_ECN					= 	data_head[27*8-3:26*8];
	assign o_tot_len				= 	data_head[26*8-1:24*8];
	assign o_identification			= 	data_head[24*8-1:22*8];
	assign o_flags					= 	data_head[22*8-1:20*8+13];
	assign o_fragment_offset		= 	data_head[22*8-4:20*8];
	assign o_ttl					= 	data_head[20*8-1:19*8];
	assign o_protocol				= 	data_head[19*8-1:18*8];
	assign o_header_checksum		= 	data_head[18*8-1:16*8];
	assign o_IP_SRC					= 	data_head[16*8-1:12*8];
	assign o_IP_DST					= 	data_head[12*8-1:8*8];
	/* ICMP	*/	
	assign o_type_of_message		= 	data_head[8*8-1:7*8];
	assign o_code					= 	data_head[7*8-1:6*8];
	assign o_icmp_header_checksum	= 	data_head[6*8-1:4*8];
	assign o_header_data			= 	data_head[4*8-1:0];
		
	assign o_icmp_valid 			= 	(o_MAC_DST 			== FPGA_MAC) &&
										(o_eth_tp			== 16'h0800) &&
										(o_version			== 4'h4) 	 &&
										(o_IHL				== 4'h5) 	 &&
										(o_protocol			== 8'h01) 	 &&
										(o_IP_DST			== FPGA_IP)  &&
										(o_type_of_message	== 8'h08) 	 &&
										(o_code				== 8'h00);
								   
	/* UDP 	*/
	assign o_SRC_PORT				= 	data_head[8*8-1:6*8];
	assign o_DST_PORT				= 	data_head[6*8-1:4*8];
	assign o_length					= 	data_head[4*8-1:2*8];
	assign o_udp_header_checksum 	= 	data_head[2*8-1:0];
		
	assign o_udp_valid 				= 	(o_MAC_DST 			== FPGA_MAC) && 
										(o_eth_tp			== 16'h0800) && 
										(o_version			== 4'h4) 	 && 
										(o_IHL				== 4'h5) 	 && 
										(o_protocol			== 8'h11) 	 && 
										(o_IP_DST			== FPGA_IP);
endmodule