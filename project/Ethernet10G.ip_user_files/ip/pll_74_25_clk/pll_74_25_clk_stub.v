// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Thu Mar 28 12:29:26 2024
// Host        : LAPTOP-3EF4A3RH running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               D:/programming/RLCBC_BROD/project/Ethernet10G.srcs/sources_1/ip/pll_74_25_clk/pll_74_25_clk_stub.v
// Design      : pll_74_25_clk
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu9eg-ffvb1156-3-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module pll_74_25_clk(clk_out_125, clk_out_156_25, reset, locked, 
  clk_74_25)
/* synthesis syn_black_box black_box_pad_pin="clk_out_125,clk_out_156_25,reset,locked,clk_74_25" */;
  output clk_out_125;
  output clk_out_156_25;
  input reset;
  output locked;
  input clk_74_25;
endmodule
