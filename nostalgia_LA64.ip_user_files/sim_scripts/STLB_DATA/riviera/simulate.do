transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+STLB_DATA  -L xil_defaultlib -L blk_mem_gen_v8_4_11 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.STLB_DATA xil_defaultlib.glbl

do {STLB_DATA.udo}

run 1000ns

endsim

quit -force
