module CacheController (
    input logic clock,
	input logic reset,
	input logic [9:0] address,
    input logic MemRead,
    input logic MemWrite,
    input logic ready, // from DataMemory
	
	output logic stall, 
    output logic [4: 0] index, 
    output logic [1: 0] offset,
    output logic MemRead_en,
    output logic MemWrite_en,
    output logic CacheRead_en,
    output logic CacheWrite_en,
    output logic hit,
    output logic miss
);

parameter depth = 32;

// tags and valid_bits arrays
logic [2: 0] tags [0: depth-1];
logic valid_bits [0: depth-1];
logic fill;
logic done;
logic [2: 0] tag;

assign tag = address [9: 7]; // map/match data
assign index = address [6: 2]; // indentify block
assign offset = address [1: 0]; // specify word

// FSM opposite edge of clock from PC of RISC-V
typedef enum logic [1:0] {idle, reading, writing} cc_state_type;

cc_state_type state_reg, state_next;

// state register on opposite edge of PC
always_ff @(negedge clock or negedge reset) begin
    if (!reset)
        state_reg <= idle;
    else
        state_reg <= state_next;
end

// next-state logic
always_comb begin
    state_next = state_reg;
    case (state_reg)
        idle: begin
            if (MemRead)
                state_next = reading; // LW instruction
            else if (MemWrite)
                state_next = writing; // SW instruction
        end
        reading: begin
            if (done)
                state_next = idle; 
        end
        writing: begin
            if (done)
                state_next = idle;
        end
    endcase
end

// Moore output logic
always_comb begin
    CacheRead_en = 0;     // default cases
    CacheWrite_en = 0;
    MemRead_en = 0;
    MemWrite_en = 0;
    stall = 0;
    fill = 0;
    done = 0;
    case (state_reg)
        idle: begin 
            // No outputs
        end
        reading: begin
            if (hit) begin
                CacheRead_en = 1;
                done = 1;
            end 
            else if (miss) begin
                stall = 1;
                MemRead_en = 1;
                if (ready) begin
                    CacheWrite_en = 1;
                    fill = 1;
                    done = 1;
                end
            end
        end
        writing: begin      
            if (hit) begin // write-through
                MemWrite_en = 1;
                CacheWrite_en = 1;
                stall = 1;
                if (ready)
                    done = 1;
            end
            else if (miss) begin  // write-around 
                MemWrite_en = 1;
                stall = 1;
                if (ready)
                    done = 1;
            end
        end
    endcase
end

assign hit = valid_bits[index] && (tags[index] == tag);
assign miss = !hit;

// update valid_bits and tag arrays
always_ff @(negedge clock or negedge reset) begin
    if (!reset) begin
        // cold-cache start
        for (int i=0; i<depth; i++) begin
            valid_bits [i] <= 'b0;
        end
    end
    else if (fill) begin  // Read miss case
        valid_bits [index] <= 1'b1;
        tags [index] <= tag; 
    end
end


endmodule
	