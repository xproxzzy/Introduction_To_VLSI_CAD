// ================================================ // 
//  Course:      IVCAD 2024 Spring                  //                       
//  Auther:      Zong-Jin CAI (Leo)                 //                         
//  Filename:    tb.v                               //                               
//  Description: testbench                          //                 
//  Version:     1.0                                // 
//  Date:        2024/02/26                         //     
// ================================================ //  


`timescale 1ns/10ps
`define CYCLE 1.0         	  
`define MAXCYCLE  10000000

`include "./RAM.v"
`ifdef SYN
`include "/usr/cad/CBDK/Executable_Package/Collaterals/IP/stdcell/N16ADFP_StdCell/VERILOG/N16ADFP_StdCell.v"
`include "./LBP_syn.v"
`else
`include "./LBP.v"
`endif

`define SDFFILE    "./LBP_syn.sdf"
`define PATTERN "./pattern.dat"    
`define GOLDEN  "./golden.dat"

module tb;

parameter N_PATT        = 4096; // 64 x 64 pixels
parameter N_GOLD        = N_PATT;
parameter ADDRWIDTH     = 12;
parameter DATAWIDTH     = 8;

// ================= [VARIABLES] ================== //
logic                                   clk;
logic                                   rst;
logic   [7:0]                           gold_mem    [0:N_GOLD-1];
logic                                   enable;
logic   [ADDRWIDTH-1:0]                 gray_addr;
logic                                   gray_OE;
logic   [DATAWIDTH-1:0]                 gray_data;
logic   [ADDRWIDTH-1:0]                 lbp_addr;
logic                                   lbp_WEN;
logic   [DATAWIDTH-1:0]                 lbp_data;
logic                                   finish;
logic   [DATAWIDTH-1:0]                 lbp_q;
integer                                 err;


// ================= [MODULE CONNECTIONS] ================== //
LBP LBP(
    .clk            (clk        ),            
    .rst            (rst        ),
    .enable         (enable     ),
    .gray_addr      (gray_addr  ),    
    .gray_OE        (gray_OE    ),    
    .gray_data      (gray_data  ),    
    .lbp_addr       (lbp_addr   ),    
    .lbp_WEN        (lbp_WEN    ),    
    .lbp_data       (lbp_data   ),    
    .finish         (finish     )
);


RAM  #(
    .ADDRWIDTH(ADDRWIDTH),
    .DATAWIDTH(DATAWIDTH)
) RAM_GRAY(
    .CK   (clk          ),      
    .A    (gray_addr    ),  
    .WE   (1'b0         ),  
    .OE   (gray_OE      ),  
    .D    ('d0          ),  
    .Q    (gray_data    )
);

RAM #(
    .ADDRWIDTH(ADDRWIDTH),
    .DATAWIDTH(DATAWIDTH)
) RAM_LBP(
    .CK   (clk          ),      
    .A    (lbp_addr     ),  
    .WE   (lbp_WEN      ),  
    .OE   (1'b0         ),  
    .D    (lbp_data     ),  
    .Q    (lbp_q        )
);

// ================= [SDF ANNOTATION] ================== //
`ifdef SDF
	initial $sdf_annotate(`SDFFILE, LBP);
`endif

// ================= [CLK GENERATION] ================== //
always begin #(`CYCLE/2) clk = ~clk; end

// ================= [MEM INITIALIZATION] ================== //
initial begin
    $readmemh(`PATTERN, RAM_GRAY.memory);
    $readmemh(`GOLDEN, gold_mem);
end


// ================= [PATTERN GENERATION] ================== //
// 1 degree = 0.0174532925 radian
initial begin
    clk = 1;
    rst = 1;
    enable = 0;
    err = 0;
    #(`CYCLE*3) rst = 0;

    enable = 1;
	#(`CYCLE*3) enable = 0;
    
    wait(finish);
    #(`CYCLE*3);
    for(integer i=0; i<N_GOLD; i++) begin
        if(gold_mem[i] === RAM_LBP.memory[i]) begin
            // do nothing
			err = err;
        end  
        else begin
            err = err + 1;
            $display("mem[%d] should be %h, instead of %h.\n", i, gold_mem[i],RAM_LBP.memory[i]);
        end
    end

    if ((err) === 0) begin
        $display("        ****************************               ");
        $display("        **                        **       |\__/|  ");
        $display("        **  Congratulations !!    **      / O.O  | ");
        $display("        **                        **    /_____   | ");
        $display("        **  Simulation PASS!!     **   /^ ^ ^ \\  |");
        $display("        **                        **  |^ ^ ^ ^ |w| ");
        $display("        ****************************   \\m___m__|_|");
        $display("\n");
    end
    else begin
        $display("        ****************************               ");
        $display("        **                        **       |\__/|  ");
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
    #(`MAXCYCLE)
    $display("        *******************************************");
    $display("        ** Simulation cannot terminate properly ** ");
    $display("        *******************************************");
    $finish;
end


endmodule
