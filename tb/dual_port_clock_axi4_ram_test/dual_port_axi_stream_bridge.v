module dual_port_axi_stream_bridge(
	/* System */
	input 				i_reset,
	/* Ethernet controller */
	input 				i_ethernet_controller_clk,
	output reg 			o_rx_contr_tvalid,
	output reg 	[63:0] 	o_rx_contr_tdata,
	output reg 			o_rx_contr_tlast, 
	output reg 	[7:0] 	o_rx_contr_tkeep, 
	input 				i_tx_contr_tvalid,
	input 		[63:0] 	i_tx_contr_tdata,
	input 				i_tx_contr_tlast, 
	input 		[7:0] 	i_tx_contr_tkeep, 
	/* AXI Stream */
	input 				i_axi_stream_clk,
	input 				i_tx_axis_tready,
	output reg 			o_tx_axis_tvalid,      
	output reg 	[63:0] 	o_tx_axis_tdata,
	output reg 			o_tx_axis_tlast,       
	output reg 	[7:0] 	o_tx_axis_tkeep,      
	output reg 	 	    o_tx_axis_tuser,      
	input 				i_rx_axis_tvalid,       
	input 		[63:0] 	i_rx_axis_tdata,
	input 				i_rx_axis_tlast,        
	input 		[7:0] 	i_rx_axis_tkeep,      
	input 		[55:0] 	i_rx_preambleout
);
	initial begin
		o_tx_axis_tvalid	<= 0;
		o_tx_axis_tdata		<= 0;
		o_tx_axis_tlast		<= 0;
		o_tx_axis_tkeep		<= 0;
		o_rx_contr_tvalid	<= 0;
		o_rx_contr_tdata	<= 0;
		o_rx_contr_tlast	<= 0;
		o_rx_contr_tkeep	<= 0;
	end
	
	reg 	[6:0] 	addra;
	reg 	[6:0] 	addrb;
	wire 		 	wea = i_tx_contr_tvalid;
	wire 		 	web = i_rx_axis_tvalid;
	wire 	[63:0] 	douta;
	wire 	[63:0] 	doutb;
	
	initial begin
		addra <= 0;
		addrb <= 0;
	end
	
	reg i_rx_axis_tvalid_prev;
	reg enable_read_A;
	reg i_tx_contr_tvalid_prev;
	reg enable_read_B;
	
	initial begin
		enable_read_A <= 0;
		enable_read_B <= 0;
	end
	
	reg [10:0] data_counter_A;
	reg [10:0] data_counter_B;
	
	ethernet_controller_to_axi_mem ethernet_controller_to_axi_mem_inst(
		.clka(i_ethernet_controller_clk),	//	input 			clka,  // ETHERNET_CONTROLLER
		.wea(wea),							//	input 			wea,   // ETHERNET_CONTROLLER
		.addra(addra),						//	input 	[6:0] 	addra, // ETHERNET_CONTROLLER
		.dina(i_tx_contr_tdata),			//	input 	[63:0] 	dina,  // ETHERNET_CONTROLLER
		.douta(douta),						//	output 	[63:0] 	douta, // ETHERNET_CONTROLLER
		.clkb(i_axi_stream_clk),			//	input 			clkb,  // AXI4
		.web(web),							//	input 			web,   // AXI4
		.addrb(addrb),						//	input 	[6:0] 	addrb, // AXI4
		.dinb(i_rx_axis_tdata),				//	input 	[63:0] 	dinb,  // AXI4
		.doutb(doutb)						//	output 	[63:0] 	doutb  // AXI4
	);
	
	always @(posedge i_ethernet_controller_clk, posedge i_reset) begin	// PORT A
		if (i_reset) begin
			o_rx_contr_tvalid	<= 0;
			o_rx_contr_tdata	<= 0;
			o_rx_contr_tlast	<= 0;
			o_rx_contr_tkeep	<= 0;
			addra				<= 0;
		end else begin
			enable_read_B <= i_tx_contr_tvalid;
			
			if (enable_read_A) begin
				addra 				<= addra + 1;
				o_rx_contr_tvalid	<= 1;
				o_rx_contr_tdata	<= douta;
				o_rx_contr_tlast	<= o_tx_axis_tvalid ? 0: 1;
				o_rx_contr_tkeep	<= 8'hFF;
			end else begin
				o_rx_contr_tvalid	<= 0;
				o_rx_contr_tdata	<= 0;
				o_rx_contr_tlast	<= 0;
				o_rx_contr_tkeep	<= 0;
			end
		end
	end
	
	always @(posedge i_axi_stream_clk, posedge i_reset) begin	// PORT B
		if (i_reset) begin
			o_tx_axis_tvalid	<= 0;
			o_tx_axis_tdata		<= 0;
			o_tx_axis_tlast		<= 0;
			o_tx_axis_tkeep		<= 0;
			o_tx_axis_tuser		<= 0;
			addrb				<= 0;
			enable_read_A		<= 0;
		end else begin
		    i_rx_axis_tvalid_prev <= i_rx_axis_tvalid;
		    
			enable_read_A <= (~i_rx_axis_tvalid_prev && i_rx_axis_tvalid) ? 1: (data_counter_A == 0) ? 0 : enable_read_A;
			data_counter_A <= i_rx_axis_tvalid ? (data_counter_A + 1) : data_counter_A;
			
			if (enable_read_B) begin
				addrb 				<= addrb + 1;
				o_tx_axis_tvalid	<= 1;
				o_tx_axis_tdata		<= doutb;
				o_tx_axis_tlast		<= i_tx_contr_tvalid ? 0: 1;
				o_tx_axis_tkeep		<= 8'hFF;
				o_tx_axis_tuser		<= 0;
			end else begin
				o_tx_axis_tvalid	<= 0;
				o_tx_axis_tdata		<= 0;
				o_tx_axis_tlast		<= 0;
				o_tx_axis_tkeep		<= 0;
				o_tx_axis_tuser		<= 0;
			end
		end
	end
	
endmodule