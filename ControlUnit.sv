module ControlUnit (
	input logic [6:0] Op,
	input logic [2:0] funct3,
	input logic funct7,
	input logic zero,

	output logic [2:0] ALUControl,
	output logic PCSrc,
	output logic [1:0] ResultSrc,
	output logic MemWrite,
	output logic MemRead,
	output logic ALUsrc,
	output logic [1:0] ImmSrc,
	output logic RegWrite
);

logic Branch;
logic [1:0] ALUOp;

MainDecoder DUT1 (
	.Op (Op), .Branch (Branch), .Jump (Jump), .ResultSrc (ResultSrc), .MemWrite (MemWrite), 
	.MemRead (MemRead), .ALUsrc (ALUsrc), .ImmSrc (ImmSrc), .RegWrite (RegWrite), .ALUOp (ALUOp)
);

AluDecoder DUT2 (
	.Op (Op), .funct3 (funct3), .funct7 (funct7), .ALUOp (ALUOp), .ALUControl (ALUControl)
);

assign PCSrc = (zero & Branch) | Jump;		

endmodule
	