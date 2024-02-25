module top(
           /* FIXED CLOCKS */ 			/* SOURCE - U69 SI5341B Clock Generator */
    input     i_CLK_74_25_P,                //    74.25 MHz    SCHEMATIC - CLK_74_25_P    I/O - LVDS_25    PIN - AK15
    input     i_CLK_74_25_N,                //    74.25 MHz    SCHEMATIC - CLK_74_25_N    I/O - LVDS_25    PIN - AK14
    input     i_CLK_125_P,                  //    125 MHz      SCHEMATIC - CLK_125_P      I/O - LVDS_25    PIN - G21
    input     i_CLK_125_N,                  //    125 MHz      SCHEMATIC - CLK_125_N      I/O - LVDS_25    PIN - F21
   
    input     i_reset,                      //    SCHEMATIC - CPU_RESET    I/O - LVCMOS33    PIN - AM13
    
            /* IO */
    input     [4:0]  i_push_btn,            //    SCHEMATIC - GPIO_SW_N(E, W, S, C)    I/O - LVCMOS33
                                            //    PIN - [AG15, AE14, AF15, AE15, AG13]
    input     [7:0]  i_DIP_sw,              //    SCHEMATIC - GPIO_DIP_SW0(..7)        I/O - LVCMOS33
                                            //    PIN - [AN14, AP14, AM14, AN13, AN12, AP12, AL13, AK13]
    output    [7:0]  o_led,                 //    SCHEMATIC - GPIO_LED_0(..7)          I/O - LVCMOS33
                                            //    PIN - [AG14, AF13, AE13, AJ14, AJ15, AH13, AH14, AL12]
    
    //          /* ETHERNET 1G */
    //    /* TX */
    //output           o_ethernet_tx_clock,   // Board Pin - A25  Board SCHEMATIC - MIO64_ENET_TX_CLK 
    //                                        // PHY Pin - 40     PHY SCHEMATIC - GTX_CLK
    //output    [3:0]  o_ethernet_tx_d,       // Board Pin - [A26, A27, B25, B26] Board SCHEMATIC - MIO65(6, 7, 8)_ENET_TX_D0(1, 2 ,3) 
    //                                        // PHY Pin   - [38, 37, 36, 35]     PHY SCHEMATIC - TX_DO(1, 2, 3)
    //output           o_ethernet_tx_ctrl,    // Board Pin - B27  Board SCHEMATIC - MIO69_ENET_TX_CTRL 
    //                                        // PHY Pin - 52     PHY SCHEMATIC - TX_EN_TX_CTRL
    //    /* RX */
    //input            i_ethernet_rx_clock,   // Board Pin - C26  Board SCHEMATIC - MIO70_ENET_RX_CLK 
    //                                        // PHY Pin - 43     PHY SCHEMATIC - RX_CLK
    //input     [3:0]  i_ethernet_rx_d,       // Board Pin - [C27, E25, H24, G25] Board SCHEMATIC - MIO71(2, 3, 4)_ENET_RX_D0(1, 2 ,3) 
    //                                        // PHY Pin   - [44, 45, 46, 47]     PHY SCHEMATIC - RX_DO(1, 2, 3)
    //input            i_ethernet_rx_ctrl,    // Board Pin - D25  Board SCHEMATIC - MIO75_ENET_RX_CTRL 
    //                                        // PHY Pin - 53     PHY SCHEMATIC - RX_DV_RX_CTRL
    //    /* RGMII */
    //output          o_ethernet_mdc,         // Board Pin - H25  Board SCHEMATIC - MIO76_ENET_MDC 
    //                                        // PHY Pin - 20     PHY SCHEMATIC - MDC
    //output          o_ethernet_mdio,        // Board Pin - F25  Board SCHEMATIC - MIO77_ENET_MDIO 
    //                                        // PHY Pin - 21     PHY SCHEMATIC - MDIO 
                           
            /* ETHERNET 10G (P2 SFP+ Module Quad-Connector) */
    input     i_CLK_156_25_P,                 // Board Pin - AL8  I/O - DIFF_SSTL12             
    input     i_CLK_156_25_N,                 // Board Pin - AL7  I/O - DIFF_SSTL12
    //    /* Right Top (SFP0) */
    //output    o_rt_tx_p,                    // Board Pin - E4     Board SCHEMATIC - SFP0_TX_P 
    //                                        // PHY Pin - RT18     PHY SCHEMATIC - RT_TD_P
    //output    o_rt_tx_n,                    // Board Pin - E3     Board SCHEMATIC - SFP0_TX_N 
    //                                        // PHY Pin - RT19     PHY SCHEMATIC - RT_TD_N
    //input     i_rt_rx_p,                    // Board Pin - D2     Board SCHEMATIC - SFP0_RX_P 
    //                                        // PHY Pin - RT13     PHY SCHEMATIC - RT_RD_P
    //input     i_rt_rx_n,                    // Board Pin - D1     Board SCHEMATIC - SFP0_RX_N 
    //                                        // PHY Pin - RT12     PHY SCHEMATIC - RT_RD_N
    //output    o_rt_tx_disable,              // Board Pin - A12    Board SCHEMATIC - SFP0_TX_DISABLE     I/O - LVCMOS33
    //                                        // PHY Pin - RT3      PHY SCHEMATIC - RT_TX_DISABLELK
    //    /* Right Low (SFP1) */
    //output    o_rl_tx_p,                    // Board Pin - D6     Board SCHEMATIC - SFP1_TX_P 
    //                                        // PHY Pin - RL18     PHY SCHEMATIC - RL_TD_P
    //output    o_rl_tx_n,                    // Board Pin - D5     Board SCHEMATIC - SFP1_TX_N 
    //                                        // PHY Pin - RL19     PHY SCHEMATIC - RL_TD_N
    //input     i_rl_rx_p,                    // Board Pin - C4     Board SCHEMATIC - SFP1_RX_P 
    //                                        // PHY Pin - RL13     PHY SCHEMATIC - RL_RD_P
    //input     i_rl_rx_n,                    // Board Pin - C3     Board SCHEMATIC - SFP1_RX_N 
    //                                        // PHY Pin - RL12     PHY SCHEMATIC - RL_RD_N
    //output    o_rl_tx_disable,              // Board Pin - A13    Board SCHEMATIC - SFP1_TX_DISABLE     I/O - LVCMOS33
    //                                        // PHY Pin - RL3      PHY SCHEMATIC - RL_TX_DISABLE
    //    /* Left top (SFP2) */
    //output    o_lt_tx_p,                    // Board Pin - B6     Board SCHEMATIC - SFP2_TX_P 
    //                                        // PHY Pin - LT18     PHY SCHEMATIC - LT_TD_P
    //output    o_lt_tx_n,                    // Board Pin - B5     Board SCHEMATIC - SFP2_TX_N 
    //                                        // PHY Pin - LT19     PHY SCHEMATIC - LT_TD_N
    //input     i_lt_rx_p,                    // Board Pin - B2     Board SCHEMATIC - SFP2_RX_P 
    //                                        // PHY Pin - LT13     PHY SCHEMATIC - LT_RD_P
    //input     i_lt_rx_n,                    // Board Pin - B1     Board SCHEMATIC - SFP2_RX_N 
    //                                        // PHY Pin - LT12     PHY SCHEMATIC - LT_RD_N
    //output    o_lt_tx_disable,              // Board Pin - B13    Board SCHEMATIC - SFP2_TX_DISABLE     I/O - LVCMOS33
    //                                        // PHY Pin - LT3      PHY SCHEMATIC - LT_TX_DISABLE
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
    wire CLK_74_25;
    wire CLK_125;
    clock_generator clock_generator_inst(
        .i_CLK_74_25_P(i_CLK_74_25_P),      //  input   i_CLK_74_25_P, 
        .i_CLK_74_25_N(i_CLK_74_25_N),      //  input   i_CLK_74_25_N, 
        .i_CLK_125_P(i_CLK_125_P),          //  input   i_CLK_125_P,   
        .i_CLK_125_N(i_CLK_125_N),          //  input   i_CLK_125_N,   
        .o_CLK_74_25(CLK_74_25),            //  output  o_CLK_74_25,   
        .o_CLK_125(CLK_125)                 //  output  o_CLK_125,
    );
    /* SETUP */
    
    /* MAIN ALGORITHM */
    ethernet ethernet_inst(
       .i_CLK_125(CLK_125),                 //  input   i_CLK_125,
       .i_CLK_156_25_P(i_CLK_156_25_P),     //  input   i_CLK_156_25,
       .i_CLK_156_25_N(i_CLK_156_25_N),     //  input   i_CLK_156_25,
       .i_reset(i_reset),                   //  input   i_reset,
       .o_ll_tx_p(o_ll_tx_p),               //  output  o_ll_tx_p,
       .o_ll_tx_n(o_ll_tx_n),               //  output  o_ll_tx_n,
       .i_ll_rx_p(i_ll_rx_p),               //  input   i_ll_rx_p,
       .i_ll_rx_n(i_ll_rx_n),               //  input   i_ll_rx_n,
       .o_ll_tx_disable(o_ll_tx_disable)    //  output  o_ll_tx_disable
    ); 
    /*  MAIN ALGORITHM */
   
    /* OUTPUT */
    status_led_control status_led_control_inst(
        .i_clk(CLK_74_25),
        .i_reset(global_reset),
        .i_push_btn(i_push_btn),
        .i_DIP_sw(i_DIP_sw),
        .o_led(o_led)
    );
    /* OUTPUT */
endmodule