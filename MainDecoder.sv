module MainDecoder (
	input logic [6:0] Op,

	output logic Branch,
	output logic Jump,
	output logic [1: 0] ResultSrc,
	output logic MemWrite,
	output logic MemRead,
	output logic ALUsrc,
	output logic [1:0] ImmSrc,
	output logic RegWrite,
	output logic [1:0] ALUOp
);

always_comb begin
	case (Op)
		// LW
		7'b0000011: begin
			{Branch, Jump, ResultSrc, MemWrite, MemRead, ALUsrc, ImmSrc, RegWrite, ALUOp} = 
			{1'b0, 1'b0, 2'b01, 1'b0, 1'b1, 1'b1, 2'b00, 1'b1, 2'b00};
		end
		// SW
		7'b0100011: begin
			{Branch, Jump, ResultSrc, MemWrite, MemRead, ALUsrc, ImmSrc, RegWrite, ALUOp} = 
			{1'b0, 1'b0, 2'bxx, 1'b1, 1'b0, 1'b1, 2'b01, 1'b0, 2'b00};
		end
		// R-type
		7'b0110011: begin
			{Branch, Jump, ResultSrc, MemWrite, MemRead, ALUsrc, ImmSrc, RegWrite, ALUOp} = 
			{1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b0, 2'bxx, 1'b1, 2'b10};
		end
		// beq
		7'b1100011: begin
			{Branch, Jump, ResultSrc, MemWrite, MemRead, ALUsrc, ImmSrc, RegWrite, ALUOp} = 
			{1'b1, 1'b0, 2'bxx, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0, 2'b01};
		end
		// addi
		7'b0010011: begin
			{Branch, Jump, ResultSrc, MemWrite, MemRead, ALUsrc, ImmSrc, RegWrite, ALUOp} = 
			{1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b1, 2'b00, 1'b1, 2'b10};
		end
		// jal
		7'b1101111: begin
			{Branch, Jump, ResultSrc, MemWrite, MemRead, ALUsrc, ImmSrc, RegWrite, ALUOp} = 
			{1'b0, 1'b1, 2'b10, 1'b0, 1'b0, 1'bx, 2'b11, 1'b1, 2'bxx};
		end
		default: begin
			{Branch, Jump, ResultSrc, MemWrite, MemRead, ALUsrc, ImmSrc, RegWrite, ALUOp} = 
			{1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b0, 2'b00, 1'b0, 2'b00};
		end
	endcase
	
end
endmodule
	