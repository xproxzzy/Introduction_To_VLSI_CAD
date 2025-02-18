module MUX_LBP(
    input   [11:0]          lbp_addr_CLBP,
    input                   lbp_WEN_CLBP,
    input   [7:0]           lbp_data_CLBP,

    input                   lbp_ren_HCU,
    input       [11:0]      lbp_addr_HCU,
    output  reg [7:0]       lbp_rdata_HCU,

    input                   sel,

    input       [7:0]       lbp_rdata,
    output  reg [11:0]      lbp_addr,
    output  reg             lbp_wen,
    output  reg [7:0]       lbp_wdata,
    output  reg             lbp_ren
);

// put your design here
always @ (*)
begin
	if(sel == 1'b0)
	begin
		lbp_addr = lbp_addr_CLBP;
		lbp_wen = lbp_WEN_CLBP;
		lbp_wdata = lbp_data_CLBP;
		lbp_ren = 1'b0;
		lbp_rdata_HCU = 8'd0;
	end
	else
	begin
		lbp_addr = lbp_addr_HCU;
		lbp_wen = 1'b0;
		lbp_wdata = 8'd0;
		lbp_ren = lbp_ren_HCU;
		lbp_rdata_HCU = lbp_rdata;
	end
end
endmodule