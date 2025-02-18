// ================================================ // 
//  Course:      IVCAD 2024 Spring                  //                       
//  Auther:      Zong-Jin CAI (Leo)                 //                         
//  Filename:    tb.v                               //                               
//  Description: testbench                          //                 
//  Version:     1.0                                // 
//  Date:        2024/02/26                         //     
// ================================================ //  


`timescale 1ns/10ps
`define CYCLE      2.0          	  
`define MAXCYCLE  10000000

`include "./RAM.v"
`ifdef SYN
`include "/usr/cad/CBDK/Executable_Package/Collaterals/IP/stdcell/N16ADFP_StdCell/VERILOG/N16ADFP_StdCell.v"
`include "./CLBP_syn.v"
`else
`include "./CLBP.v"
`endif

`define SDFFILE    "./CLBP_syn.sdf"
`define PATTERN "./pattern.dat"    
`define GOLDEN  "./golden.dat"

module tb;

parameter N_PATT        = 4096; // 64 x 64 pixels
parameter N_GOLD        = N_PATT;
parameter INT_WIDTH     = 9;
parameter FRAC_WIDTH    = 16;
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
logic   [(INT_WIDTH+FRAC_WIDTH)-1:0]    theta;
logic                                   theta_valid;
logic   [(INT_WIDTH+FRAC_WIDTH)-1:0]    cos_data;
logic                                   cos_valid;
logic   [(INT_WIDTH+FRAC_WIDTH)-1:0]    sin_data;
logic                                   sin_valid;  
logic                                   finish;
logic   [DATAWIDTH-1:0]                 lbp_q;
integer                                 err;

logic   [(INT_WIDTH+FRAC_WIDTH)-1:0]    theta_tmp;
real tmp;

// ================= [MODULE CONNECTIONS] ================== //
CLBP CLBP(
    .clk            (clk        ),            
    .rst            (rst        ),
    .enable         (enable     ),
    .gray_addr      (gray_addr  ),    
    .gray_OE        (gray_OE    ),    
    .gray_data      (gray_data  ),    
    .lbp_addr       (lbp_addr   ),    
    .lbp_WEN        (lbp_WEN    ),    
    .lbp_data       (lbp_data   ),    
    .theta          (theta      ),
    .theta_valid    (theta_valid),        
    .cos_data       (cos_data   ),    
    .cos_valid      (cos_valid  ),    
    .sin_data       (sin_data   ),    
    .sin_valid      (sin_valid  ),
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

    
    wait(finish);
    #(`CYCLE*3);
    for(integer i=0; i<N_GOLD; i++) begin
        if(gold_mem[i] === RAM_LBP.memory[i]) begin
            // do nothing
        end  
        else begin
            err = err + 1;
            $display("mem[%d] should be %h, instead of %h.\n", i, gold_mem[i],RAM_LBP.memory[i]);
        end
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

always_ff @(posedge clk) begin
    if(rst) begin
        cos_data <= 0;
        sin_data <= 0;
        cos_valid <= 0;
        sin_valid <= 0;
    end
    else begin
        if(theta_valid) begin
            if(theta == 0) cos_data <= {1'b0,8'd1,16'd0};
            else cos_data <= dec2fix($cos(fix2dec(theta)));
            cos_valid <= 1'b1;
        end

        if(theta_valid) begin
            if(theta == 0) sin_data <= {1'b0,8'd0,16'd0};
            else sin_data <= dec2fix($sin(fix2dec(theta)));
            sin_valid <= 1'b1;
        end
        
        else begin
            cos_data <= 0;
            sin_data <= 0;
            cos_valid <= 0;
            sin_valid <= 0;
        end
        
    end
end

initial begin
    #(`MAXCYCLE)
    $display("        *******************************************");
    $display("        ** Simulation cannot terminate properly ** ");
    $display("        *******************************************");
    $finish;
end


function real fix2dec;
    input [(INT_WIDTH+FRAC_WIDTH)-1:0] data_i;
    integer i;
    begin
        fix2dec = 0;
        for(i=0;i<(INT_WIDTH+FRAC_WIDTH);i++) begin
            fix2dec += (data_i[((INT_WIDTH+FRAC_WIDTH)-1)-(i+1)] * $pow(2,(7-i)));
        end
    end
endfunction


function [(INT_WIDTH+FRAC_WIDTH)-1:0] dec2fix;
    input real data_i;
    integer i;
    integer round;
    real tmp;
    begin
        tmp = data_i * $pow(2,16);
        round = $rtoi(tmp);
        if(round == 32'd0) dec2fix = 25'd1;
        else dec2fix = round[(INT_WIDTH+FRAC_WIDTH)-1:0];
    end
endfunction













endmodule