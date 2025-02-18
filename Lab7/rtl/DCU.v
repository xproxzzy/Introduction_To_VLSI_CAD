module DCU(
    input               clk,
    input               rst,
    input               enable,
    input   [20:0]      hist_addr_offset,

    output  reg [20:0]  hist_addr_train,
    output  reg         hist_ren_train,
    input   [7:0]       hist_rdata_train,

    output  reg [13:0]  hist_addr_predict,
    output  reg         hist_ren_predict,
    input   [7:0]       hist_rdata_predict,

    output  reg [17:0]  distance,
    output  reg         valid
);
// put your design here
parameter [1:0] S0=2'b00, S1=2'b01, S2=2'b10, S3=2'b11;
reg [1:0]	current_state, next_state;
reg [13:0]	counter;
reg [17:0]	d;
always @ (posedge clk or posedge rst)
begin
	if(rst)
	begin
		current_state <= S0;
		counter <= 14'd0;
		distance <= 18'd0;
	end
	else
	begin
		current_state <= next_state;
		if(current_state == S2)			counter <= counter + 14'd1;
		else if(current_state == S3)	counter <= 14'd0;
		if(current_state == S2)			distance <= distance + d;
		else if(current_state == S3)	distance <= 18'd0;
	end
end
always @ (*)
begin
    case(current_state)
		S0:
		begin
			hist_addr_train = 21'd0;
			hist_ren_train = 1'b0;
			hist_addr_predict = 14'd0;
			hist_ren_predict = 1'b0;
			d = 18'd0;
			valid = 1'b0;
			if(enable)	next_state = S1;
			else		next_state = S0;
		end
		S1:
		begin
			hist_addr_train = hist_addr_offset + counter;
			hist_ren_train = 1'b1;
			hist_addr_predict = counter;
			hist_ren_predict = 1'b1;
			d = 18'd0;
			valid = 1'b0;
			next_state = S2;
		end
		S2:
		begin
			hist_addr_train = 21'd0;
			hist_ren_train = 1'b1;
			hist_addr_predict = 14'd0;
			hist_ren_predict = 1'b1;
			if(hist_rdata_predict >= hist_rdata_train)	d = (hist_rdata_predict - hist_rdata_train)**2;
			else										d = (hist_rdata_train - hist_rdata_predict)**2;
			valid = 1'b0;
			if(counter == 14'd16383)	next_state = S3;
			else						next_state = S1;
		end
		S3:
		begin
			hist_addr_train = 21'd0;
			hist_ren_train = 1'b0;
			hist_addr_predict = 14'd0;
			hist_ren_predict = 1'b0;
			d = 18'd0;
			valid = 1'b1;
			next_state = S0;
		end
	endcase
end
endmodule   