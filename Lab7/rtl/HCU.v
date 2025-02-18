module HCU(
    input               clk,
    input               rst,
    input               mode,
    input               enable,
    input   [3:0]       gridX,
    input   [3:0]       gridY,
    output  reg         lbp_ren,
    output  reg [11:0]  lbp_addr,
    input       [7:0]   lbp_rdata,

    output  reg         hist_wen_train,
    output  reg [7:0]   hist_wdata_train,
    output  reg [20:0]  hist_addr_train,
    output  reg         hist_ren_train,
    input   [7:0]       hist_rdata_train,

    output  reg         hist_wen_predict,
    output  reg [7:0]   hist_wdata_predict,
    output  reg [13:0]  hist_addr_predict,
    output  reg         hist_ren_predict,
    input   [7:0]       hist_rdata_predict,

    output  reg         done
);

// put your design here
parameter [2:0] S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100;
reg [2:0]	current_state, next_state;
reg [13:0]	counter_zero;
reg [5:0]	counter;
reg [5:0]	grid;
reg [5:0]	picture;
reg [20:0]	hist_addr_train_record;
reg [13:0]	hist_addr_predict_record;

always @ (posedge clk or posedge rst)
begin
	if(rst)
	begin
		current_state <= S0;
		counter_zero <= 14'd0;
		counter <= 6'd0;
		grid <= 6'd0;
		picture <= 6'd0;
		hist_addr_train_record <= 21'd0;
		hist_addr_predict_record <= 14'd0;
		done <= 1'b0;
	end
	else
	begin
		current_state <= next_state;
		if(current_state == S1)
		begin
			if(counter_zero == 14'd16383)	counter_zero <= 14'd0;
			else							counter_zero <= counter_zero + 14'd1;
		end
		if(current_state == S4)
		begin
			if(counter == 6'd63)
			begin
				counter <= 6'd0;
				if(grid == 6'd63)
				begin
					grid <= 6'd0;
					picture <= picture + 6'd1;
					done <= 1'b1;
				end
				else
				begin
					grid <= grid + 6'd1;
					done <= 1'b0;
				end
			end
			else
			begin
				counter <= counter + 6'd1;
				grid <= grid;
				done <= 1'b0;
			end
		end
		else	done <= 1'b0;
		if(current_state == S3)
		begin
			if(mode == 1'b0)	hist_addr_train_record <= hist_addr_train;
			else				hist_addr_predict_record <= hist_addr_predict;
		end
	end
end
always @ (*)
begin
    case(current_state)
		S0://idle
		begin
			lbp_ren = 1'b0;
			lbp_addr = 12'd0;
			hist_wen_train = 1'b0;
			hist_wdata_train = 8'd0;
			hist_addr_train = 21'd0;
			hist_ren_train = 1'b0;
			hist_wen_predict = 1'b0;
			hist_wdata_predict = 8'd0;
			hist_addr_predict = 14'd0;
			hist_ren_predict = 1'b0;
			if(enable)	next_state = S1;
			else		next_state = S0;
		end
		S1://zero
		begin
			lbp_ren = 1'b0;
			lbp_addr = 12'd0;
			if(mode == 1'b0)
			begin
				hist_wen_train = 1'b1;
				hist_wdata_train = 8'd0;
				hist_addr_train = counter_zero + (picture << 14);
				hist_ren_train = 1'b0;
				hist_wen_predict = 1'b0;
				hist_wdata_predict = 8'd0;
				hist_addr_predict = 14'd0;
				hist_ren_predict = 1'b0;
			end
			else
			begin
				hist_wen_train = 1'b0;
				hist_wdata_train = 8'd0;
				hist_addr_train = 21'd0;
				hist_ren_train = 1'b0;
				hist_wen_predict = 1'b1;
				hist_wdata_predict = 8'd0;
				hist_addr_predict = counter_zero;
				hist_ren_predict = 1'b0;
			end
			if(counter_zero == 14'd16383)	next_state = S2;
			else							next_state = S1;
		end
		S2:
		begin
			lbp_ren = 1'b0;
			if((grid>=6'd0) && (grid<=6'd7))
			begin
				if((counter>=6'd0) && (counter<=6'd7))			lbp_addr = {6'd0,counter} + {6'd0,(grid<<3)};
				else if((counter>=6'd8) && (counter<=6'd15))	lbp_addr = {6'd0,counter} + 12'd56 + {6'd0,(grid<<3)};
				else if((counter>=6'd16) && (counter<=6'd23))	lbp_addr = {6'd0,counter} + 12'd112 + {6'd0,(grid<<3)};
				else if((counter>=6'd24) && (counter<=6'd31))	lbp_addr = {6'd0,counter} + 12'd168 + {6'd0,(grid<<3)};
				else if((counter>=6'd32) && (counter<=6'd39))	lbp_addr = {6'd0,counter} + 12'd224 + {6'd0,(grid<<3)};
				else if((counter>=6'd40) && (counter<=6'd47))	lbp_addr = {6'd0,counter} + 12'd280 + {6'd0,(grid<<3)};
				else if((counter>=6'd48) && (counter<=6'd55))	lbp_addr = {6'd0,counter} + 12'd336 + {6'd0,(grid<<3)};
				else if((counter>=6'd56) && (counter<=6'd63))	lbp_addr = {6'd0,counter} + 12'd392 + {6'd0,(grid<<3)};
				else											lbp_addr = 12'd0;
			end
			else if((grid>=6'd8) && (grid<=6'd15))
			begin
				if((counter>=6'd0) && (counter<=6'd7))			lbp_addr = {6'd0,counter} + 12'd512 + {6'd0,((grid - 6'd8)<<3)};
				else if((counter>=6'd8) && (counter<=6'd15))	lbp_addr = {6'd0,counter} + 12'd512 + 12'd56 + {6'd0,((grid - 6'd8)<<3)};
				else if((counter>=6'd16) && (counter<=6'd23))	lbp_addr = {6'd0,counter} + 12'd512 + 12'd112 + {6'd0,((grid - 6'd8)<<3)};
				else if((counter>=6'd24) && (counter<=6'd31))	lbp_addr = {6'd0,counter} + 12'd512 + 12'd168 + {6'd0,((grid - 6'd8)<<3)};
				else if((counter>=6'd32) && (counter<=6'd39))	lbp_addr = {6'd0,counter} + 12'd512 + 12'd224 + {6'd0,((grid - 6'd8)<<3)};
				else if((counter>=6'd40) && (counter<=6'd47))	lbp_addr = {6'd0,counter} + 12'd512 + 12'd280 + {6'd0,((grid - 6'd8)<<3)};
				else if((counter>=6'd48) && (counter<=6'd55))	lbp_addr = {6'd0,counter} + 12'd512 + 12'd336 + {6'd0,((grid - 6'd8)<<3)};
				else if((counter>=6'd56) && (counter<=6'd63))	lbp_addr = {6'd0,counter} + 12'd512 + 12'd392 + {6'd0,((grid - 6'd8)<<3)};
				else											lbp_addr = 12'd0;
			end
			else if((grid>=6'd16) && (grid<=6'd23))
			begin
				if((counter>=6'd0) && (counter<=6'd7))			lbp_addr = {6'd0,counter} + 12'd1024 + {6'd0,((grid - 6'd16)<<3)};
				else if((counter>=6'd8) && (counter<=6'd15))	lbp_addr = {6'd0,counter} + 12'd1024 + 12'd56 + {6'd0,((grid - 6'd16)<<3)};
				else if((counter>=6'd16) && (counter<=6'd23))	lbp_addr = {6'd0,counter} + 12'd1024 + 12'd112 + {6'd0,((grid - 6'd16)<<3)};
				else if((counter>=6'd24) && (counter<=6'd31))	lbp_addr = {6'd0,counter} + 12'd1024 + 12'd168 + {6'd0,((grid - 6'd16)<<3)};
				else if((counter>=6'd32) && (counter<=6'd39))	lbp_addr = {6'd0,counter} + 12'd1024 + 12'd224 + {6'd0,((grid - 6'd16)<<3)};
				else if((counter>=6'd40) && (counter<=6'd47))	lbp_addr = {6'd0,counter} + 12'd1024 + 12'd280 + {6'd0,((grid - 6'd16)<<3)};
				else if((counter>=6'd48) && (counter<=6'd55))	lbp_addr = {6'd0,counter} + 12'd1024 + 12'd336 + {6'd0,((grid - 6'd16)<<3)};
				else if((counter>=6'd56) && (counter<=6'd63))	lbp_addr = {6'd0,counter} + 12'd1024 + 12'd392 + {6'd0,((grid - 6'd16)<<3)};
				else											lbp_addr = 12'd0;
			end
			else if((grid>=6'd24) && (grid<=6'd31))
			begin
				if((counter>=6'd0) && (counter<=6'd7))			lbp_addr = {6'd0,counter} + 12'd1536 + {6'd0,((grid - 6'd24)<<3)};
				else if((counter>=6'd8) && (counter<=6'd15))	lbp_addr = {6'd0,counter} + 12'd1536 + 12'd56 + {6'd0,((grid - 6'd24)<<3)};
				else if((counter>=6'd16) && (counter<=6'd23))	lbp_addr = {6'd0,counter} + 12'd1536 + 12'd112 + {6'd0,((grid - 6'd24)<<3)};
				else if((counter>=6'd24) && (counter<=6'd31))	lbp_addr = {6'd0,counter} + 12'd1536 + 12'd168 + {6'd0,((grid - 6'd24)<<3)};
				else if((counter>=6'd32) && (counter<=6'd39))	lbp_addr = {6'd0,counter} + 12'd1536 + 12'd224 + {6'd0,((grid - 6'd24)<<3)};
				else if((counter>=6'd40) && (counter<=6'd47))	lbp_addr = {6'd0,counter} + 12'd1536 + 12'd280 + {6'd0,((grid - 6'd24)<<3)};
				else if((counter>=6'd48) && (counter<=6'd55))	lbp_addr = {6'd0,counter} + 12'd1536 + 12'd336 + {6'd0,((grid - 6'd24)<<3)};
				else if((counter>=6'd56) && (counter<=6'd63))	lbp_addr = {6'd0,counter} + 12'd1536 + 12'd392 + {6'd0,((grid - 6'd24)<<3)};
				else											lbp_addr = 12'd0;
			end
			else if((grid>=6'd32) && (grid<=6'd39))
			begin
				if((counter>=6'd0) && (counter<=6'd7))			lbp_addr = {6'd0,counter} + 12'd2048 + {6'd0,((grid - 6'd32)<<3)};
				else if((counter>=6'd8) && (counter<=6'd15))	lbp_addr = {6'd0,counter} + 12'd2048 + 12'd56 + {6'd0,((grid - 6'd32)<<3)};
				else if((counter>=6'd16) && (counter<=6'd23))	lbp_addr = {6'd0,counter} + 12'd2048 + 12'd112 + {6'd0,((grid - 6'd32)<<3)};
				else if((counter>=6'd24) && (counter<=6'd31))	lbp_addr = {6'd0,counter} + 12'd2048 + 12'd168 + {6'd0,((grid - 6'd32)<<3)};
				else if((counter>=6'd32) && (counter<=6'd39))	lbp_addr = {6'd0,counter} + 12'd2048 + 12'd224 + {6'd0,((grid - 6'd32)<<3)};
				else if((counter>=6'd40) && (counter<=6'd47))	lbp_addr = {6'd0,counter} + 12'd2048 + 12'd280 + {6'd0,((grid - 6'd32)<<3)};
				else if((counter>=6'd48) && (counter<=6'd55))	lbp_addr = {6'd0,counter} + 12'd2048 + 12'd336 + {6'd0,((grid - 6'd32)<<3)};
				else if((counter>=6'd56) && (counter<=6'd63))	lbp_addr = {6'd0,counter} + 12'd2048 + 12'd392 + {6'd0,((grid - 6'd32)<<3)};
				else											lbp_addr = 12'd0;
			end
			else if((grid>=6'd40) && (grid<=6'd47))
			begin
				if((counter>=6'd0) && (counter<=6'd7))			lbp_addr = {6'd0,counter} + 12'd2560 + {6'd0,((grid - 6'd40)<<3)};
				else if((counter>=6'd8) && (counter<=6'd15))	lbp_addr = {6'd0,counter} + 12'd2560 + 12'd56 + {6'd0,((grid - 6'd40)<<3)};
				else if((counter>=6'd16) && (counter<=6'd23))	lbp_addr = {6'd0,counter} + 12'd2560 + 12'd112 + {6'd0,((grid - 6'd40)<<3)};
				else if((counter>=6'd24) && (counter<=6'd31))	lbp_addr = {6'd0,counter} + 12'd2560 + 12'd168 + {6'd0,((grid - 6'd40)<<3)};
				else if((counter>=6'd32) && (counter<=6'd39))	lbp_addr = {6'd0,counter} + 12'd2560 + 12'd224 + {6'd0,((grid - 6'd40)<<3)};
				else if((counter>=6'd40) && (counter<=6'd47))	lbp_addr = {6'd0,counter} + 12'd2560 + 12'd280 + {6'd0,((grid - 6'd40)<<3)};
				else if((counter>=6'd48) && (counter<=6'd55))	lbp_addr = {6'd0,counter} + 12'd2560 + 12'd336 + {6'd0,((grid - 6'd40)<<3)};
				else if((counter>=6'd56) && (counter<=6'd63))	lbp_addr = {6'd0,counter} + 12'd2560 + 12'd392 + {6'd0,((grid - 6'd40)<<3)};
				else											lbp_addr = 12'd0;
			end
			else if((grid>=6'd48) && (grid<=6'd55))
			begin
				if((counter>=6'd0) && (counter<=6'd7))			lbp_addr = {6'd0,counter} + 12'd3072 + {6'd0,((grid - 6'd48)<<3)};
				else if((counter>=6'd8) && (counter<=6'd15))	lbp_addr = {6'd0,counter} + 12'd3072 + 12'd56 + {6'd0,((grid - 6'd48)<<3)};
				else if((counter>=6'd16) && (counter<=6'd23))	lbp_addr = {6'd0,counter} + 12'd3072 + 12'd112 + {6'd0,((grid - 6'd48)<<3)};
				else if((counter>=6'd24) && (counter<=6'd31))	lbp_addr = {6'd0,counter} + 12'd3072 + 12'd168 + {6'd0,((grid - 6'd48)<<3)};
				else if((counter>=6'd32) && (counter<=6'd39))	lbp_addr = {6'd0,counter} + 12'd3072 + 12'd224 + {6'd0,((grid - 6'd48)<<3)};
				else if((counter>=6'd40) && (counter<=6'd47))	lbp_addr = {6'd0,counter} + 12'd3072 + 12'd280 + {6'd0,((grid - 6'd48)<<3)};
				else if((counter>=6'd48) && (counter<=6'd55))	lbp_addr = {6'd0,counter} + 12'd3072 + 12'd336 + {6'd0,((grid - 6'd48)<<3)};
				else if((counter>=6'd56) && (counter<=6'd63))	lbp_addr = {6'd0,counter} + 12'd3072 + 12'd392 + {6'd0,((grid - 6'd48)<<3)};
				else											lbp_addr = 12'd0;
			end
			else if((grid>=6'd56) && (grid<=6'd63))
			begin
				if((counter>=6'd0) && (counter<=6'd7))			lbp_addr = {6'd0,counter} + 12'd3584 + {6'd0,((grid - 6'd56)<<3)};
				else if((counter>=6'd8) && (counter<=6'd15))	lbp_addr = {6'd0,counter} + 12'd3584 + 12'd56 + {6'd0,((grid - 6'd56)<<3)};
				else if((counter>=6'd16) && (counter<=6'd23))	lbp_addr = {6'd0,counter} + 12'd3584 + 12'd112 + {6'd0,((grid - 6'd56)<<3)};
				else if((counter>=6'd24) && (counter<=6'd31))	lbp_addr = {6'd0,counter} + 12'd3584 + 12'd168 + {6'd0,((grid - 6'd56)<<3)};
				else if((counter>=6'd32) && (counter<=6'd39))	lbp_addr = {6'd0,counter} + 12'd3584 + 12'd224 + {6'd0,((grid - 6'd56)<<3)};
				else if((counter>=6'd40) && (counter<=6'd47))	lbp_addr = {6'd0,counter} + 12'd3584 + 12'd280 + {6'd0,((grid - 6'd56)<<3)};
				else if((counter>=6'd48) && (counter<=6'd55))	lbp_addr = {6'd0,counter} + 12'd3584 + 12'd336 + {6'd0,((grid - 6'd56)<<3)};
				else if((counter>=6'd56) && (counter<=6'd63))	lbp_addr = {6'd0,counter} + 12'd3584 + 12'd392 + {6'd0,((grid - 6'd56)<<3)};
				else											lbp_addr = 12'd0;
			end
			else												lbp_addr = 12'd0;
			hist_wen_train = 1'b0;
			hist_wdata_train = 8'd0;
			hist_addr_train = 21'd0;
			hist_ren_train = 1'b0;
			hist_wen_predict = 1'b0;
			hist_wdata_predict = 8'd0;
			hist_addr_predict = 14'd0;
			hist_ren_predict = 1'b0;
			next_state = S3;
		end
		S3:
		begin
			lbp_ren = 1'b1;
			lbp_addr = 12'd0;
			if(mode == 1'b0)
			begin
				hist_wen_train = 1'b0;
				hist_wdata_train = 8'd0;
				hist_addr_train = lbp_rdata + (grid << 8) + (picture << 14);
				hist_ren_train = 1'b0;

				hist_wen_predict = 1'b0;
				hist_wdata_predict = 8'd0;
				hist_addr_predict = 14'd0;
				hist_ren_predict = 1'b0;
			end
			else
			begin
				hist_wen_train = 1'b0;
				hist_wdata_train = 8'd0;
				hist_addr_train = 21'd0;
				hist_ren_train = 1'b0;

				hist_wen_predict = 1'b0;
				hist_wdata_predict = 8'd0;
				hist_addr_predict = lbp_rdata + (grid << 8);
				hist_ren_predict = 1'b0;
			end
			next_state = S4;
		end
		S4:
		begin
			lbp_ren = 1'b0;
			lbp_addr = 12'd0;
			if(mode == 1'b0)
			begin
				hist_wen_train = 1'b1;
				hist_wdata_train = hist_rdata_train + 8'd1;
				hist_addr_train = hist_addr_train_record;
				hist_ren_train = 1'b1;

				hist_wen_predict = 1'b0;
				hist_wdata_predict = 8'd0;
				hist_addr_predict = 14'd0;
				hist_ren_predict = 1'b0;
			end
			else
			begin
				hist_wen_train = 1'b0;
				hist_wdata_train = 8'd0;
				hist_addr_train = 21'd0;
				hist_ren_train = 1'b0;

				hist_wen_predict = 1'b1;
				hist_wdata_predict = hist_rdata_predict + 8'd1;
				hist_addr_predict = hist_addr_predict_record;
				hist_ren_predict = 1'b1;
			end
			if((grid==6'd63)&&(counter==6'd63))	next_state = S0;
			else								next_state = S2;
		end
		default:
		begin
			lbp_ren = 1'b0;
			lbp_addr = 12'd0;
			hist_wen_train = 1'b0;
			hist_wdata_train = 8'd0;
			hist_addr_train = 21'd0;
			hist_ren_train = 1'b0;
			hist_wen_predict = 1'b0;
			hist_wdata_predict = 8'd0;
			hist_addr_predict = 14'd0;
			hist_ren_predict = 1'b0;
			next_state = S0;
		end
	endcase
end
endmodule
