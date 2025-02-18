`timescale 1ns/10ps
`define CYCLE 10.0

//`include "/usr/cad/CBDK/CBDK018_UMC_Faraday_v1.0/orig_lib/fsa0m_a/2009Q2v2.0/GENERIC_CORE/FrontEnd/verilog/fsa0m_a_generic_core_21.lib.src"

`ifdef SYN
`include "Multiplier_CLA_syn.v"
`else
`include "Multiplier_CLA.v"
`endif

//`include "Multiplier_PPA.v"
//`include "Multiplier_CLA.v"

module tb;

reg [7:0] A_in, B_in;
wire [15:0] Product_o;

integer i, j;
reg [7:0] patternA, patternB;
reg [15:0] answer;

integer err;

/*
Multiplier_PPA Multiplier_PPA(
    .A(A_in),
    .B(B_in),
    .Product(Product_o)
);*/

Multiplier_CLA Multiplier_CLA(
    .A(A_in),
    .B(B_in),
    .Product(Product_o)
);

initial begin
    err = 0; answer = 0; patternA = 8'd0; patternB = 8'd0;
    # (`CYCLE);

    for (i = 0; i < 256; i=i+1) begin
        for (j = 0; j < 256; j=j+1) begin
            // feed input
            A_in = patternA;
            B_in = patternB;
            # (`CYCLE/2);
            

            // check answer
            answer = A_in * B_in;
            
            if(answer === Product_o) begin
                // do nothing!
            end
            else begin
                err = err + 1;
                $display("The correct answer is A*B = %d * %d = %d", A_in, B_in, answer);
                $display("Error: Your answer is A*B = %d * %d = %d",A_in, B_in, Product_o);
                $display("---------------------------------------------------------------------------------\n");
            end
            patternB = patternB + 1;
        end
        patternA = patternA + 1;
    end


    if ((err) === 0) begin
            $display("        ****************************               ");
            $display("        **                        **       |\__||  ");
            $display("        **  Congratulations !!    **      / O.O  | ");
            $display("        **                        **    /_____   | ");
            $display("        **  Simulation PASS!!     **   /^ ^ ^ \\  |");
            $display("        **                        **  |^ ^ ^ ^ |w| ");
            $display("        ****************************   \\m___m__|_|");
            $display("\n");
        end
        else begin
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
		$finish;
end

initial begin
	`ifdef FSDB
		$fsdbDumpfile("Multiplier_CLA.fsdb") ;
		$fsdbDumpvars;
	`endif
end

`ifdef SYN
	initial $sdf_annotate("Multiplier_CLA_syn.sdf", Multiplier_CLA);
`endif

endmodule