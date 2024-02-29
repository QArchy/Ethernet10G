module tb_ethernet_icmp_checksum_counter(
	input 				i_clk,
	input 				i_reset,
	
	input 		[63:0]	i_rx_axis_tdata, 
	input 				i_rx_axis_tlast, 
	input 		[7:0]	i_rx_axis_tkeep,
	
	input 				i_icmp_valid,
	
	input 		[20:0]	i_icmp_crc_part1,
	input 				i_icmp_crc_part1_ready,
	
	output wire [15:0]	o_icmp_crc,
	output reg 			o_icmp_ready
);
	reg [20:0] o_icmp_crc_r;
	assign o_icmp_crc = o_icmp_crc_r[15:0];
	
	reg rx_axis_tlast_suspend;
	wire enable =		i_icmp_crc_part1_ready ? i_icmp_valid :
						rx_axis_tlast_suspend ? 0: enable;
	
	initial begin
		o_icmp_crc_r 			<= 0;
		rx_axis_tlast_suspend 	<= 0;
		o_icmp_ready			<= 0;
	end
	
	always @(posedge i_clk, posedge i_reset) begin
		if (i_reset) begin
			o_icmp_crc_r			<= 0;
			rx_axis_tlast_suspend	<= 0;
			o_icmp_ready			<= 0;
		end else begin
			rx_axis_tlast_suspend <= i_rx_axis_tlast;
			
			o_icmp_crc_r	<= (rx_axis_tlast_suspend && i_icmp_valid) ? ~(o_icmp_crc_r[15:0] + {{11{1'b0}} + o_icmp_crc_r[20:16]}) : o_icmp_crc_r;
			
			if (enable) begin
				if (i_icmp_crc_part1_ready) begin
					o_icmp_crc_r <= i_icmp_crc_part1 + 
									{i_rx_axis_tdata[7*8-1:6*8], i_rx_axis_tdata[8*8-1:7*8]} + {i_rx_axis_tdata[5*8-1:4*8], i_rx_axis_tdata[6*8-1:5*8]} + 
									{i_rx_axis_tdata[3*8-1:2*8], i_rx_axis_tdata[4*8-1:3*8]} + {i_rx_axis_tdata[1*8-1:0], i_rx_axis_tdata[2*8-1:1*8]};
				end else begin
					o_icmp_crc_r <= o_icmp_crc_r +
									{(/*i_rx_axis_tkeep[6] & */i_rx_axis_tdata[7*8-1:6*8]), (/*i_rx_axis_tkeep[7] & */i_rx_axis_tdata[8*8-1:7*8])} + 
									{(/*i_rx_axis_tkeep[4] & */i_rx_axis_tdata[5*8-1:4*8]), (/*i_rx_axis_tkeep[5] & */i_rx_axis_tdata[6*8-1:5*8])} + 
									{(/*i_rx_axis_tkeep[2] & */i_rx_axis_tdata[3*8-1:2*8]), (/*i_rx_axis_tkeep[3] & */i_rx_axis_tdata[4*8-1:3*8])} + 
									{(/*i_rx_axis_tkeep[0] & */i_rx_axis_tdata[1*8-1:0]),   (/*i_rx_axis_tkeep[1] & */i_rx_axis_tdata[2*8-1:1*8])};
				end
			end
			
			o_icmp_ready 	<= (rx_axis_tlast_suspend && i_icmp_valid) ? 1 : 0;
		end
	end
	
endmodule