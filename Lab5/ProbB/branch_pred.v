module branch_pred(clk, rst, taken,p_taken);

input clk, rst;
input taken;
output reg p_taken;
parameter [1:0] S0=2'b00, S1=2'b01, S2=2'b10, S3=2'b11;
//S0:Predict Taken 2, S1:Predict Taken 1, S2:Predict Not Taken 2, S3:Predict Not Taken 1
reg [1:0] current_state, next_state;

always @ (posedge clk or posedge rst)
begin
	if(rst)	current_state <= S0;
	else			current_state <= next_state;
end

always @ (*)
begin
	case(current_state)
		S0:
		begin
			p_taken = 1'b1;
			if(taken == 1'b0)	next_state = S1;
			else				next_state = S0;
		end
		S1:
		begin
			p_taken = 1'b1;
			if(taken == 1'b0)	next_state = S2;
			else				next_state = S0;
		end
		S2:
		begin
			p_taken = 1'b0;
			if(taken == 1'b0)	next_state = S2;
			else				next_state = S3;
		end
		S3:
		begin
			p_taken = 1'b0;
			if(taken == 1'b0)	next_state = S2;
			else				next_state = S0;
		end
	endcase
end
endmodule
