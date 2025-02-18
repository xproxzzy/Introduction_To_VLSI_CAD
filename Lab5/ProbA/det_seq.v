module det_seq(clk, rst, d, q, num);

input clk, rst;
input d;
output reg q;
output reg [2:0] num;
parameter [2:0] S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100, S5=3'b101, S6=3'b110;
//S0:initial, S1:receive 1, S2:receive 10, S3:receive 101, S4:receive 1010, S5:receive 10101, S5:receive 101011
reg [2:0] current_state, next_state;

always @ (posedge clk or posedge rst)
begin
	if(rst)
	begin
		current_state <= S0;
		num <= 3'd0;
	end
	else
	begin
		current_state <= next_state;
		if(current_state == S6) 	num <= num + 3'd1;
		else			num <= num;
	end
end

always @ (*)
begin
	case(current_state)
		S0:
		begin
			q = 1'b0;
			if(d == 1'b0)	next_state = S0;
			else			next_state = S1;
		end
		S1:
		begin
			q = 1'b0;
			if(d == 1'b0)	next_state = S2;
			else			next_state = S1;
		end
		S2:
		begin
			q = 1'b0;
			if(d == 1'b0)	next_state = S0;
			else			next_state = S3;
		end
		S3:
		begin
			q = 1'b0;
			if(d == 1'b0)	next_state = S4;
			else			next_state = S1;
		end
		S4:
		begin
			q = 1'b0;
			if(d == 1'b0)	next_state = S0;
			else			next_state = S5;
		end
		S5:
		begin
			q = 1'b0;
			if(d == 1'b0)	next_state = S4;
			else			next_state = S6;
		end
		S6:
		begin
			q = 1'b1;
			if(d == 1'b0)	next_state = S2;
			else			next_state = S1;
		end
		default:
		begin
			q = 1'b0;
			next_state = S0;
		end
	endcase
end
endmodule
