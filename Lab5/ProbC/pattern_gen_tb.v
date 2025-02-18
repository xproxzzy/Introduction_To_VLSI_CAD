`timescale 1ns/10ps
`define cycle 1.0
`ifdef syn
`include "/usr/cad/CBDK/Executable_Package/Collaterals/IP/stdcell/N16ADFP_StdCell/VERILOG/N16ADFP_StdCell.v"
`include "pattern_gen_syn.v"
`else
`include "pattern_gen.v"
`endif

module pattern_gen_tb;
	reg clk;
	reg	rst;
	reg en;
	reg [2:0] sel;
	wire pattern;
	wire valid;
	integer     i,err=0;
	
	initial begin
		en = 1'b0; sel = 3'd0; clk = 0; rst = 1'b1; 
		#(`cycle) rst = 1'b0;
		#(`cycle) en = 1'b1; sel = 3'b0;
		wait(valid);
		$display("\n");
		$display("//////////////////sel is %b/////////////////", sel);
			@(negedge clk)begin
				if(pattern!==0)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,0);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==0)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,0);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==0)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,0);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==0)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,0);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end	
		#(`cycle) en  = 1'b0;
		
		#(`cycle) en  = 1'b1; sel = 3'b001;	
		wait(valid);
		$display("\n");
		$display("//////////////////sel is %b/////////////////", sel);
			@(negedge clk)begin
				if(pattern!==0)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,0);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==0)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,0);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==0)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,0);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==1)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,1);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
		#(`cycle) en  = 1'b0;
		
		#(`cycle) en  = 1'b1; sel = 3'b010;	
		wait(valid);
		$display("\n");
		$display("//////////////////sel is %b/////////////////", sel);
			@(negedge clk)begin
				if(pattern!==0)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,0);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==0)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,0);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==1)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,1);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==0)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,0);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
		#(`cycle) en  = 1'b0;
		
		#(`cycle) en  = 1'b1; sel = 3'b011;	
		wait(valid);
		$display("\n");
		$display("//////////////////sel is %b/////////////////", sel);
			@(negedge clk)begin
				if(pattern!==0)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,0);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==0)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,0);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==1)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,1);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==1)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,1);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
		#(`cycle) en  = 1'b0;
		
		#(`cycle) en  = 1'b1; sel = 3'b100;	
		wait(valid);
		$display("\n");
		$display("//////////////////sel is %b/////////////////", sel);
			@(negedge clk)begin
				if(pattern!==1)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,1);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==1)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,1);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==0)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,0);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==0)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,0);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
		#(`cycle) en  = 1'b0;
		
		#(`cycle) en  = 1'b1; sel = 3'b101;	
		wait(valid);
		$display("\n");
		$display("//////////////////sel is %b/////////////////", sel);
			@(negedge clk)begin
				if(pattern!==1)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,1);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==1)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,1);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==0)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,0);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==1)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,1);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
		#(`cycle) en  = 1'b0;
		
		#(`cycle) en  = 1'b1; sel = 3'b110;	
		wait(valid);
		$display("\n");
		$display("//////////////////sel is %b/////////////////", sel);
			@(negedge clk)begin
				if(pattern!==1)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,1);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==1)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,1);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==1)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,1);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
			@(negedge clk) begin
				if(pattern!==0)begin 
					err=err+1;
					$display("pattern is %d, expect %d", pattern,0);
				end
				else 
					$display("pattern is %d, pass!!!", pattern);
			end
		#(`cycle) en  = 1'b0;
		
		#(`cycle) en  = 1'b1; sel = 3'b111;	
		wait(valid);
		$display("\n");
		$display("//////////////////sel is %b/////////////////", sel);
			for(i=0; i<4; i=i+1)begin
				@(negedge clk) begin
					if(pattern!==1)begin 
						err=err+1;
						$display("pattern is %d, expect %d", pattern,1);
					end
					else 
						$display("pattern is %d, pass!!!", pattern);
				end
			end
		#(`cycle) en  = 1'b0;
		
		#(`cycle*3);
		if(err!= 0) begin
		  $display("\n");
          $display("\n");
          $display("        ****************************               ");
          $display("        **                        **       |\__||  ");
          $display("        **  OOPS!!                **      / X,X  | ");
          $display("        **                        **    /_____   | ");
          $display("        **  Simulation Failed!!   **   /^ ^ ^ \\  |");
          $display("        **                        **  |^ ^ ^ ^ |w| ");
          $display("        ****************************   \\m___m__|_|");
          $display("         Totally has %d errors                     ", err); 
          $display("\n");
		 end
		else begin
		  $display("\n");
          $display("\n");
          $display("        ****************************               ");
          $display("        **                        **       |\__||  ");
          $display("        **  Congratulations !!    **      / O.O  | ");
          $display("        **                        **    /_____   | ");
          $display("        **  Simulation PASS!!     **   /^ ^ ^ \\  |");
          $display("        **                        **  |^ ^ ^ ^ |w| ");
          $display("        ****************************   \\m___m__|_|");
          $display("\n");
		  
		end
		
		$finish;
	end
	
	always #(`cycle/2) clk = ~clk;
	
	
	
	
	pattern_gen p1(
	.clk(clk),
	.rst(rst),
	.en(en),
	.sel(sel),
	.pattern(pattern),
	.valid(valid));
	
	`ifdef FSDB
	initial begin
		$fsdbDumpfile("pattern_gen.fsdb");
		$fsdbDumpvars("+struct", "+mda",p1);
	end
	`endif
	
	`ifdef syn
		initial $sdf_annotate("pattern_gen_syn.sdf",p1);
	`endif
endmodule
