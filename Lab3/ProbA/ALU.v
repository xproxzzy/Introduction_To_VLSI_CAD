`define DATA_SIZE  32
`define OP_SIZE  5

`define ADD    5'b00000
`define SUB    5'b00001
`define OR     5'b00010
`define AND    5'b00011
`define XOR    5'b00100
`define NOT    5'b00101
`define NAND   5'b00110
`define NOR    5'b00111

`define SLT    5'b01000
`define SLTU   5'b01001
`define SRA    5'b01010
`define SLA    5'b01011
`define SRL    5'b01100
`define SLL    5'b01101
`define ROTR   5'b01110
`define ROTL   5'b01111
`define MUL    5'b10000
`define MULH   5'b10001
`define MULHSU 5'b10010
`define MULHU  5'b10011

module ALU (
	input      [`OP_SIZE-1:0]   alu_op,
	input      [`DATA_SIZE-1:0] src1,
	input      [`DATA_SIZE-1:0] src2,
	output reg [`DATA_SIZE-1:0] alu_out,
	output reg                  alu_overflow
);

reg	[`DATA_SIZE-1:0] tmp1;
reg	[`DATA_SIZE-1:0] tmp2;
reg	[2*`DATA_SIZE-1:0] MUL_tmp;
reg	[2*`DATA_SIZE-1:0] MUL_tmp_neg;
reg [`DATA_SIZE-1:0] src1_neg;

always@(*)begin
	case(alu_op)
		`ADD:
		begin
			alu_out = src1 + src2;
			if(((src1[`DATA_SIZE-1] == 1'b0) && (src2[`DATA_SIZE-1] == 1'b0) && (alu_out[`DATA_SIZE-1] == 1'b1))
				|| ((src1[`DATA_SIZE-1] == 1'b1) && (src2[`DATA_SIZE-1] == 1'b1) && (alu_out[`DATA_SIZE-1] == 1'b0)))
				alu_overflow = 1'b1;
			else
				alu_overflow = 1'b0;
		end
		`SUB:
		begin
			alu_out = src1 - src2;
			if(((src1[`DATA_SIZE-1] == 1'b0) && (src2[`DATA_SIZE-1] == 1'b1) && (alu_out[`DATA_SIZE-1] == 1'b1))
				|| ((src1[`DATA_SIZE-1] == 1'b1) && (src2[`DATA_SIZE-1] == 1'b0) && (alu_out[`DATA_SIZE-1] == 1'b0)))
				alu_overflow = 1'b1;
			else
				alu_overflow = 1'b0;
		end
		`OR:
		begin
			alu_out = src1 | src2;
			alu_overflow = 1'b0;
		end
		`AND:
		begin
			alu_out = src1 & src2;
			alu_overflow = 1'b0;
		end
		`XOR:
		begin
			alu_out = src1 ^ src2;
			alu_overflow = 1'b0;
		end
		`NOT:
		begin
			alu_out = ~src1;
			alu_overflow = 1'b0;
		end
		`NAND:
		begin
			alu_out = ~(src1 & src2);
			alu_overflow = 1'b0;
		end
		`NOR:
		begin
			alu_out = ~(src1 | src2);
			alu_overflow = 1'b0;
		end
		`SLT:
		begin
			alu_out = ($signed(src1) < $signed(src2))?32'd1:32'd0;
			alu_overflow = 1'b0;
		end
		`SLTU:
		begin
			alu_out = (src1 < src2)?32'd1:32'd0;
			alu_overflow = 1'b0;
		end
		`SRA:
		begin
			alu_out = $signed(src1) >>> src2;
			alu_overflow = 1'b0;
		end
		`SLA:
		begin
			alu_out = $signed(src1) <<< src2;
			alu_overflow = 1'b0;
		end
		`SRL:
		begin
			alu_out = src1 >> src2;
			alu_overflow = 1'b0;
		end
		`SLL:
		begin
			alu_out = src1 << src2;
			alu_overflow = 1'b0;
		end
		`ROTR:
		begin
			tmp1 = src1 >> src2;
			tmp2 = src1 << (`DATA_SIZE - src2);
			alu_out = tmp1 | tmp2;
			alu_overflow = 1'b0;
		end
		`ROTL:
		begin
			tmp1 = src1 << src2;
			tmp2 = src1 >> (`DATA_SIZE - src2);
			alu_out = tmp1 | tmp2;
			alu_overflow = 1'b0;
		end
		`MUL:
		begin
			MUL_tmp = src1 * src2;
			alu_out = MUL_tmp[`DATA_SIZE-1:0];
			alu_overflow = 1'b0;
		end
        `MULH:
		begin
			MUL_tmp = $signed(src1) * $signed(src2);
			alu_out = MUL_tmp[2*`DATA_SIZE-1:`DATA_SIZE];
			alu_overflow = 1'b0;
		end
       	`MULHSU:
		begin
			MUL_tmp = $signed(src1) * $signed({1'b0,src2});
			alu_out = MUL_tmp[2*`DATA_SIZE-1:`DATA_SIZE];
			alu_overflow = 1'b0;
		end
        `MULHU:
		begin
			MUL_tmp = src1 * src2;
			alu_out = MUL_tmp[2*`DATA_SIZE-1:`DATA_SIZE];
			alu_overflow = 1'b0;
		end
		default:begin
			alu_out = 32'd0;
			alu_overflow = 1'b0;
		end
	endcase
end
endmodule
