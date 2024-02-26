module tb_preambule_validity(
	input 				i_reset,
	input 				i_clk,
	input		[7:0]	i_msg_word,
	output reg			o_valid 		// 1 clk impulse
);
	initial o_valid <= 0;
	
	reg 	[2:0] 	preambule_counter;
	initial 		preambule_counter <= 0;
	
	always @(posedge i_clk, posedge i_reset) begin
		if (i_reset) begin
			o_valid 			<= 0;
			preambule_counter 	<= 0;
		end else begin
			if (preambule_counter < 3'b111 && i_msg_word == 8'h55) begin
				preambule_counter 	<= preambule_counter + 1;
				o_valid 			<= 0;
			end else if (i_msg_word == 8'hD5) begin
				preambule_counter 	<= preambule_counter + 1;
				o_valid 			<= 1;
			end else begin
				o_valid 		<= 0;
			end
		end
	end
	
endmodule