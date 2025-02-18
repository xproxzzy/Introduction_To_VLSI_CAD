`timescale 1ns/10ps
`define cycle 2.0

`ifdef syn
`include "/usr/cad/CBDK/Executable_Package/Collaterals/IP/stdcell/N16ADFP_StdCell/VERILOG/N16ADFP_StdCell.v"
`include "det_seq_syn.v"
`else
`include "det_seq.v"
`endif


module det_seq_tb();
  reg clk,rst,d;
  wire q;
  wire [2:0] num;

  reg [29:0] golden;
  reg [2:0]  num_golden;
  integer i,err;
 
  det_seq d0(.clk(clk),.rst(rst),.d(d),.q(q), .num(num));

  always begin
    #(`cycle/2) clk = ~clk;
  end

 initial begin
                clk = 1; rst = 1; d = 0;//0
    #`cycle  rst = 1;
    #(`cycle*0.5)  rst = 0; 
    #`cycle  d = 1;//1
    #`cycle  d = 0;
    #`cycle  d = 1;
    #`cycle  d = 0;	
    #`cycle  d = 1;
    #`cycle  d = 1;//6
    #`cycle  d = 1;
    #`cycle  d = 0;	
    #`cycle  d = 1;
    #`cycle  d = 0;
    #`cycle  d = 1;
    #`cycle  d = 1;//12	
    #`cycle  d = 0;
    #`cycle  d = 1;
    #`cycle  d = 0;
    #`cycle  d = 1;
    #`cycle  d = 1;//17
    #`cycle  d = 0;
    #`cycle  d = 1;
	#`cycle  d = 0;
	#`cycle  d = 1;
	#`cycle  d = 0;
	#`cycle  d = 1;
	#`cycle  d = 0;
	#`cycle  d = 1;
	#`cycle  d = 1;//26
	#`cycle  d = 1;
	#`cycle  d = 1;
	#`cycle  d = 0;
 end

 initial begin
   golden[0] = 0;
   golden[1] = 0;
   golden[2] = 0;
   golden[3] = 0;
   golden[4] = 0;
   golden[5] = 0;
   golden[6] = 1;
   golden[7] = 0;
   golden[8] = 0;
   golden[9] = 0;
   golden[10] = 0;
   golden[11] = 0;
   golden[12] = 1;
   golden[13] = 0;
   golden[14] = 0;
   golden[15] = 0;
   golden[16] = 0;
   golden[17] = 1;
   golden[18] = 0;
   golden[19] = 0;
   golden[20] = 0;
   golden[21] = 0;
   golden[22] = 0;
   golden[23] = 0;
   golden[24] = 0;
   golden[25] = 0;
   golden[26] = 1;
   golden[27] = 0;
   golden[28] = 0;
   golden[29] = 0;
   num_golden = 3'd4;
end


  initial begin
    err = 0;
    #(3*`cycle-1)
    for(i=0;i<30;i=i+1)begin
       if(q === golden[i])
          $display("Result No.%0d is correct.", i+1);
      else begin
          $display("Result No.%0d is not correct. The result is %d, but %d is expected.", i+1, q, golden[i]);
          err = err + 1;
      end
       #`cycle;
    end

    if(num === num_golden)
    	$display("The total number of pattern 101011 is %d. Correct!",num);
    else begin
     	$display("The total number of pattern 101011 is %d. Not correct, %d is expected!",num, num_golden);       
         err = err + 1;
    end

    if(err===0)begin
          $display("\n");
		  $display("\n");
			$display("        **************************               ");
			$display("        *                        *       |\__||  ");
			$display("        *  Congratulations !!    *      / O.O  | ");
			$display("        *                        *    /_____   | ");
			$display("        *  Simulation PASS!!     *   /^ ^ ^ \\  |");
			$display("        *                        *  |^ ^ ^ ^ |w| ");
			$display("        **************************   \\m___m__|_|");
			$display("\n");
    end
    else begin
          $display("\n");
		  $display("\n");
			$display("        **************************               ");
			$display("        *                        *       |\__||  ");
			$display("        *  OOPS!!                *      / X,X  | ");
			$display("        *                        *    /_____   | ");
			$display("        *  Simulation Failed!!   *   /^ ^ ^ \\  |");
			$display("        *                        *  |^ ^ ^ ^ |w| ");
			$display("        **************************   \\m___m__|_|");
			$display("\n");
    end

    $finish;
  end

  `ifdef FSDB
  initial begin
       $fsdbDumpfile("det_seq_tb.fsdb");
       $fsdbDumpvars;
   end
  `endif

 `ifdef syn
    initial $sdf_annotate("det_seq_syn.sdf",d0);
 `endif

endmodule

