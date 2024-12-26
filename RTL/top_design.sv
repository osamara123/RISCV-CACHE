//`timescale 1ns / 1ns
module top_design # (
    parameter floor_numbers = 10)
    (
    input logic [floor_numbers-1: 0] buttons,
    input logic [floor_numbers-1: 0] ups,
    input logic [floor_numbers-1: 0] downs,

    input logic reset,
    input logic clock,

    output logic up,
    output logic down,
    output logic open,
    output logic [6: 0] out
);

logic [3: 0] floor;

elevator_ctrl DUT1 (
    .buttons (buttons),
    .ups (ups),
    .downs (downs),

    .reset (reset),
    .clock (clock),

    .up (up),
    .down (down),
    .open (open),
    .floor (floor)
);

ssd DUT2 (
    .in (floor),
    .out (out)
);

endmodule