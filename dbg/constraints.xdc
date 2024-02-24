set_property SEVERITY {Warning} [get_drc_checks NSTD-1]
set_property SEVERITY {Warning} [get_drc_checks UCIO-1]

create_clock -period 8.000  -name CLK_125_P     -waveform {0.000 4.000} [get_ports i_CLK_125_P]
create_clock -period 13.4   -name CLK_74_25_P   -waveform {0.000 6.700}  [get_ports i_CLK_74_25_P]

# SETUP
    # CLK_125
set_property PACKAGE_PIN G21    [get_ports i_CLK_125_P]
set_property PACKAGE_PIN F21    [get_ports i_CLK_125_N]
set_property IOSTANDARD LVDS_25 [get_ports i_CLK_125_P]
set_property IOSTANDARD LVDS_25 [get_ports i_CLK_125_N]
    # CLK_74_25
set_property PACKAGE_PIN AK15   [get_ports i_CLK_74_25_P]
set_property PACKAGE_PIN AK14   [get_ports i_CLK_74_25_N]
set_property IOSTANDARD LVDS_25 [get_ports i_CLK_74_25_P]
set_property IOSTANDARD LVDS_25 [get_ports i_CLK_74_25_N]
    # RESET
set_property PACKAGE_PIN AM13       [get_ports i_reset]
set_property IOSTANDARD LVCMOS33    [get_ports i_reset]

# OUTPUT
    # PUSH_BTN
set_property PACKAGE_PIN AG15       [get_ports i_push_btn[0]]
set_property IOSTANDARD LVCMOS33    [get_ports i_push_btn[0]]
set_property PACKAGE_PIN AE14       [get_ports i_push_btn[1]]
set_property IOSTANDARD LVCMOS33    [get_ports i_push_btn[1]]
set_property PACKAGE_PIN AF15       [get_ports i_push_btn[2]]
set_property IOSTANDARD LVCMOS33    [get_ports i_push_btn[2]]
set_property PACKAGE_PIN AE15       [get_ports i_push_btn[3]]
set_property IOSTANDARD LVCMOS33    [get_ports i_push_btn[3]]
set_property PACKAGE_PIN AG13       [get_ports i_push_btn[4]]
set_property IOSTANDARD LVCMOS33    [get_ports i_push_btn[4]]
    # DIP_sw
set_property PACKAGE_PIN AN14       [get_ports i_DIP_sw[0]]
set_property IOSTANDARD LVCMOS33    [get_ports i_DIP_sw[0]]
set_property PACKAGE_PIN AP14       [get_ports i_DIP_sw[1]]
set_property IOSTANDARD LVCMOS33    [get_ports i_DIP_sw[1]]
set_property PACKAGE_PIN AM14       [get_ports i_DIP_sw[2]]
set_property IOSTANDARD LVCMOS33    [get_ports i_DIP_sw[2]]
set_property PACKAGE_PIN AN13       [get_ports i_DIP_sw[3]]
set_property IOSTANDARD LVCMOS33    [get_ports i_DIP_sw[3]]
set_property PACKAGE_PIN AN12       [get_ports i_DIP_sw[4]]
set_property IOSTANDARD LVCMOS33    [get_ports i_DIP_sw[4]]
set_property PACKAGE_PIN AP12       [get_ports i_DIP_sw[5]]
set_property IOSTANDARD LVCMOS33    [get_ports i_DIP_sw[5]]
set_property PACKAGE_PIN AL13       [get_ports i_DIP_sw[6]]
set_property IOSTANDARD LVCMOS33    [get_ports i_DIP_sw[6]]
set_property PACKAGE_PIN AK13       [get_ports i_DIP_sw[7]]
set_property IOSTANDARD LVCMOS33    [get_ports i_DIP_sw[7]]
    # LED
set_property PACKAGE_PIN AG14       [get_ports o_led[0]]
set_property IOSTANDARD LVCMOS33    [get_ports o_led[0]]
set_property PACKAGE_PIN AF13       [get_ports o_led[1]]
set_property IOSTANDARD LVCMOS33    [get_ports o_led[1]]
set_property PACKAGE_PIN AE13       [get_ports o_led[2]]
set_property IOSTANDARD LVCMOS33    [get_ports o_led[2]]
set_property PACKAGE_PIN AJ14       [get_ports o_led[3]]
set_property IOSTANDARD LVCMOS33    [get_ports o_led[3]]
set_property PACKAGE_PIN AJ15       [get_ports o_led[4]]
set_property IOSTANDARD LVCMOS33    [get_ports o_led[4]]
set_property PACKAGE_PIN AH13       [get_ports o_led[5]]
set_property IOSTANDARD LVCMOS33    [get_ports o_led[5]]
set_property PACKAGE_PIN AH14       [get_ports o_led[6]]
set_property IOSTANDARD LVCMOS33    [get_ports o_led[6]]
set_property PACKAGE_PIN AL12       [get_ports o_led[7]]
set_property IOSTANDARD LVCMOS33    [get_ports o_led[7]]

# ETHERNET 1G
    # TX
