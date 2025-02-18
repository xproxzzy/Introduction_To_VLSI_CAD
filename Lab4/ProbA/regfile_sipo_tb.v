`timescale 1ns/10ps

`include "regfile_sipo.v"

// ---------------------- define ---------------------- //
// ----You can define the parameters you want below---- //

`define clkPeriod 10
`define AddrSize 7
`define DataSize 32

module regfile_sipo_tb();
// ---------------------------------------------------- //
// ----------------------   reg  ---------------------- //
reg						     	clk;
reg						     	rst;
reg						     	reg_enable;
reg 					     	reg_write;
reg	[`AddrSize-1:0]	src_addr;
reg	[`AddrSize-1:0]	write_addr;
reg	[`DataSize-1:0]	write_data;

// ----------------------  wire  ---------------------- //
wire	[`DataSize-1:0]		src1;
wire	[`DataSize-1:0]		src2;
wire 	[`DataSize-1:0]		src3;
wire 	[`DataSize-1:0]		src4;
wire 	[`DataSize-1:0]		src5;

integer i,error;

regfile_sipo RF (.clk(clk), .rst(rst), .reg_enable(reg_enable), .reg_write(reg_write),
				 .src_addr(src_addr), .write_addr(write_addr), .write_data(write_data),
				 .src1(src1), .src2(src2), .src3(src3), .src4(src4), .src5(src5));

//monitor
initial begin
	error=0;
	#130 if(src1==32'hffff_0000) $display("time", $time, "  src1 is correct\n");
		else begin $display("time", $time, "  src1 is Wrong .Your src1 is %h , but Correct src1 is ffff_0000 \n",src1);	error = error +1; end
		 if(src2==32'hffff_0001) $display("time", $time, "  src2 is correct\n");
		else begin $display("time", $time, "  src2 is Wrong .Your src2 is %h , but Correct src2 is ffff_0001 \n",src2);	error = error +1; end
		if(src3==32'hffff_0002) $display("time", $time, "  src3 is correct\n");
		else begin $display("time", $time, "  src3 is Wrong .Your src3 is %h , but Correct src3 is ffff_0002 \n",src3);	error = error +1; end
		if(src4==32'hffff_0003) $display("time", $time, "  src4 is correct\n");
		else begin $display("time", $time, "  src4 is Wrong .Your src4 is %h , but Correct src4 is ffff_0003 \n",src4);	error = error +1; end
		if(src5==32'hffff_0004) $display("time", $time, "  src5 is correct\n");
		else begin $display("time", $time, "  src5 is Wrong .Your src5 is %h , but Correct src5 is ffff_0004 \n",src5);	error = error +1; end
	#10 if(src1==32'hffff_0005) $display("time", $time, "  src1 is correct\n");
		else begin $display("time", $time, "  src1 is Wrong .Your src1 is %h , but Correct src1 is ffff_0005 \n",src1);	error = error +1; end
		 if(src2==32'hffff_0006) $display("time", $time, "  src2 is correct\n");
		else begin $display("time", $time, "  src2 is Wrong .Your src2 is %h , but Correct src2 is ffff_0006 \n",src2);	error = error +1; end
		if(src3==32'hffff_0007) $display("time", $time, "  src3 is correct\n");
		else begin $display("time", $time, "  src3 is Wrong .Your src3 is %h , but Correct src3 is ffff_0007 \n",src3);	error = error +1; end
		if(src4==32'hffff_0008) $display("time", $time, "  src4 is correct\n");
		else begin $display("time", $time, "  src4 is Wrong .Your src4 is %h , but Correct src4 is ffff_0008 \n",src4);	error = error +1; end
		if(src5==32'hffff_0009) $display("time", $time, "  src5 is correct\n");
		else begin $display("time", $time, "  src5 is Wrong .Your src5 is %h , but Correct src5 is ffff_0009 \n",src5);	error = error +1; end
	
	$display("-----------------------register file---------------------------");
  for(i=0;i<`RegSize;i=i+1)
	begin
	case(i)
	7'd0:begin	
			if(RF.R[i]==32'hffff_0000) $display("R[%d] = %h  ",i,RF.R[i]);
			else begin $display("error! your R[%d] = %h  , but it should be ffff0000",i,RF.R[i]); error=error+1; end
		end
	7'd1:begin	
			if(RF.R[i]==32'hffff_0001) $display("R[%d] = %h  ",i,RF.R[i]);
			else begin $display("error! your R[%d] = %h  , but it should be ffff_0001",i,RF.R[i]); error=error+1; end
		end
	7'd2:begin	
			if(RF.R[i]==32'hffff_0002) $display("R[%d] = %h  ",i,RF.R[i]);
			else begin $display("error! your R[%d] = %h  , but it should be ffff_0002",i,RF.R[i]); error=error+1; end
		end
	7'd3:begin	
			if(RF.R[i]==32'hffff_0003) $display("R[%d] = %h  ",i,RF.R[i]);
			else begin $display("error! your R[%d] = %h  , but it should be ffff_0003",i,RF.R[i]); error=error+1; end
		end
	7'd4:begin	
			if(RF.R[i]==32'hffff_0004) $display("R[%d] = %h  ",i,RF.R[i]);
			else begin $display("error! your R[%d] = %h  , but it should be ffff_0004",i,RF.R[i]); error=error+1; end
		end
	7'd105:begin	
			if(RF.R[i]==32'hffff_0005) $display("R[%d] = %h  ",i,RF.R[i]);
			else begin $display("error! your R[%d] = %h  , but it should be ffff_0005",i,RF.R[i]); error=error+1; end
		end
	7'd106:begin	
			if(RF.R[i]==32'hffff_0006) $display("R[%d] = %h  ",i,RF.R[i]);
			else begin $display("error! your R[%d] = %h  , but it should be ffff_0006",i,RF.R[i]); error=error+1; end
		end
	7'd107:begin	
			if(RF.R[i]==32'hffff_0007) $display("R[%d] = %h  ",i,RF.R[i]);
			else begin $display("error! your R[%d] = %h  , but it should be ffff_0007",i,RF.R[i]); error=error+1; end
		end
	7'd108:begin	
			if(RF.R[i]==32'hffff_0008) $display("R[%d] = %h  ",i,RF.R[i]);
			else begin $display("error! your R[%d] = %h  , but it should be ffff_0008",i,RF.R[i]); error=error+1; end
		end
	7'd109:begin	
			if(RF.R[i]==32'hffff_0009) $display("R[%d] = %h  ",i,RF.R[i]);
			else begin $display("error! your R[%d] = %h  , but it should be ffff_0009",i,RF.R[i]); error=error+1; end
		end
	default:begin
			if(RF.R[i]==32'h0000_0000) $display("R[%d] = %h  ",i,RF.R[i]);
			else begin $display("error! your R[%d] = %h  , but it should be 00000000",i,RF.R[i]); error=error+1; end
		end
	endcase
	end
	
	if(error === 0)begin
        $display("\n");
        $display("\n");
        $display("        ****************************               ");
        $display("        **                        **       |\\__||  ");
        $display("        **  Congratulations !!    **      / O.O  | ");
        $display("        **                        **    /_____   | ");
        $display("        **  Simulation PASS!!     **   /^ ^ ^ \\  |");
        $display("        **                        **  |^ ^ ^ ^ |w| ");
        $display("        ****************************   \\m___m__|_|");
        $display("\n");
	end
	else begin
        $display("\n");
        $display("\n");
        $display("        ****************************               ");
        $display("        **                        **       |\__||  ");
        $display("        **  OOPS!!                **      / X,X  | ");
        $display("        **                        **    /_____   | ");
        $display("        **  Simulation Failed!!   **   /^ ^ ^ \\  |");
        $display("        **                        **  |^ ^ ^ ^ |w| ");
        $display("        ****************************   \\m___m__|_|");
        $display("         There are %d errors                     ", error); 
        $display("\n");
    end
end

//clock generator
always #(`clkPeriod/2) clk = ~clk;

initial begin
	clk = 0; rst = 1; reg_enable = 0; reg_write = 0; write_addr = 7'd0; write_data = 32'd0; src_addr = 7'd0;
#10			   rst = 0;                                                                       src_addr = 7'd0;
#6                  reg_enable = 1; reg_write = 1; write_addr = 7'd0;	  write_data = 32'hffff_0000; src_addr = 7'd0;
#10 		 		reg_enable = 1; reg_write = 1; write_addr = 7'd1;	  write_data = 32'hffff_0001; src_addr = 7'd0;

// ----------please complete the test patterns here--------------- //

#10                             reg_enable = 1; reg_write = 1; write_addr = 7'd2;   write_data = 32'hffff_0002; src_addr = 7'd0;
#10                             reg_enable = 1; reg_write = 1; write_addr = 7'd3;   write_data = 32'hffff_0003; src_addr = 7'd0;
#10                             reg_enable = 1; reg_write = 1; write_addr = 7'd4;   write_data = 32'hffff_0004; src_addr = 7'd0;
#10                             reg_enable = 1; reg_write = 1; write_addr = 7'd105; write_data = 32'hffff_0005; src_addr = 7'd0;
#10                             reg_enable = 1; reg_write = 1; write_addr = 7'd106; write_data = 32'hffff_0006; src_addr = 7'd0;
#10                             reg_enable = 1; reg_write = 1; write_addr = 7'd107; write_data = 32'hffff_0007; src_addr = 7'd0;
#10                             reg_enable = 1; reg_write = 1; write_addr = 7'd108; write_data = 32'hffff_0008; src_addr = 7'd0;
#10                             reg_enable = 1; reg_write = 1; write_addr = 7'd109; write_data = 32'hffff_0009; src_addr = 7'd0;

#10                             reg_enable = 1; reg_write = 0;                                                  src_addr = 7'd0;
#10                             reg_enable = 1; reg_write = 0;                                                  src_addr = 7'd105;
#200 $finish;
end

initial begin
	`ifdef FSDB
	$fsdbDumpfile("regfile_sipo.fsdb");
	$fsdbDumpvars;
    `elsif FSDB_ALL
    $fsdbDumpfile("regfile_sipo.fsdb");
    $fsdbDumpvars("+struct", "+mda", RF);
    `endif
end
endmodule

