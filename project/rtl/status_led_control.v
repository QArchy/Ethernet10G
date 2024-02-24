module status_led_control(
    input               i_clk,
    input               i_reset,
    input      [4:0]    i_push_btn,
    input      [7:0]    i_DIP_sw,
    output reg [7:0]    o_led
);
    reg [25:0] frequency_divider;
	always @(posedge i_clk, posedge i_reset) begin
		if (i_reset) begin
		    o_led[7:0]          <= 0;
            frequency_divider   <= 26'd0;
		end else begin
		    frequency_divider <= frequency_divider + 1;
		    
			if (frequency_divider == {26{1'b1}}) begin	// Blink once in ~1 seconds
				o_led[7]            <= i_DIP_sw[7] && ~o_led[7];
				frequency_divider   <= 26'd0;
			end
			
			o_led[0] <= i_DIP_sw[0] && i_push_btn[0];
            o_led[1] <= i_DIP_sw[1] && i_push_btn[1];
            o_led[2] <= i_DIP_sw[2] && i_push_btn[2];
            o_led[3] <= i_DIP_sw[3] && i_push_btn[3];
            o_led[4] <= i_DIP_sw[4] && i_push_btn[4];
            o_led[5] <= i_DIP_sw[5];
            o_led[6] <= i_DIP_sw[6];
		end
	end
endmodule
