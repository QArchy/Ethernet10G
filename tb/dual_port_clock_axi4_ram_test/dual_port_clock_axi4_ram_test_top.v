module dual_port_clock_axi4_ram_test_top();
	
	reg i_clk; 	 					initial i_clk   				<= 0; 	always #10 i_clk   					<= ~i_clk;
	reg i_reset; 					initial i_reset 				<= 0; 	always #10 i_reset 					<= ~i_reset;
	reg ethernet_controller_clk; 	initial ethernet_controller_clk <= 0; 	always #15 ethernet_controller_clk 	<= ~ethernet_controller_clk;
	reg axi_stream_clk; 			initial axi_stream_clk          <= 0; 	always #20 axi_stream_clk 			<= ~ethernet_controller_clk;
	
	wire          	o_transmit_fake_flag;
	
	wire			o_tx_axis_tvalid;
	wire	[63:0] 	o_tx_axis_tdata;
	wire			o_tx_axis_tlast; 
	wire	[7:0] 	o_tx_axis_tkeep; 
	
	dual_port_fake_transmitter dual_port_fake_transmitter_inst(
		.i_clk(axi_stream_clk),							//	input 				i_clk,  
		.i_reset(i_reset),								//	input 				i_reset,
														//	
		.o_transmit_fake_flag(o_transmit_fake_flag),	//	output reg          o_transmit_fake_flag,
														//	
		.o_tx_axis_tvalid(o_tx_axis_tvalid),			//	output reg			o_tx_axis_tvalid,
		.o_tx_axis_tdata(o_tx_axis_tdata),				//	output reg	[63:0] 	o_tx_axis_tdata, 
		.o_tx_axis_tlast(o_tx_axis_tlast), 				//	output reg			o_tx_axis_tlast, 
		.o_tx_axis_tkeep(o_tx_axis_tkeep) 				//	output reg	[7:0] 	o_tx_axis_tkeep  
	);
	
	wire 			rx_contr_tvalid;
	wire 	[63:0]	rx_contr_tdata;
	wire 			rx_contr_tlast;
	wire 	[7:0]	rx_contr_tkeep;
	wire 			tx_contr_tvalid;
	wire 	[63:0]	tx_contr_tdata;
	wire 			tx_contr_tlast;
	wire 	[7:0]	tx_contr_tkeep;
	
	wire			tx_axis_tready;
	wire            tx_axis_tvalid_bridge;
    wire	[63:0]  tx_axis_tdata_bridge; 
    wire            tx_axis_tlast_bridge; 
    wire    [7:0]   tx_axis_tkeep_bridge; 
    wire            tx_axis_tuser_bridge;
	
	wire 			rx_axis_tvalid 	= o_tx_axis_tvalid;
	wire 	[63:0] 	rx_axis_tdata	= o_tx_axis_tdata;
	wire 			rx_axis_tlast	= o_tx_axis_tlast;
	wire 	[7:0] 	rx_axis_tkeep	= o_tx_axis_tkeep;
	wire 	[55:0] 	rx_preambleout	= 56'h555555555555d5;
	
	dual_port_axi_stream_bridge dual_port_axi_stream_bridge_inst(
																//	/* System */
		.i_reset(i_reset),										//	input 				i_reset,
																//	/* Ethernet controller */
		.i_ethernet_controller_clk(ethernet_controller_clk),	//	input 				i_ethernet_controller_clk,
		.o_rx_contr_tvalid(rx_contr_tvalid),					//	output reg 			o_rx_contr_tvalid,
		.o_rx_contr_tdata(rx_contr_tdata),						//	output reg 	[63:0] 	o_rx_contr_tdata,
		.o_rx_contr_tlast(rx_contr_tlast), 						//	output reg 			o_rx_contr_tlast, 
		.o_rx_contr_tkeep(rx_contr_tkeep), 						//	output reg 	[7:0] 	o_rx_contr_tkeep, 
		.i_tx_contr_tvalid(tx_contr_tvalid),					//	input 				i_tx_contr_tvalid,
		.i_tx_contr_tdata(tx_contr_tdata),						//	input 		[63:0] 	i_tx_contr_tdata,
		.i_tx_contr_tlast(tx_contr_tlast), 						//	input 				i_tx_contr_tlast, 
		.i_tx_contr_tkeep(tx_contr_tkeep), 						//	input 		[7:0] 	i_tx_contr_tkeep, 
																//	/* AXI Stream */
		.i_axi_stream_clk(axi_stream_clk),						//	input 				i_axi_stream_clk,
		.i_tx_axis_tready(tx_axis_tready),						//	input 				i_tx_axis_tready,
		.o_tx_axis_tvalid(tx_axis_tvalid_bridge),      			//	output reg 			o_tx_axis_tvalid,      
		.o_tx_axis_tdata(tx_axis_tdata_bridge),					//	output reg 	[63:0] 	o_tx_axis_tdata,
		.o_tx_axis_tlast(tx_axis_tlast_bridge),       			//	output reg 			o_tx_axis_tlast,       
		.o_tx_axis_tkeep(tx_axis_tkeep_bridge),      			//	output reg 	[7:0] 	o_tx_axis_tkeep,      
		.o_tx_axis_tuser(tx_axis_tuser_bridge),      			//	output reg 	 	    o_tx_axis_tuser,      
		.i_rx_axis_tvalid(rx_axis_tvalid),       				//	input 				i_rx_axis_tvalid,       
		.i_rx_axis_tdata(rx_axis_tdata),						//	input 		[63:0] 	i_rx_axis_tdata,
		.i_rx_axis_tlast(rx_axis_tlast),        				//	input 				i_rx_axis_tlast,        
		.i_rx_axis_tkeep(rx_axis_tkeep),      					//	input 		[7:0] 	i_rx_axis_tkeep,      
		.i_rx_preambleout(rx_preambleout)						//	input 		[55:0] 	i_rx_preambleout
	);
	
endmodule