`include "CLA8.v"

module CLA32(
    input  [31:0] a,
    input  [31:0] b,
    output [31:0] sum,
    output overflow);
	wire   Cin, w1, w2;
	wire [2:0] carry_wire;
	assign Cin = 1'b0;
	// put your design here
	CLA8 CLA8_0(.A(a[7:0]), .B(b[7:0]), .Cin(Cin), .Sum(sum[7:0]), .Cout(carry_wire[0]) );
	CLA8 CLA8_1(.A(a[15:8]), .B(b[15:8]), .Cin(carry_wire[0]), .Sum(sum[15:8]), .Cout(carry_wire[1]) );
	CLA8 CLA8_2(.A(a[23:16]), .B(b[23:16]), .Cin(carry_wire[1]), .Sum(sum[23:16]), .Cout(carry_wire[2]) );
	CLA8 CLA8_3(.A(a[31:24]), .B(b[31:24]), .Cin(carry_wire[2]), .Sum(sum[31:24]), .Cout() );

	// overflow
	and (w1, ~a[31], ~b[31], sum[31]);
	and (w2, a[31], b[31], ~sum[31]);
	or (overflow, w1, w2);

endmodule
