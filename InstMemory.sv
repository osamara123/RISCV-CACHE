module InstMemory (
    input logic [31:0] address, 

	output logic [31:0] Instr
);

logic [31:0] memory [0:31];

initial begin
    memory[0]  = 32'h03290913;  // addi s2, s2, 50
    memory[1]  = 32'h02898993;  // addi s3, s3, 40
    memory[2]  = 32'h03228293;  // addi t0, t0, 50
    memory[3]  = 32'h025A0063;  // beq s4, t0, end
    memory[4]  = 32'h013904B3;  // add s1, s2, s3
    memory[5]  = 32'h009AA023;  // sw s1, 0(s5)
    memory[6]  = 32'h00190913;  // addi s2, s2, 1
    memory[7]  = 32'hFFE98993;  // addi s3, s3, -2
    memory[8]  = 32'h00000013;  // addi zero, zero, 0
    memory[9]  = 32'h001A0A13;  // addi s4, s4, 1
    memory[10] = 32'hFE5FF0EF;  // jal ra, loop
    memory[11] = 32'hABCDE4B7;  // lui s1, 0xABCDE
    memory[12] = 32'h009AA023;  // sw s1, 0(s5)
    memory[13] = 32'h03248493;  // addi s1, s1, 50
    memory[14] = 32'h02890913;  // addi s2, s2, 40
    memory[15] = 32'hFC498993;  // addi s3, s3, -60
    memory[16] = 32'h00990A33;  // add s4, s1, s2
    memory[17] = 32'h01402023;  // sw s4, 0(ZERO)
    memory[18] = 32'h40990A33;  // sub s4, s2, s1
    memory[19] = 32'h01402023;  // sw s4, 0(ZERO)
    memory[20] = 32'h01392A33;  // slt s4, s3, s2
    memory[21] = 32'h01402023;  // sw s4, 0(ZERO)
    memory[22] = 32'h01393A33;  // sltu s4, s3, s2
    memory[23] = 32'h01402023;  // sw s4, 0(ZERO)
    memory[24] = 32'h01397A33;  // and s4, s3, s2
    memory[25] = 32'h01402023;  // sw s4, 0(ZERO)
    memory[26] = 32'h00996A33;  // or s4, s1, s2
    memory[27] = 32'h01402023;  // sw s4, 0(ZERO)
    memory[28] = 32'hABCDE497;  // auipc s1, 0xABCDE
    memory[29] = 32'h009AA023;  // sw s1, 0(s5)
end

assign Instr = memory [address [6:2]]; // shift by 2 to convert byte address to word address 

endmodule
	