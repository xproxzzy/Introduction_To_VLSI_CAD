module CLBP
#(
    parameter INT_WIDTH     = 9,
    parameter FRAC_WIDTH    = 16
)
(
    input                                       clk,
    input                                       rst,
    input                                       enable,
    output reg  [11:0]                          gray_addr,
    output reg                                  gray_OE,
    input       [7:0]                           gray_data,
    output reg  [11:0]                          lbp_addr,
    output reg                                  lbp_WEN,
    output reg  [7:0]                           lbp_data,
    output reg  [(INT_WIDTH+FRAC_WIDTH)-1:0]    theta, // in radian
    output reg                                  theta_valid,
    input       [(INT_WIDTH+FRAC_WIDTH)-1:0]    cos_data,
    input                                       cos_valid,
    input       [(INT_WIDTH+FRAC_WIDTH)-1:0]    sin_data,
    input                                       sin_valid,
    output reg                                  finish
);  
	
// put your design here
parameter [5:0] S0=6'b000000, S1=6'b000001, S2=6'b000010, S3=6'b000011, S4=6'b000100, S5=6'b000101, S6=6'b000110, S7=6'b000111;
parameter [5:0] S8=6'b001000, S9=6'b001001, S10=6'b001010, S11=6'b001011, S12=6'b001100, S13=6'b001101, S14=6'b001110, S15=6'b001111;
parameter [5:0] S16=6'b010000, S17=6'b010001, S18=6'b010010, S19=6'b010011, S20=6'b010100, S21=6'b010101, S22=6'b010110, S23=6'b010111;
parameter [5:0] S24=6'b011000, S25=6'b011001, S26=6'b011010, S27=6'b011011, S28=6'b011100, S29=6'b011101, S30=6'b011110, S31=6'b011111;
parameter [5:0] S32=6'b100000, S33=6'b100001, S34=6'b100010, S35=6'b100011, S36=6'b100100, S37=6'b100101, S38=6'b100110, S39=6'b100111;
parameter [5:0] S40=6'b101000, S41=6'b101001, S42=6'b101010, S43=6'b101011, S44=6'b101100, S45=6'b101101, S46=6'b101110, S47=6'b101111;
parameter [5:0] S48=6'b110000, S49=6'b110001, S50=6'b110010, S51=6'b110011, S52=6'b110100, S53=6'b110101, S54=6'b110110, S55=6'b110111;
parameter [24:0] pi=25'b0_0000_0011_0010_0100_0011_1111;
reg [5:0]	current_state, next_state;
reg [11:0]	counter;
reg [7:0]	gc;
reg [24:0]	cos [7:0];
reg [24:0]	sin [7:0];
reg [24:0]	rx [7:0];
reg [24:0]	ry [7:0];
reg [8:0]	x1 [7:0];
reg [8:0]	x2 [7:0];
reg [8:0]	y1 [7:0];
reg [8:0]	y2 [7:0];
reg [7:0]	x1_y1_data;
reg [7:0]	x1_y2_data;
reg [7:0]	x2_y1_data;
reg [7:0]	x2_y2_data;
reg [24:0]	tx [7:0];
reg [24:0]	ty [7:0];
reg [24:0]	w1 [7:0];
reg [24:0]	w2 [7:0];
reg [24:0]	w3 [7:0];
reg [24:0]	w4 [7:0];
reg [49:0]	multi1 [7:0];
reg [49:0]	multi2 [7:0];
reg [49:0]	multi3 [7:0];
reg [49:0]	multi4 [7:0];
reg [31:0]	LBP;
integer		i;

