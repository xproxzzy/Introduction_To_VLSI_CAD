module Comparator(
    input                   clk,
    input                   rst,
    input                   enable,
    input   [7:0]           histcount,
    input                   dcu_valid,
    input   [17:0]          distance,
    input   [4:0]           id,

    output  reg             id_ren,
    output  reg [7:0]       id_counter,
    output  reg             dcu_enable,
    output  reg [4:0]       label,
    output  reg [17:0]      minDistance,
    output  reg [20:0]      hist_addr_offset,
    output  reg             done
);

// put your design here
parameter [1:0] S0=2'b00, S1=2'b01, S2=2'b10, S3=2'b11;
reg [1:0]	current_state, next_state;
reg			first;
always @ (posedge clk or posedge rst)
begin
	if(rst)
	begin
		current_state <= S0;
		id_counter <= 8'd0;
		first <= 1'b0;
		minDistance <= 18'd0;
		label <= 5'd0;
		done <= 1'b0;
	end
	else
	begin
		current_state <= next_state;
		if(current_state == S2)
		begin
			id_counter <= id_counter + 8'd1;
		end
		if(dcu_valid == 1'b1)
		begin
			if(first == 1'b0)
			begin
				minDistance <= distance;
				label <= id;
				first <= 1'b1;
			end
			else
			begin
				if(distance < minDistance)
				begin
					minDistance <= distance;
					label <= id;
				end
			end
		end
		if(current_state == S3)
		begin
			first <=1'b0;
			id_counter <= 8'd0;
			done <= 1'b1;
		end
		else	done <= 1'b0;
	end
end
always @ (*)
begin
    case(current_state)
		S0:
		begin
			dcu_enable = 1'b0;
			id_ren = 1'b0;
			hist_addr_offset = 21'd0;
			if(enable)	next_state = S1;
			else		next_state = S0;
		end
		S1:
		begin
			dcu_enable = 1'b1;
			id_ren = 1'b1;
			hist_addr_offset = id_counter << 14;
			if(dcu_valid == 1'b1)	next_state = S2;
			else					next_state = S1;
		end
		S2:
		begin
			dcu_enable = 1'b0;
			id_ren = 1'b1;
			hist_addr_offset = 21'd0;
			if(id_counter <= (histcount - 8'd2))	next_state = S1;
			else									next_state = S3;
		end
		S3:
		begin
			dcu_enable = 1'b0;
			id_ren = 1'b0;
			hist_addr_offset = 21'd0;
			next_state = S0;
		end
	endcase
end
endmodule