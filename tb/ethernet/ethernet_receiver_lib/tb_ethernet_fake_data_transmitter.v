module tb_ethernet_fake_data_transmitter(
	input 				i_reset,
	input 				i_clk,
	input				i_start_send,	// 1 clk signal
	input 		[1:0]	i_msg_type,
	output reg	[7:0]	o_msg_word,
	output reg			o_valid
);
	parameter ARP_REQUEST_SIZE  = 50;
	parameter ICMP_REQUEST_SIZE = 82;
	parameter UDP_REQUEST_SIZE  = 82;
	
	reg [ARP_REQUEST_SIZE*8-1:0] 	arp_request;
	reg [ICMP_REQUEST_SIZE*8-1:0] 	icmp_request;
	reg [UDP_REQUEST_SIZE*8-1:0] 	udp_request;
	initial begin
		o_msg_word		<= 0;
		o_valid			<= 0;
		arp_request		<= 400'h55555555555555D5211abcdef11240b0769ea12e0806000108000604000140b0769ea12ec0000185211abcdef112c0000186;
		icmp_request	<= 656'h55555555555555D5211abcdef11240b0769ea12e08004500003c5b6f000080010000c0000185c000018608004c68000100f36162636465666768696a6b6c6d6e6f7071727374757677616263646566676869;
		udp_request		<= 656'h55555555555555D5211abcdef11240b0769ea12e08004500003c5b79000080110000c0000185c000018630d52711002c83090005000100000000000000010000000012345678123456781234567812345678;
	end
	
	reg	[1:0]	msg_type;
	reg 		start_send;
	initial begin
		msg_type	<= 0;
		start_send	<= 0;
	end
	
	reg [6:0] send_counter;
	initial begin
		send_counter <= 0;
	end
	
	/* TB SIGNAL */
	reg [1:0]	msg_type_prev;
	initial msg_type_prev 	<= 0;
	
	always @(posedge i_clk, posedge i_reset) begin
		if (i_reset) begin
			msg_type_prev 	<= 0;
		end else begin
			msg_type_prev 	<= msg_type;
		end
	end
	/* TB SIGNAL */
	
	always @(posedge i_clk, posedge i_reset) begin
		if (i_reset) begin
			o_msg_word		<= 0;
			o_valid			<= 0;
			arp_request		<= 400'h55555555555555D5211abcdef11240b0769ea12e0806000108000604000140b0769ea12ec0000185211abcdef112c0000186;
			icmp_request	<= 656'h55555555555555D5211abcdef11240b0769ea12e08004500003c5b6f000080010000c0000185c000018608004c68000100f36162636465666768696a6b6c6d6e6f7071727374757677616263646566676869;
			udp_request		<= 656'h55555555555555D5211abcdef11240b0769ea12e08004500003c5b79000080110000c0000185c000018630d52711002c83090005000100000000000000010000000012345678123456781234567812345678;
			msg_type		<= 0;
			start_send		<= 0;
			send_counter	<= 0;
		end else begin
			if (start_send) begin
				case (msg_type)
					2'b00: begin // IDLE
						msg_type		<= 0;
						start_send		<= 0;
						send_counter	<= 0;
						o_valid			<= 0;
					end
					2'b01: begin // ARP
						if (send_counter == ARP_REQUEST_SIZE) begin
							msg_type		<= 0;
							start_send		<= 0;
							send_counter	<= 0;
							o_msg_word		<= 0;
							o_valid			<= 0;
						end else begin
							o_valid 		<= 1;
							send_counter 	<= send_counter + 1;
							o_msg_word 		<= arp_request[ARP_REQUEST_SIZE*8-1:(ARP_REQUEST_SIZE-1)*8];
							arp_request 	<= arp_request << 8;
						end
					end
					2'b10: begin // ICMP
						if (send_counter == ICMP_REQUEST_SIZE) begin
							msg_type		<= 0;
							start_send		<= 0;
							send_counter	<= 0;
							o_msg_word		<= 0;
							o_valid			<= 0;
						end else begin
							o_valid 		<= 1;
							send_counter 	<= send_counter + 1;
							o_msg_word 		<= icmp_request[ICMP_REQUEST_SIZE*8-1:(ICMP_REQUEST_SIZE-1)*8];
							icmp_request 	<= icmp_request << 8;
						end
					end
					2'b11: begin // UDP
						if (send_counter == UDP_REQUEST_SIZE) begin
							msg_type		<= 0;
							start_send		<= 0;
							send_counter	<= 0;
							o_msg_word		<= 0;
							o_valid			<= 0;
						end else begin
							o_valid 		<= 1;
							send_counter 	<= send_counter + 1;
							o_msg_word 		<= udp_request[UDP_REQUEST_SIZE*8-1:(UDP_REQUEST_SIZE-1)*8];
							udp_request 	<= udp_request << 8;
						end
					end
				endcase
			end else begin
				if (i_start_send) begin
					start_send 	<= 1;
					msg_type 	<= i_msg_type;
				end
				arp_request		<= 400'h55555555555555D5211abcdef11240b0769ea12e0806000108000604000140b0769ea12ec0000185211abcdef112c0000186;
				icmp_request	<= 656'h55555555555555D5211abcdef11240b0769ea12e08004500003c5b6f000080010000c0000185c000018608004c68000100f36162636465666768696a6b6c6d6e6f7071727374757677616263646566676869;
				udp_request		<= 656'h55555555555555D5211abcdef11240b0769ea12e08004500003c5b79000080110000c0000185c000018630d52711002c83090005000100000000000000010000000012345678123456781234567812345678;
			end
		end
	end
	
endmodule