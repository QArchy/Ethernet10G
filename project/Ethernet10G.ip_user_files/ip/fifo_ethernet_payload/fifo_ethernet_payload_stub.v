// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Sun Mar  3 12:44:55 2024
// Host        : LAPTOP-3EF4A3RH running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               D:/programming/RLCBC_BROD/project/Ethernet10G.srcs/sources_1/ip/fifo_ethernet_payload/fifo_ethernet_payload_stub.v
// Design      : fifo_ethernet_payload
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu9eg-ffvb1156-3-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_5,Vivado 2019.2" *)
module fifo_ethernet_payload(clk, rst, din, wr_en, rd_en, dout, full, empty, 
  data_count)
/* synthesis syn_black_box black_box_pad_pin="clk,rst,din[63:0],wr_en,rd_en,dout[63:0],full,empty,data_count[3:0]" */;
  input clk;
  input rst;
  input [63:0]din;
  input wr_en;
  input rd_en;
  output [63:0]dout;
  output full;
  output empty;
  output [3:0]data_count;
endmodule
