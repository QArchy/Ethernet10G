module crc_calc(
	input clk,
	input rst,
	input enbl,
	input [7:0] data_in,
	output [31:0] crc_out
);
	wire [31:0] lfsr_c   ;
	reg  [31:0] lfsr_q   ;
	wire  [7:0] data_loc ;
	
	initial begin
		lfsr_q <= 0;
	end
	
	assign data_loc  [0] =  data_in  [7] ;
	assign data_loc  [1] =  data_in  [6] ;
	assign data_loc  [2] =  data_in  [5] ;
	assign data_loc  [3] =  data_in  [4] ;
	assign data_loc  [4] =  data_in  [3] ;
	assign data_loc  [5] =  data_in  [2] ;
	assign data_loc  [6] =  data_in  [1] ;
	assign data_loc  [7] =  data_in  [0] ;
	assign crc_out  [24] = !lfsr_q  [31] ;
	assign crc_out  [25] = !lfsr_q  [30] ;
	assign crc_out  [26] = !lfsr_q  [29] ;
	assign crc_out  [27] = !lfsr_q  [28] ;
	assign crc_out  [28] = !lfsr_q  [27] ;
	assign crc_out  [29] = !lfsr_q  [26] ;
	assign crc_out  [30] = !lfsr_q  [25] ;
	assign crc_out  [31] = !lfsr_q  [24] ;
	assign crc_out  [16] = !lfsr_q  [23] ;
	assign crc_out  [17] = !lfsr_q  [22] ;
	assign crc_out  [18] = !lfsr_q  [21] ;
	assign crc_out  [19] = !lfsr_q  [20] ;
	assign crc_out  [20] = !lfsr_q  [19] ;
	assign crc_out  [21] = !lfsr_q  [18] ;
	assign crc_out  [22] = !lfsr_q  [17] ;
	assign crc_out  [23] = !lfsr_q  [16] ;
	assign crc_out   [8] = !lfsr_q  [15] ;
	assign crc_out   [9] = !lfsr_q  [14] ;
	assign crc_out  [10] = !lfsr_q  [13] ;
	assign crc_out  [11] = !lfsr_q  [12] ;
	assign crc_out  [12] = !lfsr_q  [11] ;
	assign crc_out  [13] = !lfsr_q  [10] ;
	assign crc_out  [14] = !lfsr_q   [9] ;
	assign crc_out  [15] = !lfsr_q   [8] ;
	assign crc_out   [0] = !lfsr_q   [7] ;
	assign crc_out   [1] = !lfsr_q   [6] ;
	assign crc_out   [2] = !lfsr_q   [5] ;
	assign crc_out   [3] = !lfsr_q   [4] ;
	assign crc_out   [4] = !lfsr_q   [3] ;
	assign crc_out   [5] = !lfsr_q   [2] ;
	assign crc_out   [6] = !lfsr_q   [1] ;
	assign crc_out   [7] = !lfsr_q   [0] ;
	assign lfsr_c    [0] =  lfsr_q  [24] ^ lfsr_q [30] ^ data_loc  [0] ^ data_loc  [6] ;
	assign lfsr_c    [1] =  lfsr_q  [24] ^ lfsr_q [25] ^ lfsr_q   [30] ^ lfsr_q   [31] ^ data_loc  [0] ^ data_loc  [1] ^ data_loc  [6] ^ data_loc [7] ;
	assign lfsr_c    [2] =  lfsr_q  [24] ^ lfsr_q [25] ^ lfsr_q   [26] ^ lfsr_q   [30] ^ lfsr_q   [31] ^ data_loc  [0] ^ data_loc  [1] ^ data_loc [2] ^ data_loc [6] ^ data_loc [7] ;
	assign lfsr_c    [3] =  lfsr_q  [25] ^ lfsr_q [26] ^ lfsr_q   [27] ^ lfsr_q   [31] ^ data_loc  [1] ^ data_loc  [2] ^ data_loc  [3] ^ data_loc [7] ;
	assign lfsr_c    [4] =  lfsr_q  [24] ^ lfsr_q [26] ^ lfsr_q   [27] ^ lfsr_q   [28] ^ lfsr_q   [30] ^ data_loc  [0] ^ data_loc  [2] ^ data_loc [3] ^ data_loc [4] ^ data_loc [6] ;
	assign lfsr_c    [5] =  lfsr_q  [24] ^ lfsr_q [25] ^ lfsr_q   [27] ^ lfsr_q   [28] ^ lfsr_q   [29] ^ lfsr_q   [30] ^ lfsr_q   [31] ^ data_loc [0] ^ data_loc [1] ^ data_loc [3] ^ data_loc [4] ^ data_loc [5] ^ data_loc [6] ^ data_loc [7] ;
	assign lfsr_c    [6] =  lfsr_q  [25] ^ lfsr_q [26] ^ lfsr_q   [28] ^ lfsr_q   [29] ^ lfsr_q   [30] ^ lfsr_q   [31] ^ data_loc  [1] ^ data_loc [2] ^ data_loc [4] ^ data_loc [5] ^ data_loc [6] ^ data_loc [7] ;
	assign lfsr_c    [7] =  lfsr_q  [24] ^ lfsr_q [26] ^ lfsr_q   [27] ^ lfsr_q   [29] ^ lfsr_q   [31] ^ data_loc  [0] ^ data_loc  [2] ^ data_loc [3] ^ data_loc [5] ^ data_loc [7] ;
	assign lfsr_c    [8] =  lfsr_q   [0] ^ lfsr_q [24] ^ lfsr_q   [25] ^ lfsr_q   [27] ^ lfsr_q   [28] ^ data_loc  [0] ^ data_loc  [1] ^ data_loc [3] ^ data_loc [4] ;
	assign lfsr_c    [9] =  lfsr_q   [1] ^ lfsr_q [25] ^ lfsr_q   [26] ^ lfsr_q   [28] ^ lfsr_q   [29] ^ data_loc  [1] ^ data_loc  [2] ^ data_loc [4] ^ data_loc [5] ;
	assign lfsr_c   [10] =  lfsr_q   [2] ^ lfsr_q [24] ^ lfsr_q   [26] ^ lfsr_q   [27] ^ lfsr_q   [29] ^ data_loc  [0] ^ data_loc  [2] ^ data_loc [3] ^ data_loc [5] ;
	assign lfsr_c   [11] =  lfsr_q   [3] ^ lfsr_q [24] ^ lfsr_q   [25] ^ lfsr_q   [27] ^ lfsr_q   [28] ^ data_loc  [0] ^ data_loc  [1] ^ data_loc [3] ^ data_loc [4] ;
	assign lfsr_c   [12] =  lfsr_q   [4] ^ lfsr_q [24] ^ lfsr_q   [25] ^ lfsr_q   [26] ^ lfsr_q   [28] ^ lfsr_q   [29] ^ lfsr_q   [30] ^ data_loc [0] ^ data_loc [1] ^ data_loc [2] ^ data_loc [4] ^ data_loc [5] ^ data_loc [6] ;
	assign lfsr_c   [13] =  lfsr_q   [5] ^ lfsr_q [25] ^ lfsr_q   [26] ^ lfsr_q   [27] ^ lfsr_q   [29] ^ lfsr_q   [30] ^ lfsr_q   [31] ^ data_loc [1] ^ data_loc [2] ^ data_loc [3] ^ data_loc [5] ^ data_loc [6] ^ data_loc [7] ;
	assign lfsr_c   [14] =  lfsr_q   [6] ^ lfsr_q [26] ^ lfsr_q   [27] ^ lfsr_q   [28] ^ lfsr_q   [30] ^ lfsr_q   [31] ^ data_loc  [2] ^ data_loc [3] ^ data_loc [4] ^ data_loc [6] ^ data_loc [7] ;
	assign lfsr_c   [15] =  lfsr_q   [7] ^ lfsr_q [27] ^ lfsr_q   [28] ^ lfsr_q   [29] ^ lfsr_q   [31] ^ data_loc  [3] ^ data_loc  [4] ^ data_loc [5] ^ data_loc [7] ;
	assign lfsr_c   [16] =  lfsr_q   [8] ^ lfsr_q [24] ^ lfsr_q   [28] ^ lfsr_q   [29] ^ data_loc  [0] ^ data_loc  [4] ^ data_loc  [5] ;
	assign lfsr_c   [17] =  lfsr_q   [9] ^ lfsr_q [25] ^ lfsr_q   [29] ^ lfsr_q   [30] ^ data_loc  [1] ^ data_loc  [5] ^ data_loc  [6] ;
	assign lfsr_c   [18] =  lfsr_q  [10] ^ lfsr_q [26] ^ lfsr_q   [30] ^ lfsr_q   [31] ^ data_loc  [2] ^ data_loc  [6] ^ data_loc  [7] ;
	assign lfsr_c   [19] =  lfsr_q  [11] ^ lfsr_q [27] ^ lfsr_q   [31] ^ data_loc  [3] ^ data_loc  [7] ;
	assign lfsr_c   [20] =  lfsr_q  [12] ^ lfsr_q [28] ^ data_loc  [4] ;
	assign lfsr_c   [21] =  lfsr_q  [13] ^ lfsr_q [29] ^ data_loc  [5] ;
	assign lfsr_c   [22] =  lfsr_q  [14] ^ lfsr_q [24] ^ data_loc  [0] ;
	assign lfsr_c   [23] =  lfsr_q  [15] ^ lfsr_q [24] ^ lfsr_q   [25] ^ lfsr_q   [30] ^ data_loc  [0] ^ data_loc  [1] ^ data_loc  [6] ;
	assign lfsr_c   [24] =  lfsr_q  [16] ^ lfsr_q [25] ^ lfsr_q   [26] ^ lfsr_q   [31] ^ data_loc  [1] ^ data_loc  [2] ^ data_loc  [7] ;
	assign lfsr_c   [25] =  lfsr_q  [17] ^ lfsr_q [26] ^ lfsr_q   [27] ^ data_loc  [2] ^ data_loc  [3] ;
	assign lfsr_c   [26] =  lfsr_q  [18] ^ lfsr_q [24] ^ lfsr_q   [27] ^ lfsr_q   [28] ^ lfsr_q   [30] ^ data_loc  [0] ^ data_loc  [3] ^ data_loc [4] ^ data_loc [6] ;
	assign lfsr_c   [27] =  lfsr_q  [19] ^ lfsr_q [25] ^ lfsr_q   [28] ^ lfsr_q   [29] ^ lfsr_q   [31] ^ data_loc  [1] ^ data_loc  [4] ^ data_loc [5] ^ data_loc [7] ;
	assign lfsr_c   [28] =  lfsr_q  [20] ^ lfsr_q [26] ^ lfsr_q   [29] ^ lfsr_q   [30] ^ data_loc  [2] ^ data_loc  [5] ^ data_loc  [6] ;
	assign lfsr_c   [29] =  lfsr_q  [21] ^ lfsr_q [27] ^ lfsr_q   [30] ^ lfsr_q   [31] ^ data_loc  [3] ^ data_loc  [6] ^ data_loc  [7] ;
	assign lfsr_c   [30] =  lfsr_q  [22] ^ lfsr_q [28] ^ lfsr_q   [31] ^ data_loc  [4] ^ data_loc  [7] ;
	assign lfsr_c   [31] =  lfsr_q  [23] ^ lfsr_q [29] ^ data_loc  [5] ;
	
	always @(posedge clk, posedge rst)
		if (rst) lfsr_q [31:0] <= 32'hFF_FF_FF_FF ;
			else if (enbl) lfsr_q [31:0] <= lfsr_c [31:0] ;
				else ;
	
endmodule 