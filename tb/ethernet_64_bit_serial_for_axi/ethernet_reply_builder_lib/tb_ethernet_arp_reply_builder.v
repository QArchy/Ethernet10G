module tb_ethernet_arp_reply_builder(
	input 					i_clk,
	input 					i_reset,
	input 					i_arp_crc_ready,
	input 		[31:0] 		i_arp_crc,
	input 		[42*8-1:0]	i_arp_reply_head,
	output	reg	[54*8-1:0]	o_arp_reply,
	output	reg				o_arp_reply_ready
); 
	reg [31:0] 		arp_crc_r;
	reg [42*8-1:0] 	arp_reply_head_r;
	
	reg 			form_reply;
	
	initial begin
		o_arp_reply 		<= 0;
		o_arp_reply_ready 	<= 0;
		arp_crc_r			<= 0;
		arp_reply_head_r 	<= 0;
		form_reply 			<= 0;
	end
	
	always @(posedge i_clk, posedge i_reset) begin
		if (i_reset) begin
			o_arp_reply 		<= 0;
			o_arp_reply_ready 	<= 0;
			arp_crc_r			<= 0;
			arp_reply_head_r 	<= 0;
			form_reply 			<= 0;
		end else begin
			if (i_arp_crc_ready) begin
				arp_crc_r 			<= i_arp_crc;
				arp_reply_head_r 	<= i_arp_reply_head;
				form_reply 			<= 1;
			end else;
			
			if (form_reply) begin
				o_arp_reply 		<= {64'h55555555555555D5, arp_reply_head_r, arp_crc_r};
				arp_crc_r 			<= 0;
				arp_reply_head_r 	<= 0;
				o_arp_reply_ready 	<= 1;
				form_reply 			<= 0;
			end else 
				o_arp_reply_ready 	<= 0;
		end
	end
	
endmodule