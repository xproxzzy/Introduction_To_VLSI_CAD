`timescale 1ns/10ps
`define CYCLE 10.0

//`include "/usr/cad/CBDK/CBDK018_UMC_Faraday_v1.0/orig_lib/fsa0m_a/2009Q2v2.0/GENERIC_CORE/FrontEnd/verilog/fsa0m_a_generic_core_21.lib.src"
`ifdef SYN
`include "PPA32_syn.v"
`else
`include "PPA32.v"
`endif

module tb;

reg  signed [31:0] A_in, B_in;
wire signed [31:0] Sum_o;
wire overflow;

integer i, j;
reg [7:0] patternA, patternB;
reg signed [31:0] answer;
reg overflow_ans;
integer err;


PPA32 PPA32(
    .a(A_in),
    .b(B_in),
    .sum(Sum_o),
    .overflow(overflow)
);

initial begin
    err = 0; answer = 0; patternA = 8'd0; patternB = 8'd0; overflow_ans = 1'b0;
    # (`CYCLE);

    for (i = 0; i < 8; i=i+1) begin
        for (j = 0; j < 8; j=j+1) begin
            // feed input
            A_in = {4{patternA}};
            B_in = {4{patternB}};
            # (`CYCLE/2);
            

            // check answer
            answer = A_in + B_in;
            if (A_in[31] == B_in[31] && A_in[31] != answer[31]) overflow_ans = 1'b1;
            else overflow_ans = 1'b0;
            
            if(answer === Sum_o && overflow_ans === overflow) begin
                // do nothing!
            end
            else begin
                err = err + 1;
                $display("The correct answer is A+B = %d + %d = %d, overflow = %d", A_in, B_in, answer, overflow_ans);
                $display("Error: Your answer is A+B = %d + %d = %d, overflow = %d,",A_in, B_in, Sum_o, overflow);
                $display("---------------------------------------------------------------------------------\n");
            end
            patternB = patternB + 1;
        end
        patternA = patternA + 1;
    end

	# (`CYCLE/2);
    A_in = 42949672;
    B_in = 9672;
    answer = A_in + B_in;
    if (A_in[31] == B_in[31] && A_in[31] != answer[31]) overflow_ans = 1'b1;
    else overflow_ans = 1'b0;
    # (`CYCLE/2);
    if(answer === Sum_o && overflow_ans === overflow) begin
        // do nothing!
    end
    else begin
        err = err + 1;
        $display("The correct answer is A+B = %d + %d = %d, overflow = %d", A_in, B_in, answer, overflow_ans);
        $display("Error: Your answer is A+B = %d + %d = %d, overflow = %d,",A_in, B_in, Sum_o, overflow);
        $display("---------------------------------------------------------------------------------\n");
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
		$stop;
end


initial begin
	`ifdef FSDB
		$fsdbDumpfile("PPA32.fsdb") ;
		$fsdbDumpvars;
	`endif
end

`ifdef SYN
	initial $sdf_annotate("PPA32_syn.sdf", CLA32);
`endif

endmodule

//vcs -R -sverilog tb_PPA32.v -debug_access+all -full64 +define+FSDB
//vcs -R -sverilog tb_PPA32.v -debug_access+all -full64 +define+FSDB+syn
