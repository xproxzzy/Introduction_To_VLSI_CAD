// ================================================ // 
//  Course:      IVCAD 2024 Spring                  //                       
//  Auther:      Zong-Jin CAI (Leo)                 //                         
//  Filename:    top_tb.sv                          //                               
//  Description: testbench                          //                 
//  Version:     1.0                                // 
//  Date:        2024/02/07                         //     
// ================================================ //     

`timescale 1ns/10ps

// =============== [Include files] =============== //
`include "RAM.v"

`ifdef SYN
  `include "/usr/cad/CBDK/Executable_Package/Collaterals/IP/stdcell/N16ADFP_StdCell/VERILOG/N16ADFP_StdCell.v"
  `include "../syn/top_syn.v"
`else
  `include "../rtl/top.v"
`endif


// =============== [Macro definition] =============== //
`define CYCLE 2.0
`define MAXCYCLE 2000000000
`define DATAWIDTH 8
`define ADDRWIDTH_ID  8
`define ADDRWIDTH_LBP 12
`define ADDRWIDTH_HIST 21
`define ADDRWIDTH_HIST_PREDICT 14
`define DATAWIDTH_ID 5
`define GRAY_PATH_TRAIN "./HEX/GRAY/TRAIN/"
`define GRAY_PATH_PREDICT "./HEX/GRAY/PREDICT/"
`define LBP_PATH_TRAIN "./HEX/LBP/TRAIN/"
`define LBP_PATH_PREDICT "./HEX/LBP/PREDICT/"
`define HIST_PATH_TRAIN "./HEX/HIST/TRAIN/"
`define HIST_PATH_PREDICT "./HEX/HIST/PREDICT/"
`define ID_PATH_TRAIN "./HEX/ID/id_train.hex"
`define ID_PATH_PREDICT "./HEX/ID/id_predict.hex"
`define ID_PATH_PREDICT_GOLDEN "./HEX/predictions.hex"
`define MINDIST_PATH_GOLDEN "./HEX/minDistances.hex"
`define PERSON 5 // altered
`define TRAINNUM 7
`define DATANUM 11
`define GRIDX 8
`define GRIDY 8
`define POSITIONS 256

