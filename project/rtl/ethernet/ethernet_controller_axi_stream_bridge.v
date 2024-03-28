module ethernet_controller_axi_stream_bridge(
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
	input 		[55:0] 	i_rx_preambleout,
	
	output ila_rd_en_axis_tx_64,
	output [71:0] ila_dout_axis_tx_64,
	output ila_full_axis_tx_64,
	output ila_empty_axis_tx_64,
	output ila_wr_rst_busy_axis_tx_64,
	output ila_rd_rst_busy_axis_tx_64,
	output ila_rd_en_contr_rx_64,      
    output [71:0] ila_dout_contr_rx_64,       
    output ila_full_contr_rx_64,       
    output ila_empty_contr_rx_64,      
    output ila_wr_rst_busy_contr_rx_64,
    output ila_rd_rst_busy_contr_rx_64
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
	
	reg            fifo_tx_rd_en;          assign ila_rd_en_axis_tx_64         = fifo_tx_rd_en;      
	wire   [71:0]  fifo_tx_dout;           assign ila_dout_axis_tx_64          = fifo_tx_dout;       
	wire           fifo_tx_full;           assign ila_full_axis_tx_64          = fifo_tx_full;       
	wire           fifo_tx_empty;          assign ila_empty_axis_tx_64         = fifo_tx_empty;      
	wire           fifo_tx_wr_rst_busy;    assign ila_wr_rst_busy_axis_tx_64   = fifo_tx_wr_rst_busy;
	wire           fifo_tx_rd_rst_busy;    assign ila_rd_rst_busy_axis_tx_64   = fifo_tx_rd_rst_busy;
	fifo_72_72 fifo_72_72_tx( // controller to axis
        .srst(i_reset),                             //  input           srst,
        .wr_clk(i_ethernet_controller_clk),         //  input           wr_clk,
        .rd_clk(i_axi_stream_clk),                  //  input           rd_clk,
        .din({i_tx_contr_tdata, i_tx_contr_tkeep}), //  input   [71:0]  din,
        .wr_en(i_tx_contr_tvalid),                  //  input           wr_en,
        .rd_en(~fifo_tx_empty),                     //  input           rd_en,
        .dout(fifo_tx_dout),                        //  output  [71:0]  dout,
        .full(fifo_tx_full),                        //  output          full,
        .empty(fifo_tx_empty),                      //  output          empty,
        .wr_rst_busy(fifo_tx_wr_rst_busy),          //  output          wr_rst_busy,
        .rd_rst_busy(fifo_tx_rd_rst_busy)           //  output          rd_rst_busy
    );
    
    always @(posedge i_axi_stream_clk, posedge i_reset) begin
        if (i_reset) begin
            o_tx_axis_tvalid    <= 0;
            o_tx_axis_tdata     <= 0;
            o_tx_axis_tlast     <= 0;
            o_tx_axis_tkeep     <= 0;
            o_tx_axis_tuser     <= 0;
        end else begin
            fifo_tx_rd_en <= ~fifo_tx_empty;
            
            if (fifo_tx_rd_en && fifo_tx_empty) begin
                o_tx_axis_tvalid  <= 1;                
                o_tx_axis_tdata   <= fifo_tx_dout[71:8];  
                o_tx_axis_tlast   <= 1;                
                o_tx_axis_tkeep   <= fifo_tx_dout[7:0];   
                o_tx_axis_tuser   <= 0;
            end else if (fifo_tx_rd_en) begin
                o_tx_axis_tvalid  <= 1;    
                o_tx_axis_tdata   <= fifo_tx_dout[71:8];
                o_tx_axis_tlast   <= 0;     
                o_tx_axis_tkeep   <= fifo_tx_dout[7:0];
                o_tx_axis_tuser   <= 0;                
            end else begin
                o_tx_axis_tvalid  <= 0;               
                o_tx_axis_tdata   <= 0; 
                o_tx_axis_tlast   <= 0;               
                o_tx_axis_tkeep   <= 0;  
                o_tx_axis_tuser   <= 0;       
            end
        end
    end
   
    reg            fifo_rx_rd_en;          assign ila_rd_en_contr_rx_64         = fifo_rx_rd_en;      
    wire   [71:0]  fifo_rx_dout;           assign ila_dout_contr_rx_64          = fifo_rx_dout;       
    wire           fifo_rx_full;           assign ila_full_contr_rx_64          = fifo_rx_full;       
    wire           fifo_rx_empty;          assign ila_empty_contr_rx_64         = fifo_rx_empty;      
    wire           fifo_rx_wr_rst_busy;    assign ila_wr_rst_busy_contr_rx_64   = fifo_rx_wr_rst_busy;
    wire           fifo_rx_rd_rst_busy;    assign ila_rd_rst_busy_contr_rx_64   = fifo_rx_rd_rst_busy;
    fifo_72_72 fifo_72_72_rx( // controller to axis
        .srst(i_reset),                             //  input           srst,
        .wr_clk(i_axi_stream_clk),                  //  input           wr_clk,
        .rd_clk(i_ethernet_controller_clk),         //  input           rd_clk,
        .din({i_rx_axis_tdata, i_rx_axis_tkeep}),   //  input   [71:0]  din,
        .wr_en(i_rx_axis_tvalid),                   //  input           wr_en,
        .rd_en(~fifo_rx_empty),                     //  input           rd_en,
        .dout(fifo_rx_dout),                        //  output  [71:0]  dout,
        .full(fifo_rx_full),                        //  output          full,
        .empty(fifo_rx_empty),                      //  output          empty,
        .wr_rst_busy(fifo_rx_wr_rst_busy),          //  output          wr_rst_busy,
        .rd_rst_busy(fifo_rx_rd_rst_busy)           //  output          rd_rst_busy
    );
	
	always @(posedge i_ethernet_controller_clk, posedge i_reset) begin
		if (i_reset) begin
			o_rx_contr_tvalid	<= 0;
			o_rx_contr_tdata	<= 0;
			o_rx_contr_tlast	<= 0;
			o_rx_contr_tkeep	<= 0;
		end else begin
		    fifo_rx_rd_en <= ~fifo_rx_empty;
            
            if (fifo_rx_rd_en && fifo_rx_empty) begin
                o_rx_contr_tvalid  <= 1;                
                o_rx_contr_tdata   <= fifo_rx_dout[71:8];  
                o_rx_contr_tlast   <= 1;                
                o_rx_contr_tkeep   <= fifo_rx_dout[7:0]; 
            end else if (fifo_rx_rd_en) begin
                o_rx_contr_tvalid  <= 1;    
                o_rx_contr_tdata   <= fifo_rx_dout[71:8];
                o_rx_contr_tlast   <= 0;     
                o_rx_contr_tkeep   <= fifo_rx_dout[7:0];            
            end else begin
                o_rx_contr_tvalid  <= 0;               
                o_rx_contr_tdata   <= 0; 
                o_rx_contr_tlast   <= 0;               
                o_rx_contr_tkeep   <= 0;       
            end
		end
	end
	
endmodule