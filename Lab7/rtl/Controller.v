module Controller(
    input               clk,
    input               rst,
    input               mode,
    input               enable,
    input               valid,
    input   [4:0]       id,

    // ID RAM 
    output  reg [7:0]   id_addr,
    output  reg [4:0]   id_wdata,
    output  reg         id_wen,

    // CLBP I/O
	output	reg			lbp_enable,
	input   			lbp_finish,
	output  reg			ram_clbp,
	
    // HCU I/O
    input   [3:0]       gridX_i,     
    input   [3:0]       gridY_i,        
    output  reg         hcu_enable,
    output  reg [3:0]   gridX_o,
    output  reg [3:0]   gridY_o,  
    input               hcu_finish,      
    // Comparator I/O
    input               comparator_finish,
    output  reg         comparator_enable,
    output  reg         ram_comp
);

// put your design here
parameter [2:0] S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100, S5=3'b101, S6=3'b110, S7=3'b111;
reg [2:0]	current_state, next_state;
always @ (posedge clk or posedge rst)
begin
	if(rst)
	begin
		current_state <= S0;
		id_addr <= 8'd0;
		id_wdata <= 5'd0;
	end
	else
	begin
		current_state <= next_state;
		if(mode == 1'b0)
		begin
			if((current_state == S5)&&(hcu_finish == 1'b1))	id_addr <= id_addr + 8'd1;
			else											id_addr <= id_addr;
			if(valid)	id_wdata <= id;
			else		id_wdata <= id_wdata;
		end
	end
end
always @ (*)
begin
	gridX_o = 4'd8;
	gridY_o = 4'd8;
	case(current_state)
	S0://idle
	begin
		lbp_enable = 1'b0;
		hcu_enable = 1'b0;
		comparator_enable = 1'b0;
		ram_clbp = 1'b0;
		ram_comp = 1'b0;
		id_wen = 1'b0;
		if(enable)		next_state = S1;
		else			next_state = S0;
	end
	S1:
	begin
		lbp_enable = 1'b0;
		hcu_enable = 1'b0;
		comparator_enable = 1'b0;
		ram_clbp = 1'b0;
		ram_comp = 1'b0;
		if(mode == 1'b0)
		begin
			if(valid)	id_wen = 1'b1;
			else		id_wen = 1'b0;
		end
		else	id_wen = 1'b0;
		if(valid)	next_state = S2;
		else		next_state = S1;
	end
	S2://CLBP
	begin
		lbp_enable = 1'b1;
		hcu_enable = 1'b0;
		comparator_enable = 1'b0;
		ram_clbp = 1'b0;
		ram_comp = 1'b0;
		if(mode == 1'b0)
		begin
			if(valid)	id_wen = 1'b1;
			else		id_wen = 1'b0;
		end
		else	id_wen = 1'b0;
		next_state = S3;
	end
	S3:
	begin
		lbp_enable = 1'b0;
		hcu_enable = 1'b0;
		comparator_enable = 1'b0;
		ram_clbp = 1'b0;
		ram_comp = 1'b0;
		if(mode == 1'b0)
		begin
			if(valid)	id_wen = 1'b1;
			else		id_wen = 1'b0;
		end
		else	id_wen = 1'b0;
		if(lbp_finish)	next_state = S4;
		else			next_state = S3;
	end
	S4://HCU
	begin
		lbp_enable = 1'b0;
		hcu_enable = 1'b1;
		comparator_enable = 1'b0;
		ram_clbp = 1'b1;
		ram_comp = 1'b0;
		if(mode == 1'b0)
		begin
			if(valid)	id_wen = 1'b1;
			else		id_wen = 1'b0;
		end
		else	id_wen = 1'b0;
		next_state = S5;
	end
	S5:
	begin
		lbp_enable = 1'b0;
		hcu_enable = 1'b0;
		comparator_enable = 1'b0;
		ram_clbp = 1'b1;
		ram_comp = 1'b0;
		if(mode == 1'b0)
		begin
			if(valid)	id_wen = 1'b1;
			else		id_wen = 1'b0;
		end
		else	id_wen = 1'b0;
		if(mode == 1'b0)
		begin
			if(hcu_finish)	next_state = S1;
			else			next_state = S5;
		end
		else
		begin
			if(hcu_finish)	next_state = S6;
			else			next_state = S5;
		end
	end
	S6://Comparator
	begin
		lbp_enable = 1'b0;
		hcu_enable = 1'b0;
		comparator_enable = 1'b1;
		ram_clbp = 1'b0;
		ram_comp = 1'b1;
		id_wen = 1'b0;
		next_state = S7;
	end
	S7:
	begin
		lbp_enable = 1'b0;
		hcu_enable = 1'b0;
		comparator_enable = 1'b0;
		ram_clbp = 1'b0;
		ram_comp = 1'b1;
		id_wen = 1'b0;
		if(comparator_finish)	next_state = S1;
		else					next_state = S7;
	end
	endcase
end
endmodule
