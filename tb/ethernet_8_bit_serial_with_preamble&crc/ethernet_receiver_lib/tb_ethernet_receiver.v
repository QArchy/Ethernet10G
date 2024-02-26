module tb_ethernet_receiver #(parameter FPGA_MAC = 48'h211abcdef112, parameter FPGA_IP  = 32'hC0000186) (
	input 				i_clk,
	input 				i_reset,
	
	output 	[6*8-1:0]	MAC_DST,					
	output 	[6*8-1:0]	MAC_SRC,					
	output 	[2*8-1:0]	eth_tp,					
	/* ARP 	*/
	output 	[15:0] 		HTYPE,					
	output 	[15:0] 		PTYPE,					
	output 	[7:0] 		HLEN,					
	output 	[7:0] 		PLEN,					
	output 	[15:0] 		OPER,					
	output 	[6*8-1:0] 	SHA,						
	output 	[4*8-1:0] 	SPA,					
	output 	[6*8-1:0] 	THA,						
	output 	[4*8-1:0] 	TPA,						
	
	output 				arp_valid, 			
	output 	[31:0] 		arp_crc_out,
	output 	 			arp_crc_ready,
	
	/* ICMP + UDP GENERAL */
	output 	[3:0]		version,					
	output 	[3:0]		IHL,						
	output 	[5:0]		DSCP,					
	output 	[1:0]		ECN,						
	output 	[15:0]		tot_len,					
	output 	[15:0]		identification,			
	output 	[2:0]		flags,					
	output 	[12:0]		fragment_offset,			
	output 	[7:0] 		ttl,						
	output 	[7:0] 		protocol,				
	output 	[15:0] 		header_checksum,			
	output 	[31:0] 		IP_SRC,					
	output 	[31:0] 		IP_DST,					
	/* ICMP	*/
	output  [7:0] 		type_of_message,			
	output  [7:0] 		code,					
	output  [15:0] 		icmp_header_checksum,	
	output  [31:0] 		header_data,				
	
	output 				icmp_valid, 	
	output 	[15:0] 		icmp_crc_out,
	output 	 			icmp_crc_ready,
	
	/* UDP 	*/
	output  [15:0] 		SRC_PORT,				
	output  [15:0] 		DST_PORT,				
	output  [15:0] 		length,					
	output  [15:0] 		udp_header_checksum, 	
	
	output 				udp_valid, 	
	
	output reg	[7:0]	payload_word
);
	/* FAKE DATA TRANSMITTER BLOCK */
	wire [7:0] 	msg_word;
	wire 		valid;
	
	tb_ethernet_fake_data_transmitter_controller tb_ethernet_fake_data_transmitter_controller_inst(
		.i_clk(i_clk),			//	input 			i_clk,
		.i_reset(i_reset),		//	input 			i_reset,
		.o_msg_word(msg_word),	//	output 	[7:0] 	o_msg_word,
		.o_valid(valid)			//	output  		o_valid
	);
	
	always @(posedge i_clk, posedge i_reset) payload_word <= i_reset ? 0: msg_word;
	/* FAKE DATA TRANSMITTER BLOCK */
	
	/* MSG HEADER RECEIVER BLOCK */
	wire [42*8-1:0] msg_header;
	wire 			preambule_valid;
	
	tb_ethernet_header_receiver tb_ethernet_header_receiver_inst(
		.i_reset(i_reset),					//	input 					i_reset,
		.i_clk(i_clk),						//	input 					i_clk,
		.i_msg_word(msg_word),				//	input		[7:0]		i_msg_word,
		.o_msg_header(msg_header),			//	output reg	[42*8-1:0]	o_msg_header,
		.o_preambule_valid(preambule_valid)	//	output reg	[42*8-1:0]	o_msg_header,
	);
	/* MSG HEADER RECEIVER BLOCK */
	
	/* GENERAl */
	assign MAC_DST	= msg_header[42*8-1:36*8];
    assign MAC_SRC	= msg_header[36*8-1:30*8];
	assign eth_tp	= msg_header[30*8-1:28*8];
    /* ARP 	*/
    assign HTYPE	= msg_header[28*8-1:26*8];
    assign PTYPE	= msg_header[26*8-1:24*8];
    assign HLEN		= msg_header[24*8-1:23*8];
    assign PLEN		= msg_header[23*8-1:22*8];
    assign OPER		= msg_header[22*8-1:20*8];
    assign SHA		= msg_header[20*8-1:14*8];
    assign SPA		= msg_header[14*8-1:10*8];
    assign THA		= msg_header[10*8-1:4*8];
    assign TPA		= msg_header[4*8-1:0];
	
	assign arp_valid 	= (MAC_DST 	== FPGA_MAC) && 
						  (eth_tp	== 16'h0806) && 
						  (HTYPE	== 16'h0001) && 
						  (PTYPE	== 16'h0800) && 
						  (OPER		== 16'h0001) && 
						  (THA		== FPGA_MAC) && 
						  (TPA		== FPGA_IP);
						  
	/* ARP CRC CALC BLOCK */
	tb_crc_arp_calc tb_crc_arp_calc_inst(
		.i_clk(i_clk),							//	input 				i_clk,
		.i_reset(i_reset),						//	input 				i_reset,
		.i_preambule_valid(preambule_valid),	//	input 				i_preambule_valid,	// 1 clk impulse
		.i_arp_valid(arp_valid),				//	input 				i_arp_valid,		// 1 clk impulse
		.i_arp_word(msg_word),					//	input 		[7:0] 	arp_word,
		.o_crc_out(arp_crc_out),				//	output reg 	[31:0] 	o_crc_out_r,
		.o_crc_ready(arp_crc_ready)				//	output reg 			o_crc_ready			// 1 clk impulse
	);
	/* ARP CRC CALC BLOCK */
	
    /* ICMP + UDP GENERAL */
    assign version			= msg_header[28*8-1:27*8+4];
    assign IHL				= msg_header[28*8-5:27*8];
    assign DSCP				= msg_header[27*8-1:26*8+6];
    assign ECN				= msg_header[27*8-3:26*8];
    assign tot_len			= msg_header[26*8-1:24*8];
    assign identification	= msg_header[24*8-1:22*8];
    assign flags			= msg_header[22*8-1:20*8+13];
    assign fragment_offset	= msg_header[22*8-4:20*8];
    assign ttl				= msg_header[20*8-1:19*8];
    assign protocol			= msg_header[19*8-1:18*8];
    assign header_checksum	= msg_header[18*8-1:16*8];
    assign IP_SRC			= msg_header[16*8-1:12*8];
    assign IP_DST			= msg_header[12*8-1:8*8];
    /* ICMP	*/
    assign type_of_message		= msg_header[8*8-1:7*8];
    assign code					= msg_header[7*8-1:6*8];
    assign icmp_header_checksum	= msg_header[6*8-1:4*8];
    assign header_data			= msg_header[4*8-1:0];
	
	assign icmp_valid 			= (MAC_DST 			== FPGA_MAC) && 
								  (eth_tp			== 16'h0800) && 
								  (version			== 4'h4) 	 && 
								  (IHL				== 4'h5) 	 && 
								  (protocol			== 8'h01) 	 && 
								  (IP_DST			== FPGA_IP)  && 
								  (type_of_message	== 8'h08) 	 && 
								  (code				== 8'h00);
								  
	/* ICMP CRC CALC BLOCK */
	tb_crc_icmp_calc tb_crc_icmp_calc_inst(
		.i_clk(i_clk),																			//	input 				i_clk,
		.i_reset(i_reset),																		//	input 				i_reset,
		.i_icmp_valid(icmp_valid),																//	input 				i_icmp_valid,	// 1 clk impulse
		.i_msg_valid(valid),																	//	input 			 	i_msg_valid,
		.i_arp_word(msg_word),																	//	input 		[7:0] 	i_arp_word,
		.i_initial_sum({21{1'b0}} + {8'h00, code} + header_data[31:16] + header_data[15:0]), 	//	input 		[20:0] 	i_initial_sum,
		.o_crc_out(icmp_crc_out),																//	output reg	[20:0] 	o_crc_out,
		.o_crc_ready(icmp_crc_ready)															//	output reg 			o_crc_ready			// 1 clk impulse
	);
	/* ICMP CRC CALC BLOCK */
	
    /* UDP 	*/
    assign SRC_PORT				= msg_header[8*8-1:6*8];
    assign DST_PORT				= msg_header[6*8-1:4*8];
    assign length				= msg_header[4*8-1:2*8];
    assign udp_header_checksum 	= msg_header[2*8-1:0];
	
	assign udp_valid 			= (MAC_DST 			== FPGA_MAC) && 
								  (eth_tp			== 16'h0800) && 
								  (version			== 4'h4) 	 && 
								  (IHL				== 4'h5) 	 && 
								  (protocol			== 8'h11) 	 && 
								  (IP_DST			== FPGA_IP);
endmodule