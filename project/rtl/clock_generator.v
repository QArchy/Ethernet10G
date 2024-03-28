module clock_generator(
    input   i_reset,
    input   i_clk_74_25_P,
    input   i_clk_74_25_N,  
    
    output  o_clk_156_25,
    output  o_clk_125,
    output  o_pll_locked
);
    wire buffered_clk_74_25;
    IBUFGDS #(.IOSTANDARD ("LVDS_25"), .DIFF_TERM("FALSE")) IBUFDS_clk_74_25 (          
        .O(buffered_clk_74_25), // Buffer output                                           
        .I(i_clk_74_25_P),      // Diff_p buffer input (connect directly to top-level port)
        .IB(i_clk_74_25_N)      // Diff_n buffer input (connect directly to top-level port)
    ); 
    
    wire pll_74_25_locked;
    pll_74_25_clk pll_74_25_clk_inst(
                                        //  // Clock out ports
        .clk_out_125(o_clk_125),        //  output        clk_out_74_25,
        .clk_out_156_25(o_clk_156_25),  //  output        clk_out_156_25,
                                        //  // Status and control signals
        .reset(0),                      //  input         reset,
        .locked(pll_74_25_locked),      //  output        locked,
                                        //  // Clock in ports
        .clk_74_25(buffered_clk_74_25)  //  input         clk_74_25,
    );
    
    assign o_pll_locked = pll_74_25_locked;
    
endmodule
