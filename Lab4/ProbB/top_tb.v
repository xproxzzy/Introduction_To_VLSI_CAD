`timescale 1ns/10ps

`include "top.v"



// ---------------------- define ---------------------- //
`define RGB_DataSize 24
`define D_DataSize 10
`define clkPeriod 10

module top_tb;

// ----------------------   reg  ---------------------- //
reg  clk;
reg  rst;
reg  clear;
reg  c_en;
reg  if_en;
reg  [`RGB_DataSize-1:0] c_in0, c_in1, c_in2, c_in3, c_in4, c_in5, c_in6, c_in7;
reg  [`RGB_DataSize-1:0] if_in;

// ----------------------  wire  ---------------------- //
wire [`D_DataSize-1:0] out_distance;
wire [2:0] out_index;

integer error;


top t(.clk         (clk         ),
      .rst         (rst         ),
      .clear       (clear       ),
      .c_en        (c_en        ),
      .if_en       (if_en       ),
      .c_in0       (c_in0       ),
      .c_in1       (c_in1       ),
      .c_in2       (c_in2       ),
      .c_in3       (c_in3       ),
      .c_in4       (c_in4       ),
      .c_in5       (c_in5       ),
      .c_in6       (c_in6       ),
      .c_in7       (c_in7       ),
      .if_in       (if_in       ),
      .out_index   (out_index   ),
      .out_distance(out_distance));

//monitor
initial begin
  error=0;
  #35
  $display("-----------------------------------------------------------------------\n");
  if(out_index==3'd6 && out_distance==10'h0C8)  $display("time", $time, "  output is correct\n");
  else begin
    $display("time", $time, "  output is Wrong .Your index is %d and min distance is %h , but Correct index is 6 and min distance is 0C8. \n",out_index,out_distance);
    error = error +1;
  end
  #10
  if(out_index==3'd0 && out_distance==10'h000)  $display("time", $time, "  output is correct\n");
  else begin
    $display("time", $time, "  output is Wrong .Your index is %d and min distance is %h , but Correct index is 0 and min distance is 000. \n",out_index,out_distance);
    error = error +1;
  end
  #10
  if(out_index==3'd2 && out_distance==10'h083)  $display("time", $time, "  output is correct\n");
  else begin
    $display("time", $time, "  output is Wrong .Your index is %d and min distance is %h , but Correct index is 2 and min distance is 083. \n",out_index,out_distance);
    error = error +1;
  end
  #10
  if(out_index==3'd0 && out_distance==10'h05D)  $display("time", $time, "  output is correct\n");
  else begin
    $display("time", $time, "  output is Wrong .Your index is %d and min distance is %h , but Correct index is 0 and min distance is 05d. \n",out_index,out_distance);
    error = error +1;
  end
  #10
  if(out_index==3'd6 && out_distance==10'h008)  $display("time", $time, "  output is correct\n");
  else begin
    $display("time", $time, "  output is Wrong .Your index is %d and min distance is %h , but Correct index is 6 and min distance is 008. \n",out_index,out_distance);
    error = error +1;
  end
  #10
  if(out_index==3'd6 && out_distance==10'h008)  $display("time", $time, "  output is correct\n");
  else begin
    $display("time", $time, "  output is Wrong .Your index is %d and min distance is %h , but Correct index is 6 and min distance is 008. \n",out_index,out_distance);
    error = error +1;
  end
  #10
  $display("-----------------------------------------------------------------------\n");

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
      clk=0; rst=1; clear=0; c_en=0; if_en=0;
      c_in0=0; c_in1=0; c_in2=0; c_in3=0; c_in4=0; c_in5=0; c_in6=0; c_in7=0; if_in=0;
  #10 rst=0;
  #10 c_en=1; if_en=1;
      c_in0=24'h000000; c_in1=24'hFF0000; c_in2=24'h921AFF; c_in3=24'h2828FF;
      c_in4=24'h00CACA; c_in5=24'h28FF28; c_in6=24'hFFFF37; c_in7=24'hFF8000;
      if_in=24'hFFFFFF;
  #10 clear=1;
  #10 clear=0; c_en=1; if_en=1;
      c_in0=24'hFF359A; c_in1=24'hA6FFFF; c_in2=24'h9AFF02; c_in3=24'h95CACA;
      c_in4=24'h28004D; c_in5=24'h019858; c_in6=24'hFF5809; c_in7=24'hAFAF61;
      if_in=24'h8C8C00;
  #10 c_en=1; if_en=0;
      c_in0=24'hBB5E00; c_in1=24'hCAFFFF; c_in2=24'hEA7500; c_in3=24'h7373B9;
      c_in4=24'hDDC1E0; c_in5=24'hFFECEC; c_in6=24'hFFF7FF; c_in7=24'hFAF4FF;
      if_in=24'hFFFFFF;
  #10 c_en=0; if_en=1;
      c_in0=24'hFF359A; c_in1=24'hA6FFFF; c_in2=24'h9AFF02; c_in3=24'h95CACA;
      c_in4=24'h28004D; c_in5=24'h019858; c_in6=24'hFF5809; c_in7=24'hAFAF61;
      if_in=24'hFFFFFF;
  #10 c_en=0; if_en=0;
      c_in0=24'h000000; c_in1=24'hFF0000; c_in2=24'h921AFF; c_in3=24'h2828FF;
      c_in4=24'h00CACA; c_in5=24'h28FF28; c_in6=24'hFFFF37; c_in7=24'hFF8000;
      if_in=24'hFFFFFF;
  #100 $finish;
end

initial begin
  `ifdef FSDB
    $fsdbDumpfile("top.fsdb");
    $fsdbDumpvars("+mda");
  	`elsif FSDB_ALL
    $fsdbDumpfile("top.fsdb");
    $fsdbDumpvars("+struct", "+mda", t);
    `endif
end
endmodule
