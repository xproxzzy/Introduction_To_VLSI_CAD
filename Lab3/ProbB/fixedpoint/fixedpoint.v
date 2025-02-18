module fixedpoint(
    input [7:0] in1, // integer[7:5], decimal[4:0]
    input [7:0] in2, // integer[7:5], decimal[4:0]
    output reg [7:0] out // integer[7:2], decimal[1:0]
);
reg [15:0] product;
always @ (*)
begin
	product = in1 * in2;
	if(product[7] == 1'b1)
		out = product[15:8] + 8'b1;
	else
		out = product[15:8];
end
endmodule
