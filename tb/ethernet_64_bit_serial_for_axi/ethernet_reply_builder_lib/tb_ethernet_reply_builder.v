module tb_ethernet_reply_builder  #(parameter FPGA_MAC = 48'h211abcdef112, parameter FPGA_IP  = 32'hC0000186) (
	input 				i_clk,	
	input 				i_reset,
	
	/* GENERAL */
	input 	[6*8-1:0]	MAC_DST,				
	input 	[6*8-1:0]	MAC_SRC,				
	input 	[2*8-1:0]	eth_tp,					
	/* ARP 	*/
	input 	[15:0] 		HTYPE,					
	input 	[15:0] 		PTYPE,					
	input 	[7:0] 		HLEN,					
	input 	[7:0] 		PLEN,
	
	input 	[6*8-1:0] 	SHA,					
	input 	[4*8-1:0] 	SPA,					
	input 	[6*8-1:0] 	THA,					
	input 	[4*8-1:0] 	TPA,					
		
	input 	[31:0] 		arp_crc_out,
	input 	 			arp_crc_ready,		
	
	/* ICMP + UDP GENERAL */
	input 	[3:0]		version,				
	input 	[3:0]		IHL,					
	input 	[5:0]		DSCP,					
	input 	[1:0]		ECN,					
	input 	[15:0]		tot_len,				
	input 	[15:0]		identification,			
	input 	[2:0]		flags,					
	input 	[12:0]		fragment_offset,		
	input 	[7:0] 		ttl,					
	input 	[7:0] 		protocol,				
	input 	[15:0] 		header_checksum,		
	input 	[31:0] 		IP_SRC,					
	input 	[31:0] 		IP_DST,					
	/* ICMP	*/
	
	input 	[7:0] 		code,					
	input 	[15:0] 		icmp_header_checksum,
	input 	[31:0] 		header_data,			
	
	input 				icmp_valid, 		
	input 	[15:0] 		icmp_crc_out,
	input 	 			icmp_crc_ready,		
	/* UDP 	*/
	input 	[15:0] 		SRC_PORT,				
	input 	[15:0] 		DST_PORT,				
	input 	[15:0] 		length,					
	
	
	input 				udp_valid, 	
	
	input 	[7:0]		payload_word,
	
	
	output [54*8-1:0] 	arp_reply,
	output				arp_reply_ready,
	
	output [50*8-1:0] 	icmp_reply_head,
	output [63*8-1:0] 	icmp_reply_payload,
	output [5:0] 		icmp_reply_payload_size,
	output 				icmp_reply_ready,
	
	output [50*8-1:0] 	udp_reply_head,
	output [63*8-1:0] udp_reply_payload,
	output [15:0] 		udp_reply_payload_size,
	output 				udp_reply_ready
);
	/* ARP TRANSMITTER BLOCK */
	tb_ethernet_arp_reply_builder tb_ethernet_arp_reply_builder_inst(
		.i_clk(i_clk),						//	input 					i_clk,
		.i_reset(i_reset),					//	input 					i_reset,
		.i_arp_crc_ready(arp_crc_ready),	//	input 					i_arp_crc_ready,
		.i_arp_crc(arp_crc_out),			//	input 		[31:0] 		arp_crc,
		
		.i_arp_reply_head({MAC_SRC /*MAC_DST*/, FPGA_MAC /*MAC_SRC*/, eth_tp, HTYPE, PTYPE, HLEN, PLEN, 16'h0002 /*OPER*/, 
						   FPGA_MAC /*SHA*/, FPGA_IP /*SPA*/, SHA /*THA*/, SPA /*TPA*/}),
											
											//	input 		[42*8-1:0]	arp_reply_head,
		.o_arp_reply(arp_reply),			//	output	reg	[54*8-1:0]	arp_reply,
		.o_arp_reply_ready(arp_reply_ready)	//	output	reg				arp_reply_ready
	);
	/* ARP TRANSMITTER BLOCK */
	
	/* ICMP TRANSMITTER BLOCK */
	tb_ethernet_icmp_reply_builder tb_ethernet_icmp_reply_builder_inst(
		.i_clk(i_clk),										//	input 					i_clk,
		.i_reset(i_reset),									//	input 					i_reset,
		.i_icmp_crc_ready(icmp_crc_ready),					//	input 					i_icmp_crc_ready,
		.i_icmp_valid(icmp_valid),							//	input 					i_icmp_valid,
		.i_icmp_payload_word(payload_word),					//	input 					i_icmp_payload_word,
		.i_icmp_payload_size(tot_len[5:0] - 6'd28),			//	input		[5:0]		i_icmp_payload_size,
		
		.i_icmp_reply_head({MAC_SRC /*MAC_DST*/, MAC_DST /*MAC_SRC*/, eth_tp, version, IHL, DSCP, ECN, tot_len, identification, flags, fragment_offset, 
							ttl, protocol, header_checksum, IP_DST /*IP_SRC*/, IP_SRC /*IP_DST*/, 8'h00, code, icmp_crc_out /*icmp_header_checksum*/, header_data}),
											
															//	input 		[42*8-1:0]	i_icmp_reply_head,
		.o_icmp_reply_head(icmp_reply_head),				//	output	reg	[50*8-1:0]	o_icmp_reply_head,
		.o_icmp_reply_payload(icmp_reply_payload),			//	output	reg	[63*8-1:0]	o_icmp_reply_payload,
		.o_icmp_payload_size(icmp_reply_payload_size),		//	output	reg	[5:0]		o_icmp_payload_size,
		.o_icmp_reply_ready(icmp_reply_ready)				//	output	reg				o_icmp_reply_ready
	);
	/* ICMP TRANSMITTER BLOCK */
	
	/* UDP TRANSMITTER BLOCK */
	tb_ethernet_udp_reply_builder tb_ethernet_udp_reply_builder_inst(
		.i_clk(i_clk),									//	input 						i_clk,
		.i_reset(i_reset),								//	input 						i_reset,
		.i_udp_valid(udp_valid),						//	input 						i_udp_valid,
		.i_udp_payload_word(payload_word),				//	input 						i_udp_payload_word,
		.i_udp_payload_size(tot_len - 6'd28),			//	input		[15:0]			i_udp_payload_size,
														
		.i_udp_reply_head({MAC_SRC /*MAC_DST*/, MAC_DST /*MAC_SRC*/, eth_tp, version, IHL, DSCP, ECN, tot_len, identification, flags, fragment_offset, 
						   ttl, protocol, header_checksum, IP_DST /*IP_SRC*/, IP_SRC /*IP_DST*/, DST_PORT /*SRC_PORT*/, SRC_PORT /*DST_PORT*/, length, 16'hFFFF /*udp_header_checksum*/}),
														
														//	input 		[42*8-1:0]		i_udp_reply_head,
		.o_udp_reply_head(udp_reply_head),				//	output	reg	[50*8-1:0]		o_udp_reply_head,
		.o_udp_reply_payload(udp_reply_payload),		//	output	reg	[1472*8-1:0]	o_udp_reply_payload,
		.o_udp_payload_size(udp_reply_payload_size),	//	output	reg	[15:0]			o_udp_payload_size,
		.o_udp_reply_ready(udp_reply_ready)				//	output	reg					o_udp_reply_ready
	);
	/* UDP TRANSMITTER BLOCK */
endmodule