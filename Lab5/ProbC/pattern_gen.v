module pattern_gen(clk, rst, en, sel, pattern, valid);

input clk, rst;
input en;
input [2:0] sel;
output reg pattern;
output reg valid;
parameter [2:0] S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100;
//S0:idle, S1:pattern, S2:pattern, S3:pattern, S4:pattern
reg [2:0] current_state, next_state;

always @(posedge clk or posedge rst)
begin
	if(rst)
		current_state <= S0;
	else 
		current_state <= next_state;
end
 
always @(*)
begin
	case(current_state)
		S0:
		begin
			pattern = 1'b0;
			valid = 1'b0;
			if(en == 1'b1)	next_state = S1;
			else			next_state = S0;
		end
		S1:
		begin
			pattern = sel[2];
			valid = 1'b1;
			next_state = S2;
		end
		S2:
		begin
			pattern = sel[2];
			valid = 1'b1;
			next_state = S3;
		end
		S3:
		begin
			pattern = sel[1];
			valid = 1'b1;
			next_state = S4;
		end
		S4:
		begin
			pattern = sel[0];
			valid = 1'b1;
			next_state = S0;
		end
		default:
		begin
			pattern = 1'b0;
			valid = 1'b0;
			next_state = S0;
		end
	endcase
end

endmodule
