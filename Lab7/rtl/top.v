`include "../rtl/CLBP.v"
`include "../rtl/HCU.v"
`include "../rtl/DCU.v"
`include "../rtl/Comparator.v"
`include "../rtl/Controller.v"
`include "../rtl/MUX_LBP.v"
`include "../rtl/MUX_TRAIN.v"
`include "../rtl/MUX_PREDICT.v"
`include "../rtl/MUX_ID.v"

module top(
    input           clk,
    input           rst,
    input           enable,
    input           mode,
    input           valid, 
    input   [4:0]   id,
    input   [3:0]   gridX,
    input   [3:0]   gridY,

    // CLBP I/O & LBP RAM
	output 	[11:0]	gray_addr,
	output			gray_ren,
	input	[7:0]	gray_rdata,
    output  [11:0]  lbp_addr,
    output          lbp_wen,
	output			lbp_ren,
    input   [7:0]   lbp_rdata,
	output	[7:0] 	lbp_wdata,
	output	[24:0]	theta,
	output			theta_valid,
	input	[24:0]	cos_data,
	input			cos_valid,
	input	[24:0]	sin_data,
	input			sin_valid,
	output			lbp_finish,
	
    // ID RAM I/O
    output  [7:0]   id_addr,
    output  [4:0]   id_wdata,
    output          id_wen,
    output          id_ren,
    input   [4:0]   id_rdata,

    // HIST TRAIN RAM I/O
    output  [20:0]  hist_addr_train,
    output  [7:0]   hist_wdata_train,
    output          hist_wen_train,
    output          hist_ren_train,
    input   [7:0]   hist_rdata_train,

    // HIST PREDICT RAM I/O
    output  [13:0]  hist_addr_predict,
    output  [7:0]   hist_wdata_predict,
    output          hist_wen_predict,
    output          hist_ren_predict,
    input   [7:0]   hist_rdata_predict,  

    output          hcu_finish,
    output          done,
    output  [4:0]   label,
    output  [17:0]  minDistance
);
// put your design here
wire 			lbp_enable;
wire [11:0]		lbp_addr_CLBP;
wire 			lbp_WEN_CLBP;
wire [7:0]		lbp_data_CLBP;

wire			hcu_enable;
wire [3:0]		gridX_o;
wire [3:0]		gridY_o;
wire 			lbp_ren_HCU;
wire [11:0]		lbp_addr_HCU;
wire [7:0]		lbp_rdata_HCU;
wire 			hist_wen_train_HCU;
wire [7:0]		hist_wdata_train_HCU;
wire [20:0]		hist_addr_train_HCU;
wire 			hist_ren_train_HCU;
wire [7:0]		hist_rdata_train_HCU;
wire 			hist_wen_predict_HCU;
wire [7:0]		hist_wdata_predict_HCU;
wire [13:0]		hist_addr_predict_HCU;
wire 			hist_ren_predict_HCU;
wire [7:0]		hist_rdata_predict_HCU;

wire			dcu_enable;
wire			dcu_valid;
wire [17:0]		distance;
wire [20:0]		hist_addr_offset;
wire [20:0]		hist_addr_train_DCU;
wire 			hist_ren_train_DCU;
wire [7:0]		hist_rdata_train_DCU;
wire [13:0]		hist_addr_predict_DCU;
wire 			hist_ren_predict_DCU;
wire [7:0]		hist_rdata_predict_DCU;

wire			comparator_enable;
wire			id_ren_Comparator;
wire [7:0]		id_counter_Comparator;//address
wire [4:0]		id_Comparator;//rdata

wire			ram_clbp;
wire			ram_comp;
wire [7:0]		id_addr_Controller;
wire [4:0]		id_wdata_Controller;
wire			id_wen_Controller;

CLBP CLBP(
    .clk(clk),
    .rst(rst),
    .enable(lbp_enable),
    .gray_addr(gray_addr),
    .gray_OE(gray_ren),
    .gray_data(gray_rdata),
    .lbp_addr(lbp_addr_CLBP),
    .lbp_WEN(lbp_WEN_CLBP),
    .lbp_data(lbp_data_CLBP),
    .theta(theta),
    .theta_valid(theta_valid),
    .cos_data(cos_data),
    .cos_valid(cos_valid),
    .sin_data(sin_data),
    .sin_valid(sin_valid),
    .finish(lbp_finish)
);

HCU HCU(
    .clk(clk),
    .rst(rst),
    .mode(mode),
    .enable(hcu_enable),
    .gridX(gridX_o),
    .gridY(gridY_o),
    .lbp_ren(lbp_ren_HCU),
    .lbp_addr(lbp_addr_HCU),
    .lbp_rdata(lbp_rdata_HCU),
    .hist_wen_train(hist_wen_train_HCU),
    .hist_wdata_train(hist_wdata_train_HCU),
    .hist_addr_train(hist_addr_train_HCU),
    .hist_ren_train(hist_ren_train_HCU),
    .hist_rdata_train(hist_rdata_train_HCU),
    .hist_wen_predict(hist_wen_predict_HCU),
    .hist_wdata_predict(hist_wdata_predict_HCU),
    .hist_addr_predict(hist_addr_predict_HCU),
    .hist_ren_predict(hist_ren_predict_HCU),
    .hist_rdata_predict(hist_rdata_predict_HCU),
    .done(hcu_finish)
);

DCU DCU(
	.clk(clk),
	.rst(rst),
	.enable(dcu_enable),
	.hist_addr_offset(hist_addr_offset),
	.hist_addr_train(hist_addr_train_DCU),
	.hist_ren_train(hist_ren_train_DCU),
	.hist_rdata_train(hist_rdata_train_DCU),
	.hist_addr_predict(hist_addr_predict_DCU),
	.hist_ren_predict(hist_ren_predict_DCU),
	.hist_rdata_predict(hist_rdata_predict_DCU),
	.distance(distance),
	.valid(dcu_valid)
);

Comparator Comparator(
	.clk(clk),
	.rst(rst),
	.enable(comparator_enable),
	.histcount(id_addr_Controller),
	.dcu_valid(dcu_valid),
	.distance(distance),
	.id(id_Comparator),
	.id_ren(id_ren_Comparator),
	.id_counter(id_counter_Comparator),
	.dcu_enable(dcu_enable),
	.label(label),
	.minDistance(minDistance),
	.hist_addr_offset(hist_addr_offset),
	.done(done)
);

Controller Controller(
	.clk(clk),
	.rst(rst),
	.mode(mode),
	.enable(enable),
	.valid(valid),
	.id(id),
	.id_addr(id_addr_Controller),
	.id_wdata(id_wdata_Controller),
	.id_wen(id_wen_Controller),
	.lbp_enable(lbp_enable),
	.lbp_finish(lbp_finish),
	.ram_clbp(ram_clbp),
	.gridX_i(gridX),     
	.gridY_i(gridY),        
	.hcu_enable(hcu_enable),
	.gridX_o(gridX_o),
	.gridY_o(gridY_o),  
	.hcu_finish(hcu_finish),      
	.comparator_finish(done),
	.comparator_enable(comparator_enable),
	.ram_comp(ram_comp)
);

MUX_LBP MUX_LBP(
	.lbp_addr_CLBP(lbp_addr_CLBP),
	.lbp_WEN_CLBP(lbp_WEN_CLBP),
	.lbp_data_CLBP(lbp_data_CLBP),
	.lbp_ren_HCU(lbp_ren_HCU),
	.lbp_addr_HCU(lbp_addr_HCU),
	.lbp_rdata_HCU(lbp_rdata_HCU),
	.sel(ram_clbp),
	.lbp_rdata(lbp_rdata),
	.lbp_addr(lbp_addr),
	.lbp_wen(lbp_wen),
	.lbp_wdata(lbp_wdata),
	.lbp_ren(lbp_ren)
);

MUX_TRAIN MUX_TRAIN(
	.hist_wen_train_HCU(hist_wen_train_HCU),
	.hist_wdata_train_HCU(hist_wdata_train_HCU),
	.hist_addr_train_HCU(hist_addr_train_HCU),
	.hist_ren_train_HCU(hist_ren_train_HCU),
	.hist_rdata_train_HCU(hist_rdata_train_HCU),
	.hist_addr_train_DCU(hist_addr_train_DCU),
	.hist_ren_train_DCU(hist_ren_train_DCU),
	.hist_rdata_train_DCU(hist_rdata_train_DCU),
	.sel(ram_comp),
	.hist_rdata_train(hist_rdata_train),
	.hist_addr_train(hist_addr_train),
	.hist_wen_train(hist_wen_train),
	.hist_wdata_train(hist_wdata_train),
	.hist_ren_train(hist_ren_train)
);

MUX_PREDICT MUX_PREDICT(
	.hist_wen_predict_HCU(hist_wen_predict_HCU),
	.hist_wdata_predict_HCU(hist_wdata_predict_HCU),
	.hist_addr_predict_HCU(hist_addr_predict_HCU),
	.hist_ren_predict_HCU(hist_ren_predict_HCU),
	.hist_rdata_predict_HCU(hist_rdata_predict_HCU),
	.hist_addr_predict_DCU(hist_addr_predict_DCU),
	.hist_ren_predict_DCU(hist_ren_predict_DCU),
	.hist_rdata_predict_DCU(hist_rdata_predict_DCU),
	.sel(ram_comp),
	.hist_rdata_predict(hist_rdata_predict),
	.hist_addr_predict(hist_addr_predict),
	.hist_wen_predict(hist_wen_predict),
	.hist_wdata_predict(hist_wdata_predict),
	.hist_ren_predict(hist_ren_predict)
);

MUX_ID MUX_ID(
	.id_addr_Controller(id_addr_Controller),
	.id_wdata_Controller(id_wdata_Controller),
	.id_wen_Controller(id_wen_Controller),
	.id_ren_Comparator(id_ren_Comparator),
	.id_counter_Comparator(id_counter_Comparator),//address
	.id_Comparator(id_Comparator),//rdata
	.sel(ram_comp),
	.id_rdata(id_rdata),
	.id_addr(id_addr),
	.id_wen(id_wen),
	.id_wdata(id_wdata),
	.id_ren(id_ren)
);
endmodule