module Memorymux (
	input logic [31:0] ALUResult,
	input logic [31:0] RD,
	input logic [1: 0] ResultSrc,
	input logic [31: 0] PCPlus4,
	
	output logic [31:0] write_data
);

always_comb begin
	case (ResultSrc)
		2'b00:	write_data = ALUResult;
		2'b01:	write_data = RD;
		2'b10: 	write_data = PCPlus4;
		default:	write_data = 2'b00;
	endcase		
end

endmodule
	