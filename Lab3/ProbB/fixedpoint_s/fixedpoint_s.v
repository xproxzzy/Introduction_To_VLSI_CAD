module fixedpoint_s(
    input  [7:0] in1, // signed integer[7:4], decimal[3:0]
    input  [7:0] in2, // signed integer[7:4], decimal[3:0]
    output reg  [7:0] out // 8 bit signed integer[7:0]
);
reg [15:0] product_abs;
reg [7:0] in1_abs, in2_abs, product_abs_rounding;
reg symbol; // (+) = 1'b0, (-) = 1'b1
always @ (*)
begin
	if((in1[7] == 1'b0) && (in2[7] == 1'b0))
	begin
		in1_abs = in1;
		in2_abs = in2;
		product_abs = in1_abs * in2_abs;
		symbol = 1'b0;
	end
	else if((in1[7] == 1'b1) && (in2[7] == 1'b0))
	begin
		in1_abs = ~in1 + 8'b1;
		in2_abs = in2;
		product_abs = in1_abs * in2_abs;
		symbol = 1'b1;
	end
	else if((in1[7] == 1'b0) && (in2[7] == 1'b1))
	begin
		in1_abs = in1;
		in2_abs = ~in2 + 8'b1;
		product_abs = in1_abs * in2_abs;
		symbol = 1'b1;
	end
	else
	begin
		in1_abs = ~in1 + 8'b1;
		in2_abs = ~in2 + 8'b1;
		product_abs = in1_abs * in2_abs;
		symbol = 1'b0;
	end
	
	if(product_abs[7] == 1'b1)
		product_abs_rounding[7:0] = product_abs[15:8] + 8'b1;
	else
		product_abs_rounding[7:0] = product_abs[15:8];

	if(symbol == 1'b1)
		out = ~product_abs_rounding + 8'b1;
	else
		out = product_abs_rounding;
end
endmodule
