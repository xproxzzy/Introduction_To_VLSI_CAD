`define RGB_DataSize 24
`define D_DataSize 10
`include "Manhattan.v"
`include "Min.v"
`timescale 1ns/10ps

// ---------------------- define ---------------------- //

module top(clk,
           rst,
           clear,
           c_en,
           if_en,
           c_in0,
           c_in1,
           c_in2,
           c_in3,
           c_in4,
           c_in5,
           c_in6,
           c_in7,
           if_in,
           out_index,
           out_distance);

  // ---------------------- input  ---------------------- //
  input  clk;
  input  rst;
  input  clear;
  input  c_en;
  input  if_en;
  input  [`RGB_DataSize-1:0] c_in0, c_in1, c_in2, c_in3, c_in4, c_in5, c_in6, c_in7;
  input  [`RGB_DataSize-1:0] if_in;

  // ---------------------- output ---------------------- //
  output [`D_DataSize-1:0] out_distance;
  output [2:0] out_index;
  // ---------------------- Write down Your design below  ---------------------- //
wire [`D_DataSize-1:0] d_0, d_1, d_2, d_3, d_4, d_5, d_6, d_7;
Manhattan Manhattan(.clk(clk), .rst(rst), .clear(clear), .c_en(c_en), .if_en(if_en), 
.c_in0(c_in0), .c_in1(c_in1), .c_in2(c_in2), .c_in3(c_in3), .c_in4(c_in4), .c_in5(c_in5), .c_in6(c_in6), .c_in7(c_in7), 
.if_in(if_in), .d_0(d_0), .d_1(d_1), .d_2(d_2), .d_3(d_3), .d_4(d_4), .d_5(d_5), .d_6(d_6), .d_7(d_7));

Min Min(.d_0(d_0), .d_1(d_1), .d_2(d_2), .d_3(d_3), .d_4(d_4), .d_5(d_5), .d_6(d_6), .d_7(d_7), 
.out_index(out_index), .out_distance(out_distance));

endmodule
