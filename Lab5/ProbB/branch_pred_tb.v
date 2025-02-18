`timescale 1ns/1ps
`define cycle 1.0

`ifdef syn
   `include "branch_pred_syn.v"
   `include "/usr/cad/CBDK/Executable_Package/Collaterals/IP/stdcell/N16ADFP_StdCell/VERILOG/N16ADFP_StdCell.v"
`else
   `include "branch_pred.v"
`endif


module branch_pred_tb();
  reg         clk, rst;
  reg  	      taken;
  wire        p_taken;
  integer error;
 
  branch_pred bp(.clk(clk), .rst(rst), .taken(taken), .p_taken(p_taken));

  always begin
    #(`cycle/2) clk = ~clk;
  end
  
  initial begin
	error=0;
	#(`cycle*2.5) if(p_taken==1'd1) $display("time", $time, "  output is correct\n");
			else begin $display("time", $time, "  p_taken is Wrong .Your p_taken is %h , but Correct p_taken is 1 \n",p_taken);	error = error +1; end
	#(`cycle) if(p_taken==1'd1) $display("time", $time, "  output is correct\n");
			else begin $display("time", $time, "  p_taken is Wrong .Your p_taken is %h , but Correct p_taken is 1 \n",p_taken);	error = error +1; end
	#(`cycle) if(p_taken==1'd1) $display("time", $time, "  output is correct\n");
			else begin $display("time", $time, "  p_taken is Wrong .Your p_taken is %h , but Correct p_taken is 1 \n",p_taken);	error = error +1; end
	#(`cycle) if(p_taken==1'd0) $display("time", $time, "  output is correct\n");
			else begin $display("time", $time, "  p_taken is Wrong .Your p_taken is %h , but Correct p_taken is 0 \n",p_taken);	error = error +1; end
	#(`cycle) if(p_taken==1'd0) $display("time", $time, "  output is correct\n");
			else begin $display("time", $time, "  p_taken is Wrong .Your p_taken is %h , but Correct p_taken is 0 \n",p_taken);	error = error +1; end
	#(`cycle) if(p_taken==1'd1) $display("time", $time, "  output is correct\n");
			else begin $display("time", $time, "  p_taken is Wrong .Your p_taken is %h , but Correct p_taken is 1 \n",p_taken);	error = error +1; end
	#(`cycle) if(p_taken==1'd1) $display("time", $time, "  output is correct\n");
			else begin $display("time", $time, "  p_taken is Wrong .Your p_taken is %h , but Correct p_taken is 1 \n",p_taken);	error = error +1; end
	#(`cycle) if(p_taken==1'd1) $display("time", $time, "  output is correct\n");
			else begin $display("time", $time, "  p_taken is Wrong .Your p_taken is %h , but Correct p_taken is 1 \n",p_taken);	error = error +1; end
	#(`cycle) if(p_taken==1'd1) $display("time", $time, "  output is correct\n");
			else begin $display("time", $time, "  p_taken is Wrong .Your p_taken is %h , but Correct p_taken is 1 \n",p_taken);	error = error +1; end
	#(`cycle) if(p_taken==1'd0) $display("time", $time, "  output is correct\n");
			else begin $display("time", $time, "  p_taken is Wrong .Your p_taken is %h , but Correct p_taken is 0 \n",p_taken);	error = error +1; end
	#(`cycle) if(p_taken==1'd0) $display("time", $time, "  output is correct\n");
			else begin $display("time", $time, "  p_taken is Wrong .Your p_taken is %h , but Correct p_taken is 0 \n",p_taken);	error = error +1; end
	#(`cycle) if(p_taken==1'd1) $display("time", $time, "  output is correct\n");
			else begin $display("time", $time, "  p_taken is Wrong .Your p_taken is %h , but Correct p_taken is 1 \n",p_taken);	error = error +1; end		
	#(`cycle) if(p_taken==1'd1) $display("time", $time, "  output is correct\n");
			else begin $display("time", $time, "  p_taken is Wrong .Your p_taken is %h , but Correct p_taken is 1 \n",p_taken);	error = error +1; end		
	#(`cycle) if(p_taken==1'd1) $display("time", $time, "  output is correct\n");
			else begin $display("time", $time, "  p_taken is Wrong .Your p_taken is %h , but Correct p_taken is 1 \n",p_taken);	error = error +1; end		
	#(`cycle) if(p_taken==1'd1) $display("time", $time, "  output is correct\n");
			else begin $display("time", $time, "  p_taken is Wrong .Your p_taken is %h , but Correct p_taken is 1 \n",p_taken);	error = error +1; end		
	#(`cycle) if(p_taken==1'd1) $display("time", $time, "  output is correct\n");
			else begin $display("time", $time, "  p_taken is Wrong .Your p_taken is %h , but Correct p_taken is 1 \n",p_taken);	error = error +1; end
	#(`cycle) if(p_taken==1'd1) $display("time", $time, "  output is correct\n");
			else begin $display("time", $time, "  p_taken is Wrong .Your p_taken is %h , but Correct p_taken is 1 \n",p_taken);	error = error +1; end
	#(`cycle) if(p_taken==1'd1) $display("time", $time, "  output is correct\n");
			else begin $display("time", $time, "  p_taken is Wrong .Your p_taken is %h , but Correct p_taken is 1 \n",p_taken);	error = error +1; end
	#(`cycle) if(p_taken==1'd0) $display("time", $time, "  output is correct\n");
			else begin $display("time", $time, "  p_taken is Wrong .Your p_taken is %h , but Correct p_taken is 0 \n",p_taken);	error = error +1; end
	#(`cycle) if(p_taken==1'd0) $display("time", $time, "  output is correct\n");
			else begin $display("time", $time, "  p_taken is Wrong .Your p_taken is %h , but Correct p_taken is 0 \n",p_taken);	error = error +1; end
	#(`cycle) if(p_taken==1'd0) $display("time", $time, "  output is correct\n");
			else begin $display("time", $time, "  p_taken is Wrong .Your p_taken is %h , but Correct p_taken is 0 \n",p_taken);	error = error +1; end
	#(`cycle) if(p_taken==1'd1) $display("time", $time, "  output is correct\n");
			else begin $display("time", $time, "  p_taken is Wrong .Your p_taken is %h , but Correct p_taken is 1 \n",p_taken);	error = error +1; end
	#(`cycle) if(p_taken==1'd1) $display("time", $time, "  output is correct\n");
			else begin $display("time", $time, "  p_taken is Wrong .Your p_taken is %h , but Correct p_taken is 1 \n",p_taken);	error = error +1; end
	#(`cycle) if(p_taken==1'd1) $display("time", $time, "  output is correct\n");
			else begin $display("time", $time, "  p_taken is Wrong .Your p_taken is %h , but Correct p_taken is 1 \n",p_taken);	error = error +1; end
	#(`cycle) if(p_taken==1'd1) $display("time", $time, "  output is correct\n");
			else begin $display("time", $time, "  p_taken is Wrong .Your p_taken is %h , but Correct p_taken is 1 \n",p_taken);	error = error +1; end
	#(`cycle) if(p_taken==1'd0) $display("time", $time, "  output is correct\n");
			else begin $display("time", $time, "  p_taken is Wrong .Your p_taken is %h , but Correct p_taken is 0 \n",p_taken);	error = error +1; end
	#(`cycle) if(p_taken==1'd0) $display("time", $time, "  output is correct\n");
			else begin $display("time", $time, "  p_taken is Wrong .Your p_taken is %h , but Correct p_taken is 0 \n",p_taken);	error = error +1; end
	#(`cycle) if(p_taken==1'd0) $display("time", $time, "  output is correct\n");
			else begin $display("time", $time, "  p_taken is Wrong .Your p_taken is %h , but Correct p_taken is 0 \n",p_taken);	error = error +1; end
	#(`cycle) if(p_taken==1'd0) $display("time", $time, "  output is correct\n");
			else begin $display("time", $time, "  p_taken is Wrong .Your p_taken is %h , but Correct p_taken is 0 \n",p_taken);	error = error +1; end
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

			
			
 initial begin
                      clk = 1; rst = 1; taken = 0;
    #`cycle        rst = 1; taken = 0;
    #(`cycle*0.5)  rst = 0; 
    #`cycle     taken = 1;   
    #`cycle     taken = 0;   
    #`cycle     taken = 0;   
    #`cycle     taken = 1;   
    #`cycle     taken = 1;       
    #`cycle     taken = 0;   
    #`cycle     taken = 1;   
    #`cycle     taken = 0;    
    #`cycle     taken = 0;   
    #`cycle     taken = 1;   
    #`cycle     taken = 1;     
    #`cycle     taken = 1;   
    #`cycle     taken = 0;   
    #`cycle     taken = 1;     
    #`cycle     taken = 0;   
    #`cycle     taken = 1;   
    #`cycle     taken = 0;    
    #`cycle     taken = 0;   
    #`cycle     taken = 0;   
    #`cycle     taken = 1;     
    #`cycle     taken = 1;   
    #`cycle     taken = 1;   
    #`cycle     taken = 1;   
    #`cycle     taken = 0;   
    #`cycle     taken = 0;   
    #`cycle     taken = 1;       
    #`cycle     taken = 0;   
    #`cycle     taken = 0;   
    #`cycle     taken = 1;    
    #`cycle     taken = 0;  
	$finish;
 end

  `ifdef FSDB
  initial begin
       $fsdbDumpfile("branch_pred_tb.fsdb");
       $fsdbDumpvars();
   end
  `endif

 `ifdef syn
    initial $sdf_annotate("branch_pred_syn.sdf",bp);
 `endif

endmodule

