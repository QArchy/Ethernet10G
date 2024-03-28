
// file: pll_74_25_clk.v
// 
// (c) Copyright 2008 - 2013 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
//----------------------------------------------------------------------------
// User entered comments
//----------------------------------------------------------------------------
// None
//
//----------------------------------------------------------------------------
//  Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
//   Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
//----------------------------------------------------------------------------
// clk_out_125__126.22500______0.000______50.0______111.520____106.943
// clk_out_156_25__157.78125______0.000______50.0______107.314____106.943
//
//----------------------------------------------------------------------------
// Input Clock   Freq (MHz)    Input Jitter (UI)
//----------------------------------------------------------------------------
// __primary__________74.250____________0.010

`timescale 1ps/1ps

module pll_74_25_clk_clk_wiz 

 (// Clock in ports
  // Clock out ports
  output        clk_out_125,
  output        clk_out_156_25,
  // Status and control signals
  input         reset,
  output        locked,
  input         clk_74_25
 );
  // Input buffering
  //------------------------------------
wire clk_74_25_pll_74_25_clk;
wire clk_in2_pll_74_25_clk;
  BUFG clkin1_bufg
   (.O (clk_74_25_pll_74_25_clk),
    .I (clk_74_25));




  // Clocking PRIMITIVE
  //------------------------------------

  // Instantiation of the MMCM PRIMITIVE
  //    * Unused inputs are tied off
  //    * Unused outputs are labeled unused

  wire        clk_out_125_pll_74_25_clk;
  wire        clk_out_156_25_pll_74_25_clk;
  wire        clk_out3_pll_74_25_clk;
  wire        clk_out4_pll_74_25_clk;
  wire        clk_out5_pll_74_25_clk;
  wire        clk_out6_pll_74_25_clk;
  wire        clk_out7_pll_74_25_clk;

  wire [15:0] do_unused;
  wire        drdy_unused;
  wire        psdone_unused;
  wire        locked_int;
  wire        clkfbout_pll_74_25_clk;
  wire        clkfboutb_unused;
    wire clkout0b_unused;
   wire clkout1b_unused;
  wire        clkfbstopped_unused;
  wire        clkinstopped_unused;
  wire        reset_high;

  
    PLLE4_ADV
  #(
    .COMPENSATION         ("AUTO"),
    .STARTUP_WAIT         ("FALSE"),
    .DIVCLK_DIVIDE        (1),
    .CLKFBOUT_MULT        (17),
    .CLKFBOUT_PHASE       (0.000),
    .CLKOUT0_DIVIDE       (10),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.500),
    .CLKOUT1_DIVIDE       (8),
    .CLKOUT1_PHASE        (0.000),
    .CLKOUT1_DUTY_CYCLE   (0.500),
    .CLKIN_PERIOD         (13.468))
  
  plle4_adv_inst
    // Output clocks
   (
    .CLKFBOUT            (clkfbout_pll_74_25_clk),
    .CLKOUT0             (clk_out_125_pll_74_25_clk),
    .CLKOUT0B            (clkout0b_unused),
    .CLKOUT1             (clk_out_156_25_pll_74_25_clk),
    .CLKOUT1B            (clkout1b_unused),
     // Input clock control
    .CLKFBIN             (clkfbout_pll_74_25_clk),
    .CLKIN               (clk_74_25_pll_74_25_clk),
    // Ports for dynamic reconfiguration
    .DADDR               (7'h0),
    .DCLK                (1'b0),
    .DEN                 (1'b0),
    .DI                  (16'h0),
    .DO                  (do_unused),
    .DRDY                (drdy_unused),
    .DWE                 (1'b0),
    .CLKOUTPHYEN         (1'b0),
    .CLKOUTPHY           (),
    // Other control and status signals
    .LOCKED              (locked_int),
    .PWRDWN              (1'b0),
    .RST                 (reset_high));
  assign reset_high = reset; 

  assign locked = locked_int;
// Clock Monitor clock assigning
//--------------------------------------
 // Output buffering
  //-----------------------------------






  BUFG clkout1_buf
   (.O   (clk_out_125),
    .I   (clk_out_125_pll_74_25_clk));


  BUFG clkout2_buf
   (.O   (clk_out_156_25),
    .I   (clk_out_156_25_pll_74_25_clk));



endmodule
