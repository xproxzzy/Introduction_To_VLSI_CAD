`include "FA.v"

module CLA8(A, B, Cin, Sum, Cout);

	input  [7:0] A;
	input  [7:0] B;
	input 	     Cin;
	output [7:0] Sum;
	output       Cout;
	wire   [6:0] g;
	wire   [6:0] p;
	wire   [7:0] C;
	wire   		 w1;
	wire   [1:0] w2;
	wire   [2:0] w3;
	wire   [3:0] w4;
	wire   [4:0] w5;
	wire   [5:0] w6;
	wire   [6:0] w7;
	// put your design here

	// p,g generation
	and (g[0], A[0], B[0]);
	and (g[1], A[1], B[1]);
	and (g[2], A[2], B[2]);
	and (g[3], A[3], B[3]);
	and (g[4], A[4], B[4]);
	and (g[5], A[5], B[5]);
	and (g[6], A[6], B[6]);
	or (p[0], A[0], B[0]);
	or (p[1], A[1], B[1]);
	or (p[2], A[2], B[2]);
	or (p[3], A[3], B[3]);
	or (p[4], A[4], B[4]);
	or (p[5], A[5], B[5]);
	or (p[6], A[6], B[6]);
	
	//C0
	assign C[0] = Cin;

	//C1
	and (w1, p[0], C[0]);
	or (C[1], g[0], w1);

	//C2
	and (w2[0], p[1], g[0]);
	and (w2[1], p[1], p[0], C[0]);
	or (C[2], g[1], w2[0], w2[1]);

	//C3
	and (w3[0], p[2], g[1]);
	and (w3[1], p[2], p[1], g[0]);
	and (w3[2], p[2], p[1], p[0], C[0]);
	or (C[3], g[2], w3[0], w3[1], w3[2]);

	//C4
	and (w4[0], p[3], g[2]);
	and (w4[1], p[3], p[2], g[1]);
	and (w4[2], p[3], p[2], p[1], g[0]);
	and (w4[3], p[3], p[2], p[1], p[0], C[0]);
	or (C[4], g[3], w4[0], w4[1], w4[2], w4[3]);

	//C5
	and (w5[0], p[4], g[3]);
	and (w5[1], p[4], p[3], g[2]);
	and (w5[2], p[4], p[3], p[2], g[1]);
	and (w5[3], p[4], p[3], p[2], p[1], g[0]);
	and (w5[4], p[4], p[3], p[2], p[1], p[0], C[0]);
	or (C[5], g[4], w5[0], w5[1], w5[2], w5[3], w5[4]);
	
	//C6
	and (w6[0], p[5], g[4]);
	and (w6[1], p[5], p[4], g[3]);
	and (w6[2], p[5], p[4], p[3], g[2]);
	and (w6[3], p[5], p[4], p[3], p[2], g[1]);
	and (w6[4], p[5], p[4], p[3], p[2], p[1], g[0]);
	and (w6[5], p[5], p[4], p[3], p[2], p[1], p[0], C[0]);
	or (C[6], g[5], w6[0], w6[1], w6[2], w6[3], w6[4], w6[5]);

	//C7
	and (w7[0], p[6], g[5]);
	and (w7[1], p[6], p[5], g[4]);
	and (w7[2], p[6], p[5], p[4], g[3]);
	and (w7[3], p[6], p[5], p[4], p[3], g[2]);
	and (w7[4], p[6], p[5], p[4], p[3], p[2], g[1]);
	and (w7[5], p[6], p[5], p[4], p[3], p[2], p[1], g[0]);
	and (w7[6], p[6], p[5], p[4], p[3], p[2], p[1], p[0], C[0]);
	or (C[7], g[6], w7[0], w7[1], w7[2], w7[3], w7[4], w7[5], w7[6]);

	// full adder
	FA FA0( .a(A[0]), .b(B[0]), .cin(C[0]), .sum(Sum[0]), .cout() );
	FA FA1( .a(A[1]), .b(B[1]), .cin(C[1]), .sum(Sum[1]), .cout() );
	FA FA2( .a(A[2]), .b(B[2]), .cin(C[2]), .sum(Sum[2]), .cout() );
	FA FA3( .a(A[3]), .b(B[3]), .cin(C[3]), .sum(Sum[3]), .cout() );
	FA FA4( .a(A[4]), .b(B[4]), .cin(C[4]), .sum(Sum[4]), .cout() );
	FA FA5( .a(A[5]), .b(B[5]), .cin(C[5]), .sum(Sum[5]), .cout() );
	FA FA6( .a(A[6]), .b(B[6]), .cin(C[6]), .sum(Sum[6]), .cout() );
	FA FA7( .a(A[7]), .b(B[7]), .cin(C[7]), .sum(Sum[7]), .cout(Cout) );

endmodule
