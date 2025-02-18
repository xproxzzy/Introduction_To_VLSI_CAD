// ================================================ // 
//  Course:      IVCAD 2024 Spring                  //                       
//  Auther:      Zong-Jin CAI (Leo)                 //                         
//  Filename:    Multiplier_PPA.v                   //                               
//  Description: 8*8-bit Multiplier using PPA       //                 
//  Version:     1.0                                // 
//  Date:        2024/02/22                         //     
// ================================================ //    

`include "PPA8.v"

module Multiplier_PPA(
    input   [7:0]   A,
    input   [7:0]   B,
    output  [15:0]  Product
);
	// put your design here
	wire	[7:0]	and_out	[7:0];
	wire	[7:0]	Sum		[6:0];
	wire	[6:0]	Cout;
	wire   Cin;
	assign Cin = 1'b0;
	and (and_out[0][0], A[0], B[0]);
	and (and_out[0][1], A[1], B[0]);
	and (and_out[0][2], A[2], B[0]);
	and (and_out[0][3], A[3], B[0]);
	and (and_out[0][4], A[4], B[0]);
	and (and_out[0][5], A[5], B[0]);
	and (and_out[0][6], A[6], B[0]);
	and (and_out[0][7], A[7], B[0]);

	and (and_out[1][0], A[0], B[1]);
	and (and_out[1][1], A[1], B[1]);
	and (and_out[1][2], A[2], B[1]);
	and (and_out[1][3], A[3], B[1]);
	and (and_out[1][4], A[4], B[1]);
	and (and_out[1][5], A[5], B[1]);
	and (and_out[1][6], A[6], B[1]);
	and (and_out[1][7], A[7], B[1]);

	and (and_out[2][0], A[0], B[2]);
	and (and_out[2][1], A[1], B[2]);
	and (and_out[2][2], A[2], B[2]);
	and (and_out[2][3], A[3], B[2]);
	and (and_out[2][4], A[4], B[2]);
	and (and_out[2][5], A[5], B[2]);
	and (and_out[2][6], A[6], B[2]);
	and (and_out[2][7], A[7], B[2]);

	and (and_out[3][0], A[0], B[3]);
	and (and_out[3][1], A[1], B[3]);
	and (and_out[3][2], A[2], B[3]);
	and (and_out[3][3], A[3], B[3]);
	and (and_out[3][4], A[4], B[3]);
	and (and_out[3][5], A[5], B[3]);
	and (and_out[3][6], A[6], B[3]);
	and (and_out[3][7], A[7], B[3]);

	and (and_out[4][0], A[0], B[4]);
	and (and_out[4][1], A[1], B[4]);
	and (and_out[4][2], A[2], B[4]);
	and (and_out[4][3], A[3], B[4]);
	and (and_out[4][4], A[4], B[4]);
	and (and_out[4][5], A[5], B[4]);
	and (and_out[4][6], A[6], B[4]);
	and (and_out[4][7], A[7], B[4]);

	and (and_out[5][0], A[0], B[5]);
	and (and_out[5][1], A[1], B[5]);
	and (and_out[5][2], A[2], B[5]);
	and (and_out[5][3], A[3], B[5]);
	and (and_out[5][4], A[4], B[5]);
	and (and_out[5][5], A[5], B[5]);
	and (and_out[5][6], A[6], B[5]);
	and (and_out[5][7], A[7], B[5]);

	and (and_out[6][0], A[0], B[6]);
	and (and_out[6][1], A[1], B[6]);
	and (and_out[6][2], A[2], B[6]);
	and (and_out[6][3], A[3], B[6]);
	and (and_out[6][4], A[4], B[6]);
	and (and_out[6][5], A[5], B[6]);
	and (and_out[6][6], A[6], B[6]);
	and (and_out[6][7], A[7], B[6]);

	and (and_out[7][0], A[0], B[7]);
	and (and_out[7][1], A[1], B[7]);
	and (and_out[7][2], A[2], B[7]);
	and (and_out[7][3], A[3], B[7]);
	and (and_out[7][4], A[4], B[7]);
	and (and_out[7][5], A[5], B[7]);
	and (and_out[7][6], A[6], B[7]);
	and (and_out[7][7], A[7], B[7]);

	PPA8 PPA8_0(.A({1'b0, and_out[0][7:1]}), .B(and_out[1][7:0]), .Cin(Cin), .Sum(Sum[0][7:0]), .Cout(Cout[0]));
	PPA8 PPA8_1(.A({Cout[0], Sum[0][7:1]}), .B(and_out[2][7:0]), .Cin(Cin), .Sum(Sum[1][7:0]), .Cout(Cout[1]));
	PPA8 PPA8_2(.A({Cout[1], Sum[1][7:1]}), .B(and_out[3][7:0]), .Cin(Cin), .Sum(Sum[2][7:0]), .Cout(Cout[2]));
	PPA8 PPA8_3(.A({Cout[2], Sum[2][7:1]}), .B(and_out[4][7:0]), .Cin(Cin), .Sum(Sum[3][7:0]), .Cout(Cout[3]));
	PPA8 PPA8_4(.A({Cout[3], Sum[3][7:1]}), .B(and_out[5][7:0]), .Cin(Cin), .Sum(Sum[4][7:0]), .Cout(Cout[4]));
	PPA8 PPA8_5(.A({Cout[4], Sum[4][7:1]}), .B(and_out[6][7:0]), .Cin(Cin), .Sum(Sum[5][7:0]), .Cout(Cout[5]));
	PPA8 PPA8_6(.A({Cout[5], Sum[5][7:1]}), .B(and_out[7][7:0]), .Cin(Cin), .Sum(Sum[6][7:0]), .Cout(Cout[6]));
	
	assign Product[0] = and_out[0][0];
	assign Product[1] = Sum[0][0];
	assign Product[2] = Sum[1][0];
	assign Product[3] = Sum[2][0];
	assign Product[4] = Sum[3][0];
	assign Product[5] = Sum[4][0];
	assign Product[6] = Sum[5][0];
	assign Product[14:7] = Sum[6][7:0];
	assign Product[15] = Cout[6];

endmodule
