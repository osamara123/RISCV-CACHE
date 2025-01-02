module CacheMemory (
	input logic [127: 0] DataIn_ReadM, // read miss (1-block)
	input logic [31: 0] DataIn_WriteH, // write hit (1-word)
	input logic read_en,
	input logic write_en,
	input logic [4: 0] index, 
    input logic [1: 0] offset,
	input logic hit,
	input logic miss,
	
	output logic [31: 0] DataOut
);

parameter size = 4; // words per block
parameter depth = 32; // 32 block total

// 32 blocks (1 block => 16B (4 words)) (Word Addressable) 
logic [depth-1: 0] cache_memory [0: depth-1] [0: size-1];
 
always_comb begin
	DataOut = 'b0; // default output
    if (write_en && miss) begin // Read Miss
		cache_memory [index] [0] = DataIn_ReadM [31: 0];
		cache_memory [index] [1] = DataIn_ReadM [63: 32];
		cache_memory [index] [2] = DataIn_ReadM [95: 64];
		cache_memory [index] [3] = DataIn_ReadM [127: 96];
	end 
	else if (read_en && hit) // Read Hit
		DataOut = cache_memory [index] [offset];
	else if (write_en && hit) // Write Hit
		cache_memory [index] [offset] = DataIn_WriteH;
end

endmodule
	