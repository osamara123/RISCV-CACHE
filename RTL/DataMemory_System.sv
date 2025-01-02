module DataMemory_System #(
	parameter data_length = 32,
	parameter address_length = 10
)(
	input logic [address_length -1: 0] address,
	input logic [data_length -1: 0] DataIn,
	input logic clock,
	input logic reset,
	input logic MemRead,
	input logic MemWrite,
	
	output logic stall,
	output logic [31:0] DataOut // DATAOUT 
);

logic MemRead_en;
logic MemWrite_en;
logic CacheRead_en;
logic CacheWrite_en;
logic [4: 0] index; 
logic [1: 0] offset;
logic hit;
logic miss;

logic ready;

logic [127: 0] DataIn_ReadM;

CacheController DUT1 (
    .clock (clock), .reset (reset), .address (address), .MemRead (MemRead),
    .MemWrite (MemWrite), .ready (ready), 
	
	.stall (stall), .index (index), .offset (offset), .MemRead_en (MemRead_en),
    .MemWrite_en (MemWrite_en), .CacheRead_en (CacheRead_en), .CacheWrite_en (CacheWrite_en),
    .hit (hit), .miss (miss)
);

DataMemory DUT2 (
	.clock (clock), .reset (reset), .DataIn (DataIn), .address (address),
	.read_en (MemRead_en), .write_en (MemWrite_en),

	.DataOut (DataIn_ReadM), .ready (ready)
);

CacheMemory DUT3 (
	.DataIn_ReadM (DataIn_ReadM), .DataIn_WriteH (DataIn), .read_en (CacheRead_en), .write_en (CacheWrite_en),
	.index (index), .offset (offset), .hit (hit), .miss (miss),
	
	.DataOut (DataOut)
);



endmodule
	