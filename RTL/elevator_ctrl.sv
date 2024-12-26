//`timescale 1ns / 1ns
module elevator_ctrl # (
    // request solver inputs
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
    output logic [3: 0] floor
);



// request solver signals
logic [floor_numbers-1: 0] request_reg;
logic [floor_numbers-1: 0] internal_requests;
logic [floor_numbers-1: 0] up_requests;
logic [floor_numbers-1: 0] down_requests;
logic [3: 0] request; // request to FSM
logic first_entry;
logic [floor_numbers-1: 0] up_buttons;
logic [floor_numbers-1: 0] down_buttons;
logic previous_direction; // elevator obtained direction
logic [3: 0] i; // index for requests

// timer variables
logic [3:0] counter;
logic [1:0] timer;
logic enable;


// define state 
typedef enum logic [1:0] {idle, move_up, move_down, open_door} ec_state_type;

// state register
ec_state_type state_reg, state_next;

// state register
always_ff @(posedge clock or negedge reset) begin
    if (!reset) begin
        state_reg <= idle;
    end 
    else begin
        state_reg <= state_next;
    end
end

// next-state logic
always_comb begin
    state_next = state_reg;
    case (state_reg)
        idle: begin
            if (request > floor) 
                state_next = move_up;
            else if (request < floor)
                state_next = move_down;
        end
        move_up: begin 
            if (request != floor)
                state_next = move_up;
            else if (request == floor)
                state_next = open_door;
        end
        move_down: begin
            if (request != floor)
                state_next = move_down;
            else if (request == floor)
                state_next = open_door;
        end
        open_door: begin
            if (timer == 2)
                state_next = idle;
        end
    endcase
end

// Moore output logic
always_comb begin
    up = 0;     // default cases
    down = 0; 
    open = 0;
    case (state_reg)
        idle: begin 
            // No outputs
        end
        move_up: begin 
            up = 1;     
            down = 0; 
            open = 0;
        end
        move_down: begin
            up = 0;
            down = 1; 
            open = 0;
        end
        open_door: begin
            up = 0;
            down = 0; 
            open = 1;
        end
    endcase
end

// floor output and update
always_ff @(posedge clock or negedge reset) begin
    if (!reset)
        floor <= 'b0;
    else if (timer == 2) begin
        case (state_reg)
            move_up: begin 
                floor <= floor + 1;
            end
            move_down: begin
                floor <= floor - 1;
            end
        endcase
    end
end
    

// counter timer 
//improtant note: 10 clock cycles equivalent to 1s
always_ff @(posedge clock or negedge reset) begin
    if (!reset) begin
        enable <= 0;
        counter <= 0;
        timer <= 0;
    end 
    else begin 
        if (timer == 2)
            timer <= 0;
        else if (counter < 8 && (state_reg == move_up || state_reg == move_down || state_reg == open_door)) begin
            counter <= counter + 1;
            enable <= 0;
        end 
        else if (counter == 8 && (state_reg == move_up || state_reg == move_down || state_reg == open_door)) begin
            enable <= 1;
            counter <= 0;
            timer <= timer + 1;
        end
    end 
end


// clear down and up in GND and last floor
assign up_buttons = ups & 10'b0111111111;
assign down_buttons = downs & 10'b1111111110; 

assign request_reg = (state_reg == open_door) ? (request_reg & ~(1 << floor)) // Clear only the bit at index `floor`
: (request_reg | up_buttons | down_buttons | buttons);
assign internal_requests = (state_reg == open_door) ? (internal_requests & ~(1 << floor)) 
: (internal_requests | buttons);
assign up_requests = (state_reg == open_door) ? (up_requests & ~(1 << floor)) 
: (up_requests | up_buttons);
assign down_requests = (state_reg == open_door) ? (down_requests & ~(1 << floor)) 
: (down_requests | down_buttons);

// request solver
always_ff @(posedge clock or negedge reset) begin
    if (!reset) begin
        request <= 'b0;   
        previous_direction <= 0; // default move_up
        first_entry <= 'b0; // flag to capture current floor for index i
        i <= 0;   
    end
    else if (request_reg != 0 && (state_reg == idle || state_reg == move_up || state_reg == move_down)) begin
        // check requests from current floor 
        if (!first_entry) begin
            i <= floor;
            first_entry <= 1;
        end
        else begin
            // moving down
            if (previous_direction) begin
                if (request_reg [i]) begin
                    if (down_requests [i] || internal_requests [i]) begin
                        request <= i;
                        first_entry <= 'b0;
                    end 
                    else
                        i <= i - 1;
                end
                else if (i < 0) begin
                    previous_direction <= 0; // check up requests
                    first_entry <= 'b0;
                end 
                else 
                    i <= i - 1;
            end
            // moving up
            else begin
                if (request_reg [i]) begin
                    if (internal_requests [i] || up_requests [i]) begin
                        request <= i;
                        first_entry <= 'b0;
                    end 
                    else
                        i <= i + 1;
                end              
                else if (i > 9) begin
                    previous_direction <= 1; // check down requests
                    first_entry <= 'b0;
                end 
                else 
                    i <= i + 1;
            end 
        end
    end  
end

endmodule