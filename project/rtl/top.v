module top(
           /* FIXED CLOCKS */ 			/* SOURCE - U69 SI5341B Clock Generator */
    input     i_clk_74_25_P,                //    74.25 MHz    SCHEMATIC - CLK_74_25_P    I/O - LVDS_25    PIN - AK15
    input     i_clk_74_25_N,                //    74.25 MHz    SCHEMATIC - CLK_74_25_N    I/O - LVDS_25    PIN - AK14
   
    input     i_reset,                      //    SCHEMATIC - CPU_RESET    I/O - LVCMOS33    PIN - AM13
    
            /* IO */
    input     [4:0]  i_push_btn,            //    SCHEMATIC - GPIO_SW_N(E, W, S, C)    I/O - LVCMOS33
                                            //    PIN - [AG15, AE14, AF15, AE15, AG13]
    input     [7:0]  i_DIP_sw,              //    SCHEMATIC - GPIO_DIP_SW0(..7)        I/O - LVCMOS33
                                            //    PIN - [AN14, AP14, AM14, AN13, AN12, AP12, AL13, AK13]
    output    [7:0]  o_led,                 //    SCHEMATIC - GPIO_LED_0(..7)          I/O - LVCMOS33
    
           /* ETHERNET 10G (P2 SFP+ Module Quad-Connector) */
    input     i_clk_156_25_P,               // Board Pin - AL8  I/O - DIFF_SSTL12             
    input     i_clk_156_25_N,               // Board Pin - AL7  I/O - DIFF_SSTL12
        /* Left low (SFP3) */
    output    o_ll_tx_p,                    // Board Pin - A8     Board SCHEMATIC - SFP3_TX_P 
                                            // PHY Pin - LL18     PHY SCHEMATIC - LL_TD_P
    output    o_ll_tx_n,                    // Board Pin - A7     Board SCHEMATIC - SFP3_TX_N 
                                            // PHY Pin - LL19     PHY SCHEMATIC - LL_TD_N
    input     i_ll_rx_p,                    // Board Pin - A4     Board SCHEMATIC - SFP3_RX_P 
                                            // PHY Pin - LL13     PHY SCHEMATIC - LL_RD_P
    input     i_ll_rx_n,                    // Board Pin - A3     Board SCHEMATIC - SFP3_RX_N 
                                            // PHY Pin - LL12     PHY SCHEMATIC - LL_RD_N
    output    o_ll_tx_disable               // Board Pin - C13    Board SCHEMATIC - SFP3_TX_DISABLE     I/O - LVCMOS33
                                            // PHY Pin - LL3      PHY SCHEMATIC - LL_TX_DISABLE
);
    /* SETUP */
    wire clk_156_25;
    wire clk_125;
    wire pll_locked;
    clock_generator clock_generator_inst(
        .i_reset(i_reset),              //  input   i_reset,
        .i_clk_74_25_P(i_clk_74_25_P),  //  input   i_clk_74_25_P,
        .i_clk_74_25_N(i_clk_74_25_N),  //  input   i_clk_74_25_N,
                                        //  
        .o_clk_125(clk_125),            //  output  o_clk_74_25,  
        .o_clk_156_25(clk_156_25),      //  output  o_clk_156_25,
        .o_pll_locked(pll_locked)       //  output  o_pll_locked
    );
    
    wire global_reset;
    wire await_init;
    reset_init_block reset_init_block_inst(
        .i_slowest_clk(clk_125),             //  input       i_slowest_clk,        
        .i_reset_trigger(i_reset),           //  input       i_reset_trigger,      
        .i_pll_locked(pll_locked),           //  input       i_pll_locked,      
        .o_reset(global_reset),              //  output reg  o_reset,              
        .o_await_initialization(await_init)  //  output reg  o_await_initialization
    );
    /* SETUP */
    
    /* MAIN ALGORITHM */
    wire          ila_tx_clk_out;    
    wire          ila_tx_axis_tvalid;
    wire  [63:0]  ila_tx_axis_tdata; 
    wire          ila_tx_axis_tlast; 
    wire  [7:0]   ila_tx_axis_tkeep; 
    wire          ila_tx_axis_tuser; 
    wire          ila_rx_axis_tvalid;
    wire  [63:0]  ila_rx_axis_tdata; 
    wire          ila_rx_axis_tlast; 
    wire  [7:0]   ila_rx_axis_tkeep; 
    wire          ila_rx_axis_tuser; 
    wire  [55:0]  ila_rx_preambleout; 
    wire          ila_transmit_fake_flag;
    
    wire          ila_rx_crx_contr_tvalid;      
    wire  [63:0]  ila_rx_contr_tdata;     
    wire          ila_rx_crx_contr_tlast; 
    wire  [7:0]   ila_rx_contr_tkeep;     
    wire          ila_tx_ctx_contr_tvalid;
    wire  [63:0]  ila_tx_contr_tdata;     
    wire          ila_tx_ctx_contr_tlast; 
    wire  [7:0]   ila_tx_contr_tkeep;      
    wire  [42*8-1:0] ila_data_head;      
    wire  [48*8-1:0] ila_transmit_data_head;
    
    wire              ila_payload_transmit_start;    
                                     
    wire [63:0]       ila_payload_fifo_din;
    wire              ila_payload_fifo_empty;       
    wire              ila_payload_fifo_wr_en;       
    wire              ila_payload_fifo_rd_en;       
    wire [63:0]       ila_payload_fifo_dout;        
    wire              ila_payload_fifo_full;        
    wire [3:0]        ila_payload_fifo_data_count;  
                                 
    wire [7:0]        ila_payload_keep_fifo_din;       
    wire              ila_payload_keep_fifo_wr_en;         
    wire              ila_payload_keep_fifo_rd_en;         
    wire [7:0]        ila_payload_keep_fifo_dout;      
    wire              ila_payload_keep_fifo_full;          
    wire              ila_payload_keep_fifo_empty;         
    wire [3:0]        ila_payload_keep_fifo_data_count; 
    
    wire ila_rd_en_axis_tx_64;          
    wire [63:0] ila_dout_axis_tx_64;    
    wire ila_full_axis_tx_64;           
    wire ila_empty_axis_tx_64;          
    wire ila_wr_rst_busy_axis_tx_64;    
    wire ila_rd_rst_busy_axis_tx_64;    
    wire [7:0] ila_dout_axis_tx_8;      
    wire ila_full_axis_tx_8;         
    wire ila_empty_axis_tx_8;        
    wire ila_wr_rst_busy_axis_tx_8;  
    wire ila_rd_rst_busy_axis_tx_8;  
    wire ila_rd_en_contr_rx_64;      
    wire [63:0] ila_dout_contr_rx_64;
    wire ila_full_contr_rx_64;      
    wire ila_empty_contr_rx_64;      
    wire ila_wr_rst_busy_contr_rx_64;
    wire ila_rd_rst_busy_contr_rx_64;
    wire [7:0] ila_dout_contr_rx_8;  
    wire ila_full_contr_rx_8;        
    wire ila_empty_contr_rx_8;       
    wire ila_wr_rst_busy_contr_rx_8; 
    wire ila_rd_rst_busy_contr_rx_8;  
    
    wire ila_stat_tx_frame_error;
    wire ila_stat_tx_packet_small;
    wire ila_stat_tx_bad_fcs;
    wire ila_stat_tx_fifo_error;  
    wire ila_stat_tx_local_fault; 
    wire ila_stat_tx_bad_parity;  
    
    wire ila_icmp_valid;    
    wire [20:0] ila_icmp_crc_part1;
    wire [15:0] ila_icmp_crc;       
    wire ila_icmp_crc_ready; 
    
    ethernet #(48'h211abcdef112, 32'hC0000186, 16'h0000) ethernet_inst(
       .i_clk_156_25(clk_156_25),                       //  input   i_clk_156_25,
       .i_clk_125(clk_125),                             //  input   i_clk_125,
       .i_clk_156_25_P(i_clk_156_25_P),                 //  input   i_clk_156_25,
       .i_clk_156_25_N(i_clk_156_25_N),                 //  input   i_clk_156_25,
       .i_reset(global_reset),                          //  input   i_reset,
       .i_await_init(await_init),                       //  input   i_await_init,
       .o_ll_tx_p(o_ll_tx_p),                           //  output  o_ll_tx_p,
       .o_ll_tx_n(o_ll_tx_n),                           //  output  o_ll_tx_n,
       .i_ll_rx_p(i_ll_rx_p),                           //  input   i_ll_rx_p,
       .i_ll_rx_n(i_ll_rx_n),                           //  input   i_ll_rx_n,
       .o_ll_tx_disable(o_ll_tx_disable),               //  output  o_ll_tx_disable
       
       .ila_tx_clk_out(ila_tx_clk_out),                 //   output          ila_tx_clk_out,    
       .ila_tx_axis_tvalid(ila_tx_axis_tvalid),         //   output          ila_tx_axis_tvalid,
       .ila_tx_axis_tdata(ila_tx_axis_tdata),           //   output  [63:0]  ila_tx_axis_tdata, 
       .ila_tx_axis_tlast(ila_tx_axis_tlast),           //   output          ila_tx_axis_tlast, 
       .ila_tx_axis_tkeep(ila_tx_axis_tkeep),           //   output  [7:0]   ila_tx_axis_tkeep, 
       .ila_tx_axis_tuser(ila_tx_axis_tuser),           //   output          ila_tx_axis_tuser, 
       .ila_rx_axis_tvalid(ila_rx_axis_tvalid),         //   output          ila_rx_axis_tvalid,
       .ila_rx_axis_tdata(ila_rx_axis_tdata),           //   output  [63:0]  ila_rx_axis_tdata, 
       .ila_rx_axis_tlast(ila_rx_axis_tlast),           //   output          ila_rx_axis_tlast, 
       .ila_rx_axis_tkeep(ila_rx_axis_tkeep),           //   output  [7:0]   ila_rx_axis_tkeep, 
       .ila_rx_axis_tuser(ila_rx_axis_tuser),           //   output          ila_rx_axis_tuser, 
       .ila_rx_preambleout(ila_rx_preambleout),         //   output  [55:0]  ila_rx_preambleout 
       .ila_transmit_fake_flag(ila_transmit_fake_flag), //   output   ila_transmit_fake_flag 
       
       .ila_rx_crx_contr_tvalid(ila_rx_crx_contr_tvalid),   //   output 		 ila_rx_crx_contr_tvalid,      
       .ila_rx_contr_tdata(ila_rx_contr_tdata),             //   output  [63:0]  ila_rx_contr_tdata,     
       .ila_rx_crx_contr_tlast(ila_rx_crx_contr_tlast),     //   output          ila_rx_crx_contr_tlast, 
       .ila_rx_contr_tkeep(ila_rx_contr_tkeep),             //   output  [7:0]   ila_rx_contr_tkeep,     
       .ila_tx_ctx_contr_tvalid(ila_tx_ctx_contr_tvalid),   //   output          ila_tx_ctx_contr_tvalid,
       .ila_tx_contr_tdata(ila_tx_contr_tdata),             //   output  [63:0]  ila_tx_contr_tdata,     
       .ila_tx_ctx_contr_tlast(ila_tx_ctx_contr_tlast),     //   output          ila_tx_ctx_contr_tlast, 
       .ila_tx_contr_tkeep(ila_tx_contr_tkeep),             //   output  [7:0]   ila_tx_contr_tkeep            
                                                            //                                            
       .ila_data_head(ila_data_head),                       //   output [42*8-1:0] ila_data_head                                                     
       .ila_transmit_data_head(ila_transmit_data_head),     //   output [48*8-1:0] ila_transmit_data_head    
             
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
       .ila_payload_keep_fifo_din(ila_payload_keep_fifo_din),               //  output [7:0]        ila_payload_keep_fifo_din,      
       .ila_payload_keep_fifo_wr_en(ila_payload_keep_fifo_wr_en),           //  output              ila_payload_keep_fifo_wr_en,    
       .ila_payload_keep_fifo_rd_en(ila_payload_keep_fifo_rd_en),           //  output              ila_payload_keep_fifo_rd_en,    
       .ila_payload_keep_fifo_dout(ila_payload_keep_fifo_dout),             //  output [7:0]        ila_payload_keep_fifo_dout,     
       .ila_payload_keep_fifo_full(ila_payload_keep_fifo_full),             //  output              ila_payload_keep_fifo_full,     
       .ila_payload_keep_fifo_empty(ila_payload_keep_fifo_empty),           //  output              ila_payload_keep_fifo_empty,    
       .ila_payload_keep_fifo_data_count(ila_payload_keep_fifo_data_count), //  output [3:0]        ila_payload_keep_fifo_data_count  
       
       .ila_rd_en_axis_tx_64(ila_rd_en_axis_tx_64),                 //  output ila_rd_en_axis_tx_64,          
       .ila_dout_axis_tx_64(ila_dout_axis_tx_64),                   //  output [63:0] ila_dout_axis_tx_64, 
       .ila_full_axis_tx_64(ila_full_axis_tx_64),                   //  output ila_full_axis_tx_64,        
       .ila_empty_axis_tx_64(ila_empty_axis_tx_64),                 //  output ila_empty_axis_tx_64,       
       .ila_wr_rst_busy_axis_tx_64(ila_wr_rst_busy_axis_tx_64),     //  output ila_wr_rst_busy_axis_tx_64, 
       .ila_rd_rst_busy_axis_tx_64(ila_rd_rst_busy_axis_tx_64),     //  output ila_rd_rst_busy_axis_tx_64, 
       .ila_rd_en_contr_rx_64(ila_rd_en_contr_rx_64),               //  output ila_rd_en_contr_rx_64,      
       .ila_dout_contr_rx_64(ila_dout_contr_rx_64),                 //  output [63:0] ila_dout_contr_rx_64,
       .ila_full_contr_rx_64(ila_full_contr_rx_64),                 //  output ila_full_contr_rx_64,       
       .ila_empty_contr_rx_64(ila_empty_contr_rx_64),               //  output ila_empty_contr_rx_64,      
       .ila_wr_rst_busy_contr_rx_64(ila_wr_rst_busy_contr_rx_64),   //  output ila_wr_rst_busy_contr_rx_64,
       .ila_rd_rst_busy_contr_rx_64(ila_rd_rst_busy_contr_rx_64),   //  output ila_rd_rst_busy_contr_rx_64     
       
       .ila_stat_tx_frame_error(ila_stat_tx_frame_error),           //   output ila_stat_tx_frame_error,
       .ila_stat_tx_packet_small(ila_stat_tx_packet_small),         //   output ila_stat_tx_packet_small,
       .ila_stat_tx_bad_fcs(ila_stat_tx_bad_fcs),                   //   output ila_stat_tx_bad_fcs,
       .ila_stat_tx_fifo_error(ila_stat_tx_fifo_error),             //   output ila_stat_tx_fifo_error,
       .ila_stat_tx_local_fault(ila_stat_tx_local_fault),           //   output ila_stat_tx_local_fault,
       .ila_stat_tx_bad_parity(ila_stat_tx_bad_parity),             //   output ila_stat_tx_bad_parity         
       
       .ila_icmp_valid(ila_icmp_valid),            //  output ila_icmp_valid,    
       .ila_icmp_crc_part1(ila_icmp_crc_part1),    //  output ila_icmp_crc_part1,
       .ila_icmp_crc(ila_icmp_crc),                //  output ila_icmp_crc,      
       .ila_icmp_crc_ready(ila_icmp_crc_ready)     //  output ila_icmp_crc_ready                            
    );
    
    ila_ethernet ila_ethernet_inst(
        .clk(ila_tx_clk_out),
        
        .probe0(ila_tx_axis_tvalid),
        .probe1(ila_tx_axis_tdata),
        .probe2(ila_tx_axis_tlast),
        .probe3(ila_tx_axis_tkeep),
        .probe4(ila_tx_axis_tuser),
        .probe5(ila_rx_axis_tvalid),
        .probe6(ila_rx_axis_tdata),
        .probe7(ila_rx_axis_tlast),
        .probe8(ila_rx_axis_tkeep),
        .probe9(ila_rx_axis_tuser),
        .probe10(ila_rx_preambleout),
        .probe11(await_init),
        .probe12(global_reset),
        .probe13(ila_transmit_fake_flag),
        .probe14(i_reset),
        .probe15(ila_rx_crx_contr_tvalid),
        .probe16(ila_rx_contr_tdata),
        .probe17(ila_rx_crx_contr_tlast),
        .probe18(ila_rx_contr_tkeep),
        .probe19(ila_tx_ctx_contr_tvalid),
        .probe20(ila_tx_contr_tdata),
        .probe21(ila_tx_ctx_contr_tlast),
        .probe22(ila_tx_contr_tkeep),
        .probe23(ila_data_head),
        .probe24(ila_transmit_data_head),
        
        .probe25(ila_payload_transmit_start),
        .probe26(ila_payload_fifo_din),
        .probe27(ila_payload_fifo_empty),
        .probe28(ila_payload_fifo_wr_en),
        .probe29(ila_payload_fifo_rd_en),
        .probe30(ila_payload_fifo_dout),
        .probe31(ila_payload_fifo_full),
        .probe32(ila_payload_fifo_data_count),
        .probe33(ila_payload_keep_fifo_din),
        .probe34(ila_payload_keep_fifo_wr_en),
        .probe35(ila_payload_keep_fifo_rd_en),
        .probe36(ila_payload_keep_fifo_dout),
        .probe37(ila_payload_keep_fifo_full),
        .probe38(ila_payload_keep_fifo_empty),
        .probe39(ila_payload_keep_fifo_data_count),
        
        .probe40(ila_rd_en_axis_tx_64),         //  wire ila_rd_en_axis_tx_64;       
        .probe41(ila_dout_axis_tx_64),          //  wire [71:0] ila_dout_axis_tx_64; 
        .probe42(ila_full_axis_tx_64),          //  wire ila_full_axis_tx_64;        
        .probe43(ila_empty_axis_tx_64),         //  wire ila_empty_axis_tx_64;       
        .probe44(ila_wr_rst_busy_axis_tx_64),   //  wire ila_wr_rst_busy_axis_tx_64; 
        .probe45(ila_rd_rst_busy_axis_tx_64),   //  wire ila_rd_rst_busy_axis_tx_64; 
        .probe46(ila_rd_en_contr_rx_64),        //  wire ila_rd_en_contr_rx_64;      
        .probe47(ila_dout_contr_rx_64),         //  wire [71:0] ila_dout_contr_rx_64;
        .probe48(ila_full_contr_rx_64),         //  wire ila_full_contr_rx_64;       
        .probe49(ila_empty_contr_rx_64),        //  wire ila_empty_contr_rx_64;      
        .probe50(ila_wr_rst_busy_contr_rx_64),  //  wire ila_wr_rst_busy_contr_rx_64;
        .probe51(ila_rd_rst_busy_contr_rx_64),  //  wire ila_rd_rst_busy_contr_rx_64;
        
        .probe52(ila_stat_tx_frame_error),      //   output ila_stat_tx_frame_error, 
        .probe53(ila_stat_tx_packet_small),     //   output ila_stat_tx_packet_small,
        .probe54(ila_stat_tx_bad_fcs),          //   output ila_stat_tx_bad_fcs,     
        .probe55(ila_stat_tx_fifo_error),       //   output ila_stat_tx_fifo_error,  
        .probe56(ila_stat_tx_local_fault),      //   output ila_stat_tx_local_fault, 
        .probe57(ila_stat_tx_bad_parity),       //   output ila_stat_tx_bad_parity   
        
        .probe58(ila_icmp_valid),               //  output ila_icmp_valid,     
        .probe59(ila_icmp_crc_part1),           //  [20:0] output ila_icmp_crc_part1, 
        .probe60(ila_icmp_crc),                 //  [15:0] output ila_icmp_crc,       
        .probe61(ila_icmp_crc_ready)            //  output ila_icmp_crc_ready  
    );
    /*  MAIN ALGORITHM */
    
    /* OUTPUT */
    status_led_control status_led_control_inst(
        .i_clk(clk_125),
        .i_reset(global_reset),
        .i_push_btn(i_push_btn),
        .i_DIP_sw(i_DIP_sw),
        .o_led(o_led)
    );
    /* OUTPUT */
endmodule