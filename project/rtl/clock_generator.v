module clock_generator(
    input   i_CLK_74_25_P,
    input   i_CLK_74_25_N,
    input   i_CLK_125_P,  
    input   i_CLK_125_N,   
    output  o_CLK_74_25,  
    output  o_CLK_125
);                                                               
    IBUFDS #(.IOSTANDARD ("LVDS_25"), .DIFF_TERM("FALSE")) IBUFDS_clk_74_25 (          
        .O(o_CLK_74_25),         // Buffer output                                           
        .I(i_CLK_74_25_P),      // Diff_p buffer input (connect directly to top-level port)
        .IB(i_CLK_74_25_N)      // Diff_n buffer input (connect directly to top-level port)
    );                     
                                                                
    IBUFDS #(.IOSTANDARD ("LVDS_25"), .DIFF_TERM("FALSE")) IBUFDS_clk_125 (            
        .O(o_CLK_125),          // Buffer output                                           
        .I(i_CLK_125_P),        // Diff_p buffer input (connect directly to top-level port)
        .IB(i_CLK_125_N)        // Diff_n buffer input (connect directly to top-level port)
    );
    
endmodule
