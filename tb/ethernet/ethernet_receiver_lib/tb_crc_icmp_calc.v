module tb_crc_icmp_calc(
	input 				i_clk,
	input 				i_reset,
	input 				i_icmp_valid,	// 1 clk impulse
	input 			 	i_msg_valid,
	input 		[7:0] 	i_arp_word,
	input 		[20:0] 	i_initial_sum,
	output reg	[20:0] 	o_crc_out,
	output reg 			o_crc_ready			// 1 clk impulse
);
	reg [15:0] 	i_arp_word_r;
	reg 		_switch;
	reg 		_start;
	reg 		_end;
	
	initial begin
		o_crc_out 		<= 0;
		o_crc_ready 	<= 0;
		i_arp_word_r 	<= 0;
		_switch 		<= 0;
		_start 			<= 0;
		_end 			<= 0;
	end
	
	always @(posedge i_clk, posedge i_reset) begin
		if (i_reset) begin
			o_crc_out 		<= 0;
			o_crc_ready 	<= 0;
			i_arp_word_r 	<= 0;
			_switch 		<= 0;
			_start 			<= 0;
			_end 			<= 0;
		end else begin 
			if (_switch)
				i_arp_word_r[15:0] 	<= {{8{1'b0}}, i_arp_word};
			else begin
				i_arp_word_r 		<= i_arp_word_r << 8;
				i_arp_word_r[7:0]	<= i_arp_word;
			end
			
			if (i_msg_valid) begin
				if (i_icmp_valid) begin
					o_crc_out 	<= o_crc_out + i_initial_sum;
					_start 		<= 1;
					_switch 	<= 1;
				end else begin
					_switch 		<= _start ? ~_switch : _switch;
					if (_switch) begin
						o_crc_out	<= _start ? (o_crc_out + i_arp_word_r): o_crc_out;
					end
				end
			end else if (_start) begin
				o_crc_out		<= _switch ? (o_crc_out + i_arp_word_r): o_crc_out;
				_start 			<= 0;
				_end 			<= 1;
			end
			
			if (_end) begin
				o_crc_out 	<= ~(o_crc_out[15:0] + {{11{1'b0}} + o_crc_out[20:16]});
				o_crc_ready <= 1;
				_end 		<= 0;
			end else begin
				o_crc_ready <= 0;
			end
		end
	end
endmodule