set_property PACKAGE_PIN A25        [get_ports o_ethernet_tx_clock]
set_property IOSTANDARD LVCMOS33    [get_ports o_ethernet_tx_clock]
set_property PACKAGE_PIN A26        [get_ports o_ethernet_tx_d[0]]
set_property IOSTANDARD LVCMOS33    [get_ports o_ethernet_tx_d[0]]  
set_property PACKAGE_PIN A27        [get_ports o_ethernet_tx_d[1]]
set_property IOSTANDARD LVCMOS33    [get_ports o_ethernet_tx_d[1]]  
set_property PACKAGE_PIN B25        [get_ports o_ethernet_tx_d[2]]
set_property IOSTANDARD LVCMOS33    [get_ports o_ethernet_tx_d[2]]  
set_property PACKAGE_PIN B26        [get_ports o_ethernet_tx_d[3]]
set_property IOSTANDARD LVCMOS33    [get_ports o_ethernet_tx_d[3]]   
set_property PACKAGE_PIN B27        [get_ports o_ethernet_tx_ctrl]
set_property IOSTANDARD LVCMOS33    [get_ports o_ethernet_tx_ctrl]   
    # TX
set_property PACKAGE_PIN C26        [get_ports i_ethernet_rx_clock]
set_property IOSTANDARD LVCMOS33    [get_ports i_ethernet_rx_clock]
set_property PACKAGE_PIN C27        [get_ports i_ethernet_rx_d[0]]
set_property IOSTANDARD LVCMOS33    [get_ports i_ethernet_rx_d[0]]  
set_property PACKAGE_PIN E25        [get_ports i_ethernet_rx_d[1]]
set_property IOSTANDARD LVCMOS33    [get_ports i_ethernet_rx_d[1]]  
set_property PACKAGE_PIN H24        [get_ports i_ethernet_rx_d[2]]
set_property IOSTANDARD LVCMOS33    [get_ports i_ethernet_rx_d[2]]  
set_property PACKAGE_PIN G25        [get_ports i_ethernet_rx_d[3]]
set_property IOSTANDARD LVCMOS33    [get_ports i_ethernet_rx_d[3]]   
set_property PACKAGE_PIN D25        [get_ports i_ethernet_rx_ctrl]
set_property IOSTANDARD LVCMOS33    [get_ports i_ethernet_rx_ctrl]  
    # RGMII
set_property PACKAGE_PIN H25        [get_ports o_ethernet_mdc]
set_property IOSTANDARD LVCMOS33    [get_ports o_ethernet_mdc]
set_property PACKAGE_PIN F25        [get_ports o_ethernet_mdio]
set_property IOSTANDARD LVCMOS33    [get_ports o_ethernet_mdio]

# ETHERNET 10G
set_property PACKAGE_PIN AL8        [get_ports i_CLK_156_25_P]
set_property IOSTANDARD DIFF_SSTL12 [get_ports i_CLK_156_25_P]                    
set_property PACKAGE_PIN AL7        [get_ports i_CLK_156_25_N]
set_property IOSTANDARD DIFF_SSTL12 [get_ports i_CLK_156_25_N] 
    # Right Top (SFP0)
set_property PACKAGE_PIN E4         [get_ports o_rt_tx_p]                     
set_property PACKAGE_PIN E3         [get_ports o_rt_tx_n]                      
set_property PACKAGE_PIN D2         [get_ports i_rt_rx_p]                     
set_property PACKAGE_PIN D1         [get_ports i_rt_rx_n]                     
set_property PACKAGE_PIN A12        [get_ports o_rt_tx_disable]
set_property IOSTANDARD LVCMOS33    [get_ports o_rt_tx_disable]
    # Right Low (SFP1)
set_property PACKAGE_PIN D6         [get_ports o_rl_tx_p]                     
set_property PACKAGE_PIN D5         [get_ports o_rl_tx_n]                      
set_property PACKAGE_PIN C4         [get_ports i_rl_rx_p]                    
set_property PACKAGE_PIN C3         [get_ports i_rl_rx_n]                    
set_property PACKAGE_PIN A13        [get_ports o_rl_tx_disable]
set_property IOSTANDARD LVCMOS33    [get_ports o_rl_tx_disable]
    # Left top (SFP2)
set_property PACKAGE_PIN B6         [get_ports o_lt_tx_p]                     
set_property PACKAGE_PIN B5         [get_ports o_lt_tx_n]                    
set_property PACKAGE_PIN B2         [get_ports i_lt_rx_p]                    
set_property PACKAGE_PIN B1         [get_ports i_lt_rx_n]                    
set_property PACKAGE_PIN B13        [get_ports o_lt_tx_disable]
set_property IOSTANDARD LVCMOS33    [get_ports o_lt_tx_disable]
    # Left low (SFP3)
set_property PACKAGE_PIN A8         [get_ports o_ll_tx_p]                       
set_property PACKAGE_PIN A7         [get_ports o_ll_tx_n]                       
set_property PACKAGE_PIN A4         [get_ports i_ll_rx_p]                       
set_property PACKAGE_PIN A3         [get_ports i_ll_rx_n]                      
set_property PACKAGE_PIN C13        [get_ports o_ll_tx_disable]                 
set_property IOSTANDARD LVCMOS33    [get_ports o_ll_tx_disable]                











