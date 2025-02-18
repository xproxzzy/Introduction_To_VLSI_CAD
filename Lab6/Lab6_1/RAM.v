//*************************************************
//** 2019 spring iVCAD
//** Description: Random-access memory
//** Mar. 2018 Henry authored
//** Mar. 2019 Kevin revised
//** Mar. 2020 Claire revised
//** Feb. 2024 Leo revised
//*************************************************

`timescale 1ns/10ps

module RAM #(
    parameter ADDRWIDTH = 12,
    parameter DATAWIDTH = 8
)
(CK, A, WE, OE, D, Q);

  input                     CK;
  input  [ADDRWIDTH-1:0]    A;
  input                     WE;
  input                     OE;
  input  [DATAWIDTH-1:0]    D;
  output [DATAWIDTH-1:0]    Q;

  reg    [DATAWIDTH-1:0]    Q;
  reg    [ADDRWIDTH-1:0]    latched_A;
  reg    [ADDRWIDTH-1:0]    latched_A_neg;
  reg    [DATAWIDTH-1:0]    memory [0:(2 << ADDRWIDTH - 1)];

  always @(posedge CK) begin
  
    if (WE) begin
	
		memory[A] <= D;
		
    end
	
		latched_A <= A;
  end
  
  always@(negedge CK) begin
	latched_A_neg <= latched_A;
  end
  
  always @(*) begin
  
    if (OE) begin
	
      Q = memory[latched_A_neg];
	  
    end
    else begin
	
      Q = {DATAWIDTH{1'hz}};
	  
    end
	
  end

endmodule
