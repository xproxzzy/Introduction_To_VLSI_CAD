`timescale 1ns/10ps
`define RGB_DataSize 24
`define D_DataSize   10
// ---------------------- define ---------------------- //

module Manhattan(clk,
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
                 d_0,
                 d_1,
                 d_2,
                 d_3,
                 d_4,
                 d_5,
                 d_6,
                 d_7);

  // ---------------------- input  ---------------------- //
  input  clk;
  input  rst;
  input  clear;
  input  c_en;
  input  if_en;
  input  [`RGB_DataSize-1:0] c_in0, c_in1, c_in2, c_in3, c_in4, c_in5, c_in6, c_in7;
  input  [`RGB_DataSize-1:0] if_in;

  // ---------------------- output ---------------------- //
  output [`D_DataSize-1:0]   d_0, d_1, d_2, d_3, d_4, d_5, d_6, d_7;

  // ---------------------- Write down Your design below  ---------------------- //
reg [`D_DataSize-1:0]   d_0, d_1, d_2, d_3, d_4, d_5, d_6, d_7;
reg [`RGB_DataSize-1:0]   c_in0_store, c_in1_store, c_in2_store, c_in3_store, c_in4_store, c_in5_store, c_in6_store, c_in7_store;
reg [`RGB_DataSize-1:0]   if_in_store;
always @ (posedge clk)
begin
    if(clear == 1'b1)
	begin
		c_in0_store <= 24'b0;
		c_in1_store <= 24'b0;
		c_in2_store <= 24'b0;
		c_in3_store <= 24'b0;
		c_in4_store <= 24'b0;
		c_in5_store <= 24'b0;
		c_in6_store <= 24'b0;
		c_in7_store <= 24'b0;
		if_in_store <= 24'b0;
    end
    else
    begin
        if(c_en == 1'b1)
	    begin
			c_in0_store <= c_in0;
			c_in1_store <= c_in1;
			c_in2_store <= c_in2;
			c_in3_store <= c_in3;
			c_in4_store <= c_in4;
			c_in5_store <= c_in5;
			c_in6_store <= c_in6;
			c_in7_store <= c_in7;
        end
		else
		begin
			c_in0_store <= c_in0_store;
			c_in1_store <= c_in1_store;
			c_in2_store <= c_in2_store;
			c_in3_store <= c_in3_store;
			c_in4_store <= c_in4_store;
			c_in5_store <= c_in5_store;
			c_in6_store <= c_in6_store;
			c_in7_store <= c_in7_store;
		end
		if(if_en == 1'b1)
	    begin
			if_in_store <= if_in;
        end
		else
		begin
			if_in_store <= if_in_store;
		end
    end
end
always @ (*)
begin
	if(rst == 1'b1)
	begin
		d_0 = 10'b0;
		d_1 = 10'b0;
		d_2 = 10'b0;
		d_3 = 10'b0;
		d_4 = 10'b0;
		d_5 = 10'b0;
		d_6 = 10'b0;
		d_7 = 10'b0;
	end
	else
	begin
		d_0 = ((if_in_store[7:0]>c_in0_store[7:0])?if_in_store[7:0]-c_in0_store[7:0]:c_in0_store[7:0]-if_in_store[7:0]) +
			  ((if_in_store[15:8]>c_in0_store[15:8])?if_in_store[15:8]-c_in0_store[15:8]:c_in0_store[15:8]-if_in_store[15:8]) +
			  ((if_in_store[23:16]>c_in0_store[23:16])?if_in_store[23:16]-c_in0_store[23:16]:c_in0_store[23:16]-if_in_store[23:16]);
		d_1 = ((if_in_store[7:0]>c_in1_store[7:0])?if_in_store[7:0]-c_in1_store[7:0]:c_in1_store[7:0]-if_in_store[7:0]) +
			  ((if_in_store[15:8]>c_in1_store[15:8])?if_in_store[15:8]-c_in1_store[15:8]:c_in1_store[15:8]-if_in_store[15:8]) +
			  ((if_in_store[23:16]>c_in1_store[23:16])?if_in_store[23:16]-c_in1_store[23:16]:c_in1_store[23:16]-if_in_store[23:16]);
		d_2 = ((if_in_store[7:0]>c_in2_store[7:0])?if_in_store[7:0]-c_in2_store[7:0]:c_in2_store[7:0]-if_in_store[7:0]) +
			  ((if_in_store[15:8]>c_in2_store[15:8])?if_in_store[15:8]-c_in2_store[15:8]:c_in2_store[15:8]-if_in_store[15:8]) +
			  ((if_in_store[23:16]>c_in2_store[23:16])?if_in_store[23:16]-c_in2_store[23:16]:c_in2_store[23:16]-if_in_store[23:16]);
		d_3 = ((if_in_store[7:0]>c_in3_store[7:0])?if_in_store[7:0]-c_in3_store[7:0]:c_in3_store[7:0]-if_in_store[7:0]) +
			  ((if_in_store[15:8]>c_in3_store[15:8])?if_in_store[15:8]-c_in3_store[15:8]:c_in3_store[15:8]-if_in_store[15:8]) +
			  ((if_in_store[23:16]>c_in3_store[23:16])?if_in_store[23:16]-c_in3_store[23:16]:c_in3_store[23:16]-if_in_store[23:16]);
		d_4 = ((if_in_store[7:0]>c_in4_store[7:0])?if_in_store[7:0]-c_in4_store[7:0]:c_in4_store[7:0]-if_in_store[7:0]) +
			  ((if_in_store[15:8]>c_in4_store[15:8])?if_in_store[15:8]-c_in4_store[15:8]:c_in4_store[15:8]-if_in_store[15:8]) +
			  ((if_in_store[23:16]>c_in4_store[23:16])?if_in_store[23:16]-c_in4_store[23:16]:c_in4_store[23:16]-if_in_store[23:16]);
		d_5 = ((if_in_store[7:0]>c_in5_store[7:0])?if_in_store[7:0]-c_in5_store[7:0]:c_in5_store[7:0]-if_in_store[7:0]) +
			  ((if_in_store[15:8]>c_in5_store[15:8])?if_in_store[15:8]-c_in5_store[15:8]:c_in5_store[15:8]-if_in_store[15:8]) +
			  ((if_in_store[23:16]>c_in5_store[23:16])?if_in_store[23:16]-c_in5_store[23:16]:c_in5_store[23:16]-if_in_store[23:16]);
		d_6 = ((if_in_store[7:0]>c_in6_store[7:0])?if_in_store[7:0]-c_in6_store[7:0]:c_in6_store[7:0]-if_in_store[7:0]) +
			  ((if_in_store[15:8]>c_in6_store[15:8])?if_in_store[15:8]-c_in6_store[15:8]:c_in6_store[15:8]-if_in_store[15:8]) +
			  ((if_in_store[23:16]>c_in6_store[23:16])?if_in_store[23:16]-c_in6_store[23:16]:c_in6_store[23:16]-if_in_store[23:16]);
		d_7 = ((if_in_store[7:0]>c_in7_store[7:0])?if_in_store[7:0]-c_in7_store[7:0]:c_in7_store[7:0]-if_in_store[7:0]) +
			  ((if_in_store[15:8]>c_in7_store[15:8])?if_in_store[15:8]-c_in7_store[15:8]:c_in7_store[15:8]-if_in_store[15:8]) +
			  ((if_in_store[23:16]>c_in7_store[23:16])?if_in_store[23:16]-c_in7_store[23:16]:c_in7_store[23:16]-if_in_store[23:16]);
	end
end
endmodule
