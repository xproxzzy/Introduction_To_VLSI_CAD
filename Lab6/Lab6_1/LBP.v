module LBP
(
	input 	 			clk,
	input 	 			rst,
	input 				enable,
	output 	reg	[11:0] 	gray_addr,
	output 	reg 		gray_OE,
	input 	  	[7:0]  	gray_data,
	output 	reg	[11:0]	lbp_addr,
    output 	reg         lbp_WEN,
    output 	reg [7:0] 	lbp_data,
	output	reg			finish
);

// put your design here
parameter [3:0] S0=4'b0000, S1=4'b0001, S2=4'b0010, S3=4'b0011, S4=4'b0100, S5=4'b0101, S6=4'b0110, S7=4'b0111, S8=4'b1000, S9=4'b1001, S10=4'b1010, S11=4'b1011, S12=4'b1100;
reg [3:0] current_state, next_state;
reg [11:0]	counter;
reg [7:0]	gc;

always @ (posedge clk or posedge rst)
begin
	if(rst)
	begin
		current_state <= S0;
		counter <= 12'd0;
		finish <= 1'b0;
		lbp_data <= 8'd0;
		gc <= 8'd0;
	end
	else
	begin
		current_state <= next_state;
		if((current_state == S11) || (current_state == S12))	counter <= counter + 12'd1;
		else													counter <= counter;
		if((counter == 12'd4095)&&(current_state == S12))	finish <= 1'b1;
		else					finish <= 1'b0;
		case(current_state)
			S2:	gc <= gray_data;
			S3:
			begin
				if(gray_data >= gc)	lbp_data[0] <= 1'b1;
				else				lbp_data[0] <= 1'b0;
			end
			S4:
			begin
				if(gray_data >= gc)	lbp_data[1] <= 1'b1;
				else				lbp_data[1] <= 1'b0;
			end
			S5:
			begin
				if(gray_data >= gc)	lbp_data[2] <= 1'b1;
				else				lbp_data[2] <= 1'b0;
			end
			S6:
			begin
				if(gray_data >= gc)	lbp_data[3] <= 1'b1;
				else				lbp_data[3] <= 1'b0;
			end
			S7:
			begin
				if(gray_data >= gc)	lbp_data[4] <= 1'b1;
				else				lbp_data[4] <= 1'b0;
			end
			S8:
			begin
				if(gray_data >= gc)	lbp_data[5] <= 1'b1;
				else				lbp_data[5] <= 1'b0;
			end
			S9:
			begin
				if(gray_data >= gc)	lbp_data[6] <= 1'b1;
				else				lbp_data[6] <= 1'b0;
			end
			S10:
			begin
				if(gray_data >= gc)	lbp_data[7] <= 1'b1;
				else				lbp_data[7] <= 1'b0;
			end
			default:	lbp_data <= 8'd0;
		endcase
	end
end

always @ (*)
begin
	case(current_state)
		S0:
		begin
			gray_addr = 12'd0;
			gray_OE = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			if(enable)
			begin
				if(((counter >= 12'd0)&&(counter <= 12'd63))||((counter >= 12'd4032)&&(counter <= 12'd4095))||(counter[5:0]==6'd0)||(counter[5:0]==6'd63))	next_state = S12;
				else	next_state = S1;
			end
			else		next_state = S0;
		end
		S1:
		begin
			gray_addr = counter;
			gray_OE = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			if(((counter >= 12'd0)&&(counter <= 12'd63))||((counter >= 12'd4032)&&(counter <= 12'd4095))||(counter[5:0]==6'd0)||(counter[5:0]==6'd63))	next_state = S12;
			else	next_state = S2;
		end
		S2:
		begin
			gray_addr = counter - 12'd65;
			gray_OE = 1'b1;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			next_state = S3;
		end
		S3:
		begin
			gray_addr = counter - 12'd64;
			gray_OE = 1'b1;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			next_state = S4;
		end
		S4:
		begin
			gray_addr = counter - 12'd63;
			gray_OE = 1'b1;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			next_state = S5;
		end
		S5:
		begin
			gray_addr = counter - 12'd1;
			gray_OE = 1'b1;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			next_state = S6;
		end
		S6:
		begin
			gray_addr = counter + 12'd1;
			gray_OE = 1'b1;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			next_state = S7;
		end
		S7:
		begin
			gray_addr = counter + 12'd63;
			gray_OE = 1'b1;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			next_state = S8;
		end
		S8:
		begin
			gray_addr = counter + 12'd64;
			gray_OE = 1'b1;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			next_state = S9;
		end
		S9:
		begin
			gray_addr = counter + 12'd65;
			gray_OE = 1'b1;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			next_state = S10;
		end
		S10:
		begin
			gray_addr = 12'd0;
			gray_OE = 1'b1;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			next_state = S11;
		end
		S11:
		begin
			gray_addr = 12'd0;
			gray_OE = 1'b0;
			lbp_addr = counter;
			lbp_WEN = 1'b1;
			next_state = S1;
		end
		S12:
		begin
			gray_addr = 12'd0;
			gray_OE = 1'b0;
			lbp_addr = counter;
			lbp_WEN = 1'b1;
			if(counter == 12'd4095)	next_state = S0;
			else					next_state = S1;
		end
		default:
		begin
			gray_addr = 12'd0;
			gray_OE = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			next_state = S0;
		end
	endcase
end
endmodule