always @ (posedge clk or posedge rst)
begin
	if(rst)
	begin
		current_state <= S0;
		counter <= 12'd0;
		finish <= 1'b0;
		cos[0] <= 25'b0;
		cos[1] <= 25'b0;
		cos[2] <= 25'b0;
		cos[3] <= 25'b0;
		cos[4] <= 25'b0;
		cos[5] <= 25'b0;
		cos[6] <= 25'b0;
		cos[7] <= 25'b0;
		sin[0] <= 25'b0;
		sin[1] <= 25'b0;
		sin[2] <= 25'b0;
		sin[3] <= 25'b0;
		sin[4] <= 25'b0;
		sin[5] <= 25'b0;
		sin[6] <= 25'b0;
		sin[7] <= 25'b0;
	end
	else
	begin
		current_state <= next_state;
		if((current_state == S51) || (current_state == S52))	counter <= counter + 12'd1;
		else													counter <= counter;
		if((counter == 12'd4095)&&(current_state == S52))	finish <= 1'b1;
		else					finish <= 1'b0;
		case(current_state)
			S2:
			begin
				if(cos_valid)	cos[0] <= cos_data;
				if(sin_valid)	sin[0] <= sin_data;
			end
			S3:
			begin
				if(cos_valid)	cos[1] <= cos_data;
				if(sin_valid)	sin[1] <= sin_data;
			end
			S4:
			begin
				if(cos_valid)	cos[2] <= cos_data;
				if(sin_valid)	
				begin
					if(sin_data[15:6] == 10'b11_1111_1111)	sin[2] <= {sin_data[24:16], 16'd0} + 25'b0_0000_0001_0000_0000_0000_0000;
					else									sin[2] <= sin_data;
				end
			end
			S5:
			begin
				if(cos_valid)	cos[3] <= cos_data;
				if(sin_valid)	sin[3] <= sin_data;
			end
			S6:
			begin
				if(cos_valid)
				begin
					if(cos_data[15:6] == 10'b00_0000_0000)	cos[4] <= {cos_data[24:16], 16'd0};
					else									cos[4] <= cos_data;
				end
				if(sin_valid)	sin[4] <= sin_data;
			end
			S7:
			begin
				if(cos_valid)	cos[5] <= cos_data;
				if(sin_valid)	sin[5] <= sin_data;
			end
			S8:
			begin
				if(cos_valid)	cos[6] <= cos_data;
				begin
					if(sin_data[15:6] == 10'b00_0000_0000)	sin[6] <= {sin_data[24:16], 16'd0};
					else									sin[6] <= sin_data;
				end
			end
			S9:
			begin
				if(cos_valid)	cos[7] <= cos_data;
				if(sin_valid)	sin[7] <= sin_data;
				lbp_data <= 8'd0;
			end
			S10:	gc <= gray_data;
			S11:	x1_y1_data <= gray_data;
			S12:	x1_y2_data <= gray_data;
			S13:	x2_y1_data <= gray_data;
			S14:	x2_y2_data <= gray_data;
			S15:
			begin
				if(LBP[23:0] > {gc, 16'd0})	lbp_data[0] <= 1'b1;
				else						lbp_data[0] <= 1'b0;
			end
			S16:	x1_y1_data <= gray_data;
			S17:	x1_y2_data <= gray_data;
			S18:	x2_y1_data <= gray_data;
			S19:	x2_y2_data <= gray_data;
			S20:
			begin
				if(LBP[23:0] > {gc, 16'd0})	lbp_data[1] <= 1'b1;
				else						lbp_data[1] <= 1'b0;
			end
			S21:	x1_y1_data <= gray_data;
			S22:	x1_y2_data <= gray_data;
			S23:	x2_y1_data <= gray_data;
			S24:	x2_y2_data <= gray_data;
			S25:
			begin
				if(LBP[23:0] > {gc, 16'd0})	lbp_data[2] <= 1'b1;
				else						lbp_data[2] <= 1'b0;
			end
			S26:	x1_y1_data <= gray_data;
			S27:	x1_y2_data <= gray_data;
			S28:	x2_y1_data <= gray_data;
			S29:	x2_y2_data <= gray_data;
			S30:
			begin
				if(LBP[23:0] > {gc, 16'd0})	lbp_data[3] <= 1'b1;
				else						lbp_data[3] <= 1'b0;
			end
			S31:	x1_y1_data <= gray_data;
			S32:	x1_y2_data <= gray_data;
			S33:	x2_y1_data <= gray_data;
			S34:	x2_y2_data <= gray_data;
			S35:
			begin
				if(LBP[23:0] > {gc, 16'd0})	lbp_data[4] <= 1'b1;
				else						lbp_data[4] <= 1'b0;
			end
			S36:	x1_y1_data <= gray_data;
			S37:	x1_y2_data <= gray_data;
			S38:	x2_y1_data <= gray_data;
			S39:	x2_y2_data <= gray_data;
			S40:
			begin
				if(LBP[23:0] > {gc, 16'd0})	lbp_data[5] <= 1'b1;
				else						lbp_data[5] <= 1'b0;
			end
			S41:	x1_y1_data <= gray_data;
			S42:	x1_y2_data <= gray_data;
			S43:	x2_y1_data <= gray_data;
			S44:	x2_y2_data <= gray_data;
			S45:
			begin
				if(LBP[23:0] > {gc, 16'd0})	lbp_data[6] <= 1'b1;
				else						lbp_data[6] <= 1'b0;
			end
			S46:	x1_y1_data <= gray_data;
			S47:	x1_y2_data <= gray_data;
			S48:	x2_y1_data <= gray_data;
			S49:	x2_y2_data <= gray_data;
			S50:
			begin
				if(LBP[23:0] > {gc, 16'd0})	lbp_data[7] <= 1'b1;
				else						lbp_data[7] <= 1'b0;
			end
			S51:	lbp_data <= lbp_data;
			S52:	lbp_data <= 8'd0;
			default:lbp_data <= 8'd0;
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
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			if(enable)	next_state = S1;
			else		next_state = S0;
		end
		S1:
		begin
			gray_addr = 12'd0;
			gray_OE = 1'b0;
			theta = 25'd0;
			theta_valid = 1'b1;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S2;
		end
		S2:
		begin
			gray_addr = 12'd0;
			gray_OE = 1'b0;
			theta = ((pi << 1) * 3'd1) >> 3;
			theta_valid = 1'b1;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S3;
		end
		S3:
		begin
			gray_addr = 12'd0;
			gray_OE = 1'b0;
			theta = ((pi << 1) * 3'd2) >> 3;
			theta_valid = 1'b1;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S4;
		end
		S4:
		begin
			gray_addr = 12'd0;
			gray_OE = 1'b0;
			theta = ((pi << 1) * 3'd3) >> 3;
			theta_valid = 1'b1;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S5;
		end
		S5:
		begin
			gray_addr = 12'd0;
			gray_OE = 1'b0;
			theta = ((pi << 1) * 3'd4) >> 3;
			theta_valid = 1'b1;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S6;
		end
		S6:
		begin
			gray_addr = 12'd0;
			gray_OE = 1'b0;
			theta = ((pi << 1) * 3'd5) >> 3;
			theta_valid = 1'b1;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S7;
		end
		S7:
		begin
			gray_addr = 12'd0;
			gray_OE = 1'b0;
			theta = ((pi << 1) * 3'd6) >> 3;
			theta_valid = 1'b1;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S8;
		end
		S8:
		begin
			gray_addr = 12'd0;
			gray_OE = 1'b0;
			theta = ((pi << 1) * 3'd7) >> 3;
			theta_valid = 1'b1;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S9;
		end
		S9://S1
		begin
			gray_addr = counter;
			gray_OE = 1'b0;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			if(((counter >= 12'd0)&&(counter <= 12'd191))||((counter >= 12'd3904)&&(counter <= 12'd4095))||(counter[5:0]==6'd0)||(counter[5:0]==6'd1)||(counter[5:0]==6'd2)||(counter[5:0]==6'd61)||(counter[5:0]==6'd62)||(counter[5:0]==6'd63))	next_state = S52;
			else	next_state = S10;
		end
		S10:
		begin
			gray_addr = counter + {{3{x1[0][7]}}, x1[0]} + ({{3{y1[0][7]}}, y1[0]} << 6);
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S11;
		end
		S11:
		begin
			gray_addr = counter + {{3{x1[0][7]}}, x1[0]} + ({{3{y2[0][7]}}, y2[0]} << 6);
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S12;
		end
		S12:
		begin
			gray_addr = counter + {{3{x2[0][7]}}, x2[0]} + ({{3{y1[0][7]}}, y1[0]} << 6);
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S13;
		end
		S13:
		begin
			gray_addr = counter + {{3{x2[0][7]}}, x2[0]} + ({{3{y2[0][7]}}, y2[0]} << 6);
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S14;
		end
		S14:
		begin
			gray_addr = 12'd0;
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S15;
		end
		S15:
		begin
			gray_addr = counter + {{3{x1[1][7]}}, x1[1]} + ({{3{y1[1][7]}}, y1[1]} << 6);
			gray_OE = 1'b0;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = x1_y1_data*w1[0] + x1_y2_data*w2[0] + x2_y1_data*w3[0] + x2_y2_data*w4[0];
			next_state = S16;
		end
		S16:
		begin
			gray_addr = counter + {{3{x1[1][7]}}, x1[1]} + ({{3{y2[1][7]}}, y2[1]} << 6);
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S17;
		end
		S17:
		begin
			gray_addr = counter + {{3{x2[1][7]}}, x2[1]} + ({{3{y1[1][7]}}, y1[1]} << 6);
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S18;
		end
		S18:
		begin
			gray_addr = counter + {{3{x2[1][7]}}, x2[1]} + ({{3{y2[1][7]}}, y2[1]} << 6);
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S19;
		end
		S19:
		begin
			gray_addr = 12'd0;
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S20;
		end
		S20:
		begin
			gray_addr = counter + {{3{x1[2][7]}}, x1[2]} + ({{3{y2[2][7]}}, y1[2]} << 6);
			gray_OE = 1'b0;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = x1_y1_data*w1[1] + x1_y2_data*w2[1] + x2_y1_data*w3[1] + x2_y2_data*w4[1];
			next_state = S21;
		end
		S21:
		begin
			gray_addr = counter + {{3{x1[2][7]}}, x1[2]} + ({{3{y2[2][7]}}, y2[2]} << 6);
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S22;
		end
		S22:
		begin
			gray_addr = counter + {{3{x2[2][7]}}, x2[2]} + ({{3{y1[2][7]}}, y1[2]} << 6);
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S23;
		end
		S23:
		begin
			gray_addr = counter + {{3{x2[2][7]}}, x2[2]} + ({{3{y2[2][7]}}, y2[2]} << 6);
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S24;
		end
		S24:
		begin
			gray_addr = 12'd0;
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S25;
		end
		S25:
		begin
			gray_addr = counter + {{3{x1[3][7]}}, x1[3]} + ({{3{y2[3][7]}}, y1[3]} << 6);
			gray_OE = 1'b0;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = x1_y1_data*w1[2] + x1_y2_data*w2[2] + x2_y1_data*w3[2] + x2_y2_data*w4[2];
			next_state = S26;
		end
		S26:
		begin
			gray_addr = counter + {{3{x1[3][7]}}, x1[3]} + ({{3{y2[3][7]}}, y2[3]} << 6);
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S27;
		end
		S27:
		begin
			gray_addr = counter + {{3{x2[3][7]}}, x2[3]} + ({{3{y1[3][7]}}, y1[3]} << 6);
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S28;
		end
		S28:
		begin
			gray_addr = counter + {{3{x2[3][7]}}, x2[3]} + ({{3{y2[3][7]}}, y2[3]} << 6);
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S29;
		end
		S29:
		begin
			gray_addr = 12'd0;
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S30;
		end
		S30:
		begin
			gray_addr = counter + {{3{x1[4][7]}}, x1[4]} + ({{3{y2[4][7]}}, y1[4]} << 6);
			gray_OE = 1'b0;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = x1_y1_data*w1[3] + x1_y2_data*w2[3] + x2_y1_data*w3[3] + x2_y2_data*w4[3];
			next_state = S31;
		end
		S31:
		begin
			gray_addr = counter + {{3{x1[4][7]}}, x1[4]} + ({{3{y2[4][7]}}, y2[4]} << 6);
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S32;
		end
		S32:
		begin
			gray_addr = counter + {{3{x2[4][7]}}, x2[4]} + ({{3{y1[4][7]}}, y1[4]} << 6);
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S33;
		end
		S33:
		begin
			gray_addr = counter + {{3{x2[4][7]}}, x2[4]} + ({{3{y2[4][7]}}, y2[4]} << 6);
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S34;
		end
		S34:
		begin
			gray_addr = 12'd0;
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S35;
		end
		S35:
		begin
			gray_addr = counter + {{3{x1[5][7]}}, x1[5]} + ({{3{y2[5][7]}}, y1[5]} << 6);
			gray_OE = 1'b0;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = x1_y1_data*w1[4] + x1_y2_data*w2[4] + x2_y1_data*w3[4] + x2_y2_data*w4[4];
			next_state = S36;
		end
		S36:
		begin
			gray_addr = counter + {{3{x1[5][7]}}, x1[5]} + ({{3{y2[5][7]}}, y2[5]} << 6);
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S37;
		end
		S37:
		begin
			gray_addr = counter + {{3{x2[5][7]}}, x2[5]} + ({{3{y1[5][7]}}, y1[5]} << 6);
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S38;
		end
		S38:
		begin
			gray_addr = counter + {{3{x2[5][7]}}, x2[5]} + ({{3{y2[5][7]}}, y2[5]} << 6);
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S39;
		end
		S39:
		begin
			gray_addr = 12'd0;
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S40;
		end
		S40:
		begin
			gray_addr = counter + {{3{x1[6][7]}}, x1[6]} + ({{3{y2[6][7]}}, y1[6]} << 6);
			gray_OE = 1'b0;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = x1_y1_data*w1[5] + x1_y2_data*w2[5] + x2_y1_data*w3[5] + x2_y2_data*w4[5];
			next_state = S41;
		end
		S41:
		begin
			gray_addr = counter + {{3{x1[6][7]}}, x1[6]} + ({{3{y2[6][7]}}, y2[6]} << 6);
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S42;
		end
		S42:
		begin
			gray_addr = counter + {{3{x2[6][7]}}, x2[6]} + ({{3{y1[6][7]}}, y1[6]} << 6);
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S43;
		end
		S43:
		begin
			gray_addr = counter + {{3{x2[6][7]}}, x2[6]} + ({{3{y2[6][7]}}, y2[6]} << 6);
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S44;
		end
		S44:
		begin
			gray_addr = 12'd0;
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S45;
		end
		S45:
		begin
			gray_addr = counter + {{3{x1[7][7]}}, x1[7]} + ({{3{y2[7][7]}}, y1[7]} << 6);
			gray_OE = 1'b0;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = x1_y1_data*w1[6] + x1_y2_data*w2[6] + x2_y1_data*w3[6] + x2_y2_data*w4[6];
			next_state = S46;
		end
		S46:
		begin
			gray_addr = counter + {{3{x1[7][7]}}, x1[7]} + ({{3{y2[7][7]}}, y2[7]} << 6);
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S47;
		end
		S47:
		begin
			gray_addr = counter + {{3{x2[7][7]}}, x2[7]} + ({{3{y1[7][7]}}, y1[7]} << 6);
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S48;
		end
		S48:
		begin
			gray_addr = counter + {{3{x2[7][7]}}, x2[7]} + ({{3{y2[7][7]}}, y2[7]} << 6);
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S49;
		end
		S49:
		begin
			gray_addr = 12'd0;
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S50;
		end
		S50:
		begin
			gray_addr = 12'd0;
			gray_OE = 1'b0;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = x1_y1_data*w1[7] + x1_y2_data*w2[7] + x2_y1_data*w3[7] + x2_y2_data*w4[7];
			next_state = S51;
		end
		S51:
		begin
			gray_addr = 12'd0;
			gray_OE = 1'b1;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = counter;
			lbp_WEN = 1'b1;
			LBP = 32'd0;
			next_state = S9;
		end
		S52:
		begin
			gray_addr = 12'd0;
			gray_OE = 1'b0;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = counter;
			lbp_WEN = 1'b1;
			LBP = 32'd0;
			if(counter == 12'd4095)	next_state = S0;
			else					next_state = S9;
		end
		default:
		begin
			gray_addr = 12'd0;
			gray_OE = 1'b0;
			theta = 25'd0;
			theta_valid = 1'b0;
			lbp_addr = 12'd0;
			lbp_WEN = 1'b0;
			LBP = 32'd0;
			next_state = S0;
		end
	endcase
end

always @ (*)
begin
	for(i=0; i<8; i=i+1)
	begin
		rx[i] = 3 * cos[i];
		ry[i] = (-3) * sin[i];
		if(rx[i][15:0] == 16'b0)
		begin
			x1[i] = rx[i][24:16];
			x2[i] = rx[i][24:16];
		end
		else
		begin
			x1[i] = rx[i][24:16];
			x2[i] = rx[i][24:16] + 9'd1;
		end
		if(ry[i][15:0] == 16'b0)
		begin
			y1[i] = ry[i][24:16];
			y2[i] = ry[i][24:16];
		end
		else
		begin
			y1[i] = ry[i][24:16];
			y2[i] = ry[i][24:16] + 9'd1;
		end
		tx[i] = rx[i] - {x1[i], 16'd0};
		ty[i] = ry[i] - {y1[i], 16'd0};
		multi1[i] = (25'b0_0000_0001_0000_0000_0000_0000 - tx[i]) * (25'b0_0000_0001_0000_0000_0000_0000 - ty[i]);
		multi2[i] = (tx[i]) * (25'b0_0000_0001_0000_0000_0000_0000 - ty[i]);
		multi3[i] = (25'b0_0000_0001_0000_0000_0000_0000 - tx[i]) * (ty[i]);
		multi4[i] = (tx[i]) * (ty[i]);
		w1[i] = multi1[i][40:16];
		w2[i] = multi2[i][40:16];
		w3[i] = multi3[i][40:16];
		w4[i] = multi4[i][40:16];
	end
end
endmodule
