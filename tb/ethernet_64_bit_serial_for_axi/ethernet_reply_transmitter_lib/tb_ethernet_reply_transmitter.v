module tb_ethernet_reply_transmitter(
	input 				i_clk,
	input 				i_reset,
	
	input [54*8-1:0] 	i_arp_reply,
	input				i_arp_reply_ready,
	
	input [50*8-1:0] 	i_icmp_reply_head,
	input [63*8-1:0] 	i_icmp_reply_payload,
	input [5:0] 		i_icmp_reply_payload_size,
	input				i_icmp_reply_ready,
	
	input [50*8-1:0] 	i_udp_reply_head,
	input [63*8-1:0] 	i_udp_reply_payload,
	input [15:0] 		i_udp_reply_payload_size,
	input				i_udp_reply_ready,
	
	output [7:0]		o_word,
	output 				o_valid
);
	/* ARP */
	wire [7:0] 	arp_word;
	wire 		arp_valid;
	
	tb_ethernet_arp_reply_transmitter tb_ethernet_arp_reply_transmitter_inst(
		.i_clk(i_clk),							//	input 				i_clk,
		.i_reset(i_reset),						//	input 				i_reset,
												//	
		.i_arp_reply(i_arp_reply),				//	input [54*8-1:0] 	i_arp_reply,
		.i_arp_reply_ready(i_arp_reply_ready),	//	input				i_arp_reply_ready,
												//	
		.o_word(arp_word),						//	output reg [7:0]	o_word,
		.o_valid(arp_valid)						//	output reg			o_valid
	);
	/* ARP */
	
	/* ICMP */
	wire [7:0] 	icmp_word;
	wire 		icmp_valid;
	
	tb_ethernet_icmp_reply_transmitter tb_ethernet_icmp_reply_transmitter_inst(
		.i_clk(i_clk),											//	input 				i_clk,
		.i_reset(i_reset),										//	input 				i_reset,
																//	
		.i_icmp_reply_head(i_icmp_reply_head),					//	input [50*8-1:0] 	i_icmp_reply_head,
		.i_icmp_reply_payload(i_icmp_reply_payload),			//	input [63*8-1:0] 	i_icmp_reply_payload,
		.i_icmp_reply_payload_size(i_icmp_reply_payload_size),	//	input [5:0] 		i_icmp_reply_payload_size,
		.i_icmp_reply_ready(i_icmp_reply_ready),				//	input				i_icmp_reply_ready,
																//	
		.o_word(icmp_word),									//	output reg [7:0]	o_word,
		.o_valid(icmp_valid)									//	output reg			o_valid
	); 
	/* ICMP */
	
	/* UDP */
	wire [7:0] 	udp_word;
	wire 		udp_valid;
	
	tb_ethernet_udp_reply_transmitter tb_ethernet_udp_reply_transmitter_inst(
		.i_clk(i_clk),											//	input 				i_clk,
		.i_reset(i_reset),										//	input 				i_reset,
																//	
		.i_udp_reply_head(i_udp_reply_head),					//	input [50*8-1:0] 	i_udp_reply_head,
		.i_udp_reply_payload(i_udp_reply_payload),				//	input [1472*8-1:0] 	i_udp_reply_payload,
		.i_udp_reply_payload_size(i_udp_reply_payload_size),	//	input [15:0] 		i_udp_reply_payload_size,
		.i_udp_reply_ready(i_udp_reply_ready),					//	input				i_udp_reply_ready,
																//	
		.o_word(udp_word),									//	output reg [7:0]	o_word,
		.o_valid(udp_valid)									//	output reg			o_valid
	); 	
	/* UDP */
	
	assign o_valid = i_reset ? 0:
					(arp_valid || icmp_valid || udp_valid) ? 1: 0;
	assign o_word = i_reset? 0:
					arp_valid  ? arp_word:
					icmp_valid ? icmp_word:
					udp_valid  ? udp_word: 0;
	
endmodule