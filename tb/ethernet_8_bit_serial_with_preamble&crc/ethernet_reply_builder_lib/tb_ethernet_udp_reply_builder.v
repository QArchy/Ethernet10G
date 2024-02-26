module tb_ethernet_udp_reply_builder(
	input 						i_clk,
	input 						i_reset,
	input 						i_udp_valid,
	input 		[7:0]			i_udp_payload_word,
	input 		[15:0]			i_udp_payload_size,
	input 		[42*8-1:0]		i_udp_reply_head,
	output	reg	[50*8-1:0]		o_udp_reply_head,
	output	reg	[63*8-1:0]		o_udp_reply_payload,
	output	reg	[15:0]			o_udp_payload_size,
	output	reg					o_udp_reply_ready
);
	reg	[15:0]	udp_reply_payload_size;
	reg 		get_payload;
	
	initial begin
		o_udp_reply_head		<= 0;
		o_udp_reply_payload		<= 0;
		o_udp_payload_size		<= 0;
		udp_reply_payload_size	<= 0;
		o_udp_reply_ready		<= 0;
		get_payload				<= 0;
	end
	
	always @(posedge i_clk, posedge i_reset) begin
		if (i_reset) begin
			o_udp_reply_head		<= 0;
			o_udp_reply_payload		<= 0;
			o_udp_payload_size		<= 0;
			udp_reply_payload_size	<= 0;
			o_udp_reply_ready		<= 0;
			get_payload				<= 0;
		end else begin
			
			if (i_udp_valid) begin
				o_udp_reply_payload 		<= o_udp_reply_payload << 8;
				o_udp_reply_payload[7:0]	<= i_udp_payload_word;
				udp_reply_payload_size		<= udp_reply_payload_size + 1;
				
				o_udp_reply_head 		<= {64'h55555555555555D5, i_udp_reply_head};
				o_udp_payload_size 		<= i_udp_payload_size;
				
				get_payload 				<= 1;
			end else;
			
			if (get_payload) begin
				if (udp_reply_payload_size == i_udp_payload_size) begin
					o_udp_reply_payload 	<= o_udp_reply_payload << ((16'd63 - udp_reply_payload_size) * 8);
					udp_reply_payload_size 	<= 0;
					get_payload				<= 0;
					o_udp_reply_ready 		<= 1;
				end else begin
					o_udp_reply_payload 		<= o_udp_reply_payload << 8;
					o_udp_reply_payload[7:0]	<= i_udp_payload_word;
					udp_reply_payload_size		<= udp_reply_payload_size + 1;
				end
			end else o_udp_reply_ready 	<= 0;
		end
	end
	
endmodule