`timescale 1 ps / 1 ps
module tb_ethernet_top  #(parameter FPGA_MAC = 48'h211abcdef112, parameter FPGA_IP  = 32'hC0000186) (
	// input 
);
	reg 	clk;
	initial clk <= 0;
	always 	#10 clk <= ~clk;
	
	reg 	reset;
	initial reset <= 0;
	always 	#1000000 reset <= ~reset;
	
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
	wire 	[31:0]		arp_crc_out;
	reg 	[31:0]		arp_crc_out_r;
	wire				arp_crc_ready;
	reg 				arp_crc_ready_r;
	
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
	wire 	[15:0]		icmp_crc_out;
	reg 	[15:0]		icmp_crc_out_r;
	wire 				icmp_crc_ready;
	reg 				icmp_crc_ready_r;
	
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
	
	wire 	[7:0]		payload_word;			
	reg 	[7:0]		payload_word_r;			
	
	initial begin
		/* GENERAl */
		MAC_DST_r		<= 0;
		MAC_SRC_r		<= 0;
		eth_tp_r		<= 0;
		/* ARP 	*/
		HTYPE_r			<= 0;
		PTYPE_r			<= 0;
		HLEN_r			<= 0;
		PLEN_r			<= 0;
		OPER_r			<= 0;
		SHA_r			<= 0;
		SPA_r			<= 0;
		THA_r			<= 0;
		TPA_r			<= 0;
		
		arp_valid_r 	<= 0;
		arp_crc_out_r 	<= 0;
		arp_crc_ready_r	<= 0;
		
		/* ICMP + UDP GENERAL */
		version_r			<= 0;
		IHL_r				<= 0;
		DSCP_r				<= 0;
		ECN_r				<= 0;
		tot_len_r			<= 0;
		identification_r	<= 0;
		flags_r				<= 0;
		fragment_offset_r	<= 0;
		ttl_r				<= 0;
		protocol_r			<= 0;
		header_checksum_r	<= 0;
		IP_SRC_r			<= 0;
		IP_DST_r			<= 0;
		/* ICMP	*/
		type_of_message_r		<= 0;
		code_r					<= 0;
		icmp_header_checksum_r	<= 0;
		header_data_r			<= 0;
		
		icmp_valid_r 			<= 0;
		icmp_crc_out_r			<= 0;
		icmp_crc_ready_r		<= 0;
		
		/* UDP 	*/
		SRC_PORT_r				<= 0;
		DST_PORT_r				<= 0;
		length_r				<= 0;
		udp_header_checksum_r 	<= 0;
		
		udp_valid_r 			<= 0;
		
		payload_word_r 			<= 0;
	end
	
	tb_ethernet_receiver #(.FPGA_MAC(FPGA_MAC), .FPGA_IP(FPGA_IP)) tb_ethernet_receiver_inst (
		.i_reset(reset),								//	input 				i_reset,
		.i_clk(clk),									//	input 				i_clk,
														//	
		.MAC_DST(MAC_DST),								//	output 	[6*8-1:0]	MAC_DST,				
		.MAC_SRC(MAC_SRC),								//	output 	[6*8-1:0]	MAC_SRC,				
		.eth_tp(eth_tp),								//	output 	[2*8-1:0]	eth_tp,					
														//	/* ARP 	*/
		.HTYPE(HTYPE),									//	output 	[15:0] 		HTYPE,					
		.PTYPE(PTYPE),									//	output 	[15:0] 		PTYPE,					
		.HLEN(HLEN),									//	output 	[7:0] 		HLEN,					
		.PLEN(PLEN),									//	output 	[7:0] 		PLEN,					
		.OPER(OPER),									//	output 	[15:0] 		OPER,					
		.SHA(SHA),										//	output 	[6*8-1:0] 	SHA,					
		.SPA(SPA),										//	output 	[4*8-1:0] 	SPA,					
		.THA(THA),										//	output 	[6*8-1:0] 	THA,					
		.TPA(TPA),										//	output 	[4*8-1:0] 	TPA,					
														//	
		.arp_valid(arp_valid), 							//	output 				arp_valid_r, 	
		.arp_crc_out(arp_crc_out),						//	output 	[31:0] 		arp_crc_out,
		.arp_crc_ready(arp_crc_ready),					//	output 	 			arp_crc_ready,		
														//	
														//	/* ICMP + UDP GENERAL */
		.version(version),								//	output 	[3:0]		version,				
		.IHL(IHL),										//	output 	[3:0]		IHL,					
		.DSCP(DSCP),									//	output 	[5:0]		DSCP,					
		.ECN(ECN),										//	output 	[1:0]		ECN,					
		.tot_len(tot_len),								//	output 	[15:0]		tot_len,				
		.identification(identification),				//	output 	[15:0]		identification,			
		.flags(flags),									//	output 	[2:0]		flags,					
		.fragment_offset(fragment_offset),				//	output 	[12:0]		fragment_offset,		
		.ttl(ttl),										//	output 	[7:0] 		ttl,					
		.protocol(protocol),							//	output 	[7:0] 		protocol,				
		.header_checksum(header_checksum),				//	output 	[15:0] 		header_checksum,		
		.IP_SRC(IP_SRC),								//	output 	[31:0] 		IP_SRC,					
		.IP_DST(IP_DST),								//	output 	[31:0] 		IP_DST,					
														//	/* ICMP	*/
		.type_of_message(type_of_message),				//	output 	[7:0] 		type_of_message,		
		.code(code),									//	output 	[7:0] 		code,					
		.icmp_header_checksum(icmp_header_checksum),	//	output 	[15:0] 		icmp_header_checksum,
		.header_data(header_data),						//	output 	[31:0] 		header_data,			
														//	
		.icmp_valid(icmp_valid), 						//	output 				icmp_valid_r, 		
		.icmp_crc_out(icmp_crc_out),					//	output 	[15:0] 		icmp_crc_out,
		.icmp_crc_ready(icmp_crc_ready),				//	output 	 			icmp_crc_ready,		
														//	/* UDP 	*/
		.SRC_PORT(SRC_PORT),							//	output 	[15:0] 		SRC_PORT,				
		.DST_PORT(DST_PORT),							//	output 	[15:0] 		DST_PORT,				
		.length(length),								//	output 	[15:0] 		length,					
		.udp_header_checksum(udp_header_checksum), 		//	output 	[15:0] 		udp_header_checksum, 
														//	
		.udp_valid(udp_valid), 							//	output 				udp_valid, 	
														//	
		.payload_word(payload_word)						//	output reg	[7:0]	payload_word
	);
	
	always @(posedge clk, posedge reset) begin
		if (reset) begin
			/* GENERAl */
			MAC_DST_r		<= 0;
			MAC_SRC_r		<= 0;
			eth_tp_r		<= 0;
			/* ARP 	*/
			HTYPE_r			<= 0;
			PTYPE_r			<= 0;
			HLEN_r			<= 0;
			PLEN_r			<= 0;
			OPER_r			<= 0;
			SHA_r			<= 0;
			SPA_r			<= 0;
			THA_r			<= 0;
			TPA_r			<= 0;
			
			arp_valid_r 	<= 0;
			arp_crc_out_r 	<= 0;
			arp_crc_ready_r	<= 0;
			
			/* ICMP + UDP GENERAL */
			version_r			<= 0;
			IHL_r				<= 0;
			DSCP_r				<= 0;
			ECN_r				<= 0;
			tot_len_r			<= 0;
			identification_r	<= 0;
			flags_r				<= 0;
			fragment_offset_r	<= 0;
			ttl_r				<= 0;
			protocol_r			<= 0;
			header_checksum_r	<= 0;
			IP_SRC_r			<= 0;
			IP_DST_r			<= 0;
			/* ICMP	*/
			type_of_message_r		<= 0;
			code_r					<= 0;
			icmp_header_checksum_r	<= 0;
			header_data_r			<= 0;
			
			icmp_valid_r 			<= 0;
			icmp_crc_out_r			<= 0;
			icmp_crc_ready_r		<= 0;
			
			/* UDP 	*/
			SRC_PORT_r				<= 0;
			DST_PORT_r				<= 0;
            length_r				<= 0;
            udp_header_checksum_r 	<= 0;
            
            udp_valid_r 			<= 0;
            
            payload_word_r 			<= 0;
		end else begin
			if (arp_crc_ready) begin
				arp_crc_out_r 			<= arp_crc_out;
				arp_crc_ready_r			<= arp_crc_ready;
			end else arp_crc_ready_r	<= 0;
			
			if (icmp_crc_ready) begin
				icmp_crc_out_r			<= icmp_crc_out;
				icmp_crc_ready_r		<= icmp_crc_ready;
			end else icmp_crc_ready_r	<= 0;
			
			arp_valid_r 	<= arp_valid;
			
			icmp_valid_r 	<= icmp_valid;
			
			udp_valid_r		<= udp_valid;
			
			if (arp_valid || icmp_valid || udp_valid) begin
				/* GENERAl */
				MAC_DST_r	<= MAC_DST;
				MAC_SRC_r	<= MAC_SRC;
				eth_tp_r	<= eth_tp;
				/* ARP 	*/
				HTYPE_r		<= HTYPE;
				PTYPE_r		<= PTYPE;
				HLEN_r		<= HLEN;
				PLEN_r		<= PLEN;
				OPER_r		<= OPER;
				SHA_r		<= SHA;
				SPA_r		<= SPA;	
				THA_r		<= THA;	
				TPA_r		<= TPA;	
				
				/* ICMP + UDP GENERAL */
				version_r			<= version;			
				IHL_r				<= IHL;				
				DSCP_r				<= DSCP;			
				ECN_r				<= ECN;				
				tot_len_r			<= tot_len;			
				identification_r	<= identification;	
				flags_r				<= flags;			
				fragment_offset_r	<= fragment_offset;	
				ttl_r				<= ttl;				
				protocol_r			<= protocol;		
				header_checksum_r	<= header_checksum;	
				IP_SRC_r			<= IP_SRC;			
				IP_DST_r			<= IP_DST;			
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
			end
			
			payload_word_r 			<= payload_word;
		end
	end
	
	wire [54*8-1:0] 	arp_reply;
	wire				arp_reply_ready;
	
	wire [50*8-1:0] 	icmp_reply_head;
	wire [63*8-1:0] 	icmp_reply_payload;
	wire [5:0] 			icmp_reply_payload_size;
	wire 				icmp_reply_ready;
	
	wire [50*8-1:0] 	udp_reply_head;
	wire [63*8-1:0] 	udp_reply_payload;
	wire [15:0] 		udp_reply_payload_size;
	wire 				udp_reply_ready;
	
	tb_ethernet_reply_builder #(.FPGA_MAC(FPGA_MAC), .FPGA_IP(FPGA_IP)) tb_ethernet_reply_builder_inst (
		.i_clk(clk),										//	input 				i_clk,	
		.i_reset(reset),									//	input 				i_reset,
															//	
															//	/* GENERAL */
		.MAC_DST(MAC_DST_r),								//	input 	[6*8-1:0]	MAC_DST,				
		.MAC_SRC(MAC_SRC_r),								//	input 	[6*8-1:0]	MAC_SRC,				
		.eth_tp(eth_tp_r),									//	input 	[2*8-1:0]	eth_tp,					
															//	/* ARP 	*/
		.HTYPE(HTYPE_r),									//	input 	[15:0] 		HTYPE,					
		.PTYPE(PTYPE_r),									//	input 	[15:0] 		PTYPE,					
		.HLEN(HLEN_r),										//	input 	[7:0] 		HLEN,					
		.PLEN(PLEN_r),										//	input 	[7:0] 		PLEN,
															//	
		.SHA(SHA_r),										//	input 	[6*8-1:0] 	SHA,					
		.SPA(SPA_r),										//	input 	[4*8-1:0] 	SPA,					
		.THA(THA_r),										//	input 	[6*8-1:0] 	THA,					
		.TPA(TPA_r),										//	input 	[4*8-1:0] 	TPA,					
															//		
		.arp_crc_out(arp_crc_out_r),						//	input 	[31:0] 		arp_crc_out,
		.arp_crc_ready(arp_crc_ready_r),					//	input 	 			arp_crc_ready,		
															//	
															//	/* ICMP + UDP GENERAL */
		.version(version_r),								//	input 	[3:0]		version,				
		.IHL(IHL_r),										//	input 	[3:0]		IHL,					
		.DSCP(DSCP_r),										//	input 	[5:0]		DSCP,					
		.ECN(ECN_r),										//	input 	[1:0]		ECN,					
		.tot_len(tot_len_r),								//	input 	[15:0]		tot_len,				
		.identification(identification_r),					//	input 	[15:0]		identification,			
		.flags(flags_r),									//	input 	[2:0]		flags,					
		.fragment_offset(fragment_offset_r),				//	input 	[12:0]		fragment_offset,		
		.ttl(ttl_r),										//	input 	[7:0] 		ttl,					
		.protocol(protocol_r),								//	input 	[7:0] 		protocol,				
		.header_checksum(header_checksum_r),				//	input 	[15:0] 		header_checksum,		
		.IP_SRC(IP_SRC_r),									//	input 	[31:0] 		IP_SRC,					
		.IP_DST(IP_DST_r),									//	input 	[31:0] 		IP_DST,					
															//	/* ICMP	*/
															//	
		.code(code_r),										//	input 	[7:0] 		code,					
		.icmp_header_checksum(icmp_header_checksum_r),		//	input 	[15:0] 		icmp_header_checksum,
		.header_data(header_data_r),						//	input 	[31:0] 		header_data,			
															//	
		.icmp_valid(icmp_valid_r), 							//	input 				icmp_valid, 		
		.icmp_crc_out(icmp_crc_out_r),						//	input 	[15:0] 		icmp_crc_out,
		.icmp_crc_ready(icmp_crc_ready_r),					//	input 	 			icmp_crc_ready,		
															//	/* UDP 	*/
		.SRC_PORT(SRC_PORT_r),								//	input 	[15:0] 		SRC_PORT,				
		.DST_PORT(DST_PORT_r),								//	input 	[15:0] 		DST_PORT,				
		.length(length_r),									//	input 	[15:0] 		length,					
															//	
															//	
		.udp_valid(udp_valid_r), 							//	input 				udp_valid, 	
															//	
		.payload_word(payload_word_r),						//	input 	[7:0]		payload_word
															//	
															//	
		.arp_reply(arp_reply),								//	output [54*8-1:0] 	arp_reply,
		.arp_reply_ready(arp_reply_ready),					//	output				arp_reply_ready,
															//	
		.icmp_reply_head(icmp_reply_head),					//	output [50*8-1:0] 	icmp_reply_head,
		.icmp_reply_payload(icmp_reply_payload),			//	output [63*8-1:0] 	icmp_reply_payload,
		.icmp_reply_payload_size(icmp_reply_payload_size),	//	output [5:0] 		icmp_reply_payload_size,
		.icmp_reply_ready(icmp_reply_ready),				//	output 				icmp_reply_ready,
															//	
		.udp_reply_head(udp_reply_head),					//	output [50*8-1:0] 	udp_reply_head,
		.udp_reply_payload(udp_reply_payload),				//	output [1472*8-1:0] udp_reply_payload,
		.udp_reply_payload_size(udp_reply_payload_size),	//	output [15:0] 		udp_reply_payload_size,
		.udp_reply_ready(udp_reply_ready)					//	output 				udp_reply_ready
	);
	
	wire [7:0] 	word;
	wire	 	valid;
	
	tb_ethernet_reply_transmitter tb_ethernet_reply_transmitter_inst(
		.i_clk(clk),											//	input 				i_clk,
		.i_reset(reset),										//	input 				i_reset,
																//	
		.i_arp_reply(arp_reply),								//	input [54*8-1:0] 	i_arp_reply,
		.i_arp_reply_ready(arp_reply_ready),					//	input				i_arp_reply_ready,
																//	
		.i_icmp_reply_head(icmp_reply_head),					//	input [50*8-1:0] 	i_icmp_reply_head,
		.i_icmp_reply_payload(icmp_reply_payload),				//	input [63*8-1:0] 	i_icmp_reply_payload,
		.i_icmp_reply_payload_size(icmp_reply_payload_size),	//	input [5:0] 		i_icmp_reply_payload_size,
		.i_icmp_reply_ready(icmp_reply_ready),					//	input				i_icmp_reply_ready,
																//	
		.i_udp_reply_head(udp_reply_head),						//	input [50*8-1:0] 	i_udp_reply_head,
		.i_udp_reply_payload(udp_reply_payload),				//	input [1472*8-1:0] 	i_udp_reply_payload,
		.i_udp_reply_payload_size(udp_reply_payload_size),		//	input [15:0] 		i_udp_reply_payload_size,
		.i_udp_reply_ready(udp_reply_ready),					//	input				i_udp_reply_ready,
																//	
		.o_word(word),											//	output [7:0]		o_word,
		.o_valid(valid)											//	output 				o_valid
	);
	
	/////////////////////////////////////////////////////////////////		TEST OUTPUT		/////////////////////////////////////////////////////////////////
	
	reg [1:0] 	msg_type;
	reg 		valid_prev;
	reg [1:0] 	valid_negedge_counter;
	
	initial begin
		msg_type 				<= 0;
		valid_prev				<= 0;
		valid_negedge_counter	<= 0;
	end
	
	/* TEST */
	always @(posedge clk, posedge reset) begin
		if (reset) begin
			msg_type 				<= 0;
			valid_prev				<= 0;
			valid_negedge_counter	<= 0;
		end else begin
			valid_prev 				<= valid;
			valid_negedge_counter 	<= (valid_prev && ~valid) ? valid_negedge_counter + 1: valid_negedge_counter;
			
			
			
			/* ARP */
			if (tb_ethernet_receiver_inst.tb_ethernet_fake_data_transmitter_controller_inst.tb_ethernet_fake_data_transmitter_inst.msg_type_prev == 2'b00 &&
				tb_ethernet_receiver_inst.tb_ethernet_fake_data_transmitter_controller_inst.tb_ethernet_fake_data_transmitter_inst.msg_type == 2'b01) begin
				$display("[$time=%0d] -- STATUS: TEST START -- ", $time);
				$display("[$time=%0d] -- STATUS: ARP RECEIVE STARTED --", $time);
				msg_type <= msg_type + 1;
			end
			if (tb_ethernet_receiver_inst.tb_ethernet_header_receiver_inst.msg_header_counter == 6'd42 && msg_type == 2'b01) begin
				if (tb_ethernet_receiver_inst.arp_valid)
					$display("[$time=%0d] -- STATUS: ARP RECEIVED AND VALID --", $time);
				else 
					$display("[$time=%0d] -- STATUS: ARP RECEIVED AND NOT VALID --", $time);
			end
			if (arp_reply_ready)
				$display("[$time=%0d] -- STATUS: ARP REPLY FORMED --", $time);
			if (valid_negedge_counter == 2'b00 && valid_prev && ~valid)
				$display("[$time=%0d] -- STATUS: ARP REPLY SENT --", $time);
			/* ARP */
			
			/* ICMP */
			if (tb_ethernet_receiver_inst.tb_ethernet_fake_data_transmitter_controller_inst.tb_ethernet_fake_data_transmitter_inst.msg_type_prev == 2'b00 &&
				tb_ethernet_receiver_inst.tb_ethernet_fake_data_transmitter_controller_inst.tb_ethernet_fake_data_transmitter_inst.msg_type == 2'b10) begin
				$display("[$time=%0d] -- STATUS: ICMP RECEIVE STARTED --", $time);
				msg_type <= msg_type + 1;
			end
			if (tb_ethernet_receiver_inst.tb_ethernet_header_receiver_inst.msg_header_counter == 6'd42 && msg_type == 2'b10) begin
				if (tb_ethernet_receiver_inst.icmp_valid)
					$display("[$time=%0d] -- STATUS: ICMP RECEIVED AND VALID --", $time);
				else 
					$display("[$time=%0d] -- STATUS: ICMP RECEIVED AND NOT VALID --", $time);
			end
			if (icmp_reply_ready)
				$display("[$time=%0d] -- STATUS: ICMP REPLY FORMED --", $time);
			if (valid_negedge_counter == 2'b01 && valid_prev && ~valid)
				$display("[$time=%0d] -- STATUS: ICMP REPLY SENT --", $time);
			/* ICMP */
			
			/* UDP */
			if (tb_ethernet_receiver_inst.tb_ethernet_fake_data_transmitter_controller_inst.tb_ethernet_fake_data_transmitter_inst.msg_type_prev == 2'b00 &&
				tb_ethernet_receiver_inst.tb_ethernet_fake_data_transmitter_controller_inst.tb_ethernet_fake_data_transmitter_inst.msg_type == 2'b11) begin
				$display("[$time=%0d] -- STATUS: UDP RECEIVE STARTED --", $time);
				msg_type <= msg_type + 1;
			end
			if (tb_ethernet_receiver_inst.tb_ethernet_header_receiver_inst.msg_header_counter == 6'd42 && msg_type == 2'b11) begin
				if (tb_ethernet_receiver_inst.udp_valid)
					$display("[$time=%0d] -- STATUS: UDP RECEIVED AND VALID --", $time);
				else 
					$display("[$time=%0d] -- STATUS: UDP RECEIVED AND NOT VALID --", $time);
			end
			if (udp_reply_ready)
				$display("[$time=%0d] -- STATUS: UDP REPLY FORMED --", $time);
			if (valid_negedge_counter == 2'b10 && valid_prev && ~valid)
				$display("[$time=%0d] -- STATUS: UDP REPLY SENT --", $time);
			/* UDP */
			
			/* TEST END */
			if (valid_negedge_counter == 2'b11) begin
				$display("[$time=%0d] -- STATUS: TEST END --", $time);
				$stop;
			end
		end
	end
	/* TEST */
endmodule