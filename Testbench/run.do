quit -sim
vlib work
vmap work work
vlog -sv ALU.sv
vlog -sv AluDecoder.sv
vlog -sv ALUmux.sv
vlog -sv ControlUnit.sv
vlog -sv CacheController.sv
vlog -sv CacheMemory.sv
vlog -sv DataMemory.sv
vlog -sv DataMemory_System.sv
vlog -sv DataPath.sv
vlog -sv Extend.sv
vlog -sv InstMemory.sv
vlog -sv MainDecoder.sv
vlog -sv Memorymux.sv
vlog -sv mips.sv
vlog -sv PC.sv
vlog -sv PCMux.sv
vlog -sv PCPlus4.sv
vlog -sv PCTarget.sv
vlog -sv Regfile.sv
vlog -sv RISCV_CACHE.sv
vlog -sv TopModule_TB.sv

vsim -voptargs=+acc work.TopModule_TB

add wave  \
    sim:/TopModule_TB/clock \
    sim:/TopModule_TB/reset   
run -all
quit