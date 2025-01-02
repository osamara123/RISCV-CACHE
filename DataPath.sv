
module DataPath (
	
	input logic clock, reset,
	input logic [31: 0] Instr,
	input logic [31: 0] ReadData,
	input logic RegWrite,
	input logic [1: 0] ImmSrc,
	input logic ALUsrc,
	input logic [2: 0] ALUControl,
	input logic [1: 0] ResultSrc,
	input logic PCSrc,
	input logic stall,

	output logic zero,
	output logic [31: 0] PCOut,
	output logic [31: 0] ALUResult,
	output logic [31: 0] WriteData
);

logic [31: 0] PC_IN; 

logic [4:0] rs1;
logic [4:0] rs2;
logic [4:0] rd;
logic [31: 0] RD1, RD2;

logic [31: 0] ImmExt;

logic [31: 0] SrcB;

logic [31: 0] PCTarget;

logic [31: 0] PCPlus4;

assign rs1 = Instr[19:15];  // Extract bits 19 to 15 for rs1
assign rs2 = Instr[24:20];  // Extract bits 24 to 20 for rs2
assign rd  = Instr[11:7];   // Extract bits 11 to 7 for rd

PC DUT1 (
	.PC_IN (PC_IN), .clock (clock), .reset (reset), .stall (stall), .PC_OUT (PCOut)
);

Regfile DUT2 (
	.Regwrite (RegWrite), .clock (clock), .reset (reset), .rs1 (rs1),
	.rs2 (rs2), .rd (rd), .WD3 (WriteData), .RD1 (RD1), .RD2 (RD2)
);

Extend DUT3 (
	.Instr (Instr), .ImmSrc(ImmSrc), .ImmExt(ImmExt)
);
 
ALUmux DUT4 (
	.RD2 (RD2), .ImmExt (ImmExt),.ALUsrc (ALUsrc), .SrcB (SrcB)
);

ALU DUT5 (
	.SrcB (SrcB), .SrcA (RD1), .ALUControl (ALUControl),
	.ALUResult (ALUResult), .zero (zero)
);

PCTarget DUT6 (
	.PC (PCOut), .ImmExt (ImmExt),
	.PCTarget (PCTarget)
);

PCPlus4 DUT7 (
	.PC (PCOut), .PCPlus4 (PCPlus4)
);

PCMux DUT8 (
	.PCPlus4 (PCPlus4), .PCTarget (PCTarget),
	.PCSrc (PCSrc), .PCNext (PC_IN)
);

Memorymux DUT9 (
	.ALUResult (ALUResult), .RD (ReadData), .ResultSrc (ResultSrc), 
	.PCPlus4 (PCPlus4), .write_data (WriteData)
);

endmodule