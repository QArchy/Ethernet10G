module tb_ethernet_reply_transmitter(
	input 				i_clk,
	input 				i_reset,
	
	input 				arp_valid, 
	input 				icmp_valid,
	input 				udp_valid,
	
	input				data_head_valid,
	
	input 	[6*8-1:0]	data_head_frame_payload,	
	input 	[5:0]		data_head_frame_payload_keep,	
	
	input 	[42*8-1:0] 	data_head_reply,		
	input 				data_head_reply_ready,	
	
	input 	[15:0] 		icmp_crc,	
	input 				icmp_crc_ready,	
	
	input 				rx_axis_tvalid,
	input 	[63:0]		rx_axis_tdata, 
	input 				rx_axis_tlast, 
	input 	[7:0]		rx_axis_tkeep,
	
	output 	reg			tx_axis_tvalid,	
	output 	reg	[63:0]	tx_axis_tdata, 	
	output 	reg			tx_axis_tlast, 	
	output 	reg	[7:0]	tx_axis_tkeep	
);
	initial begin
		tx_axis_tvalid	<= 0;	
		tx_axis_tdata	<= 0;
		tx_axis_tlast	<= 0;
		tx_axis_tkeep	<= 0;
	end
	
	reg rx_axis_tlast_suspend;
	reg [2:0] protocol;
	
	initial begin
		rx_axis_tlast_suspend 	<= 0;
		protocol 				<= 0;
	end
	
	/* Head transmit registers */
	reg 	 		payload_transmit_start;
	reg 	 		head_transmit_start;
	reg [48*8-1:0] 	transmit_data_head;
	reg [5:0] 		transmit_data_head_payload_keep;
	reg 			data_head_sent;	// 1 clk signal
	
	initial begin
		payload_transmit_start				    <= 0;
		head_transmit_start				        <= 0;
		transmit_data_head				        <= 0;
		transmit_data_head_payload_keep         <= 0;
		data_head_sent					        <= 0;	// 1 clk signal
	end
	
	wire [63:0]	payload_fifo_din			= rx_axis_tdata;
	wire 		payload_fifo_wr_en			= rx_axis_tlast_suspend ? 0 : (data_head_valid && ~arp_valid) ? 1 : payload_fifo_wr_en;
	wire 		payload_fifo_rd_en			= payload_fifo_empty ? 0 :  data_head_sent ? 1 : payload_fifo_rd_en;
	wire [63:0]	payload_fifo_dout;
	wire 		payload_fifo_full;
	wire 		payload_fifo_empty;
	wire [3:0]	payload_fifo_data_count;
	
	fifo_ethernet_payload fifo_ethernet_payload_inst(
		.clk(i_clk),          					//	input clk,
		.rst(i_reset),        					//	input rst,
		.din(payload_fifo_din),               	//	input [63:0] din,			// FIFO WRITE
		.wr_en(payload_fifo_wr_en),             //	input wr_en,				// FIFO WRITE
		.rd_en(payload_fifo_rd_en),             //	input rd_en,				// FIFO READ
		.dout(payload_fifo_dout),              	//	output [63:0] dout,			// FIFO READ
		.full(payload_fifo_full),              	//	output full,				// FIFO WRITE
		.empty(payload_fifo_empty),             //	output empty,				// FIFO READ
		.data_count(payload_fifo_data_count)	//	output [3:0] data_count		
	);
	
	wire [7:0]	payload_keep_fifo_din		= rx_axis_tkeep;
	wire 		payload_keep_fifo_wr_en		= payload_fifo_wr_en;
	wire 		payload_keep_fifo_rd_en		= payload_fifo_rd_en;
	wire [7:0]	payload_keep_fifo_dout;
	wire 		payload_keep_fifo_full;
	wire 		payload_keep_fifo_empty;
	wire [3:0]	payload_keep_fifo_data_count;
	
	fifo_ethernet_payload_keep fifo_ethernet_payload_keep_inst (
		.clk(i_clk),        						//	input clk;
		.rst(i_reset),      						//	input rst;
		.din(payload_keep_fifo_din),           		//	input [7:0]din;        	// FIFO WRITE
		.wr_en(payload_keep_fifo_wr_en),         	//	input wr_en;           	// FIFO WRITE
		.rd_en(payload_keep_fifo_rd_en),         	//	input rd_en;           	// FIFO READ
		.dout(payload_keep_fifo_dout),          	//	output [7:0]dout;      	// FIFO READ
		.full(payload_keep_fifo_full),          	//	output full;           	// FIFO WRITE
		.empty(payload_keep_fifo_empty),         	//	output empty;          	// FIFO READ
		.data_count(payload_keep_fifo_data_count)	//	output [3:0]data_count;
	);
	
	always @(posedge i_clk, posedge i_reset) begin
		if (i_reset) begin
			rx_axis_tlast_suspend <= 0;
		end else begin
			rx_axis_tlast_suspend <= rx_axis_tlast;
		end
	end
	
	always @(posedge i_clk, posedge i_reset) begin
		if (i_reset) begin
			protocol <= 0;
		end else begin
			if (data_head_valid)
				protocol <=	arp_valid ? 2'b01 : icmp_valid ? 2'b10 : udp_valid ? 2'b11 : 0;
		end
	end
	
	always @(posedge i_clk, posedge i_reset) begin
		if (i_reset) begin
			tx_axis_tvalid	<= 0;
			tx_axis_tdata	<= 0;
			tx_axis_tlast	<= 0;
			tx_axis_tkeep	<= 0;
			
			payload_transmit_start			<= 0;
			head_transmit_start				<= 0;
			transmit_data_head				<= 0;
			transmit_data_head_payload_keep	<= 0;
			data_head_sent					<= 0;
		end else begin
		    
			if (data_head_reply_ready) begin
				head_transmit_start 			<= 1;
				transmit_data_head 				<= {data_head_reply, data_head_frame_payload};
				transmit_data_head_payload_keep <= data_head_frame_payload_keep;
			end else begin
				if (head_transmit_start) begin
					head_transmit_start 	<= (transmit_data_head[40*8-1:0] == 0) ? 0 : head_transmit_start;
					payload_transmit_start 	<= ((transmit_data_head[40*8-1:0] == 0) && ~arp_valid) ? 1 : payload_transmit_start;
					data_head_sent			<= (transmit_data_head[40*8-1:0] == 0) ? 1 : 0;
					
					transmit_data_head <= transmit_data_head << 8*8;
					
					if (icmp_crc_ready) begin
						transmit_data_head[44*8-1:42*8] <= icmp_crc;
					end
					
					tx_axis_tvalid	<= 1;
					
					/* Realign data for AXI Stream */
					tx_axis_tdata[8*8-1:7*8]	<= transmit_data_head[41*8-1:40*8]; 	
					tx_axis_tdata[7*8-1:6*8]	<= transmit_data_head[42*8-1:41*8]; 	
					tx_axis_tdata[6*8-1:5*8]	<= transmit_data_head[43*8-1:42*8]; 	
					tx_axis_tdata[5*8-1:4*8]	<= transmit_data_head[44*8-1:43*8]; 	
					tx_axis_tdata[4*8-1:3*8]	<= transmit_data_head[45*8-1:44*8]; 	
					tx_axis_tdata[3*8-1:2*8]	<= transmit_data_head[46*8-1:45*8]; 	
					tx_axis_tdata[2*8-1:1*8]	<= transmit_data_head[47*8-1:46*8]; 	
					tx_axis_tdata[1*8-1:0]		<= transmit_data_head[48*8-1:47*8]; 
					
					tx_axis_tlast	<= ((transmit_data_head[40*8-1:0] == 0) && arp_valid) ? 1 : 0;
					tx_axis_tkeep	<= ((transmit_data_head[40*8-1:0] == 0) && ~arp_valid) ? {2'b11, transmit_data_head_payload_keep} : 8'hFF;
					
				end else if (payload_transmit_start) begin
				    data_head_sent          <= 0;
				    payload_transmit_start 	<= (payload_fifo_data_count == 4'd0) ? 0: payload_transmit_start;
				    
					tx_axis_tvalid			<= 1;
					tx_axis_tdata			<= payload_fifo_dout;	
					tx_axis_tlast			<= (payload_fifo_data_count == 4'd0) ? 1: 0;
					tx_axis_tkeep			<= payload_keep_fifo_dout;
				end else begin
					tx_axis_tvalid	<= 0;
					tx_axis_tdata	<= 0;
					tx_axis_tlast	<= 0;
					tx_axis_tkeep	<= 0;
					
					head_transmit_start						<= 0;
					transmit_data_head				        <= 0;
					transmit_data_head_payload_keep	        <= 0;
					data_head_sent					        <= 0;
				end
			end
		end
	end
	
endmodule