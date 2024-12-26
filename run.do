vlib work
vmap work work
vlog -sv elevator_ctrl.sv
vlog -sv elevator_ctrl_tb.sv
vlog -sv ssd.sv
vlog -sv top_design_tb.sv
vlog -sv top_design.sv
vsim -voptargs=+acc work.elevator_ctrl_tb
add wave  \
    sim:/elevator_ctrl_tb/buttons \
    sim:/elevator_ctrl_tb/clock \
    sim:/elevator_ctrl_tb/CLOCK_PERIOD \
    sim:/elevator_ctrl_tb/down \
    sim:/elevator_ctrl_tb/downs \
    sim:/elevator_ctrl_tb/floor \
    sim:/elevator_ctrl_tb/open \
    sim:/elevator_ctrl_tb/reset \
    sim:/elevator_ctrl_tb/SYSTEM_TIMER \
    sim:/elevator_ctrl_tb/up \
    sim:/elevator_ctrl_tb/ups \
    sim:/elevator_ctrl_tb/DUT/request_reg \
    sim:/elevator_ctrl_tb/DUT/state_next \
    sim:/elevator_ctrl_tb/DUT/state_reg \
    sim:/elevator_ctrl_tb/DUT/down_buttons \
    sim:/elevator_ctrl_tb/DUT/down_requests \
    sim:/elevator_ctrl_tb/DUT/up_buttons \
    sim:/elevator_ctrl_tb/DUT/up_requests 
run -all
quit