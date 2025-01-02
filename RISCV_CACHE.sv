module RISCV_CACHE (
  input logic clock,
  input logic reset
);

logic [31:0] Instr;
logic [31:0] ReadData;
logic MemWrite;
logic MemRead;
logic [31:0] PCOut;
logic [31:0] WriteData;
logic [31:0] ALUResult;

logic [2:0] funct3;
logic funct7;
logic [6:0] Op;

assign funct3 = Instr [14:12];
assign funct7 = Instr [30];
assign Op = Instr [6:0];

logic stall;
logic [9: 0] Word_Address;

assign Word_Address = ALUResult [9: 0];

InstMemory DUT1 (
	.address (PCOut), .Instr (Instr) // RD
);

mips DUT2 (
	.clock (clock), .reset (reset), .Instr (Instr), .ReadData (ReadData),
	.funct3 (funct3), .funct7 (funct7), .Op (Op), .PCOut (PCOut), .stall (stall),
	.ALUResult (ALUResult), .WriteData (WriteData), .MemWrite (MemWrite), .MemRead (MemRead)
);

DataMemory_System #(
	.data_length (32),
	.address_length (10)
) DUT3(
	.address (Word_Address),
	.DataIn (WriteData),
	.clock (clock),
	.reset (reset),
	.MemRead (MemRead),
	.MemWrite (MemWrite),
	
	.stall (stall),
	.DataOut (ReadData) 
);


endmodule
