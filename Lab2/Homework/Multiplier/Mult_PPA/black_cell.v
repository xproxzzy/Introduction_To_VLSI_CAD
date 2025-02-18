module black_cell(p1, p2, g1, g2, G, P);
input  p1, p2, g1, g2;
output G, P;
wire   and1;

// put your design here
	and (and1, p2, g1);
	or (G, g2, and1);
	and (P, p1, p2);

endmodule
