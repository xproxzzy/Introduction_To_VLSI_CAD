`include "black_cell.v"
`include "blue_cell.v"
`include "FA.v"

module PPA8(A, B, Cin, Sum, Cout);
	input  [7:0] A, B;
	input        Cin;
	output [7:0] Sum;
	output Cout;
	wire   [7:0] g;
	wire   [7:0] p;
	wire   [7:0] Q [7:0];
	wire   [5:0] P1;
	wire   [3:0] P2;
	// put your design here
	// p,g generation
	and (g[0], A[0], B[0]);
	and (g[1], A[1], B[1]);
	and (g[2], A[2], B[2]);
	and (g[3], A[3], B[3]);
	and (g[4], A[4], B[4]);
	and (g[5], A[5], B[5]);
	and (g[6], A[6], B[6]);
	and (g[7], A[7], B[7]);
	or (p[0], A[0], B[0]);
	or (p[1], A[1], B[1]);
	or (p[2], A[2], B[2]);
	or (p[3], A[3], B[3]);
	or (p[4], A[4], B[4]);
	or (p[5], A[5], B[5]);
	or (p[6], A[6], B[6]);
	or (p[7], A[7], B[7]);

	assign Q[0][0] = g[0];
	assign Q[1][1] = g[1];
	assign Q[2][2] = g[2];
	assign Q[3][3] = g[3];
	assign Q[4][4] = g[4];
	assign Q[5][5] = g[5];
	assign Q[6][6] = g[6];
	assign Q[7][7] = g[7];

	blue_cell blue_cell_2_1(.p2(p[1]), .g1(Q[0][0]), .g2(Q[1][1]), .G(Q[1][0]));
	black_cell black_cell_3_2(.p1(p[1]), .p2(p[2]), .g1(Q[1][1]), .g2(Q[2][2]), .G(Q[2][1]), .P(P1[0]));
	black_cell black_cell_4_3(.p1(p[2]), .p2(p[3]), .g1(Q[2][2]), .g2(Q[3][3]), .G(Q[3][2]), .P(P1[1]));
	black_cell black_cell_5_4(.p1(p[3]), .p2(p[4]), .g1(Q[3][3]), .g2(Q[4][4]), .G(Q[4][3]), .P(P1[2]));
	black_cell black_cell_6_5(.p1(p[4]), .p2(p[5]), .g1(Q[4][4]), .g2(Q[5][5]), .G(Q[5][4]), .P(P1[3]));
	black_cell black_cell_7_6(.p1(p[5]), .p2(p[6]), .g1(Q[5][5]), .g2(Q[6][6]), .G(Q[6][5]), .P(P1[4]));
	black_cell black_cell_8_7(.p1(p[6]), .p2(p[7]), .g1(Q[6][6]), .g2(Q[7][7]), .G(Q[7][6]), .P(P1[5]));

	blue_cell blue_cell_3_1(.p2(P1[0]), .g1(Q[0][0]), .g2(Q[2][1]), .G(Q[2][0]));
	blue_cell blue_cell_4_1(.p2(P1[1]), .g1(Q[1][0]), .g2(Q[3][2]), .G(Q[3][0]));
	black_cell black_cell_5_2(.p1(P1[0]), .p2(P1[2]), .g1(Q[2][1]), .g2(Q[4][3]), .G(Q[4][1]), .P(P2[0]));
	black_cell black_cell_6_3(.p1(P1[1]), .p2(P1[3]), .g1(Q[3][2]), .g2(Q[5][4]), .G(Q[5][2]), .P(P2[1]));
	black_cell black_cell_7_4(.p1(P1[2]), .p2(P1[4]), .g1(Q[4][3]), .g2(Q[6][5]), .G(Q[6][3]), .P(P2[2]));
	black_cell black_cell_8_5(.p1(P1[3]), .p2(P1[5]), .g1(Q[5][4]), .g2(Q[7][6]), .G(Q[7][4]), .P(P2[3]));

	blue_cell blue_cell_5_1(.p2(P2[0]), .g1(Q[0][0]), .g2(Q[4][1]), .G(Q[4][0]));
	blue_cell blue_cell_6_1(.p2(P2[1]), .g1(Q[1][0]), .g2(Q[5][2]), .G(Q[5][0]));
	blue_cell blue_cell_7_1(.p2(P2[2]), .g1(Q[2][0]), .g2(Q[6][3]), .G(Q[6][0]));
	blue_cell blue_cell_8_1(.p2(P2[3]), .g1(Q[3][0]), .g2(Q[7][4]), .G(Q[7][0]));

	// Sum
	FA FA0( .a(A[0]), .b(B[0]), .cin(Cin), .sum(Sum[0]), .cout() );
	FA FA1( .a(A[1]), .b(B[1]), .cin(Q[0][0]), .sum(Sum[1]), .cout() );
	FA FA2( .a(A[2]), .b(B[2]), .cin(Q[1][0]), .sum(Sum[2]), .cout() );
	FA FA3( .a(A[3]), .b(B[3]), .cin(Q[2][0]), .sum(Sum[3]), .cout() );
	FA FA4( .a(A[4]), .b(B[4]), .cin(Q[3][0]), .sum(Sum[4]), .cout() );
	FA FA5( .a(A[5]), .b(B[5]), .cin(Q[4][0]), .sum(Sum[5]), .cout() );
	FA FA6( .a(A[6]), .b(B[6]), .cin(Q[5][0]), .sum(Sum[6]), .cout() );
	FA FA7( .a(A[7]), .b(B[7]), .cin(Q[6][0]), .sum(Sum[7]), .cout(Cout) );
endmodule
