vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/blk_mem_gen_v8_4_11
vlib questa_lib/msim/xil_defaultlib

vmap blk_mem_gen_v8_4_11 questa_lib/msim/blk_mem_gen_v8_4_11
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work blk_mem_gen_v8_4_11  -incr -mfcu  "+incdir+../../../../../../2025.1/Vivado/data/rsb/busdef" \
"../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../../../2025.1/Vivado/data/rsb/busdef" \
"../../../ip/STLB_DATA/sim/STLB_DATA.v" \


vlog -work xil_defaultlib \
"glbl.v"

