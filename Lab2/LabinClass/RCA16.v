`include "RCA4.v"

module RCA16(
    input  [15:0] a,
    input  [15:0] b,
    output [15:0] sum,
    output overflow
);

// put your design here
wire [2:0] carry_wire;
wire cin, w1, w2;
assign cin = 1'b0;

RCA4 RCA4_0( .a(a[3:0]), .b(b[3:0]), .cin(cin), .sum(sum[3:0]), .cout(carry_wire[0]) );
RCA4 RCA4_1( .a(a[7:4]), .b(b[7:4]), .cin(carry_wire[0]), .sum(sum[7:4]), .cout(carry_wire[1]) );
RCA4 RCA4_2( .a(a[11:8]), .b(b[11:8]), .cin(carry_wire[1]), .sum(sum[11:8]), .cout(carry_wire[2]) );
RCA4 RCA4_3( .a(a[15:12]), .b(b[15:12]), .cin(carry_wire[2]), .sum(sum[15:12]), .cout() );

and (w1, ~a[15], ~b[15], sum[15]);
and (w2, a[15], b[15], ~sum[15]);
or (overflow, w1, w2);

endmodule
