module tb_ethernet_head_reply_builder #(parameter FPGA_MAC = 48'h211abcdef112, parameter FPGA_IP  = 32'hC0000186) (
	input 					i_clk,
	input 					i_reset,
	
	input					i_arp_valid,
	input					i_icmp_valid,
	input					i_udp_valid,
	input					i_data_head_valid,
	input		[42*8-1:0]	i_data_head,
	
	output reg 	[42*8-1:0] 	o_data_head_reply,
	output reg				o_data_head_reply_ready
);
	initial begin
		o_data_head_reply		<= 0;
		o_data_head_reply_ready	<= 0;
	end
	
	always @(posedge i_clk, posedge i_reset) begin
		if (i_reset) begin
			o_data_head_reply					<= 0;
			o_data_head_reply_ready				<= 0;
		end else if (i_data_head_valid) begin
			if (i_arp_valid) begin
				o_data_head_reply 				<= {i_data_head[36*8-1:30*8] /*MAC_DST*/, FPGA_MAC /*MAC_SRC*/, i_data_head[30*8-1:28*8], 
													i_data_head[28*8-1:26*8], i_data_head[26*8-1:24*8], i_data_head[24*8-1:23*8], 
													i_data_head[23*8-1:22*8], 16'h0002 /*OPER*/, FPGA_MAC /*SHA*/, FPGA_IP /*SPA*/,
													i_data_head[20*8-1:14*8] /*THA*/, i_data_head[14*8-1:10*8] /*TPA*/};
				o_data_head_reply_ready 		<= 1;
			end else if (i_icmp_valid) begin
				o_data_head_reply 				<= {i_data_head[36*8-1:30*8] /*MAC_DST*/, i_data_head[42*8-1:36*8] /*MAC_SRC*/, i_data_head[30*8-1:28*8], 
													i_data_head[28*8-1:27*8+4], i_data_head[28*8-5:27*8], i_data_head[27*8-1:26*8+6], 
													i_data_head[27*8-3:26*8], i_data_head[26*8-1:24*8], i_data_head[24*8-1:22*8], 
													i_data_head[22*8-1:20*8+13], i_data_head[22*8-4:20*8], i_data_head[20*8-1:19*8], 
													i_data_head[19*8-1:18*8], i_data_head[18*8-1:16*8], i_data_head[12*8-1:8*8] /*IP_SRC*/, 
													i_data_head[16*8-1:12*8] /*IP_DST*/, 8'h00, i_data_head[7*8-1:6*8], 16'h0000 /*icmp_header_checksum*/, 
													i_data_head[4*8-1:0]};
				o_data_head_reply_ready 		<= 1;
			end else if (i_udp_valid) begin
				o_data_head_reply 				<= {i_data_head[36*8-1:30*8] /*MAC_DST*/, i_data_head[42*8-1:36*8] /*MAC_SRC*/, i_data_head[30*8-1:28*8], 
													i_data_head[28*8-1:27*8+4], i_data_head[28*8-5:27*8], i_data_head[27*8-1:26*8+6], 
													i_data_head[27*8-3:26*8], i_data_head[26*8-1:24*8], i_data_head[24*8-1:22*8], 
													i_data_head[22*8-1:20*8+13], i_data_head[22*8-4:20*8], i_data_head[20*8-1:19*8], 
													i_data_head[19*8-1:18*8], i_data_head[18*8-1:16*8], i_data_head[12*8-1:8*8] /*IP_SRC*/, 
													i_data_head[16*8-1:12*8] /*IP_DST*/, i_data_head[6*8-1:4*8] /*SRC_PORT*/, i_data_head[8*8-1:6*8] /*DST_PORT*/, 
													i_data_head[4*8-1:2*8], 16'hFFFF /*udp_header_checksum*/};
				o_data_head_reply_ready 		<= 1;
			end else;
		end else o_data_head_reply_ready 		<= 0;
	end
endmodule