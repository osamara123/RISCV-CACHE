module PCMux (
	input logic [31:0] PCPlus4,
	input logic [31:0] PCTarget,
	input logic PCSrc,

	output logic [31: 0] PCNext
);

always_comb begin
	if (PCSrc) 
		PCNext = PCTarget;	
	else
		PCNext = PCPlus4;	
end

endmodule
	