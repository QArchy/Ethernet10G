module reset_init_block(
    input       i_slowest_clk,
    input       i_reset_trigger,
    input       i_pll_locked,      
    output reg  o_reset,
    output reg  o_await_initialization
);
    reg [2:0] reset_state;
    
    reg i_reset_trigger_prev;
    reg i_reset_trigger_posedge;
    
    reg [26:0] reset_counter;
    
    reg [26:0] init_counter;
    
    always @(posedge i_slowest_clk) begin
        case (reset_state)
            2'b00: begin
                i_reset_trigger_prev    <= i_reset_trigger;
                i_reset_trigger_posedge <= ~i_reset_trigger_prev && i_reset_trigger;
                reset_state             <= i_reset_trigger_posedge ? 2'b01 : 2'b00;
            end
            2'b01: begin
                if (reset_counter == {27{1'b1}}) begin
                    reset_counter           <= 0;
                    o_reset                 <= 0;
                    reset_state             <= 2'b10;
                end else begin
                    reset_counter   <= reset_counter + 1;
                    o_reset <= 1;
                end    
            end
            2'b10: begin
                if (init_counter == {27{1'b1}}) begin
                    init_counter           <= 0;
                    o_await_initialization <= 0;
                    reset_state            <= 2'b11;
                end else begin
                    if (i_pll_locked) begin
                        init_counter            <= init_counter + 1;
                        o_await_initialization  <= 1;
                    end else;
                end        
            end
            2'b11: begin
                reset_state <= 2'b00;                     
            end
        endcase
    end
    
endmodule
