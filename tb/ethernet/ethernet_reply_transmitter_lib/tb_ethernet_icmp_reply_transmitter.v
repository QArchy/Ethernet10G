module tb_ethernet_icmp_reply_transmitter(
	input 				i_clk,
	input 				i_reset,
	
	input [50*8-1:0] 	i_icmp_reply_head,
	input [63*8-1:0] 	i_icmp_reply_payload,
	input [5:0] 		i_icmp_reply_payload_size,
	input				i_icmp_reply_ready,
	
	output reg [7:0]	o_word,
	output reg			o_valid
); 
	reg	[50*8-1:0] 		i_icmp_reply_head_r;
	reg	[63*8-1:0] 		i_icmp_reply_payload_r;
	reg	[5:0] 			i_icmp_reply_payload_size_r;
	reg					i_icmp_reply_ready_r;
	
	initial begin
		o_word						<= 0; 	//	reset
		o_valid						<= 0;	//	reset
		
		i_icmp_reply_head_r			<= 0;
		i_icmp_reply_payload_r		<= 0;
		i_icmp_reply_payload_size_r	<= 0;
		i_icmp_reply_ready_r		<= 0;
	end
	
	reg [5:0] icmp_reply_head_size;
	initial icmp_reply_head_size <= 0;
	
	always @(posedge i_clk, posedge i_reset) begin
		if (i_reset) begin
			o_word						<= 0;
			o_valid						<= 0;
			i_icmp_reply_head_r			<= 0;
			i_icmp_reply_payload_r		<= 0;
			i_icmp_reply_payload_size_r	<= 0;
			i_icmp_reply_ready_r		<= 0;
			icmp_reply_head_size		<= 0;
		end else begin
			if (i_icmp_reply_ready) begin	/* initial */
				i_icmp_reply_head_r			<= i_icmp_reply_head << 8;
				i_icmp_reply_payload_r		<= i_icmp_reply_payload;
				i_icmp_reply_payload_size_r	<= i_icmp_reply_payload_size;
				i_icmp_reply_ready_r		<= i_icmp_reply_ready;
				
				o_word 						<= i_icmp_reply_head[50*8-1:49*8];
				o_valid 					<= 1;
				icmp_reply_head_size		<= icmp_reply_head_size + 1;
			end else;
				
			if (i_icmp_reply_ready_r) begin	/* continuous */
				
				if (icmp_reply_head_size ==  6'd42) begin	/* payload transmit */
					
					if (i_icmp_reply_payload_size_r == 0) begin /* transmission end */
						o_word						<= 0;
						o_valid						<= 0;
						i_icmp_reply_head_r			<= 0;
						i_icmp_reply_payload_r		<= 0;
						i_icmp_reply_payload_size_r	<= 0;
						i_icmp_reply_ready_r		<= 0;
						icmp_reply_head_size		<= 0;
					end else begin								/* payload transmission */
						i_icmp_reply_payload_r 		<= i_icmp_reply_payload_r << 8;
						o_word 						<= i_icmp_reply_payload_r[63*8-1:62*8];
						i_icmp_reply_payload_size_r	<= i_icmp_reply_payload_size_r - 1;
					end
					
				end else begin	/* head transmit */
					i_icmp_reply_head_r 	<= i_icmp_reply_head_r << 8;
					o_word 					<= i_icmp_reply_head_r[50*8-1:49*8];
					icmp_reply_head_size	<= icmp_reply_head_size + 1;
				end
				
			end else;
		end
	end
endmodule