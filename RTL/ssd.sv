`timescale 1ns / 1ps
module ssd (
    input logic [3: 0] in,
    output logic [6: 0] out
);

always_comb begin
    case (in)
        4'b0000: out = 7'b1000000; //1 off, 0 on in segment
        4'b0001: out = 7'b1111001;
        4'b0010: out = 7'b0100100;
        4'b0011: out = 7'b0110000;
        4'b0100: out = 7'b0011001;
        4'b0101: out = 7'b0010010;
        4'b0110: out = 7'b0000010;
        4'b0111: out = 7'b1111000;
        4'b1000: out = 7'b0000000;
        4'b1001: out = 7'b0010000;
		  default: out = 7'bxxxxxxx;
    endcase
end

endmodule