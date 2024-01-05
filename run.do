## ------------------------------------------------------------------------------------------------------------
## Date: 		17/09/2023
puts -nonewline "SA"
puts " This is a testbench for the 512 cache"
#---------------------------------------------------------------------------------------
# write test bench using tcl or create a test vector database to run during simulation, example at tcl.txt
# set assertions : set falgs that help determine the outcome of the simulation
# make comparsion between the actual and expected output.

foreach src {dmm main_cache00 } {
vlog $src.v
}
foreach src {top} {
vlog -sv $src.sv
}

#puts " Enter 1 to load the brevious simulation, or press any key to start new simulation"
#gets stdin x
if {0} {
do last_run.do
run 400 ns
write format restart last_run.do
} elseif {1} {
vsim -voptargs=+acc -l top

## adding and customizing the waveform for the cache
add wave *
delete wave /top/DataIn
add wave -decimal -color red -label TB_DataIn /top/DataIn
delete wave /top/DataOut
add wave -decimal -color blue -label TB_DataOut  /top/DataOut
delete wave /top/processor_stall
add wave -decimal -color gold -label Stall /top/processor_stall

add wave -divider "Memory signals"
add wave -decimal -color red -label MM_DataIN /top/cache/mm/DataIn
add wave -decimal -color blue -label MM_DataOut /top/cache/mm/DataOut
#add wave -decimal -color pink -label MM_addr /top/cache/mm/addr
add wave -decimal -color pink -label MM_WrEn /top/cache/mm/WrtEn
add wave  -decimal -label MM_Contents /top/cache/mm/temp[1:5]


add wave -divider "Cache signals"
add wave -decimal -color red -label Cache_DataIN /top/cache/DataIn
add wave -decimal -color blue -label Cache_DataOut /top/cache/DataOut
#add wave -decimal -color pink -label Cache_addr /top/cache/addr
add wave  -decimal -label Cache_Contents /top/cache/temp[0:1]

write format restart rerun.do}




