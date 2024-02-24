module tb_ethernet_header_receiver(
	input 					i_reset,
	input 					i_clk,
	input		[7:0]		i_msg_word,
	output reg	[42*8-1:0]	o_msg_header,
	output 					o_preambule_valid
);
	
	tb_preambule_validity tb_preambule_validity_inst(
		.i_reset(i_reset),			//	input 				i_reset,
		.i_clk(i_clk),				//	input 				i_clk,
		.i_msg_word(i_msg_word),	//	input		[7:0]	i_msg_word,
		.o_valid(o_preambule_valid) //	output reg			o_valid 		// 1 i_clk impulse
	);
	
	reg 			preambule_valid_r;
	reg [5:0]		msg_header_counter; 	// 42 == 6'b101010
	reg [7:0]		i_msg_word_r;
	
	initial begin 
		preambule_valid_r 	<= 0;
		o_msg_header 		<= 0;
		msg_header_counter 	<= 0;
		i_msg_word_r 		<= 0;
	end
	
	always @(posedge i_clk, posedge i_reset) begin
		if (i_reset) begin
			preambule_valid_r 	<= 0;
			o_msg_header 		<= 0;
			msg_header_counter 	<= 0;
			i_msg_word_r 		<= 0;
		end else begin
			i_msg_word_r 		<= i_msg_word;
			
			if (o_preambule_valid) begin
				preambule_valid_r 	<= 1; 
				o_msg_header 		<= 0;
			end else;
			
			if (preambule_valid_r) begin
				if (msg_header_counter == 6'd42) begin
					msg_header_counter 		<= 0;
					preambule_valid_r 		<= 0;
					o_msg_header			<= 0;
				end else begin
					o_msg_header 		<= o_msg_header << 8;
					o_msg_header[7:0] 	<= i_msg_word_r;
					msg_header_counter 	<= msg_header_counter + 1;
				end
			end else;
		end
	end
	
endmodule