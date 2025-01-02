module DataMemory (
	input logic clock,
	input logic reset,
	input logic [31: 0] DataIn,
	input logic [9:0] address,
	input logic read_en,
	input logic write_en,

	output logic [127 :0] DataOut,
	output logic ready // finish read/write
);

parameter width = 32;
parameter depth = 1024;

// 4KB word addressable
logic [width -1:0] memory [0: depth-1];
logic [1: 0] counter;

assign DataOut = (ready && read_en) ? {memory [address + 3], memory [address + 2], memory [address + 1], memory [address]} : 'b0;

always_ff @(posedge clock or negedge reset) begin
	if (!reset) begin
		counter <= 'b0;
		for (int i=0; i<depth; i++) begin
			memory [i] = 'b0;
		end
	end
	else begin
		if (read_en) begin
			if (counter < 3)
				counter <= counter + 1'd1;
			else
				counter <= 'b0;
		end
		else if (write_en) begin
			memory [address] <= DataIn;
			if (counter < 3)
				counter <= counter + 1'd1;
			else
				counter <= 'b0;
		end
	end 
end

always_ff @ (posedge clock or negedge reset) begin
	if (!reset)
		ready <= 1'd0;
	else if (counter == 3)
		ready <= 1'd1;
	else
		ready <= 1'd0;
end

endmodule
	