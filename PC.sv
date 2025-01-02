module PC (
	input logic [31:0] PC_IN,
	input logic clock,
	input logic reset,
	input logic stall,

	output logic [31:0] PC_OUT
);

always_ff @(posedge clock or negedge reset) begin
	if (!reset)
		PC_OUT <= 32'b0;
	else if (!stall)
		PC_OUT <= PC_IN;
end

endmodule
	