module DataMem_System_tb();

parameter data_length = 32;
parameter address_length = 10;

logic [address_length -1: 0] address;
logic [data_length -1: 0] DataIn;
logic clock;
logic reset;
logic MemRead;
logic MemWrite;
logic stall;
logic [31:0] DataOut;  

DataMemory_System DUT (
    .clock(clock),
    .reset(reset),
    .address(address),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .DataIn(DataIn),
    .DataOut(DataOut),
    .stall(stall)
);

parameter CLOCK_PERIOD = 10;
always #(CLOCK_PERIOD/2) clock = ~clock;

initial begin
    clock = 0;
    reset = 0;
    MemRead = 0;
    MemWrite = 0;
    address = 'b0;
    DataIn = 'b0;
    @(posedge clock);
    
    reset = 1;
    @(posedge clock);

    // Test Case 1: Write Miss (First Write)
    address = 10'h020;
    DataIn = 32'hAAAAAAAA;
    MemWrite = 1;
    @(posedge clock);
    while (stall) @(posedge clock);
    MemWrite = 0;
    @(posedge clock);

    // Test Case 2: Read Miss
    address = 10'h020;
    MemRead = 1;
    @(posedge clock);
    while (stall) @(posedge clock);
    MemRead = 0;
    @(posedge clock);

    // Test Case 3: Read Hit
    MemRead = 1;
    @(posedge clock);
    MemRead = 0;
    @(posedge clock);

    // Test Case 4: Write Miss 
    address = 10'h120;
    DataIn = 32'hBBBBBBBB;
    MemWrite = 1;
    @(posedge clock);
    while (stall) @(posedge clock);
    MemWrite = 0;
    @(posedge clock);

    // Test Case 5: Write Miss
    address = 10'h220;
    DataIn = 32'hCCCCCCCC;
    MemWrite = 1;
    @(posedge clock);
    while (stall) @(posedge clock);
    MemWrite = 0;
    @(posedge clock);

    repeat (10) @(posedge clock);
    $stop;
end

endmodule