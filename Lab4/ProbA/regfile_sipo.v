`timescale 1ns/10ps

// ---------------------- define ---------------------- //
`define AddrSize  7
`define DataSize  32
`define RegSize   128

// ---------------------------------------------------- //
module regfile_sipo(clk, rst, reg_enable, reg_write, src_addr,
				write_addr, write_data, src1, src2, src3, src4, src5);

// ---------------------- input  ---------------------- //
input clk;
input rst;
input reg_enable;
input reg_write;

input [`AddrSize-1:0] src_addr;
input [`AddrSize-1:0] write_addr;
input [`DataSize-1:0] write_data;

// ---------------------- output ---------------------- //
output [`DataSize-1:0] src1;
output [`DataSize-1:0] src2;
output [`DataSize-1:0] src3;
output [`DataSize-1:0] src4;
output [`DataSize-1:0] src5;

// ----------------------  reg   ---------------------- //
reg [`DataSize-1:0] src1;
reg [`DataSize-1:0] src2;
reg [`DataSize-1:0] src3;
reg [`DataSize-1:0] src4;
reg [`DataSize-1:0] src5;
reg [`DataSize-1:0] R [`RegSize-1:0];
// ----------please write your code here--------------- //

integer i;
always @ (posedge clk)
begin
	if(rst == 1'b1)
	begin
		src1 <= 32'b0;
		src2 <= 32'b0;
		src3 <= 32'b0;
		src4 <= 32'b0;
		src5 <= 32'b0;
		for(i = 0; i < `RegSize; i = i+1)
		begin
			R [i] <= 32'b0;
		end
	end
	else
	begin
		if(reg_enable == 1'b1)
		begin
			if(reg_write == 1'b0) //read
			begin
				src1[`DataSize-1:0] <= R[src_addr][`DataSize-1:0];
				src2[`DataSize-1:0] <= R[src_addr + 7'd1][`DataSize-1:0];
				src3[`DataSize-1:0] <= R[src_addr + 7'd2][`DataSize-1:0];
				src4[`DataSize-1:0] <= R[src_addr + 7'd3][`DataSize-1:0];
				src5[`DataSize-1:0] <= R[src_addr + 7'd4][`DataSize-1:0];
			end
			else //write
			begin
				R[write_addr][`DataSize-1:0] <= write_data[`DataSize-1:0];
			end
		end
		else
		begin
			src1 <= src1;
			src2 <= src2;
			src3 <= src3;
			src4 <= src4;
			src5 <= src5;
		end
	end
end

endmodule
