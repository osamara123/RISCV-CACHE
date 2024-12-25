`timescale 1ns / 1ns
module top_design_tb;

logic [9: 0] buttons;
logic [9: 0] ups;
logic [9: 0] downs;
logic reset;
logic clock;

logic up;
logic down;
logic open;
logic [6: 0] out;

parameter CLOCK_PERIOD = 20;
// parameter SYSTEM_TIMER = 2* 50_000_000 * CLOCK_PERIOD;
parameter SYSTEM_TIMER = 10 * CLOCK_PERIOD;

// instantiation 
top_design DUT (
    .buttons (buttons),
    .ups (ups),
    .downs (downs),

    .reset (reset),
    .clock (clock),

    .up (up),
    .down (down),
    .open (open),
    .out (out)
);

// clock generation 
always #(CLOCK_PERIOD/2) clock= ~clock;


initial begin
    clock = 0;
    reset = 0;
    ups = 10'b0000000000;
    downs = 10'b0000000000;
    buttons = 10'b0000000000;
    @(posedge clock);
    reset = 1; 
    $display("--Start test --\n");
    repeat (2) @(posedge clock);

    // test output of fourth floor
    // 4th floor
    buttons = 10'b0000010000;
    @(posedge clock);
    buttons = 10'b0000000000;
    # (30 * SYSTEM_TIMER);
    $display("  requests registered  = ", DUT.DUT1.request_reg); 
    if (out == 7'b0011001)
        $display("   test passed.");
    else 
        $display("   test failed.");

    $finish;
end


endmodule
