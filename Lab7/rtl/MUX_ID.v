module MUX_ID(
    input   [7:0]           id_addr_Controller,
    input   [4:0]           id_wdata_Controller,
    input                   id_wen_Controller,

    input                   id_ren_Comparator,
    input       [7:0]       id_counter_Comparator,//address
    output  reg [4:0]       id_Comparator,//rdata

    input                   sel,

    input       [4:0]       id_rdata,
    output  reg [7:0]       id_addr,
    output  reg             id_wen,
    output  reg [4:0]       id_wdata,
    output  reg             id_ren
);

// put your design here
always @ (*)
begin
	if(sel == 1'b0)
	begin
		id_addr = id_addr_Controller;
		id_wen = id_wen_Controller;
		id_wdata = id_wdata_Controller;
		id_ren = 1'b0;
		id_Comparator = 5'd0;
	end
	else
	begin
		id_addr = id_counter_Comparator;
    	id_wen = 1'b0;
    	id_wdata = 5'd0;
    	id_ren = id_ren_Comparator;
		id_Comparator = id_rdata;
	end
end
endmodule