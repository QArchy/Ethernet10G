module test_ZCU102_board(
		/* FIXED CLOCKS */ 			/* SOURCE - U69 SI5341B Clock Generator */
	input 				CLK_74_25 	//	74.25 MHz	SCHEMATIC - CLK_74_25_N(P)	I/O - LVDS_25	PIN - AK14(AK15)
	input 				CLK_125 	//	125 MHz		SCHEMATIC - CLK_125_N(P)	I/O - LVDS_25	PIN - F21(G21)
	
	input 				reset,		//	SCHEMATIC - CPU_RESET	I/O - LVCMOS33	PIN - AM13
	
			/* IO */
	input  		[4:0] 	push_btn, 	//	SCHEMATIC - GPIO_SW_N(E, W, S, C)	I/O - LVCMOS33
									// 	PIN - [AG15, AE14, AF15, AE15, AG13]
	input  		[7:0] 	DIP_sw, 	//	SCHEMATIC - GPIO_DIP_SW0(..7)		I/O - LVCMOS33
									// 	PIN - [AN14, AP14, AM14, AN13, AN12, AP12, AL13, AK13]
	output reg 	[7:0] 	led			//	SCHEMATIC - GPIO_LED_0(..7)			I/O - LVCMOS33
									// 	PIN - [AG14, AF13, AE13, AJ14, AJ15, AH13, AH14, AL12]
);
	
	reg [4:0] frequency_divider;
	
	always @(posedge CLK_125, posedge reset) begin
		if (reset) begin
			led 				<= 0;
			frequency_divider 	<= 0;
		end else begin
			frequency_divider <= frequency_divider + 1;
			
			if (frequency_divider == 5'd28) begin	// Blink once in ~2 seconds
				led[6] <= DIP_sw[6] && ~led[6];
			end
			
			led[0] <= DIP_sw[0] && push_btn[0];
			led[1] <= DIP_sw[1] && push_btn[1];
			led[2] <= DIP_sw[2] && push_btn[2];
			led[3] <= DIP_sw[3] && push_btn[3];
			led[4] <= DIP_sw[4] && push_btn[4];
			led[5] <= DIP_sw[5];
		end
	end
	
	always @(posedge CLK_74_25, posedge reset) begin
		if (!reset) begin
			if (frequency_divider == 5'd27) begin	// Blink once in ~2 seconds
				led[7] <= DIP_sw[7] && ~led[7];
			end
		end else;
	end
	
endmodule