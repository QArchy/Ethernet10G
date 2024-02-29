module test_top();
	reg 	i_clk; 		initial i_clk <= 0; 	always 	#10 i_clk <= ~i_clk;
	
	reg 	i_reset; 	initial i_reset <= 0;	always 	#1000000 i_reset <= ~i_reset;
	
	wire 		rx_axis_tvalid;
	wire [63:0]	rx_axis_tdata; 
	wire 		rx_axis_tlast; 
	wire [7:0]	rx_axis_tkeep;  
	
	tb_ethernet_fake_transmitter tb_ethernet_fake_transmitter_inst(
		.i_clk(i_clk),         				//	input 				i_clk,	
		.i_reset(i_reset),     				//	input 				i_reset,
											//	
		.o_tx_axis_tvalid(rx_axis_tvalid),	//	output reg			o_tx_axis_tvalid,	
		.o_tx_axis_tdata(rx_axis_tdata),    //	output reg	[63:0] 	o_tx_axis_tdata,	
		.o_tx_axis_tlast(rx_axis_tlast),    //	output reg			o_tx_axis_tlast, 	
		.o_tx_axis_tkeep(rx_axis_tkeep)     //	output reg	[7:0] 	o_tx_axis_tkeep 	
	);				
	
	tb_ethernet_top #(48'h211abcdef112, 32'hC0000186) tb_ethernet_top_inst(
		.i_clk(i_clk),						//	input 			i_clk,
		.i_reset(i_reset),					//	input 			i_reset
											//	
		.rx_axis_tvalid(rx_axis_tvalid),	//	input 			rx_axis_tvalid;
		.rx_axis_tdata(rx_axis_tdata),		//	input [63:0]	rx_axis_tdata; 
		.rx_axis_tlast(rx_axis_tlast), 		//	input 			rx_axis_tlast; 
		.rx_axis_tkeep(rx_axis_tkeep)  		//	input [7:0]		rx_axis_tkeep;  
	);
	
endmodule