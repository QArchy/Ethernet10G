module tb_crc_arp_calc(
	input 				i_clk,
	input 				i_reset,
	input 				i_preambule_valid,	// 1 clk impulse
	input 				i_arp_valid,		// 1 clk impulse
	input 		[7:0] 	i_arp_word,
	output  	[31:0] 	o_crc_out,
	output reg 			o_crc_ready			// 1 clk impulse
);
	reg 			crc_reset;
	reg 			crc_enbl;
	
	reg [5:0] 		head_counter;
	reg [7:0] 		i_arp_word_r;
	
	initial begin
		o_crc_ready 		<= 0;
		crc_reset 			<= 0;
		crc_enbl 			<= 0;
		head_counter 		<= 0;
		i_arp_word_r 		<= 0;
	end
	
	crc_calc crc_calc_inst(
		.clk(i_clk),				//	input clk,
		.rst(i_reset || crc_reset),	//	input rst,
		.enbl(crc_enbl),			//	input enbl,
		.data_in(i_arp_word_r),		//	input [7:0] data_in,
		.crc_out(o_crc_out)			//	output [31:0] crc_out
	);
	
	always @(posedge i_clk, posedge i_reset) begin
		if (i_reset) begin
			o_crc_ready 		<= 0;
			crc_reset 			<= 0;
			crc_enbl 			<= 0;
			head_counter 		<= 0;
			i_arp_word_r 		<= 0;
		end else begin
			i_arp_word_r <= i_arp_word;
			
			if (crc_enbl) begin
				if (head_counter == 6'd42 && i_arp_valid) begin
					crc_enbl 		<= 0;
					head_counter 	<= 0;
					o_crc_ready 	<= 1;
				end else begin
					head_counter 	<= head_counter + 1;
				end
			end else begin 
				o_crc_ready <= 0;
				crc_reset 	<= 1;
			end
			
			if (i_preambule_valid) begin
				crc_reset 	<= 0;
				crc_enbl 	<= 1;
			end else;
		end
	end
	
endmodule