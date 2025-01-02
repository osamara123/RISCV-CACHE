module Regfile (
	input logic Regwrite,
	input logic clock,
	input logic reset,
	input logic [4:0] rs1,
	input logic [4:0] rs2,
	input logic [4:0] rd,
	input logic [31:0] WD3,
	
	output logic [31:0] RD1,
	output logic [31:0] RD2
);

// register file with 32 regsiters, each of 32 bit
logic [31:0] registers [0:31]; 

always_ff @(posedge clock or negedge reset) begin
	if (!reset) begin
		for (int i=0; i < 32; i++) begin
			registers [i] <= 32'b0;
		end
	end
	// load data
	else if (Regwrite)
		registers [rd] <= WD3;
end

assign RD1 = registers [rs1];
assign RD2 = registers [rs2];

endmodule
	