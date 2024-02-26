module ethernet_controller_axi_stream_bridge(
	/* System */
	input 				i_clk,
	input 				i_reset,
	/* Ethernet controller */
	input 				i_ethernet_controller_clk,
	input 				i_data,
	input 				i_valid,
	output reg 			o_data,
	output reg 			o_valid,
	/* AXI Stream */
	input 				i_axi_stream_clk;
	input 				i_tx_axis_tready
	output reg 			o_tx_axis_tvalid;      
	output reg 	[63:0] 	o_tx_axis_tdata;
	output reg 			o_tx_axis_tlast;       
	output reg 	[7:0] 	o_tx_axis_tkeep; 
	output reg 			o_tx_axis_tuser;       
	input 				i_rx_axis_tvalid;       
	input 		[63:0] 	i_rx_axis_tdata; 
	input 				i_rx_axis_tlast;        
	input 		[7:0] 	i_rx_axis_tkeep;  
	input 				i_rx_axis_tuser;        
	input 		[55:0] 	i_rx_preambleout;
);
	
	always @(posedge i_ethernet_controller_clk, posedge i_reset) begin
		if (i_reset) begin
			o_data	<= 0;
			o_valid <= 0;
		end else begin
			
		end
	end
	
	always @(posedge i_axi_stream_clk, posedge i_reset) begin
		if (i_reset) begin
			o_tx_axis_tvalid	<= 0;
			o_tx_axis_tdata		<= 0;
			o_tx_axis_tlast		<= 0;
			o_tx_axis_tkeep		<= 0;
			o_tx_axis_tuser		<= 0;
		end else begin
			
		end
	end
	
endmodule