`define SDFFILE    "../syn/top_syn.sdf"


module top_tb;
    parameter PREDICTNUM 	= `DATANUM - `TRAINNUM;
	parameter INT_WIDTH     = 9;
    parameter FRAC_WIDTH    = 16;
	parameter N_PATT        = 4096;
	parameter N_GOLD        = N_PATT;
	
	
    // ============= [Global variables] ============ //
    logic clk;
    logic rst;
	
	logic [7:0]                 CLBP_GOLDEN    	[0:N_GOLD-1];
    logic [`DATAWIDTH-1:0] 		HIST_GOLDEN 	[0:(`GRIDX*`GRIDY*`POSITIONS-1)];
    logic [17:0] 				MINDIST_GOLDEN 	[0:(`PERSON*PREDICTNUM-1)];
    logic [`DATAWIDTH_ID-1:0] 	ID_TRAIN 		[0:(`PERSON*`TRAINNUM-1)];
    logic [`DATAWIDTH_ID-1:0] 	ID_PREDICT 		[0:(`PERSON*PREDICTNUM-1)];
    logic [`DATAWIDTH_ID-1:0] 	PREDICT_GOLDEN 	[0:(`PERSON*PREDICTNUM-1)];
    

    integer i;
    integer err;
    integer hist_offset;
    string p_s,t_s;
    string gray_file_path, lbp_file_path, hist_file_path;
    integer p,t;

    // ============== [top connections] ============ //
    logic mode;
    logic enable;
	
	logic 									valid;
    logic [4:0] 							id;
    logic [3:0] 							gridX;
    logic [3:0] 							gridY;
	
	// CLBP
	logic 									lbp_enable;
	logic [11:0] 							gray_addr;
	logic 									gray_ren;
	logic [7:0] 							gray_rdata;
	logic [11:0] 							lbp_addr;
    logic        							lbp_ren;
	logic									lbp_wen;
    logic [7:0]  							lbp_rdata;
	logic [7:0]                           	lbp_wdata;
	logic [(INT_WIDTH+FRAC_WIDTH)-1:0]    	theta; // in radian
    logic                                 	theta_valid;
    logic [(INT_WIDTH+FRAC_WIDTH)-1:0]    	cos_data;
    logic                                 	cos_valid;
    logic [(INT_WIDTH+FRAC_WIDTH)-1:0]    	sin_data;
    logic                                   sin_valid;
	logic 									lbp_finish;
	
    logic [7:0]  							id_addr;
    logic [4:0]  							id_wdata;
    logic        							id_wen;
    logic        							id_ren;
    logic [4:0]  							id_rdata;
								
    logic [20:0] 							hist_addr_train;
    logic [7:0]  							hist_wdata_train;
    logic        							hist_wen_train;
    logic        							hist_ren_train;
    logic [7:0]  							hist_rdata_train;
								
    logic [13:0] 							hist_addr_predict;
    logic [7:0]  							hist_wdata_predict;
    logic        							hist_wen_predict;
    logic        							hist_ren_predict;
    logic [7:0]  							hist_rdata_predict;
	
    logic        							hcu_finish;
    logic        							done;
    logic [4:0]  							label;
    logic [17:0] 							minDistance;
	
	logic   [(INT_WIDTH+FRAC_WIDTH)-1:0]    theta_tmp;
	real tmp;
	
	integer seed;
    

    top top(
        .clk                (clk               	),                    
        .rst                (rst               	),    
        .enable             (enable            	),    
        .mode               (mode              	),    
        .valid              (valid             	),    
        .id                 (id                	),
        .gridX              (gridX             	),    
        .gridY              (gridY             	),
		.gray_addr          (gray_addr			),
		.gray_ren           (gray_ren			),
		.gray_rdata         (gray_rdata			),
		.lbp_addr           (lbp_addr			),
		.lbp_wen            (lbp_wen			),
		.lbp_ren            (lbp_ren			),
		.lbp_rdata          (lbp_rdata			),
		.lbp_wdata          (lbp_wdata			),
		.theta              (theta			  	),
		.theta_valid        (theta_valid		),	
		.cos_data           (cos_data			),
		.cos_valid          (cos_valid			),
        .sin_data           (sin_data			),
        .sin_valid          (sin_valid			),
        .lbp_finish         (lbp_finish			),
        .id_addr            (id_addr           	),        
        .id_wdata           (id_wdata          	),        
        .id_wen             (id_wen            	),    
        .id_ren             (id_ren            	),    
        .id_rdata           (id_rdata          	),        
        .hist_addr_train    (hist_addr_train   	),                
        .hist_wdata_train   (hist_wdata_train  	),                
        .hist_wen_train     (hist_wen_train    	),            
        .hist_ren_train     (hist_ren_train    	),            
        .hist_rdata_train   (hist_rdata_train  	),                
        .hist_addr_predict  (hist_addr_predict 	),                
        .hist_wdata_predict (hist_wdata_predict	),                
        .hist_wen_predict   (hist_wen_predict  	),                
        .hist_ren_predict   (hist_ren_predict  	),                
        .hist_rdata_predict (hist_rdata_predict	),    
        .hcu_finish         (hcu_finish        	),   
        .label              (label             	),
        .minDistance        (minDistance       	),         
        .done               (done              	)
    );
	
	RAM  #(
		.ADDRWIDTH(`ADDRWIDTH_LBP),
		.DATAWIDTH(`DATAWIDTH)
	) RAM_GRAY(
		.CK   (clk          ),      
		.A    (gray_addr    ),  
		.WE   (1'b0         ),  
		.OE   (gray_ren     ),  
		.D    (8'd0         ),  
		.Q    (gray_rdata   )
	);

    RAM #(
        .ADDRWIDTH(`ADDRWIDTH_LBP),
        .DATAWIDTH(`DATAWIDTH)
    )   LBP_RAM(
        .CK (clk        ),
        .A  (lbp_addr   ),
        .WE (lbp_wen    ),
        .OE (lbp_ren    ),
        .D  (lbp_wdata  ),
        .Q  (lbp_rdata  )
    );

    RAM #(
        .ADDRWIDTH(`ADDRWIDTH_ID),
        .DATAWIDTH(`DATAWIDTH_ID)
    )   ID_RAM (
        .CK (clk      ),
        .A  (id_addr  ),
        .WE (id_wen   ),
        .OE (id_ren   ),
        .D  (id_wdata ),
        .Q  (id_rdata )
    );

    RAM #(
        .ADDRWIDTH(`ADDRWIDTH_HIST),
        .DATAWIDTH(`DATAWIDTH)
    )   HIST_RAM_TRAIN(
        .CK (clk              ),
        .A  (hist_addr_train  ),
        .WE (hist_wen_train   ),
        .OE (hist_ren_train   ),
        .D  (hist_wdata_train ),
        .Q  (hist_rdata_train ) 
    );

    RAM #(
        .ADDRWIDTH(`ADDRWIDTH_HIST_PREDICT),
        .DATAWIDTH(`DATAWIDTH)
    )   HIST_RAM_PREDICT(
        .CK (clk                ),
        .A  (hist_addr_predict  ),
        .WE (hist_wen_predict   ),
        .OE (hist_ren_predict   ),
        .D  (hist_wdata_predict ),
        .Q  (hist_rdata_predict )
    );
	
	


    // ================= [CLK gernetation] ================== //
    always begin #(`CYCLE/2) clk = ~clk; end
	
	// ================= [SDF ANNOTATION] ================== //
	`ifdef SDF
		initial $sdf_annotate(`SDFFILE, top);
	`endif

    initial begin
        $readmemh(`ID_PATH_TRAIN, ID_TRAIN);
        $readmemh(`ID_PATH_PREDICT, ID_PREDICT);
        $readmemh(`ID_PATH_PREDICT_GOLDEN, PREDICT_GOLDEN);
        $readmemh(`MINDIST_PATH_GOLDEN, MINDIST_GOLDEN);
    end
	
	
	// ================= [UTILITY function] ================== //
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
			if (tmp < 0 && round == 32'd0) begin
				dec2fix = 25'b1_1111_1111_1111_1111_1111_1111;
			end
			else if (round == 32'd0) dec2fix = 25'd1;
			else dec2fix = round[(INT_WIDTH+FRAC_WIDTH)-1:0];
		end
	endfunction

    
    // ================= [Simulation starts] ================== //
    initial begin
		seed = 2;
        clk = 1;
        rst = 1;
        mode = 0;
        enable = 0;
        valid = 0;
        gridX = 0;
        gridY = 0;
        hist_offset = 0;
        id = 0;
        #(`CYCLE*3) rst = 0;

        // Training 
        mode = 0;
        enable= 1'b1;
        gridX = 8;
        gridY = 8;
        #(`CYCLE)  enable = 1'b0;
        gridX = 0;
        gridY = 0;

        $display("=================== Training begins!!! =========================\n");
        for(int p=0; p<`PERSON; p++) begin
            p_s.itoa(p+1);
            err = 0;
            for(int t=0; t<`TRAINNUM; t++) begin
                //$display("hist_offset: %d\n",hist_offset);
                hist_offset = p*`TRAINNUM*`GRIDX*`GRIDY*`POSITIONS+t*`GRIDX*`GRIDY*`POSITIONS;
                t_s.itoa(t);
				gray_file_path = {`GRAY_PATH_TRAIN, "subject",p_s,"_",t_s,".hex"};
                lbp_file_path = {`LBP_PATH_TRAIN,"subject",p_s,"_",t_s,".hex"};
                hist_file_path = {`HIST_PATH_TRAIN,"subject",p_s,"_",t_s,".hex"};
				$readmemh(gray_file_path, RAM_GRAY.memory);
				$readmemh(lbp_file_path, CLBP_GOLDEN);
                //$readmemh(lbp_file_path, LBP_RAM.memory);
                $readmemh(hist_file_path, HIST_GOLDEN);
				
				
				// CLBP computation
				id = ID_TRAIN[p*`TRAINNUM+t];
                valid= 1'b1;
                #(`CYCLE) 
                valid = 1'b0;
                id = 'd0;
                err = 0;
				
				wait(lbp_finish);
				#(`CYCLE*2);
				for(integer i=0; i<N_GOLD; i++) begin
					if(CLBP_GOLDEN[i] === LBP_RAM.memory[i]) begin
						// do nothing
						err = err;
					end  
					else begin
						err = err + 1;
						$display("LBP RAM[%d] should be %h, instead of %h.\n", i, CLBP_GOLDEN[i],LBP_RAM.memory[i]);
					end
				end
				
				if((err) === 0) begin
                    $display("        ********************************               ");
                    $display("        **   %s CLBP PASS!!   **",{"subject",p_s,"_",t_s});
                    $display("        ********************************               ");
                    $display("\n");
                end
                else begin
                    $display("        ********************************               ");
                    $display("        **   %s CLBP FAILED!! **",{"subject",p_s,"_",t_s});
                    $display("        ********************************               ");
                    $display("\n");
                    $finish;
                end
                

                wait(hcu_finish)
                #(`CYCLE*2)
                for(i = 0; i < `GRIDX*`GRIDY*`POSITIONS; i = i + 1) begin
                    if(HIST_RAM_TRAIN.memory[i+hist_offset] === HIST_GOLDEN[i]) begin
                        continue;
                    end 
                    else begin
                        err = err + 1;
                        $display("mem[%d] should be %d, instead of %d.\n",i,HIST_GOLDEN[i],HIST_RAM_TRAIN.memory[i+hist_offset]);
                    end
                end

                if((err) === 0) begin
                    $display("        *************************************               ");
                    $display("        **   %s Histogram PASS!!   **",{"subject",p_s,"_",t_s});
                    $display("        *************************************               ");
                    $display("\n");
                end
                else begin
                    $display("        *************************************               ");
                    $display("        **   %s Histogram FAILED!! **",{"subject",p_s,"_",t_s});
                    $display("        *************************************               ");
                    $display("\n");
                    $finish;
                end
            end
        end
        
        $display("=================== Prediction begins!!! =========================\n");
        
        // Prediction -> exhaustive testing
        // mode = 1;
        // for(int p=0; p<`PERSON; p++) begin
        //    p_s.itoa(p+1);
        //    err = 0;
        //    for(int t=`TRAINNUM; t<`DATANUM; t++) begin
        //        t_s.itoa(t);
        //        lbp_file_path = {`LBP_PATH_PREDICT,"subject",p_s,"_",t_s,".hex"};
        //        hist_file_path = {`HIST_PATH_PREDICT,"subject",p_s,"_",t_s,".hex"};
        //        $readmemh(lbp_file_path, LBP_RAM.memory);
        //        $readmemh(hist_file_path, HIST_GOLDEN);
		//
        //        valid= 1'b1;
        //        //$display("p: %d, PREDICTNUM: %d, t: %d, `TRAINNUM: %d\n", p, PREDICTNUM, t, `TRAINNUM);
        //        //$display("p*PREDICTNUM: %d, (t-`TRAINNUM): %d",p*PREDICTNUM,(t-`TRAINNUM));
        //        //$display("p*PREDICTNUM+(t-`TRAINNUM) = %d.\n",p*PREDICTNUM+(t-`TRAINNUM));
        //        id = ID_PREDICT[p*PREDICTNUM+(t-`TRAINNUM)];
        //        #(`CYCLE) 
        //        valid = 1'b0;
        //        id = 'd0;
        //        err = 0;
		//
        //        wait(hcu_finish)
        //        #(`CYCLE*2)
        //        for(i = 0; i < `GRIDX*`GRIDY*`POSITIONS; i = i + 1) begin
        //            if(HIST_RAM_PREDICT.memory[i] === HIST_GOLDEN[i]) begin
        //                continue;
        //            end 
        //            else begin
        //                err = err + 1;
        //                //$display("mem[%d] should be %d, instead of %d.\n",i,HIST_GOLDEN[i],HIST_RAM_PREDICT.memory[i]);
        //            end
        //        end
		//
        //        if((err) === 0) begin
        //            //$display("        ****************************               ");
        //            //$display("        **   %s PASS!!   **",{"subject",p_s,"_",t_s});
        //            //$display("        ****************************               ");
        //            //$display("\n");
        //        end
        //        else begin
        //            $display("        ****************************               ");
        //            $display("        **   %s FAILED!! **",{"subject",p_s,"_",t_s});
        //            $display("        ****************************               ");
        //            $display("\n");
        //            $finish;
        //        end
		//
        //        err=0;
        //        wait(done)
        //        if(label == PREDICT_GOLDEN[p*PREDICTNUM+(t-`TRAINNUM)] && minDistance == MINDIST_GOLDEN[p*PREDICTNUM+(t-`TRAINNUM)]) begin
        //            
        //        end
        //        else begin
        //            err = err + 1;
        //            $display("Prediction sholud be %d, instead of %d.\n", PREDICT_GOLDEN[p*PREDICTNUM+(t-`TRAINNUM)],label);
        //        end
		//
        //        #(`CYCLE*3);
        //        if((err) === 0) begin
        //            $display("        ****************************                                          ");
        //            $display("        ** Prediction %d PASS!!   **",  ID_PREDICT[p*PREDICTNUM+(t-`TRAINNUM)]);
        //            $display("        ****************************                                          ");
        //            $display("\n");
        //        end
		//
        //        else begin
        //            $display("        ****************************                                          ");
        //            $display("        ** Prediction %d FAILED!! **",   ID_PREDICT[p*PREDICTNUM+(t-`TRAINNUM)]);
        //            $display("        ****************************                                          ");
        //            $display("\n");
        //            $finish;
        //        end
        //        
        //    end
        //end

        // Prediction -> random testing, each person one picture
        mode = 1;
		#(`CYCLE);
		void'($urandom(seed));
        for(int k=0; k < 5; k++) begin
            err = 0;
            p = $urandom_range(0,`PERSON-1);
            t = $urandom_range(`TRAINNUM,`DATANUM-1);

            p_s.itoa(p+1);
            t_s.itoa(t);
            
            $display("Prediction of subject P: %d with pic T: %d.\n", p+1, t);
			gray_file_path = {`GRAY_PATH_PREDICT, "subject",p_s,"_",t_s,".hex"};
            lbp_file_path = {`LBP_PATH_PREDICT,"subject",p_s,"_",t_s,".hex"};
            hist_file_path = {`HIST_PATH_PREDICT,"subject",p_s,"_",t_s,".hex"};
			$readmemh(gray_file_path, RAM_GRAY.memory);
			$readmemh(lbp_file_path, CLBP_GOLDEN);
            //$readmemh(lbp_file_path, LBP_RAM.memory);
            $readmemh(hist_file_path, HIST_GOLDEN);

            valid= 1'b1;
            id = ID_PREDICT[p*PREDICTNUM+(t-`TRAINNUM)];
            #(`CYCLE) 
            valid = 1'b0;
            id = 'd0;
            err = 0;
			
			
			wait(lbp_finish);
			#(`CYCLE*2);
			for(integer i=0; i<N_GOLD; i++) begin
				if(CLBP_GOLDEN[i] === LBP_RAM.memory[i]) begin
					// do nothing
					err = err;
				end  
				else begin
					err = err + 1;
					$display("LBP RAM[%d] should be %h, instead of %h.\n", i, CLBP_GOLDEN[i],LBP_RAM.memory[i]);
				end
			end
			
			if((err) === 0) begin
				//$display("        ********************************               ");
				//$display("        **   %s CLBP PASS!!   **",{"subject",p_s,"_",t_s});
				//$display("        ********************************               ");
				//$display("\n");
			end
			else begin
				$display("        ********************************               ");
				$display("        **   %s CLBP FAILED!! **",{"subject",p_s,"_",t_s});
				$display("        ********************************               ");
				$display("\n");
				$finish;
			end
				

            wait(hcu_finish)
            #(`CYCLE*2)
            for(i = 0; i < `GRIDX*`GRIDY*`POSITIONS; i = i + 1) begin
                if(HIST_RAM_PREDICT.memory[i] === HIST_GOLDEN[i]) begin
                    //continue;
					err = err;
                end 
                else begin
                    err = err + 1;
                    $display("mem[%d] should be %d, instead of %d.\n",i,HIST_GOLDEN[i],HIST_RAM_PREDICT.memory[i]);
                end
            end

            if((err) === 0) begin
                //$display("        *************************************               ");
                //$display("        **   %s Histogram PASS!!   **",{"subject",p_s,"_",t_s});
                //$display("        *************************************               ");
                //$display("\n");
            end
            else begin
                $display("        *************************************               ");
                $display("        **   %s Histogram FAILED!! **",{"subject",p_s,"_",t_s});
                $display("        *************************************               ");
                $display("\n");
                $finish;
            end

            wait(done)
            if(label === PREDICT_GOLDEN[p*PREDICTNUM+(t-`TRAINNUM)] && minDistance === MINDIST_GOLDEN[p*PREDICTNUM+(t-`TRAINNUM)]) begin
                err = err;
            end
            else begin
                err = err + 1;
                $display("Prediction sholud be %d, your answer is %d.\n", PREDICT_GOLDEN[p*PREDICTNUM+(t-`TRAINNUM)],label);
				$display("minDistance sholud be %d, your answer is %d.\n", MINDIST_GOLDEN[p*PREDICTNUM+(t-`TRAINNUM)],minDistance);
            end

            #(`CYCLE*3);
            if((err) === 0) begin
                $display("        *********************************                                     ");
                $display("        ** Prediction of Subject %d PASS!!   **",  ID_PREDICT[p*PREDICTNUM+(t-`TRAINNUM)]);
                $display("        *********************************                                     ");
                $display("\n");
            end

            else begin
                $display("        *********************************                                     ");
                $display("        ** Prediction of Subject%d FAILED!! **",   ID_PREDICT[p*PREDICTNUM+(t-`TRAINNUM)]);
                $display("        *********************************                                     ");
                $display("\n");
                $finish;
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



        $display("total simulation time: %0t ns", ($time)/100);
        $finish;
    end
	
    `ifdef FSDB
		initial begin
		  $fsdbDumpfile("top.fsdb");
		  $fsdbDumpvars("+struct", "+mda", top);
		end
	`endif
	initial begin
        #(`MAXCYCLE) 
        $display("        *******************************************");
        $display("        ** Simulation cannot terminate properly ***");
        $display("        *******************************************");
        $finish;
    end
	
	

	
endmodule