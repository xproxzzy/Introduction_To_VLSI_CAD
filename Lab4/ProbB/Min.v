`define D_DataSize 10

module Min(d_0,
            d_1,
            d_2,
            d_3,
            d_4,
            d_5,
            d_6,
            d_7,
            out_index,
            out_distance);

  // ---------------------- input  ---------------------- //
  input  [`D_DataSize-1:0] d_0, d_1, d_2, d_3, d_4, d_5, d_6, d_7;

  // ---------------------- output ---------------------- //
  output [`D_DataSize-1:0] out_distance;
  output [2:0] out_index;

  // ---------------------- Write down Your design below  ---------------------- //
  reg [`D_DataSize-1:0] out_distance;
  reg [2:0] out_index;
  reg [`D_DataSize-1:0] d_bigger_0_0, d_bigger_0_1, d_bigger_0_2, d_bigger_0_3;
  reg [`D_DataSize-1:0] d_bigger_1_0, d_bigger_1_1;
  reg [2:0] index_bigger_0_0, index_bigger_0_1, index_bigger_0_2, index_bigger_0_3;
  reg [2:0] index_bigger_1_0, index_bigger_1_1;

always @ (*)
begin
	if((d_0<=d_1)&&(d_0<=d_2)&&(d_0<=d_3)&&(d_0<=d_4)&&(d_0<=d_5)&&(d_0<=d_6)&&(d_0<=d_7))
	begin
		out_index = 3'd0;
		out_distance = d_0;
	end
	else if((d_1<d_0)&&(d_1<=d_2)&&(d_1<=d_3)&&(d_1<=d_4)&&(d_1<=d_5)&&(d_1<=d_6)&&(d_1<=d_7))
	begin
		out_index = 3'd1;
		out_distance = d_1;
	end
	else if((d_2<d_0)&&(d_2<d_1)&&(d_2<=d_3)&&(d_2<=d_4)&&(d_2<=d_5)&&(d_2<=d_6)&&(d_2<=d_7))
	begin
		out_index = 3'd2;
		out_distance = d_2;
	end
	else if((d_3<d_0)&&(d_3<d_1)&&(d_3<d_2)&&(d_3<=d_4)&&(d_3<=d_5)&&(d_3<=d_6)&&(d_3<=d_7))
	begin
		out_index = 3'd3;
		out_distance = d_3;
	end
	else if((d_4<d_0)&&(d_4<d_1)&&(d_4<d_2)&&(d_4<d_3)&&(d_4<=d_5)&&(d_4<=d_6)&&(d_4<=d_7))
	begin
		out_index = 3'd4;
		out_distance = d_4;
	end
	else if((d_5<d_0)&&(d_5<d_1)&&(d_5<d_2)&&(d_5<d_3)&&(d_5<d_4)&&(d_5<=d_6)&&(d_5<=d_7))
	begin
		out_index = 3'd5;
		out_distance = d_5;
	end
	else if((d_6<d_0)&&(d_6<d_1)&&(d_6<d_2)&&(d_6<d_3)&&(d_6<d_4)&&(d_6<d_5)&&(d_6<=d_7))
	begin
		out_index = 3'd6;
		out_distance = d_6;
	end
	else if((d_7<d_0)&&(d_7<d_1)&&(d_7<d_2)&&(d_7<d_3)&&(d_7<d_4)&&(d_7<d_5)&&(d_7<d_6))
	begin
		out_index = 3'd7;
		out_distance = d_7;
	end
	else
	begin
		out_index = 3'd0;
		out_distance = 10'd0;
	end
end

  endmodule
