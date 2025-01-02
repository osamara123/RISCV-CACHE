module PCTarget (
	input logic [31:0] PC,
	input logic [31:0] ImmExt,
	
	output logic [31:0] PCTarget
);

assign PCTarget = ImmExt + PC;

endmodule
	