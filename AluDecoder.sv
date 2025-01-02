module AluDecoder (
	input logic [6:0] Op,
	input logic [2:0] funct3,
	input logic funct7,
	input logic [1:0] ALUOp,
	
	output logic [2:0] ALUControl
);

always_comb begin
	case (ALUOp)
		2'b00: ALUControl = 3'b000; // add (LW/SW)
		2'b01: ALUControl = 3'b001; // sub (beq)
		2'b10: begin	
			// R-type
			case (funct3)
				3'b000: begin
					if ({Op[5], funct7} == 2'b11)
						ALUControl = 3'b001; //sub
					else
						ALUControl = 3'b000; //add
				end 
				3'b010: ALUControl = 3'b101; //slt
				3'b110: ALUControl = 3'b011; //OR
				3'b111: ALUControl = 3'b010; //and
				default: ALUControl = 3'bxxx;
			endcase
		end
		default: ALUControl = 3'bxxx;
	endcase	
end

endmodule