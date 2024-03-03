module ethernet_controller #(parameter FPGA_MAC = 48'h211abcdef112, parameter FPGA_IP  = 32'hC0000186) (
	input 			i_clk,
	input 			i_reset,
	
	input 			rx_axis_tvalid,
	input [63:0]	rx_axis_tdata, 
	input 			rx_axis_tlast, 
	input [7:0]		rx_axis_tkeep,
	
	output 			tx_axis_tvalid,
	output [63:0]	tx_axis_tdata, 
	output 			tx_axis_tlast, 
	output [7:0]	tx_axis_tkeep
);
	wire 				arp_valid; 
	wire 				icmp_valid;
	wire 				udp_valid; 
	
	wire 	[42*8-1:0]	data_head;
	wire 				data_head_valid;
	wire 				data_head_frame_payload_valid;
	wire 	[6*8-1:0]	data_head_frame_payload;	
	wire 	[5:0]		data_head_frame_payload_keep;	
	wire 	[20:0]		icmp_crc_part1;
	wire 				icmp_crc_part1_ready;
	
	ethernet_receiver #(.FPGA_MAC(FPGA_MAC), .FPGA_IP(FPGA_IP)) ethernet_receiver_inst(
		.i_clk(i_clk),														//	input 			i_clk,
		.i_reset(i_reset),													//	input 			i_reset,
																			//	
		.i_rx_axis_tvalid(rx_axis_tvalid),									//	input			i_rx_axis_tvalid,
		.i_rx_axis_tdata(rx_axis_tdata),									//	input	[63:0] 	i_rx_axis_tdata,
		.i_rx_axis_tlast(rx_axis_tlast), 									//	input			i_rx_axis_tlast, 
		.i_rx_axis_tkeep(rx_axis_tkeep), 									//	input	[7:0] 	i_rx_axis_tkeep 
																			//	
		.o_arp_valid(arp_valid), 											//	output 				arp_valid_r, 		
																			//	
		.o_icmp_valid(icmp_valid), 											//	output 				icmp_valid_r,
																			//
		.o_udp_valid(udp_valid), 											//	output 				udp_valid, 	
																			//
		.o_data_head(data_head),											//	output 	[42*8-1:0]		o_data_head,
		.o_data_head_valid(data_head_valid),								//	output 					o_data_head_valid,
		.o_data_head_frame_payload_valid(data_head_frame_payload_valid),	//	output 					o_data_head_frame_payload_valid,
		.o_data_head_frame_payload(data_head_frame_payload),				//	output 	[6*8-1:0]		o_data_head_frame_payload,		
		.o_data_head_frame_payload_keep(data_head_frame_payload_keep),		//	output 	[5:0]			o_data_head_frame_payload_keep
		.o_icmp_crc_part(icmp_crc_part1),									//	output 	reg [20:0]		o_icmp_crc_part
		.o_icmp_crc_part_ready(icmp_crc_part1_ready)						//	output 	reg 			o_icmp_crc_part_ready
	);
	
	wire [42*8-1:0] data_head_reply;
	wire 			data_head_reply_ready;
	
	ethernet_head_reply_builder ethernet_head_reply_builder_inst(
		.i_clk(i_clk),									//	input 					i_clk,
		.i_reset(i_reset),								//	input 					i_reset,
														//	
		.i_arp_valid(arp_valid),						//	input					i_arp_valid,
		.i_icmp_valid(icmp_valid),						//	input					i_icmp_valid,
		.i_udp_valid(udp_valid),						//	input					i_udp_valid,
		.i_data_head_valid(data_head_valid),			//	input					i_data_head_valid,
		.i_data_head(data_head),						//	input		[42*8-1:0]	i_data_head,
														//	
		.o_data_head_reply(data_head_reply),			//	output reg 	[42*8-1:0] 	o_data_head_reply,
		.o_data_head_reply_ready(data_head_reply_ready)	//	output reg				o_data_head_reply_ready
	);
	
	wire [15:0] icmp_crc;
	wire 		icmp_crc_ready;
	
	ethernet_icmp_checksum_counter ethernet_icmp_checksum_counter_inst(
		.i_clk(i_clk),									//	input 				i_clk,
		.i_reset(i_reset),								//	input 				i_reset,
														//	
		.i_rx_axis_tdata(rx_axis_tdata), 				//	input 		[63:0]	i_rx_axis_tdata, 
		.i_rx_axis_tlast(rx_axis_tlast), 				//	input 				i_rx_axis_tlast, 
		.i_rx_axis_tkeep(rx_axis_tkeep),				//	input 		[7:0]	i_rx_axis_tkeep,
														//	
		.i_icmp_valid(icmp_valid),						//	input 				i_icmp_valid,
														//	
		.i_icmp_crc_part1(icmp_crc_part1),				//	input 		[20:0]	i_icmp_crc_part1,
		.i_icmp_crc_part1_ready(icmp_crc_part1_ready),	//	input 				i_icmp_crc_part1_ready,
														//	
		.o_icmp_crc(icmp_crc),							//	output reg 	[20:0]	o_icmp_crc,
		.o_icmp_crc_ready(icmp_crc_ready)					//	output reg 			o_icmp_crc_ready
	);
	
	ethernet_reply_transmitter ethernet_reply_transmitter_inst(
		.i_clk(i_clk),													//	input 				i_clk,
		.i_reset(i_reset),												//	input 				i_reset,
																		//	
		.arp_valid(arp_valid), 											//	input 				arp_valid, 
		.icmp_valid(icmp_valid),										//	input 				icmp_valid,
		.udp_valid(udp_valid),											//	input 				udp_valid,
																		//	
		.data_head_valid(data_head_valid),								//	input				data_head_valid,
																		//	
		.data_head_frame_payload(data_head_frame_payload),				//	input 	[6*8-1:0]	data_head_frame_payload,	
		.data_head_frame_payload_keep(data_head_frame_payload_keep),	//	input 	[5:0]		data_head_frame_payload_keep,	
																		//	
		.data_head_reply(data_head_reply),								//	input 	[42*8-1:0] 	data_head_reply,		
		.data_head_reply_ready(data_head_reply_ready),					//	input 				data_head_reply_ready,	
																		//	
		.icmp_crc(icmp_crc),											//	input 	[15:0] 		icmp_crc,	
		.icmp_crc_ready(icmp_crc_ready),								//	input 				icmp_crc_ready,	
																		//	
		.rx_axis_tvalid(rx_axis_tvalid),								//	input 				rx_axis_tvalid,
		.rx_axis_tdata(rx_axis_tdata), 									//	input 	[63:0]		rx_axis_tdata, 
		.rx_axis_tlast(rx_axis_tlast), 									//	input 				rx_axis_tlast, 
		.rx_axis_tkeep(rx_axis_tkeep),									//	input 	[7:0]		rx_axis_tkeep,
																		//	
		.tx_axis_tvalid(tx_axis_tvalid),								//	output 	reg			tx_axis_tvalid,	
		.tx_axis_tdata(tx_axis_tdata), 									//	output 	reg	[63:0]	tx_axis_tdata, 	
		.tx_axis_tlast(tx_axis_tlast), 									//	output 	reg			tx_axis_tlast, 	
		.tx_axis_tkeep(tx_axis_tkeep)									//	output 	reg	[7:0]	tx_axis_tkeep	
	);
	
endmodule