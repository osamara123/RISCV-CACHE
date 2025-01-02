module mips (
	input logic clock, reset,
	input logic [31:0] Instr,
	input logic [31:0] ReadData,
	input logic [2: 0] funct3,
	input logic funct7,
	input logic [6:0] Op,
	input logic stall,

	output logic [31:0] PCOut,
	output logic [31:0] ALUResult,
	output logic [31:0] WriteData,
	output logic MemWrite,
	output logic MemRead
);

logic RegWrite;
logic [1:0] ImmSrc;
logic ALUsrc;
logic [2:0] ALUControl;
logic PCSrc;
logic zero;
logic [1:0] ResultSrc;


ControlUnit DUT1 (
	.Op (Op), .funct3 (funct3), .funct7 (funct7), .zero(zero), .PCSrc (PCSrc), 
	.ResultSrc (ResultSrc), .MemWrite (MemWrite), .MemRead (MemRead), .ALUControl (ALUControl),
	.ALUsrc (ALUsrc), .ImmSrc (ImmSrc), .RegWrite (RegWrite)
);

DataPath DUT2 (
	.clock (clock), .reset (reset), .Instr (Instr), .ReadData (ReadData), 
	.RegWrite (RegWrite),.ImmSrc (ImmSrc), .ALUsrc (ALUsrc), 
	.ALUControl (ALUControl), .ResultSrc (ResultSrc), .PCSrc (PCSrc), 
	.zero (zero), .PCOut (PCOut), .stall (stall), .ALUResult (ALUResult), .WriteData (WriteData)
);

endmodule
