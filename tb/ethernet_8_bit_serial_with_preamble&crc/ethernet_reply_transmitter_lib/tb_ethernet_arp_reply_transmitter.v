module tb_ethernet_arp_reply_transmitter(
	input 				i_clk,
	input 				i_reset,
	
	input [54*8-1:0] 	i_arp_reply,
	input				i_arp_reply_ready,
	
	output reg [7:0]	o_word,
	output reg			o_valid
); 
	reg [54*8-1:0] 		i_arp_reply_r;
	reg					i_arp_reply_ready_r;
	
	initial begin
		o_word						<= 0;
		o_valid						<= 0;
		
		i_arp_reply_r				<= 0;
		i_arp_reply_ready_r			<= 0;
	end
	
	reg [5:0] arp_reply_size;
	initial arp_reply_size <= 0;
	
	always @(posedge i_clk, posedge i_reset) begin
		if (i_reset) begin
			o_word					<= 0;
			o_valid					<= 0;
			i_arp_reply_r			<= 0;
			i_arp_reply_ready_r		<= 0;
			arp_reply_size			<= 0;
		end else begin
			if (i_arp_reply_ready) begin	/* initial */
				i_arp_reply_ready_r <= 1;
				i_arp_reply_r 		<= i_arp_reply << 8;
				
				o_word 				<= i_arp_reply[54*8-1:53*8];
				o_valid 			<= 1;
				arp_reply_size		<= arp_reply_size + 1;
			end else;
				
			if (i_arp_reply_ready_r) begin	/* continuous */
				if (arp_reply_size == 6'd54) begin
					o_word 				<= 0;
					o_valid 			<= 0;
					i_arp_reply_r		<= 0;
					i_arp_reply_ready_r <= 0;
					arp_reply_size 		<= 0;
				end else begin
					i_arp_reply_r 		<= i_arp_reply_r << 8;
					o_word 				<= i_arp_reply_r[54*8-1:53*8];
					arp_reply_size		<= arp_reply_size + 1;
				end
			end else;
		end
	end
endmodule