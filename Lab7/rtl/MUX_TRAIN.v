module MUX_TRAIN(
    input                   hist_wen_train_HCU,
    input   [7:0]           hist_wdata_train_HCU,
    input   [20:0]          hist_addr_train_HCU,
    input                   hist_ren_train_HCU,
    output  reg [7:0]       hist_rdata_train_HCU,

    input   [20:0]          hist_addr_train_DCU,
    input                   hist_ren_train_DCU,
    output  reg [7:0]       hist_rdata_train_DCU,

    input                   sel,

    input       [7:0]       hist_rdata_train,
    output  reg [20:0]      hist_addr_train,
    output  reg             hist_wen_train,
    output  reg [7:0]       hist_wdata_train,
    output  reg             hist_ren_train
);

// put your design here
always @ (*)
begin
	if(sel == 1'b0)
	begin
		hist_rdata_train_HCU = hist_rdata_train;
		hist_rdata_train_DCU = 8'd0;
		hist_addr_train = hist_addr_train_HCU;
		hist_wen_train = hist_wen_train_HCU;
		hist_wdata_train = hist_wdata_train_HCU;
		hist_ren_train = hist_ren_train_HCU;
	end
	else
	begin
		hist_rdata_train_HCU = 8'd0;
		hist_rdata_train_DCU = hist_rdata_train;
		hist_addr_train = hist_addr_train_DCU;
		hist_wen_train = 1'b0;
		hist_wdata_train = 8'd0;
		hist_ren_train = hist_ren_train_DCU;
	end
end
endmodule