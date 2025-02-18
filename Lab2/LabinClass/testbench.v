//vcs -R testbench.v -debug_access+all -full64
//vcs -R testbench.v -debug_access+all -full64 +define+FSDB
`timescale 1ns/10ps
`define CYCLE 10

`include "RCA16.v"

module tb;

reg  signed [15:0] A_in, B_in;
wire signed [15:0] Sum_o;
wire overflow;

integer i, j;
reg [3:0] patternA, patternB;
reg signed [15:0] answer;
reg overflow_ans;
integer err;


RCA16 RCA(
    .a(A_in),
    .b(B_in),
    .sum(Sum_o),
    .overflow(overflow)
);

initial begin
    err = 0; answer = 0; patternA = 4'd0; patternB = 4'd0; overflow_ans = 1'b0;
    # (`CYCLE);

    for (i = 0; i < 16; i=i+1) begin
        for (j = 0; j < 16; j=j+1) begin
            // feed input
            A_in = {4{patternA}};
            B_in = {4{patternB}};
            # (`CYCLE/2);
            

            // check answer
            answer = A_in + B_in;
            if (A_in[15] == B_in[15] && A_in[15] != answer[15]) overflow_ans = 1'b1;
            else overflow_ans = 1'b0;
            $write("A+B = %d + %d = %d, overflow = %d", A_in, B_in, answer, overflow_ans);
            
			if(answer === Sum_o && overflow_ans === overflow) begin
				$write("   Correct!\n");
			end
			else begin
				$write("   Error: ");
				$write("   Your sum: %d", Sum_o);
				
				$write("   Your overflow: %d\n", overflow);
				err = err + 1;
			end
            
            # (`CYCLE/2);
            patternB = patternB + 1;
        end
        patternA = patternA + 1;
    end

    if (err == 0) begin
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
        $display("         Totally has %d errors                     ", err); 
		$display("\n");
    end
    $finish;
end

initial begin
	`ifdef FSDB
		$fsdbDumpfile("RCA16.fsdb");
		$fsdbDumpvars;
	`endif
end

endmodule