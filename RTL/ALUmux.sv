module ALUmux (
	input logic [31:0] RD2,
	input logic [31:0] ImmExt,
	input logic ALUsrc,

	output logic [31:0] SrcB
);

assign SrcB = (ALUsrc == 0) ? RD2 : ImmExt;

endmodule
	