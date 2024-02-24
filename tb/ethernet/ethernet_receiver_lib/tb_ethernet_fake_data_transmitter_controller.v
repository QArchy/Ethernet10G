module tb_ethernet_fake_data_transmitter_controller(
	input 			i_clk,
	input 			i_reset,
	output 	[7:0] 	o_msg_word,
	output  		o_valid
); 
	reg 		start_send;
	reg  [1:0] 	msg_type;
	reg 		valid_prev;
	reg 		tb_start_send;
	
	initial begin
		start_send 				<= 0;
		msg_type				<= 0;
		valid_prev				<= 0;
		tb_start_send			<= 0;
	end
	
	tb_ethernet_fake_data_transmitter tb_ethernet_fake_data_transmitter_inst(
		.i_reset(i_reset),			//	input 				i_reset,
		.i_clk(i_clk),				//	input 				i_clk,
		.i_start_send(start_send),	//	input				i_start_send,	// 1 i_clk signal
		.i_msg_type(msg_type),		//	input 		[1:0]	i_msg_type,
		.o_msg_word(o_msg_word),	//	output reg	[7:0]	o_msg_word,
		.o_valid(o_valid)			//	output reg			o_valid
	);
	
	always @(posedge i_clk, posedge i_reset) begin
		if (i_reset) begin
			start_send 	<= 0;
			msg_type	<= 0;
		end else begin
			
			if (tb_start_send) begin
				start_send 		<= 0;
				valid_prev 		<= o_valid;
				tb_start_send 	<= (valid_prev && ~o_valid) ? 0: 1;
				//if (msg_type == 0)
				//	$stop;
			end else begin
				tb_start_send 	<= 1;
				start_send 		<= 1;
				msg_type 		<= msg_type + 1;
			end
		end
	end
endmodule