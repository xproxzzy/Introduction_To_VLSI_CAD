module blue_cell(p2, g1, g2, G);
input  p2, g1, g2;
output G;
wire   and1;

// put your design here
	and (and1, p2, g1);
	or (G, g2, and1);

endmodule
