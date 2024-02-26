`timescale 1 ps / 1 ps
module tb_ethernet_top #(parameter FPGA_MAC = 48'h211abcdef112, parameter FPGA_IP  = 32'hC0000186) (
	//input 			i_clk,
	//input 			i_reset
	//
	//input 			rx_axis_tvalid;
	//input [63:0]		rx_axis_tdata; 
	//input 			rx_axis_tlast; 
	//input [7:0]		rx_axis_tkeep;  
);
	reg 	i_clk; 		initial i_clk <= 0; 	always 	#10 i_clk <= ~i_clk;
	
	reg 	i_reset; 	initial i_reset <= 0;	always 	#1000000 i_reset <= ~i_reset;
	
	wire 		rx_axis_tvalid;
	wire [63:0]	rx_axis_tdata; 
	wire 		rx_axis_tlast; 
	wire [7:0]	rx_axis_tkeep;  
	
	tb_ethernet_fake_transmitter tb_ethernet_fake_transmitter_inst(
		.i_clk(i_clk),         				//	input 				i_clk,
		.i_reset(i_reset),     				//	input 				i_reset,
											//	
		.o_tx_axis_tvalid(rx_axis_tvalid),	//	output reg			o_tx_axis_tvalid,
		.o_tx_axis_tdata(rx_axis_tdata),    //	output reg	[63:0] 	o_tx_axis_tdata,
		.o_tx_axis_tlast(rx_axis_tlast),    //	output reg			o_tx_axis_tlast, 
		.o_tx_axis_tkeep(rx_axis_tkeep)     //	output reg	[7:0] 	o_tx_axis_tkeep 
	);
	
	/* GENERAL */
	wire 	[6*8-1:0]	MAC_DST;				
	reg 	[6*8-1:0]	MAC_DST_r;				
	wire 	[6*8-1:0]	MAC_SRC;				
	reg 	[6*8-1:0]	MAC_SRC_r;				
	wire 	[2*8-1:0]	eth_tp;					
	reg 	[2*8-1:0]	eth_tp_r;					
	/* ARP 	*/
	wire 	[15:0] 		HTYPE;					
	reg 	[15:0] 		HTYPE_r;					
	wire 	[15:0] 		PTYPE;					
	reg 	[15:0] 		PTYPE_r;					
	wire 	[7:0] 		HLEN;					
	reg 	[7:0] 		HLEN_r;					
	wire 	[7:0] 		PLEN;					
	reg 	[7:0] 		PLEN_r;					
	wire 	[15:0] 		OPER;					
	reg 	[15:0] 		OPER_r;					
	wire 	[6*8-1:0] 	SHA;					
	reg 	[6*8-1:0] 	SHA_r;					
	wire 	[4*8-1:0] 	SPA;					
	reg 	[4*8-1:0] 	SPA_r;					
	wire 	[6*8-1:0] 	THA;					
	reg 	[6*8-1:0] 	THA_r;					
	wire 	[4*8-1:0] 	TPA;					
	reg 	[4*8-1:0] 	TPA_r;					
	
	wire 				arp_valid; 				
	reg 				arp_valid_r;
	
	/* ICMP + UDP GENERAL */
	wire 	[3:0]		version;				
	reg 	[3:0]		version_r;				
	wire 	[3:0]		IHL;					
	reg 	[3:0]		IHL_r;					
	wire 	[5:0]		DSCP;					
	reg 	[5:0]		DSCP_r;					
	wire 	[1:0]		ECN;					
	reg 	[1:0]		ECN_r;					
	wire 	[15:0]		tot_len;				
	reg 	[15:0]		tot_len_r;				
	wire 	[15:0]		identification;		
	reg 	[15:0]		identification_r;		
	wire 	[2:0]		flags;				
	reg 	[2:0]		flags_r;				
	wire 	[12:0]		fragment_offset;		
	reg 	[12:0]		fragment_offset_r;		
	wire 	[7:0] 		ttl;				
	reg 	[7:0] 		ttl_r;				
	wire 	[7:0] 		protocol;				
	reg 	[7:0] 		protocol_r;				
	wire 	[15:0] 		header_checksum;		
	reg 	[15:0] 		header_checksum_r;		
	wire 	[31:0] 		IP_SRC;				
	reg 	[31:0] 		IP_SRC_r;				
	wire 	[31:0] 		IP_DST;					
	reg 	[31:0] 		IP_DST_r;					
	/* ICMP	*/
	wire 	[7:0] 		type_of_message;		
	reg 	[7:0] 		type_of_message_r;		
	wire 	[7:0] 		code;					
	reg 	[7:0] 		code_r;					
	wire 	[15:0] 		icmp_header_checksum;	
	reg 	[15:0] 		icmp_header_checksum_r;	
	wire 	[31:0] 		header_data;			
	reg 	[31:0] 		header_data_r;			
	
	wire 				icmp_valid; 			
	reg 				icmp_valid_r;
	
	/* UDP 	*/
	wire 	[15:0] 		SRC_PORT;				
	reg 	[15:0] 		SRC_PORT_r;				
	wire 	[15:0] 		DST_PORT;				
	reg 	[15:0] 		DST_PORT_r;				
	wire 	[15:0] 		length;					
	reg 	[15:0] 		length_r;				
	wire 	[15:0] 		udp_header_checksum;	
	reg 	[15:0] 		udp_header_checksum_r;	
	
	wire 				udp_valid; 				
	reg 				udp_valid_r;
	
	wire 				data_head_frame_payload_valid;	
	reg 				data_head_frame_payload_valid_r;
	wire 	[6*8-1:0]	data_head_frame_payload;		
	reg 	[6*8-1:0]	data_head_frame_payload_r;		
	wire 	[5:0]		data_head_frame_payload_keep;	
	reg 	[5:0]		data_head_frame_payload_keep_r;	
	
	initial begin
		/* GENERAl */
		MAC_DST_r						<= 0;
		MAC_SRC_r						<= 0;
		eth_tp_r						<= 0;
		/* ARP 	*/				
		HTYPE_r							<= 0;
		PTYPE_r							<= 0;
		HLEN_r							<= 0;
		PLEN_r							<= 0;
		OPER_r							<= 0;
		SHA_r							<= 0;
		SPA_r							<= 0;
		THA_r							<= 0;
		TPA_r							<= 0;
						
		arp_valid_r 					<= 0;
		
		/* ICMP + UDP GENERAL */
		version_r						<= 0;
		IHL_r							<= 0;
		DSCP_r							<= 0;
		ECN_r							<= 0;
		tot_len_r						<= 0;
		identification_r				<= 0;
		flags_r							<= 0;
		fragment_offset_r				<= 0;
		ttl_r							<= 0;
		protocol_r						<= 0;
		header_checksum_r				<= 0;
		IP_SRC_r						<= 0;
		IP_DST_r						<= 0;
		/* ICMP	*/
		type_of_message_r				<= 0;
		code_r							<= 0;
		icmp_header_checksum_r			<= 0;
		header_data_r					<= 0;
				
		icmp_valid_r 					<= 0;
				
		/* UDP 	*/		
		SRC_PORT_r						<= 0;
		DST_PORT_r						<= 0;
		length_r						<= 0;
		udp_header_checksum_r 			<= 0;
				
		udp_valid_r 					<= 0;
		
		data_head_frame_payload_valid_r <= 0;
		data_head_frame_payload_r 		<= 0;
		data_head_frame_payload_keep_r 	<= 0;
	end
	
	tb_ethernet_receiver #(.FPGA_MAC(FPGA_MAC), .FPGA_IP(FPGA_IP)) tb_ethernet_receiver_inst(
		.i_clk(i_clk),														//	input 			i_clk,
		.i_reset(i_reset),													//	input 			i_reset,
																			//	
		.i_rx_axis_tvalid(rx_axis_tvalid),									//	input			i_rx_axis_tvalid,
		.i_rx_axis_tdata(rx_axis_tdata),									//	input	[63:0] 	i_rx_axis_tdata,
		.i_rx_axis_tlast(rx_axis_tlast), 									//	input			i_rx_axis_tlast, 
		.i_rx_axis_tkeep(rx_axis_tkeep), 									//	input	[7:0] 	i_rx_axis_tkeep 
																			//	
		.o_MAC_DST(MAC_DST),												//	output 	[6*8-1:0]	MAC_DST,			
		.o_MAC_SRC(MAC_SRC),												//	output 	[6*8-1:0]	MAC_SRC,			
		.o_eth_tp(eth_tp),													//	output 	[2*8-1:0]	eth_tp,				
																			//	/* ARP 	*/
		.o_HTYPE(HTYPE),													//	output 	[15:0] 		HTYPE,				
		.o_PTYPE(PTYPE),													//	output 	[15:0] 		PTYPE,				
		.o_HLEN(HLEN),														//	output 	[7:0] 		HLEN,					
		.o_PLEN(PLEN),														//	output 	[7:0] 		PLEN,				
		.o_OPER(OPER),														//	output 	[15:0] 		OPER,					
		.o_SHA(SHA),														//	output 	[6*8-1:0] 	SHA,					
		.o_SPA(SPA),														//	output 	[4*8-1:0] 	SPA,				
		.o_THA(THA),														//	output 	[6*8-1:0] 	THA,				
		.o_TPA(TPA),														//	output 	[4*8-1:0] 	TPA,				
																			//	
		.o_arp_valid(arp_valid), 											//	output 				arp_valid_r, 		
																			//	
																			//	/* ICMP + UDP GENERAL */
		.o_version(version),												//	output 	[3:0]		version,			
		.o_IHL(IHL),														//	output 	[3:0]		IHL,				
		.o_DSCP(DSCP),														//	output 	[5:0]		DSCP,				
		.o_ECN(ECN),														//	output 	[1:0]		ECN,				
		.o_tot_len(tot_len),												//	output 	[15:0]		tot_len,			
		.o_identification(identification),									//	output 	[15:0]		identification,		
		.o_flags(flags),													//	output 	[2:0]		flags,				
		.o_fragment_offset(fragment_offset),								//	output 	[12:0]		fragment_offset,		
		.o_ttl(ttl),														//	output 	[7:0] 		ttl,					
		.o_protocol(protocol),												//	output 	[7:0] 		protocol,			
		.o_header_checksum(header_checksum),								//	output 	[15:0] 		header_checksum,	
		.o_IP_SRC(IP_SRC),													//	output 	[31:0] 		IP_SRC,				
		.o_IP_DST(IP_DST),													//	output 	[31:0] 		IP_DST,				
																			//	/* ICMP	*/	
		.o_type_of_message(type_of_message),								//	output 	[7:0] 		type_of_message,		
		.o_code(code),														//	output 	[7:0] 		code,				
		.o_icmp_header_checksum(icmp_header_checksum),						//	output 	[15:0] 		icmp_header_checksum,
		.o_header_data(header_data),										//	output 	[31:0] 		header_data,		
																			//	
		.o_icmp_valid(icmp_valid), 											//	output 				icmp_valid_r,
																			//
																			//	/* UDP 	*/
		.o_SRC_PORT(SRC_PORT),												//	output 	[15:0] 		SRC_PORT,			
		.o_DST_PORT(DST_PORT),												//	output 	[15:0] 		DST_PORT,			
		.o_length(length),													//	output 	[15:0] 		length,				
		.o_udp_header_checksum(udp_header_checksum), 						//	output 	[15:0] 		udp_header_checksum,	
																			//	
		.o_udp_valid(udp_valid), 											//	output 				udp_valid, 	
		
		.o_data_head_frame_payload_valid(data_head_frame_payload_valid),	//	output 					o_data_head_frame_payload_valid,
		.o_data_head_frame_payload(data_head_frame_payload),				//	output 	[6*8-1:0]		o_data_head_frame_payload,		
		.o_data_head_frame_payload_keep(data_head_frame_payload_keep)		//	output 	[5:0]			o_data_head_frame_payload_keep
	);
	
	always @(posedge i_clk, posedge i_reset) begin
		if (i_reset) begin
			/* GENERAl */
			MAC_DST_r						<= 0;
			MAC_SRC_r						<= 0;
			eth_tp_r						<= 0;
			/* ARP 	*/				
			HTYPE_r							<= 0;
			PTYPE_r							<= 0;
			HLEN_r							<= 0;
			PLEN_r							<= 0;
			OPER_r							<= 0;
			SHA_r							<= 0;
			SPA_r							<= 0;
			THA_r							<= 0;
			TPA_r							<= 0;
							
			arp_valid_r 					<= 0;
			
			/* ICMP + UDP GENERAL */
			version_r						<= 0;
			IHL_r							<= 0;
			DSCP_r							<= 0;
			ECN_r							<= 0;
			tot_len_r						<= 0;
			identification_r				<= 0;
			flags_r							<= 0;
			fragment_offset_r				<= 0;
			ttl_r							<= 0;
			protocol_r						<= 0;
			header_checksum_r				<= 0;
			IP_SRC_r						<= 0;
			IP_DST_r						<= 0;
			/* ICMP	*/
			type_of_message_r				<= 0;
			code_r							<= 0;
			icmp_header_checksum_r			<= 0;
			header_data_r					<= 0;
					
			icmp_valid_r 					<= 0;
					
			/* UDP 	*/		
			SRC_PORT_r						<= 0;
			DST_PORT_r						<= 0;
            length_r						<= 0;
            udp_header_checksum_r 			<= 0;
					
            udp_valid_r 					<= 0;
			
			data_head_frame_payload_valid_r <= 0;
			data_head_frame_payload_r 		<= 0;
			data_head_frame_payload_keep_r 	<= 0;
		end else begin
			arp_valid_r 	<= arp_valid;
			
			icmp_valid_r 	<= icmp_valid;
			
			udp_valid_r		<= udp_valid;
			
			if (arp_valid || icmp_valid || udp_valid) begin
				/* GENERAl */
				MAC_DST_r				<= MAC_DST;
				MAC_SRC_r				<= MAC_SRC;
				eth_tp_r				<= eth_tp;
				/* ARP 	*/			
				HTYPE_r					<= HTYPE;
				PTYPE_r					<= PTYPE;
				HLEN_r					<= HLEN;
				PLEN_r					<= PLEN;
				OPER_r					<= OPER;
				SHA_r					<= SHA;
				SPA_r					<= SPA;	
				THA_r					<= THA;	
				TPA_r					<= TPA;	
				
				/* ICMP + UDP GENERAL */
				version_r				<= version;			
				IHL_r					<= IHL;				
				DSCP_r					<= DSCP;			
				ECN_r					<= ECN;				
				tot_len_r				<= tot_len;			
				identification_r		<= identification;	
				flags_r					<= flags;			
				fragment_offset_r		<= fragment_offset;	
				ttl_r					<= ttl;				
				protocol_r				<= protocol;		
				header_checksum_r		<= header_checksum;	
				IP_SRC_r				<= IP_SRC;			
				IP_DST_r				<= IP_DST;			
				/* ICMP	*/
				type_of_message_r		<= type_of_message;		
				code_r					<= code;				
				icmp_header_checksum_r	<= icmp_header_checksum;
				header_data_r			<= header_data;			
				
				/* UDP 	*/
				SRC_PORT_r				<= SRC_PORT;			
				DST_PORT_r				<= DST_PORT;			
				length_r				<= length;				
				udp_header_checksum_r 	<= udp_header_checksum;
			end else;
			
			if (data_head_frame_payload_valid) begin
				data_head_frame_payload_valid_r <= data_head_frame_payload_valid;
				data_head_frame_payload_r 		<= data_head_frame_payload;
				data_head_frame_payload_keep_r 	<= data_head_frame_payload_keep;
			end else;
		end
	end
	
	/* !!! must remember new payload data on validity (o_udp_valid, data_head_frame_payload_valid, ...) !!! */
	
endmodule