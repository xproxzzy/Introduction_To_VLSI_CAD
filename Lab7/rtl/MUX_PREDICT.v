module MUX_PREDICT(
    input                   hist_wen_predict_HCU,
    input   [7:0]           hist_wdata_predict_HCU,
    input   [13:0]          hist_addr_predict_HCU,
    input                   hist_ren_predict_HCU,
    output  reg [7:0]       hist_rdata_predict_HCU,

    input   [13:0]          hist_addr_predict_DCU,
    input                   hist_ren_predict_DCU,
    output  reg [7:0]       hist_rdata_predict_DCU,

    input                   sel,

    input       [7:0]       hist_rdata_predict,
    output  reg [13:0]      hist_addr_predict,
    output  reg             hist_wen_predict,
    output  reg [7:0]       hist_wdata_predict,
    output  reg             hist_ren_predict
);

// put your design here
always @ (*)
begin
	if(sel == 1'b0)
	begin
		hist_rdata_predict_HCU = hist_rdata_predict;
		hist_rdata_predict_DCU = 8'd0;
		hist_addr_predict = hist_addr_predict_HCU;
		hist_wen_predict = hist_wen_predict_HCU;
		hist_wdata_predict = hist_wdata_predict_HCU;
		hist_ren_predict = hist_ren_predict_HCU;
	end
	else
	begin
		hist_rdata_predict_HCU = 8'd0;
		hist_rdata_predict_DCU = hist_rdata_predict;
		hist_addr_predict = hist_addr_predict_DCU;
		hist_wen_predict = 1'b0;
		hist_wdata_predict = 8'd0;
		hist_ren_predict = hist_ren_predict_DCU;
	end
end
endmodule