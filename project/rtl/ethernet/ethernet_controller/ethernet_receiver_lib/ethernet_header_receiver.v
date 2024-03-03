module ethernet_header_receiver(
	input 					i_clk,
	input 					i_reset,
	
	input					i_rx_axis_tvalid,
	input		[63:0] 		i_rx_axis_tdata,
	input					i_rx_axis_tlast, 
	input		[7:0] 		i_rx_axis_tkeep, 
	
	output reg 	[42*8-1:0]	o_data_head,
	output reg 				o_data_head_valid,
	output reg 				o_data_head_frame_payload_valid,
	output reg 	[6*8-1:0]	o_data_head_frame_payload,
	output reg 	[5:0]		o_data_head_frame_payload_keep
);
	reg enable;
	reg rx_axis_tvalid_prev;
	wire rx_axis_tvalid_posedge = i_rx_axis_tvalid && ~rx_axis_tvalid_prev;
	
	reg [2:0] head_counter;
	
	initial begin
		enable				<= 0;
		rx_axis_tvalid_prev	<= 0;
		
		head_counter 					<= 0;
		o_data_head 					<= 0;
		o_data_head_valid 				<= 0;
		o_data_head_frame_payload_valid	<= 0;
		o_data_head_frame_payload		<= 0;
		o_data_head_frame_payload_keep	<= 0;
	end
	
	always @(posedge i_clk, posedge i_reset) begin
		if (i_reset) begin
			enable				<= 0;
			rx_axis_tvalid_prev	<= 0;
			
			head_counter 					<= 0;
			o_data_head 					<= 0;
			o_data_head_valid 				<= 0;
			o_data_head_frame_payload_valid	<= 0;
			o_data_head_frame_payload		<= 0;
			o_data_head_frame_payload_keep	<= 0;
		end else begin
			rx_axis_tvalid_prev <= i_rx_axis_tvalid;
			enable 				<= rx_axis_tvalid_posedge ? 1: enable;
			
			if (rx_axis_tvalid_posedge || enable) begin
				if (head_counter == 3'b101) begin
					head_counter 						<= 0;
					
					enable								<= 0;
					
					o_data_head 						<= o_data_head << 2*8;
					o_data_head[2*8-1:0]				<= {i_rx_axis_tdata[1*8-1:0], 
															i_rx_axis_tdata[2*8-1:1*8]};
					
					o_data_head_valid <= 1;
					
					o_data_head_frame_payload_valid			<= i_rx_axis_tkeep[2];
					o_data_head_frame_payload_keep 			<= i_rx_axis_tkeep[7:2];
					o_data_head_frame_payload[1*8-1:0] 		<= i_rx_axis_tdata[3*8-1:2*8];
					o_data_head_frame_payload[2*8-1:1*8] 	<= i_rx_axis_tdata[4*8-1:3*8];
					o_data_head_frame_payload[3*8-1:2*8] 	<= i_rx_axis_tdata[5*8-1:4*8];
					o_data_head_frame_payload[4*8-1:3*8] 	<= i_rx_axis_tdata[6*8-1:5*8];
					o_data_head_frame_payload[5*8-1:4*8] 	<= i_rx_axis_tdata[7*8-1:6*8];
					o_data_head_frame_payload[6*8-1:5*8] 	<= i_rx_axis_tdata[8*8-1:7*8];
				end else begin
					o_data_head 			<= o_data_head << 8*8;
					o_data_head[8*8-1:0] 	<= {i_rx_axis_tdata[1*8-1:0], 	
												i_rx_axis_tdata[2*8-1:1*8], 
												i_rx_axis_tdata[3*8-1:2*8], 
												i_rx_axis_tdata[4*8-1:3*8], 
												i_rx_axis_tdata[5*8-1:4*8], 
												i_rx_axis_tdata[6*8-1:5*8], 
												i_rx_axis_tdata[7*8-1:6*8], 
												i_rx_axis_tdata[8*8-1:7*8]};
					head_counter 			<= head_counter + 1;
				end
			end else begin
				o_data_head_valid 				<= 0;
				o_data_head_frame_payload_valid	<= 0;
			end
		end
	end
	
endmodule