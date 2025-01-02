
module TopModule_TB;
logic clock; 
logic reset;

RISCV_CACHE DUT (
    .clock(clock),
    .reset(reset)
);

parameter CLOCK_PERIOD = 10;
// clock Generation
always #(CLOCK_PERIOD/2) clock =~clock;

initial begin
	clock=0;
	reset=0;
	@(posedge clock);
	reset=1; 
	repeat (50) @(posedge clock);
	
	$finish;
end

endmodule