`include "HA.v"

module FA(
    input  a,
    input  b,
    input  cin, 
    output sum,
    output cout
);

	wire	w1, w2, w3;
	HA HA1(.a(a), .b(b), .cout(w2), .sum(w1));
	HA HA2(.a(cin), .b(w1), .cout(w3), .sum(sum));
	or (cout, w3, w2);

endmodule
