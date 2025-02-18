module LFSR(
	input clk,
	input rst,
	input seed_val,
	input [7:0] seed,//if rst=1, d=8'd0
	output reg [7:0] d// d[0] = (d[7]^d[5]) ^ (d[4] ^ d[2])
);
always @ (posedge clk)
begin
	if(rst == 1'b1)
	begin
		d <= 8'd0;
	end
	else if(seed_val == 1'b1)
	begin
		d <= seed;
	end
	else
	begin
		d[0] <= (d[7] ^ d[5]) ^ (d[4] ^ d[2]);
		d[1] <= d[0];
		d[2] <= d[1];
		d[3] <= d[2];
		d[4] <= d[3];
		d[5] <= d[4];
		d[6] <= d[5];
		d[7] <= d[6];
	end
end
endmodule
