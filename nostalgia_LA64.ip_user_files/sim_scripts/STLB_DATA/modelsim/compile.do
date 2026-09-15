vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/blk_mem_gen_v8_4_11
vlib modelsim_lib/msim/xil_defaultlib

vmap blk_mem_gen_v8_4_11 modelsim_lib/msim/blk_mem_gen_v8_4_11
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work blk_mem_gen_v8_4_11  -incr -mfcu  "+incdir+../../../../../../2025.1/Vivado/data/rsb/busdef" \
"../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../../../2025.1/Vivado/data/rsb/busdef" \
"../../../ip/STLB_DATA/sim/STLB_DATA.v" \


vlog -work xil_defaultlib \
"glbl.v"

