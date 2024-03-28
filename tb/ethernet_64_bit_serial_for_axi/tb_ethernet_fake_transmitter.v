module tb_ethernet_fake_transmitter (
	input 				i_clk,
	input 				i_reset,
	
	output reg			o_tx_axis_tvalid,
	output reg	[63:0] 	o_tx_axis_tdata,
	output reg			o_tx_axis_tlast, 
	output reg	[7:0] 	o_tx_axis_tkeep 
);
	//reg i_clk; initial i_clk <= 0; always #10 i_clk <= ~i_clk;
	
	reg 		init;
	reg 		sleep_start;
	reg [4:0]	sleep;
	
	reg 		start_send;
	reg [1:0] 	msg_type;
	
	reg [63:0] 	arp_request 			[5:0];
	reg [7:0]  	arp_request_data_bytes 	[5:0];
	reg [2:0]  	arp_request_counter;
		
	reg [63:0] 	icmp_request 			[9:0];
	reg [7:0]  	icmp_request_data_bytes [9:0];
	reg [3:0]  	icmp_request_counter;
		
	reg [63:0] 	udp_request 			[9:0];
	reg [7:0]  	udp_request_data_bytes 	[9:0];
	reg [3:0]  	udp_request_counter;
	
	initial begin
		init						<= 0;
		sleep						<= 0;
		sleep_start					<= 0;
		start_send					<= 0;
		msg_type					<= 2'b01;
		
		o_tx_axis_tvalid			<= 0;
		o_tx_axis_tdata				<= 0;
		o_tx_axis_tlast				<= 0; 
		o_tx_axis_tkeep				<= 0;
		
		arp_request[0]				<= 336'h211abcdef11240b0;
		arp_request_data_bytes[0] 	<= 8'hFF;
		arp_request[1]				<= 336'h769ea12e08060001;
		arp_request_data_bytes[1] 	<= 8'hFF;
		arp_request[2]				<= 336'h08000604000140b0;
		arp_request_data_bytes[2] 	<= 8'hFF;
		arp_request[3]				<= 336'h769ea12ec0000185;
		arp_request_data_bytes[3] 	<= 8'hFF;
		arp_request[4]				<= 336'h211abcdef112c000;
		arp_request_data_bytes[4] 	<= 8'hFF;
		arp_request[5]				<= 336'h0186000000000000;
		arp_request_data_bytes[5] 	<= 8'b00000011;
		arp_request_counter			<= 0;
		
		icmp_request[0]				<= 592'h211abcdef11240b0;
		icmp_request_data_bytes[0] 	<= 8'hFF;
		icmp_request[1]				<= 592'h769ea12e08004500;
		icmp_request_data_bytes[1] 	<= 8'hFF;
		icmp_request[2]				<= 592'h003c5b6f00008001;
		icmp_request_data_bytes[2] 	<= 8'hFF;
		icmp_request[3]				<= 592'h0000c0000185c000;
		icmp_request_data_bytes[3] 	<= 8'hFF;
		icmp_request[4]				<= 592'h018608004c680001;
		icmp_request_data_bytes[4] 	<= 8'hFF;
		icmp_request[5]				<= 592'h00f3616263646566;
		icmp_request_data_bytes[5] 	<= 8'hFF;
		icmp_request[6]				<= 592'h6768696a6b6c6d6e;
		icmp_request_data_bytes[6] 	<= 8'hFF;
		icmp_request[7]				<= 592'h6f70717273747576;
		icmp_request_data_bytes[7] 	<= 8'hFF;
		icmp_request[8]				<= 592'h7761626364656667;
		icmp_request_data_bytes[8] 	<= 8'hFF;
		icmp_request[9]				<= 592'h6869000000000000;
		icmp_request_data_bytes[9] 	<= 8'b00000011;
		icmp_request_counter		<= 0;
		
		udp_request[0]				<= 592'h211abcdef11240b0;
		udp_request_data_bytes[0] 	<= 8'hFF;
		udp_request[1]				<= 592'h769ea12e08004500;
		udp_request_data_bytes[1] 	<= 8'hFF;
		udp_request[2]				<= 592'h003c5b7900008011;
		udp_request_data_bytes[2] 	<= 8'hFF;
		udp_request[3]				<= 592'h0000c0000185c000;
		udp_request_data_bytes[3] 	<= 8'hFF;
		udp_request[4]				<= 592'h018630d52711002c;
		udp_request_data_bytes[4] 	<= 8'hFF;
		udp_request[5]				<= 592'h8309000500010000;
		udp_request_data_bytes[5] 	<= 8'hFF;
		udp_request[6]				<= 592'h0000000000010000;
		udp_request_data_bytes[6] 	<= 8'hFF;
		udp_request[7]				<= 592'h0000123456781234;
		udp_request_data_bytes[7] 	<= 8'hFF;
		udp_request[8]				<= 592'h5678123456781234;
		udp_request_data_bytes[8] 	<= 8'hFF;
		udp_request[9]				<= 592'h5678000000000000;
		udp_request_data_bytes[9] 	<= 8'b00000011;
		udp_request_counter			<= 0;
	end
	
	always @(posedge i_clk, posedge i_reset) begin
		if (i_reset) begin
			sleep						<= 0;
			sleep_start					<= 0;
			start_send					<= 0;
			msg_type					<= 2'b01;
			
			o_tx_axis_tvalid			<= 0;
			o_tx_axis_tdata				<= 0;
			o_tx_axis_tlast				<= 0; 
			o_tx_axis_tkeep				<= 0;
			
			arp_request[0]				<= 336'h211abcdef11240b0;
			arp_request_data_bytes[0] 	<= 8'hFF;
			arp_request[1]				<= 336'h769ea12e08060001;
			arp_request_data_bytes[1] 	<= 8'hFF;
			arp_request[2]				<= 336'h08000604000140b0;
			arp_request_data_bytes[2] 	<= 8'hFF;
			arp_request[3]				<= 336'h769ea12ec0000185;
			arp_request_data_bytes[3] 	<= 8'hFF;
			arp_request[4]				<= 336'h211abcdef112c000;
			arp_request_data_bytes[4] 	<= 8'hFF;
			arp_request[5]				<= 336'h0186000000000000;
			arp_request_data_bytes[5] 	<= 8'b00000011;
			arp_request_counter			<= 0;
			
			icmp_request[0]				<= 592'h211abcdef11240b0;
			icmp_request_data_bytes[0] 	<= 8'hFF;
			icmp_request[1]				<= 592'h769ea12e08004500;
			icmp_request_data_bytes[1] 	<= 8'hFF;
			icmp_request[2]				<= 592'h003c5b6f00008001;
			icmp_request_data_bytes[2] 	<= 8'hFF;
			icmp_request[3]				<= 592'h0000c0000185c000;
			icmp_request_data_bytes[3] 	<= 8'hFF;
			icmp_request[4]				<= 592'h018608004c680001;
			icmp_request_data_bytes[4] 	<= 8'hFF;
			icmp_request[5]				<= 592'h00f3616263646566;
			icmp_request_data_bytes[5] 	<= 8'hFF;
			icmp_request[6]				<= 592'h6768696a6b6c6d6e;
			icmp_request_data_bytes[6] 	<= 8'hFF;
			icmp_request[7]				<= 592'h6f70717273747576;
			icmp_request_data_bytes[7] 	<= 8'hFF;
			icmp_request[8]				<= 592'h7761626364656667;
			icmp_request_data_bytes[8] 	<= 8'hFF;
			icmp_request[9]				<= 592'h6869000000000000;
			icmp_request_data_bytes[9] 	<= 8'b00000011;
			icmp_request_counter		<= 0;
			
			udp_request[0]				<= 592'h211abcdef11240b0;
			udp_request_data_bytes[0] 	<= 8'hFF;
			udp_request[1]				<= 592'h769ea12e08004500;
			udp_request_data_bytes[1] 	<= 8'hFF;
			udp_request[2]				<= 592'h003c5b7900008011;
			udp_request_data_bytes[2] 	<= 8'hFF;
			udp_request[3]				<= 592'h0000c0000185c000;
			udp_request_data_bytes[3] 	<= 8'hFF;
			udp_request[4]				<= 592'h018630d52711002c;
			udp_request_data_bytes[4] 	<= 8'hFF;
			udp_request[5]				<= 592'h8309000500010000;
			udp_request_data_bytes[5] 	<= 8'hFF;
			udp_request[6]				<= 592'h0000000000010000;
			udp_request_data_bytes[6] 	<= 8'hFF;
			udp_request[7]				<= 592'h0000123456781234;
			udp_request_data_bytes[7] 	<= 8'hFF;
			udp_request[8]				<= 592'h5678123456781234;
			udp_request_data_bytes[8] 	<= 8'hFF;
			udp_request[9]				<= 592'h5678000000000000;
			udp_request_data_bytes[9] 	<= 8'b00000011;
			udp_request_counter			<= 0;
		end else begin
			if (init == 0) begin 
				init 		<= 1;
				start_send 	<= 1;
				msg_type	<= 2'b01;
			end else;
			
			if (start_send) begin
				case (msg_type)
					2'b00: begin 	// IDLE
						start_send					<= 0;
						msg_type					<= 2'b01;
						
						o_tx_axis_tvalid			<= 0;
						o_tx_axis_tdata				<= 0;
						o_tx_axis_tlast				<= 0; 
						o_tx_axis_tkeep				<= 0;
						
						arp_request[0]				<= 336'h211abcdef11240b0;
						arp_request_data_bytes[0] 	<= 8'hFF;
						arp_request[1]				<= 336'h769ea12e08060001;
						arp_request_data_bytes[1] 	<= 8'hFF;
						arp_request[2]				<= 336'h08000604000140b0;
						arp_request_data_bytes[2] 	<= 8'hFF;
						arp_request[3]				<= 336'h769ea12ec0000185;
						arp_request_data_bytes[3] 	<= 8'hFF;
						arp_request[4]				<= 336'h211abcdef112c000;
						arp_request_data_bytes[4] 	<= 8'hFF;
						arp_request[5]				<= 336'h0186000000000000;
						arp_request_data_bytes[5] 	<= 8'b00000011;
						arp_request_counter			<= 0;
						
						icmp_request[0]				<= 592'h211abcdef11240b0;
						icmp_request_data_bytes[0] 	<= 8'hFF;
						icmp_request[1]				<= 592'h769ea12e08004500;
						icmp_request_data_bytes[1] 	<= 8'hFF;
						icmp_request[2]				<= 592'h003c5b6f00008001;
						icmp_request_data_bytes[2] 	<= 8'hFF;
						icmp_request[3]				<= 592'h0000c0000185c000;
						icmp_request_data_bytes[3] 	<= 8'hFF;
						icmp_request[4]				<= 592'h018608004c680001;
						icmp_request_data_bytes[4] 	<= 8'hFF;
						icmp_request[5]				<= 592'h00f3616263646566;
						icmp_request_data_bytes[5] 	<= 8'hFF;
						icmp_request[6]				<= 592'h6768696a6b6c6d6e;
						icmp_request_data_bytes[6] 	<= 8'hFF;
						icmp_request[7]				<= 592'h6f70717273747576;
						icmp_request_data_bytes[7] 	<= 8'hFF;
						icmp_request[8]				<= 592'h7761626364656667;
						icmp_request_data_bytes[8] 	<= 8'hFF;
						icmp_request[9]				<= 592'h6869000000000000;
						icmp_request_data_bytes[9] 	<= 8'b00000011;
						icmp_request_counter		<= 0;
						
						udp_request[0]				<= 592'h211abcdef11240b0;
						udp_request_data_bytes[0] 	<= 8'hFF;
						udp_request[1]				<= 592'h769ea12e08004500;
						udp_request_data_bytes[1] 	<= 8'hFF;
						udp_request[2]				<= 592'h003c5b7900008011;
						udp_request_data_bytes[2] 	<= 8'hFF;
						udp_request[3]				<= 592'h0000c0000185c000;
						udp_request_data_bytes[3] 	<= 8'hFF;
						udp_request[4]				<= 592'h018630d52711002c;
						udp_request_data_bytes[4] 	<= 8'hFF;
						udp_request[5]				<= 592'h8309000500010000;
						udp_request_data_bytes[5] 	<= 8'hFF;
						udp_request[6]				<= 592'h0000000000010000;
						udp_request_data_bytes[6] 	<= 8'hFF;
						udp_request[7]				<= 592'h0000123456781234;
						udp_request_data_bytes[7] 	<= 8'hFF;
						udp_request[8]				<= 592'h5678123456781234;
						udp_request_data_bytes[8] 	<= 8'hFF;
						udp_request[9]				<= 592'h5678000000000000;
						udp_request_data_bytes[9] 	<= 8'b00000011;
						udp_request_counter			<= 0;
					end
					2'b01: begin	// ARP
						if (arp_request_counter == 3'b110) begin
							arp_request_counter 	<= 0;
							o_tx_axis_tvalid		<= 0;
							o_tx_axis_tdata			<= 0;
							o_tx_axis_tlast			<= 0;
							o_tx_axis_tkeep			<= 0;
						end else begin
							arp_request_counter 		<= arp_request_counter + 1;
							o_tx_axis_tvalid			<= 1;
							o_tx_axis_tdata[1*8-1:0]	<= arp_request[arp_request_counter][8*8-1:7*8];
							o_tx_axis_tdata[2*8-1:1*8]	<= arp_request[arp_request_counter][7*8-1:6*8];
							o_tx_axis_tdata[3*8-1:2*8]	<= arp_request[arp_request_counter][6*8-1:5*8];
							o_tx_axis_tdata[4*8-1:3*8]	<= arp_request[arp_request_counter][5*8-1:4*8];
							o_tx_axis_tdata[5*8-1:4*8]	<= arp_request[arp_request_counter][4*8-1:3*8];
							o_tx_axis_tdata[6*8-1:5*8]	<= arp_request[arp_request_counter][3*8-1:2*8];
							o_tx_axis_tdata[7*8-1:6*8]	<= arp_request[arp_request_counter][2*8-1:1*8];
							o_tx_axis_tdata[8*8-1:7*8]	<= arp_request[arp_request_counter][1*8-1:0];
							o_tx_axis_tlast				<= (arp_request_counter == 3'b101) ? 1: 0;
							o_tx_axis_tkeep				<= arp_request_data_bytes[arp_request_counter]; 
						end
					end
					2'b10: begin	// ICMP
						if (icmp_request_counter == 4'b1010) begin
							icmp_request_counter 	<= 0;
							o_tx_axis_tvalid		<= 0;
							o_tx_axis_tdata			<= 0;
							o_tx_axis_tlast			<= 0;
							o_tx_axis_tkeep			<= 0;
						end else begin
							icmp_request_counter 		<= icmp_request_counter + 1;
							o_tx_axis_tvalid			<= 1;
							o_tx_axis_tdata[1*8-1:0]	<= icmp_request[icmp_request_counter][8*8-1:7*8];
							o_tx_axis_tdata[2*8-1:1*8]	<= icmp_request[icmp_request_counter][7*8-1:6*8];
							o_tx_axis_tdata[3*8-1:2*8]	<= icmp_request[icmp_request_counter][6*8-1:5*8];
							o_tx_axis_tdata[4*8-1:3*8]	<= icmp_request[icmp_request_counter][5*8-1:4*8];
							o_tx_axis_tdata[5*8-1:4*8]	<= icmp_request[icmp_request_counter][4*8-1:3*8];
							o_tx_axis_tdata[6*8-1:5*8]	<= icmp_request[icmp_request_counter][3*8-1:2*8];
							o_tx_axis_tdata[7*8-1:6*8]	<= icmp_request[icmp_request_counter][2*8-1:1*8];
							o_tx_axis_tdata[8*8-1:7*8]	<= icmp_request[icmp_request_counter][1*8-1:0];
							o_tx_axis_tlast				<= (icmp_request_counter == 4'b1001) ? 1: 0;
							o_tx_axis_tkeep				<= icmp_request_data_bytes[icmp_request_counter];
						end
					end
					2'b11: begin	// UDP
						if (udp_request_counter == 4'b1010) begin
							udp_request_counter 	<= 0;
							o_tx_axis_tvalid		<= 0;
							o_tx_axis_tdata			<= 0;
							o_tx_axis_tlast			<= 0;
							o_tx_axis_tkeep			<= 0;
						end else begin
							udp_request_counter 		<= udp_request_counter + 1;
							o_tx_axis_tvalid			<= 1;
							o_tx_axis_tdata[1*8-1:0]	<= udp_request[udp_request_counter][8*8-1:7*8];
							o_tx_axis_tdata[2*8-1:1*8]	<= udp_request[udp_request_counter][7*8-1:6*8];
							o_tx_axis_tdata[3*8-1:2*8]	<= udp_request[udp_request_counter][6*8-1:5*8];
							o_tx_axis_tdata[4*8-1:3*8]	<= udp_request[udp_request_counter][5*8-1:4*8];
							o_tx_axis_tdata[5*8-1:4*8]	<= udp_request[udp_request_counter][4*8-1:3*8];
							o_tx_axis_tdata[6*8-1:5*8]	<= udp_request[udp_request_counter][3*8-1:2*8];
							o_tx_axis_tdata[7*8-1:6*8]	<= udp_request[udp_request_counter][2*8-1:1*8];
							o_tx_axis_tdata[8*8-1:7*8]	<= udp_request[udp_request_counter][1*8-1:0];
							o_tx_axis_tlast				<= (udp_request_counter == 4'b1001) ? 1: 0;
							o_tx_axis_tkeep				<= udp_request_data_bytes[udp_request_counter];
						end
					end
				endcase
			end else;
			
			if ((arp_request_counter == 3'b110 || icmp_request_counter == 4'b1010 || udp_request_counter == 4'b1010) && (msg_type != 2'b00)) begin
				sleep_start <= 1;
				start_send  <= 0;
			end
			
			if (sleep_start) begin
				if (sleep == 5'b11111) begin
					sleep_start <= 0;
					sleep 		<= 0;
					start_send 	<= 1;
					msg_type	<= msg_type + 1;
				end else begin
					sleep <= sleep + 1;
				end
			end
			
			if (msg_type == 2'b00) $stop;
			
		end
	end
	
endmodule