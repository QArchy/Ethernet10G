`timescale 1ns / 1ps

module tb_ethernet_controller(
    output [42*8-1:0] ila_data_head,
    output [48*8-1:0] ila_transmit_data_head,
    output        ila_payload_transmit_start,     
                                         
    output [63:0]     ila_payload_fifo_din,      
    output            ila_payload_fifo_empty,       
    output            ila_payload_fifo_wr_en,       
    output            ila_payload_fifo_rd_en,       
    output [63:0]     ila_payload_fifo_dout,        
    output            ila_payload_fifo_full,        
    output [3:0]      ila_payload_fifo_data_count,  
                               
    output [7:0]      ila_payload_keep_fifo_din,       
    output            ila_payload_keep_fifo_wr_en,         
    output            ila_payload_keep_fifo_rd_en,         
    output [7:0]      ila_payload_keep_fifo_dout,      
    output            ila_payload_keep_fifo_full,          
    output            ila_payload_keep_fifo_empty,         
    output [3:0]      ila_payload_keep_fifo_data_count,
    
    output            ila_icmp_valid,    
    output [20:0]     ila_icmp_crc_part1,
    output [15:0]     ila_icmp_crc,      
    output            ila_icmp_crc_ready 
);
    reg clk; initial clk = 0; always #10 clk <= ~clk; 
    wire i_reset; assign i_reset = 0;
    
    wire            transmit_fake_flag;
    
    wire            tx_axis_tvalid_fake;
    wire    [63:0]  tx_axis_tdata_fake; 
    wire            tx_axis_tlast_fake; 
    wire    [7:0]   tx_axis_tkeep_fake; 
    
    ethernet_fake_transmitter ethernet_fake_transmitter_inst(
        .i_clk(clk),                                //  input                 i_clk,
        .i_reset(i_reset),                          //  input                 i_reset,
                                                    //  
        .o_transmit_fake_flag(transmit_fake_flag),  //  output reg            o_transmit_fake_flag,
                                                    //  
        .o_tx_axis_tvalid(tx_axis_tvalid_fake),     //  output reg            o_tx_axis_tvalid,
        .o_tx_axis_tdata(tx_axis_tdata_fake),       //  output reg    [63:0]  o_tx_axis_tdata,
        .o_tx_axis_tlast(tx_axis_tlast_fake),       //  output reg            o_tx_axis_tlast, 
        .o_tx_axis_tkeep(tx_axis_tkeep_fake)        //  output reg    [7:0]   o_tx_axis_tkeep 
    );
           
    wire 		rx_contr_tvalid = tx_axis_tvalid_fake;
	wire [63:0]	rx_contr_tdata  = tx_axis_tdata_fake; 
	wire 		rx_contr_tlast  = tx_axis_tlast_fake; 
	wire [7:0]	rx_contr_tkeep  = tx_axis_tkeep_fake; 
	wire 		tx_contr_tvalid;
	wire [63:0]	tx_contr_tdata;
	wire 		tx_contr_tlast;
	wire [7:0]	tx_contr_tkeep;
    
    ethernet_controller #(48'h211abcdef112, 32'hC0000186, 16'h0000) ethernet_controller_inst(
		.i_clk(clk),				        //	input 			i_clk,
		.i_reset(i_reset),	                //	input 			i_reset,
											//	
		.rx_axis_tvalid(rx_contr_tvalid),	//	input 			rx_axis_tvalid,
		.rx_axis_tdata(rx_contr_tdata), 	//	input [63:0]	rx_axis_tdata, 
		.rx_axis_tlast(rx_contr_tlast), 	//	input 			rx_axis_tlast, 
		.rx_axis_tkeep(rx_contr_tkeep),		//	input [7:0]		rx_axis_tkeep,
											//	
		.tx_axis_tvalid(tx_contr_tvalid),	//	output 			tx_axis_tvalid,
		.tx_axis_tdata(tx_contr_tdata), 	//	output [63:0]	tx_axis_tdata, 
		.tx_axis_tlast(tx_contr_tlast), 	//	output 			tx_axis_tlast, 
		.tx_axis_tkeep(tx_contr_tkeep),		//	output [7:0]	tx_axis_tkeep,
		                                    //	
		.ila_data_head(ila_data_head),       //  output [42*8-1:0] ila_data_head
		.ila_transmit_data_head(ila_transmit_data_head),                //  output [48*8-1:0] ila_transmit_data_head
		.ila_payload_transmit_start(ila_payload_transmit_start),        //  output              ila_payload_transmit_start,        
                                                                        //                                                      
        .ila_payload_fifo_din(ila_payload_fifo_din),                    //  output [63:0]       ila_payload_fifo_din,           
        .ila_payload_fifo_empty(ila_payload_fifo_empty),                //  output              ila_payload_fifo_empty,         
        .ila_payload_fifo_wr_en(ila_payload_fifo_wr_en),                //  output              ila_payload_fifo_wr_en,         
        .ila_payload_fifo_rd_en(ila_payload_fifo_rd_en),                //  output              ila_payload_fifo_rd_en,         
        .ila_payload_fifo_dout(ila_payload_fifo_dout),                  //  output [63:0]       ila_payload_fifo_dout,          
        .ila_payload_fifo_full(ila_payload_fifo_full),                  //  output              ila_payload_fifo_full,          
        .ila_payload_fifo_data_count(ila_payload_fifo_data_count),      //  output [3:0]        ila_payload_fifo_data_count,    
                                                                        //                                                      
        .ila_payload_keep_fifo_din(ila_payload_keep_fifo_din),              //  output [7:0]        ila_payload_keep_fifo_din,      
        .ila_payload_keep_fifo_wr_en(ila_payload_keep_fifo_wr_en),          //  output              ila_payload_keep_fifo_wr_en,    
        .ila_payload_keep_fifo_rd_en(ila_payload_keep_fifo_rd_en),          //  output              ila_payload_keep_fifo_rd_en,    
        .ila_payload_keep_fifo_dout(ila_payload_keep_fifo_dout),            //  output [7:0]        ila_payload_keep_fifo_dout,     
        .ila_payload_keep_fifo_full(ila_payload_keep_fifo_full),            //  output              ila_payload_keep_fifo_full,     
        .ila_payload_keep_fifo_empty(ila_payload_keep_fifo_empty),          //  output              ila_payload_keep_fifo_empty,    
        .ila_payload_keep_fifo_data_count(ila_payload_keep_fifo_data_count),//  output [3:0]        ila_payload_keep_fifo_data_count
        
        .ila_icmp_valid(ila_icmp_valid),            //  output ila_icmp_valid,    
        .ila_icmp_crc_part1(ila_icmp_crc_part1),    //  output ila_icmp_crc_part1,
        .ila_icmp_crc(ila_icmp_crc),                //  output ila_icmp_crc,      
        .ila_icmp_crc_ready(ila_icmp_crc_ready)     //  output ila_icmp_crc_ready 
	);
    
endmodule
