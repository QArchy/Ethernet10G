module tb_ethernet_icmp_reply_builder(
	input 					i_clk,
	input 					i_reset,
	input 					i_icmp_crc_ready,
	input 					i_icmp_valid,
	input 		[7:0]		i_icmp_payload_word,
	input 		[5:0]		i_icmp_payload_size,
	input 		[42*8-1:0]	i_icmp_reply_head,
	output	reg	[50*8-1:0]	o_icmp_reply_head,
	output	reg	[63*8-1:0]	o_icmp_reply_payload,
	output	reg	[5:0]		o_icmp_payload_size,
	output	reg				o_icmp_reply_ready
);
	reg	[5:0]	icmp_reply_payload_size;
	reg 		get_payload;
	
	initial begin
		o_icmp_reply_head			<= 0;
		o_icmp_reply_payload		<= 0;
		o_icmp_payload_size			<= 0;
		icmp_reply_payload_size		<= 0;
		o_icmp_reply_ready			<= 0;
		get_payload					<= 0;
	end
	
	always @(posedge i_clk, posedge i_reset) begin
		if (i_reset) begin
			o_icmp_reply_head			<= 0;
			o_icmp_reply_payload		<= 0;
			o_icmp_payload_size			<= 0;
			icmp_reply_payload_size		<= 0;
			o_icmp_reply_ready			<= 0;
			get_payload					<= 0;
		end else begin
			
			if (i_icmp_valid) begin
				o_icmp_reply_payload 		<= o_icmp_reply_payload << 8;
				o_icmp_reply_payload[7:0]	<= i_icmp_payload_word;
				icmp_reply_payload_size		<= icmp_reply_payload_size + 1;
				
				o_icmp_payload_size 		<= i_icmp_payload_size;
				
				get_payload 				<= 1;
			end else;
			
			if (i_icmp_crc_ready) begin
				o_icmp_reply_head 		<= {64'h55555555555555D5, i_icmp_reply_head};
				o_icmp_reply_ready 		<= 1;
			end else o_icmp_reply_ready <= 0;
			
			if (get_payload) begin
				if (icmp_reply_payload_size == i_icmp_payload_size) begin
					o_icmp_reply_payload 		<= o_icmp_reply_payload << ((6'd63 - icmp_reply_payload_size) * 8);
					icmp_reply_payload_size 	<= 0;
					get_payload				 	<= 0;
				end else begin
					o_icmp_reply_payload 		<= o_icmp_reply_payload << 8;
					o_icmp_reply_payload[7:0]	<= i_icmp_payload_word;
					icmp_reply_payload_size		<= icmp_reply_payload_size + 1;
				end
			end else;
		end
	end
	
endmodule